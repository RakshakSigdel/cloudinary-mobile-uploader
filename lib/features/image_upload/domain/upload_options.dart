class UploadOptions {
  final String? folder;
  final List<String> tags;
  final String? publicId;

  const UploadOptions({
    this.folder,
    this.tags = const[],
    this.publicId,
});
  bool get isEmpty => folder == null && tags.isEmpty && publicId == null;

  Map<String, String> toFormFields(){
    final fields = <String, String>{};
    if (folder!=null && folder!.isNotEmpty) fields['folder'] = folder!;
    if(tags.isNotEmpty) fields['tags'] = tags.join(',');
    if(publicId!=null && publicId!.isNotEmpty) fields['public_id'] = publicId!;
    return fields;
  }
}