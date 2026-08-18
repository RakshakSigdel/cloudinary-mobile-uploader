import 'package:cloudinary_mobile_uploader/core/config/env.dart';
import 'package:cloudinary_mobile_uploader/core/widgets/app_button.dart';
import 'package:cloudinary_mobile_uploader/core/widgets/app_text_field.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/domain/cloudinary_config.dart';
import 'package:flutter/cupertino.dart';

class ConfigForm extends StatefulWidget {
  final CloudinaryConfig? initialConfig;
  final bool isSaving;
  final ValueChanged<CloudinaryConfig> onSubmit;

  const ConfigForm({
    super.key,
    required this.initialConfig,
    required this.isSaving,
    required this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => _ConfigFormState();
}

class _ConfigFormState extends State<ConfigForm> {
  final _formKey = GlobalKey<FormState>();
  late final _cloudNameController = TextEditingController(
    text:
        widget.initialConfig?.cloudName ??
        (Env.hasDevDefaults ? Env.devCloudName : ''),
  );
  late final _uploadPresetController = TextEditingController(
    text:
        widget.initialConfig?.uploadPreset ??
        (Env.hasDevDefaults ? Env.devUploadPreset : ''),
  );

  @override
  void dispose() {
    _cloudNameController.dispose();
    _uploadPresetController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'This Field is Required';
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      CloudinaryConfig(
        cloudName: _cloudNameController.text.trim(),
        uploadPreset: _uploadPresetController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'cloud Name',
            hint: 'e.g., my-cloud',
            controller: _cloudNameController,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Upload Preset',
            hint: 'e.g., unsigned uploads',
            controller: _uploadPresetController,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 20),
          //SizedBox with height 16-20
          AppButton(
            label: 'Save',
            onPressed: _submit,
            isLoading: widget.isSaving,
          ),
        ],
      ),
    );
  }
}
