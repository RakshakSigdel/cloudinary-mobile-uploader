import 'dart:io';

import 'package:cloudinary_mobile_uploader/core/error/app_exception.dart';
import 'package:path/path.dart' as p;

class ImageValidators {
  ImageValidators._();

  static const allowedExtensions = {'jpg', '.jpeg'};
  static const maxFileSizeByte = 10 * 1024 * 1024; //This is 10MB -> To change file size change the first number

  static void validate(File file){
    final extension = p.extension(file.path).toLowerCase();
    if(!allowedExtensions.contains(extension)){
      throw ValidationException("Unsupported file type");
    }

    final sizeBytes = file.lengthSync();
    if (sizeBytes > maxFileSizeByte){
      throw ValidationException('File is Too Big');
    }
  }
}