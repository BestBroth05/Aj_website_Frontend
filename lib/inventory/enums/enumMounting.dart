enum Mounting {
  smt,
  panel,
  pth,
}

extension MountingExtension on Mounting {
  String get name {
    return this.toString().split('.')[1];
  }
}
