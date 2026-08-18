class CloudinaryConfig {
  final String cloudName;
  final String uploadPreset;

  const CloudinaryConfig({required this.cloudName, required this.uploadPreset});

  Map<String, dynamic> toJson() => {
    'cloudName': cloudName,
    'uploadPreset': uploadPreset,
  };

  factory CloudinaryConfig.fromJson(Map<String, dynamic> json) =>
      CloudinaryConfig(
        cloudName: json['cloudName'] as String,
        uploadPreset: json['uploadPreset'] as String,
      );
  @override
  bool operator ==(Object other) =>
      other is CloudinaryConfig &&
      other.cloudName == cloudName &&
      other.uploadPreset == uploadPreset;
  @override
  int get hasCode => Object.hash(cloudName,uploadPreset);
}
