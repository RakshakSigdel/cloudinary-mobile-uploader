import 'package:cloudinary_mobile_uploader/core/storage/local_storage_service.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/domain/cloudinary_config.dart';

class CloudinaryConfigRepository {
  final LocalStorageService _storage;
  static const _key = 'cloudinary_config';

  CloudinaryConfigRepository(this._storage);

  Future<CloudinaryConfig?> load() async{
    final json = await _storage.getJson(_key);
    if(json == null) return null;
    return CloudinaryConfig.fromJson(json);
  }

  Future<void> save(CloudinaryConfig config) async{
    await _storage.setJson(_key, config.toJson());
  }

  Future<void> clear() async {
    await _storage.remove(_key);
  }
}