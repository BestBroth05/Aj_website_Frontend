enum WorkingAreas {
  software,
  hardware,
  industrial_design,
  firmware,
  manufacture,
  none,
}

extension WorkingAreasExt on WorkingAreas {
  String get name {
    return this.toString().split('.')[1].split('_').join(' ');
  }

  int get id {
    return WorkingAreas.values.indexOf(this);
  }
}
