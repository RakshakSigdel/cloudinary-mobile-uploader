import 'dart:io';

import 'package:cloudinary_mobile_uploader/core/error/app_exception.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_options.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_progress.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_result.dart';

enum UploadStatus { queued, uploading, success, failed, cancelled }

class UploadTask {
  final String id;
  final File file;
  final UploadOptions options;
  final UploadStatus status;
  final UploadProgress progress;
  final UploadResult? result;
  final AppException? error;

  const UploadTask({
    required this.id,
    required this.file,
    required this.options,
    this.status = UploadStatus.queued,
    this.progress = UploadProgress.zero,
    this.result,
    this.error,
  });

  UploadTask copyWith({
    UploadStatus? status,
    UploadProgress? progress,
    UploadResult? result,
    AppException? error,
  }) {
    return UploadTask(
      id: id,
      file: file,
      options: options,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}
