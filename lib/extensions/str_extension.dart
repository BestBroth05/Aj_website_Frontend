extension StrExtension on String {
  String toTitle() {
    return split(' ')
        .map((word) => word.length > 1
            ? word.substring(0, 1).toUpperCase() +
                word.substring(1).toLowerCase()
            : word.toUpperCase())
        .join(' ');
  }

  String get driveFile {
    return 'https://drive.google.com/uc?id=$this';
  }
}
