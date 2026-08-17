String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB'];
  double size = bytes / 1024;
  var unitIndex = 0;

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }
  return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
}
