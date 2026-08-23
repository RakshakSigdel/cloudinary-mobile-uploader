import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadProgressIndicator extends StatelessWidget{
  final UploadTask task;
  const UploadProgressIndicator({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return switch(task.status){
      UploadStatus.queued => const LinearProgressIndicator(value:0),
      UploadStatus.uploading => LinearProgressIndicator(value: task.progress.percentage),
      UploadStatus.success => const LinearProgressIndicator(value: 1, color: Colors.green),
      UploadStatus.failed => LinearProgressIndicator(value: 1, color: Theme.of(context).colorScheme.error),
      UploadStatus.cancelled => const LinearProgressIndicator(value: 1, color: Colors.grey),
    };
  }
}