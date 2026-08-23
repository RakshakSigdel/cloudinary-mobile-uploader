import 'package:cloudinary_mobile_uploader/core/network/dio_client.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/data/cloudinary_upload_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider((ref) => DioClient.create());

final cloudinaryUploadServiceProvider = Provider((ref) => CloudinaryUploadService(ref.watch(dioProvider)));