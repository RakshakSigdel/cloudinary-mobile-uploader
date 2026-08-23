import 'package:cloudinary_mobile_uploader/core/widgets/app_text_field.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_options.dart';
import 'package:flutter/material.dart';

class UploadOptionsForm extends StatefulWidget {
  final ValueChanged<UploadOptions> onChanged;
  const UploadOptionsForm({super.key, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _UploadOptionsFormState();
}

class _UploadOptionsFormState extends State<UploadOptionsForm> {
  final _folderController = TextEditingController();
  final _tagsController = TextEditingController();
  final _publicIdController = TextEditingController();

  @override
  void dispose() {
    _folderController.dispose();
    _tagsController.dispose();
    _publicIdController.dispose();
    super.dispose();
  }

  void _notify() {
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    widget.onChanged(
      UploadOptions(
        folder: _folderController.text.trim().isEmpty
            ? null
            : _folderController.text.trim(),
        tags: tags,
        publicId: _publicIdController.text.trim().isEmpty
            ? null
            : _publicIdController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      leading: const Icon(Icons.tune),
      title: const Text('Upload options'),
      subtitle: const Text('Folder, tags, public ID (optional)'),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        AppTextField(
          label: 'Folder',
          hint: 'e.g. app-uploads',
          controller: _folderController,
          onChanged: (_) => _notify(),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Tags',
          hint: 'Comma Separated',
          controller: _tagsController,
          onChanged: (_) => _notify(),
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Public ID',
          hint: 'Leave Blank to auto generate',
          controller: _publicIdController,
          onChanged: (_) => _notify(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
