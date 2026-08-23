import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_task.dart';
import 'package:flutter/material.dart';

class UploadProgressIndicator extends StatelessWidget{
  final UploadTask task;
  const UploadProgressIndicator({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (value, color) = switch(task.status){
      UploadStatus.queued => (0.0, colorScheme.outlineVariant),
      UploadStatus.uploading => (task.progress.percentage, colorScheme.primary),
      UploadStatus.success => (1.0, Colors.green),
      UploadStatus.failed => (1.0, colorScheme.error),
      UploadStatus.cancelled => (1.0, colorScheme.outline),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value,
        color: color,
        minHeight: 6,
      ),
    );
  }
}