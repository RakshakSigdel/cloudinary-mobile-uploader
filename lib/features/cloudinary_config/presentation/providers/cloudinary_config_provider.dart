import 'dart:async';

import 'package:cloudinary_mobile_uploader/core/storage/local_storage_service.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/data/cloudinary_config_repository.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/domain/cloudinary_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageServiceProvider = Provider((ref) => LocalStorageService());

final cloudinaryConfigRepositoryProvider = Provider(
  (ref) => CloudinaryConfigRepository(ref.watch(localStorageServiceProvider)),
);

class CloudinaryConfigNotifier extends AsyncNotifier<CloudinaryConfig?> {
  @override
  Future<CloudinaryConfig?> build() {
    return ref.watch(cloudinaryConfigRepositoryProvider).load();
  }

  Future<void> save(CloudinaryConfig config) async {
    state = const AsyncLoading();
    await ref.read(cloudinaryConfigRepositoryProvider).save(config);
    state = AsyncData(config);
  }

  Future<void> clear() async {
    await ref.read(cloudinaryConfigRepositoryProvider).clear();
    state = AsyncData(null);
  }
}

final cloudinaryConfigProvider =
    AsyncNotifierProvider<CloudinaryConfigNotifier, CloudinaryConfig?>(
      CloudinaryConfigNotifier.new,
    );

final isConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(cloudinaryConfigProvider).valueOrNull != null;
});
