import 'package:cloudinary_mobile_uploader/core/constants/cloudinary_constants.dart';
import 'package:cloudinary_mobile_uploader/core/error/app_exception.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/domain/cloudinary_config.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_options.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_progress.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/domain/upload_result.dart';
import 'package:dio/dio.dart';

class CloudinaryUploadService {
  final Dio _dio;
  CloudinaryUploadService(this._dio);

  Future<UploadResult> upload({
    required CloudinaryConfig config,
    required String filePath,
    required UploadOptions options,
    required void Function(UploadProgress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'upload_preset': config.uploadPreset,
      ...options.toFormFields(),
    });

    try {
      final response = await _dio.post(
        CloudinaryConstants.uploadEndpoint(config.cloudName),
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          onProgress(UploadProgress(byteSent: sent, totalBytes: total));
        },
      );
      return UploadResult.fromJson(response.data as Map<String,dynamic>);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  AppException _mapDioException(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      return const NetworkException('Upload cancelled');
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
    final response = e.response;
    if (response == null) return const UnknownException();

    final data = response.data;
    final message = (data is Map && data['error'] is Map)
        ? (data['error']['message'] as String? ?? 'Unknown Cloudinary error')
        : 'Unknown Cloudinary Error';

    return switch (response.statusCode) {
      400 when message.toLowerCase().contains('preset') =>
        InvalidPresetException(message),
      401 || 403 => AuthErrorException(message),
      420 || 429 => RateLimitException(message),
      _ => CloudinaryApiException(message, statusCode: response.statusCode),
    };
  }
}
