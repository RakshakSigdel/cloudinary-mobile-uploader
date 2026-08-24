import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/providers/cloudinary_config_provider.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_result.dart';
import 'package:cloudinary_mobile_uploader/features/upload_history/data/upload_history_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadHistoryRepositoryProvider = Provider(
      (ref) => UploadHistoryRepository(ref.watch(localStorageServiceProvider)),
);

class UploadHistoryNotifier extends AsyncNotifier<List<UploadResult>> {
  @override
  Future<List<UploadResult>> build() {
    return ref.watch(uploadHistoryRepositoryProvider).load();
  }

  Future<void> add(UploadResult result) async {
    final current = state.valueOrNull ?? [];
    final updated = [...current, result];
    state = AsyncData(updated);
    await ref.read(uploadHistoryRepositoryProvider).save(updated);
  }

  Future<void> clearAll() async {
    await ref.read(uploadHistoryRepositoryProvider).clear();
    state = const AsyncData([]);
  }

  Future<void> remove(String publicId) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((r) => r.publicId != publicId).toList();
    state = AsyncData(updated);
    await ref.read(uploadHistoryRepositoryProvider).save(updated);
  }
}

final uploadHistoryProvider = AsyncNotifierProvider<UploadHistoryNotifier, List<UploadResult>>(
  UploadHistoryNotifier.new,
);