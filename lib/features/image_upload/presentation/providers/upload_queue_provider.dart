import 'dart:io';

import 'package:cloudinary_mobile_uploader/core/config/app_config.dart';
import 'package:cloudinary_mobile_uploader/core/error/app_exception.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/providers/cloudinary_config_provider.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_options.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_task.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/data/upload_repository.dart';
import './cloudinary_upload_service_provider.dart';
import 'package:cloudinary_mobile_uploader/features/upload_history/presentation/providers/upload_history_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadRepositoryProvider = Provider(
    (ref) => UploadRepository(ref.watch(cloudinaryUploadServiceProvider)),
);

class UploadQueueNotifier extends Notifier<List<UploadTask>>{
  final Map<String,CancelToken> _cancelTokens = {};
  int _activeCount = 0;

  @override
  List<UploadTask> build() => [];

  void enqueue(List<File> files, UploadOptions options){
    final newTasks = files
        .map((f) => UploadTask(id: '${DateTime.now().microsecondsSinceEpoch}_${f.path.hashCode}', file: f, options: options)).toList();
    state = [...state, ...newTasks];
    _processQueue();
  }
  //Retry
  void retry(String taskId){
    _updateTask(taskId, (t) => t.copyWith(status: UploadStatus.queued, error: const ConfigurationException()));
    _processQueue();
  }
  //Cancel
  void cancel(String taskId){
    _cancelTokens[taskId]?.cancel();
  }

  void _processQueue(){
    final queued = state.where((t) => t.status == UploadStatus.queued).toList();

    for (final task in queued){
      if(_activeCount >= AppConfig.uploadConcurrencyLimit) break;
      _startUpload(task);
    }
  }

  Future<void> _startUpload(UploadTask task) async{
    _activeCount++;
    _updateTask(task.id, (t)=> t.copyWith(status: UploadStatus.uploading));

    final config = ref.read(cloudinaryConfigProvider).valueOrNull;
    if(config == null){
      _updateTask(task.id, (t) => t.copyWith(status: UploadStatus.failed, error: const ConfigurationException()));
      _onTaskFinished();
      return ;
    }
    final cancelToken = CancelToken();
    //Uncomment later after cancel tokens is done
    _cancelTokens[task.id] = cancelToken;

    try{
      final result = await ref.read(uploadRepositoryProvider).uploadImage(
        config : config,
        filePath: task.file.path,
        options : task.options,
        cancelToken: cancelToken,
        onProgress : (progress) {_updateTask(task.id, (t) => t.copyWith(progress: progress));},
      );
      _updateTask(task.id, (t) => t.copyWith(status: UploadStatus.success, result: result));
      ref.read(uploadHistoryProvider.notifier).add(result);
    } on AppException catch(e){
      final wasCancelled = cancelToken.isCancelled;
      _updateTask(task.id, (t)=> t.copyWith(status: wasCancelled ? UploadStatus.cancelled : UploadStatus.failed, error: e),);
    }
    finally{
      _cancelTokens.remove(task.id);
      _onTaskFinished();
    }

  }

  void _onTaskFinished(){
    _activeCount--;
    _processQueue();
  }
  void _updateTask(String id, UploadTask Function(UploadTask) update){
    state = [
      for (final t in state)
        if(t.id == id) update(t) else t,
    ];
  }
}