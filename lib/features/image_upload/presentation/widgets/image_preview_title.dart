import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import '../../../../core/error/failure.dart';
import '../../domain/upload_task.dart';
import '../providers/upload_queue_provider.dart';
import 'upload_progress_indicator.dart';

class ImagePreviewTile extends ConsumerWidget {
  final UploadTask task;

  const ImagePreviewTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(task.file, width: 48, height: 48, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.basename(task.file.path), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  UploadProgressIndicator(task: task),
                  if (task.status == UploadStatus.failed && task.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        Failure.fromException(task.error!).message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (task.status == UploadStatus.success && task.result != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        task.result!.secureUrl,
                        style: const TextStyle(fontSize: 12, color: Colors.green),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            _TrailingAction(task: task, ref: ref),
          ],
        ),
      ),
    );
  }
}

class _TrailingAction extends StatelessWidget {
  final UploadTask task;
  final WidgetRef ref;

  const _TrailingAction({required this.task, required this.ref});

  @override
  Widget build(BuildContext context) {
    return switch (task.status) {
      UploadStatus.uploading => IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel',
        onPressed: () => ref.read(uploadQueueProvider.notifier).cancel(task.id),
      ),
      UploadStatus.failed || UploadStatus.cancelled => IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Retry',
        onPressed: () => ref.read(uploadQueueProvider.notifier).retry(task.id),
      ),
      UploadStatus.success => const Icon(Icons.check_circle, color: Colors.green),
      UploadStatus.queued => const Icon(Icons.schedule, color: Colors.grey),
    };
  }
}