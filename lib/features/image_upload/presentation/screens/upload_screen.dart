import 'dart:io';

import 'package:cloudinary_mobile_uploader/features/image_upload/presentation/widgets/image_preview_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/upload_options.dart';
import '../providers/image_picker_provider.dart';
import '../providers/upload_queue_provider.dart';
import '../widgets/upload_options_form.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  UploadOptions _currentOptions = const UploadOptions();

  Future<void> _pickFromGallery() async {
    final picker = ref.read(imagePickerProvider);
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    _enqueue(picked.map((x) => File(x.path)).toList());
  }

  Future<void> _pickFromCamera() async {
    final picker = ref.read(imagePickerProvider);
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;

    _enqueue([File(picked.path)]);
  }

  void _enqueue(List<File> files) {
    ref.read(uploadQueueProvider.notifier).enqueue(files, _currentOptions);
  }

  Future<void> _showSourcePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add images',
                    style: Theme.of(sheetContext).textTheme.titleMedium,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(uploadQueueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
        actions: [
          IconButton(
            tooltip: 'Cloudinary settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/config'),
          ),
          IconButton(
            tooltip: 'Upload history',
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Card(
              child: UploadOptionsForm(
                onChanged: (options) => _currentOptions = options,
              ),
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const _EmptyQueueState()
                : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              itemCount: tasks.length,
              itemBuilder: (context, index) => ImagePreviewTile(task: tasks[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSourcePicker,
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('Add images'),
      ),
    );
  }
}

class _EmptyQueueState extends StatelessWidget {
  const _EmptyQueueState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 56,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No uploads yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              'Tap "Add images" to take a photo or pick from your gallery.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}