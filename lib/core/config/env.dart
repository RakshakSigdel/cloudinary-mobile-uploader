class Env{
  Env._();

  static const String devCloudName = String.fromEnvironment('DEV_CLOUD_NAME');
  static const String devUploadPreset = String.fromEnvironment('DEV_UPLOAD_PRESET');

  static bool get hasDevDefaults => devCloudName.isNotEmpty && devUploadPreset.isNotEmpty;
}