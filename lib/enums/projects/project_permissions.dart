enum ProjectPermission {
  admin,
  editor,
  employee,
  viewer,
}

extension PrPerExt on ProjectPermission {
  String get name {
    return this.toString().split('.')[1];
  }

  int get id {
    return ProjectPermission.values.indexOf(this);
  }
}
