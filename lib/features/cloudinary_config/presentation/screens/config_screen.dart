import 'package:cloudinary_mobile_uploader/core/error/app_exception.dart';
import 'package:cloudinary_mobile_uploader/core/error/failure.dart';
import 'package:cloudinary_mobile_uploader/core/widgets/error_view.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/providers/cloudinary_config_provider.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/widgets/config_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(cloudinaryConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: configState.when(
            loading: () => const CircularProgressIndicator(),
            error: (err, _) => ErrorView(
              failure: Failure.fromException(
                err is AppException ? err : const UnknownException(),
              ),
            ),
            data: (config) => ConfigForm(
              initialConfig: config,
              isSaving: configState.isLoading,
              onSubmit: (newConfig) {
                ref.read(cloudinaryConfigProvider.notifier).save(newConfig);
              },
            ),
          ),
        ),
      ),
    );
  }
}
