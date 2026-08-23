import 'dart:io';

import 'package:cloudinary_mobile_uploader/features/image_upload/presentation/widgets/image_preview_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  Future<void> _pickAndEnqueue() async {
    final picker = ref.read(imagePickerProvider);
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    final files = picked.map((x) => File(x.path)).toList();
    ref.read(uploadQueueProvider.notifier).enqueue(files, _currentOptions);
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
        onPressed: _pickAndEnqueue,
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('Select images'),
      ),
    );
  }
}