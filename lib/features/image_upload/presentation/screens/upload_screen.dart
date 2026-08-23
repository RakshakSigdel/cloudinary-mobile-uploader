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
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
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
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/config'),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: UploadOptionsForm(
              onChanged: (options) => _currentOptions = options,
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text('No uploads yet'))
                : ListView.builder(
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