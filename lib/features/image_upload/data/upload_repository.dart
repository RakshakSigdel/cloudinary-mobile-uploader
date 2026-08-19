import 'package:cloudinary_mobile_uploader/features/cloudinary_config/domain/cloudinary_config.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/data/cloudinary_upload_service.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_options.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_progress.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_result.dart';
import 'package:dio/dio.dart';

class UploadRepository {
  final CloudinaryUploadService _uploadService;

  UploadRepository(this._uploadService);

  Future<UploadResult> uploadImage({
    required CloudinaryConfig config,
    required String filePath,
    required UploadOptions options,
    required void Function(UploadProgress) onProgress,
    CancelToken? cancelToken,
  }) {
    return _uploadService.upload(
      config: config,
      filePath: filePath,
      options: options,
      onProgress: onProgress,
      cancelToken: cancelToken,
    );
  }
}
