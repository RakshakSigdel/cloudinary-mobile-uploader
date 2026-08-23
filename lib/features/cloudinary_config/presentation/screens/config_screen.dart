import 'package:cloudinary_mobile_uploader/core/error/app_exception.dart';
import 'package:cloudinary_mobile_uploader/core/error/failure.dart';
import 'package:cloudinary_mobile_uploader/core/widgets/error_view.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/providers/cloudinary_config_provider.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/widgets/config_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configState = ref.watch(cloudinaryConfigProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.cloud_outlined,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Connect your Cloudinary account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your cloud name and an unsigned upload preset to start uploading.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: configState.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
