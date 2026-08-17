class CloudinaryConstants {
  CloudinaryConstants._();

  static String uploadEndpoint(String cloudName) =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}