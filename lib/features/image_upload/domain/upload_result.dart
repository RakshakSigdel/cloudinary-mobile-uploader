class UploadResult {
  final String publicId;
  final String secureUrl;
  final String format;
  final int bytes;
  final DateTime createdAt;
  final int? width;
  final int? height;
  final String? folder;

  const UploadResult({
    required this.publicId,
    required this.secureUrl,
    required this.format,
    required this.bytes,
    required this.createdAt,
    this.width,
    this.height,
    this.folder,
  });

  factory UploadResult.fromJson(Map<String,dynamic> json){
    return UploadResult(
      publicId: json['public_id'] as String,
      secureUrl: json['secure_url'] as String,
      format: json['format'] as String,
      bytes: json['bytes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      width: json['width'] as int?,
      height: json['height'] as int?,
      folder: json['folder'] as String?,
    );
  }

  Map<String,dynamic> toJson() =>{
    'public_id' : publicId,
    'secure_url' : secureUrl,
    'format' : format,
    'bytes' : bytes,
    'created_at' : createdAt,
    'width' : width,
    'height' : height,
    'folder' : folder,
  };
}
