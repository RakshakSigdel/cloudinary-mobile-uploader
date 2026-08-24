import 'package:cloudinary_mobile_uploader/core/widgets/app_button.dart';
import 'package:cloudinary_mobile_uploader/core/widgets/app_text_field.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_options.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_task.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/presentation/providers/upload_queue_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

Future<void> showEditUploadOptionsSheet(
  BuildContext context,
  WidgetRef ref,
  UploadTask task,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
      ),
      child: _EditOptionsForm(
        fileName: p.basename(task.file.path),
        initialOptions: task.options,
        onSave: (options) {
          ref.read(uploadQueueProvider.notifier).updateOptions(task.id, options);
          Navigator.of(sheetContext).pop();
        },
      ),
    ),
  );
}

class _EditOptionsForm extends StatefulWidget {
  final String fileName;
  final UploadOptions initialOptions;
  final ValueChanged<UploadOptions> onSave;

  const _EditOptionsForm({
    required this.fileName,
    required this.initialOptions,
    required this.onSave,
  });

  @override
  State<_EditOptionsForm> createState() => _EditOptionsFormState();
}

class _EditOptionsFormState extends State<_EditOptionsForm> {
  late final _folderController =
      TextEditingController(text: widget.initialOptions.folder);
  late final _tagsController =
      TextEditingController(text: widget.initialOptions.tags.join(', '));
  late final _publicIdController =
      TextEditingController(text: widget.initialOptions.publicId);

  @override
  void dispose() {
    _folderController.dispose();
    _tagsController.dispose();
    _publicIdController.dispose();
    super.dispose();
  }

  void _save() {
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    widget.onSave(
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Edit options',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          widget.fileName,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Folder',
          hint: 'e.g. app-uploads',
          controller: _folderController,
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Tags',
          hint: 'Comma separated',
          controller: _tagsController,
        ),
        const SizedBox(height: 12),
        AppTextField(
          label: 'Public ID',
          hint: 'Leave blank to auto generate',
          controller: _publicIdController,
        ),
        const SizedBox(height: 20),
        AppButton(label: 'Save', isLoading: false, onPressed: _save),
      ],
    );
  }
}
