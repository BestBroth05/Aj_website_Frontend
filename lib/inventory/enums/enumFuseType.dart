enum FuseType {
  resettable,
  no_resettable,
}

extension FuseTypeExt on FuseType {
  String get name {
    return this.toString().split('.')[1].split('_').join(' ');
  }
}
