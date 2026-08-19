class UploadProgress {
  final int byteSent;
  final int totalBytes;

  const UploadProgress({this.byteSent = 0, this.totalBytes = 0});

  double get percentage => totalBytes == 0 ? 0.0 : byteSent / totalBytes;

  static const zero = UploadProgress();
}
