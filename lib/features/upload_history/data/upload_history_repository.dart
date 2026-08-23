import 'package:cloudinary_mobile_uploader/core/config/app_config.dart';
import 'package:cloudinary_mobile_uploader/core/storage/local_storage_service.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_result.dart';

class UploadHistoryRepository {
  final LocalStorageService _storage;
  static const _key = 'upload_history';

  UploadHistoryRepository(this._storage);

  Future<List<UploadResult>> load() async{
    final list = await _storage.getJsonList(_key);
    return list.map(UploadResult.fromJson).toList();
  }
  Future<void> save(List<UploadResult> results) async{
    // final list = await _storage.getJsonList(_key);
    // final list.map(UploadResult.fromJson.to)
    final trimmed = results.length > AppConfig.maxHistoryItems
        ? results.sublist(results.length - AppConfig.maxHistoryItems)
        : results;
    await _storage.setJsonList(_key, trimmed.map((r) => r.toJson()).toList());
  }

  Future<void> clear() async{
    await _storage.remove(_key);
  }
}