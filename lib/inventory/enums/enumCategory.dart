import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumFuseType.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/utils/tools.dart';

enum Category {
  capacitors,
  connectors,
  discrete_semiconductors,
  displays,
  inductors,
  integrated_circuits,
  leds,
  mechanics,
  microcontrollers,
  miscellaneous,
  optocouplers,
  pcbs,
  power_supplies,
  protection_circuits,
  resistors,
}

extension CategoryExtension on Category {
  String get name {
    return this.toString().split('.')[1].split('_').join(' ').toUpperCase();
  }

  String get nameSingular {
    if (this.name.endsWith('S') && this != Category.miscellaneous) {
      return this.name.substring(0, this.name.length - 1);
    } else {
      return this.name;
    }
  }

  List<String> get searchSpaces {
    List<String> searchOptions = [
      'mpn',
      'description',
      'manufacturer',
      'quantity',
      'status',
    ];
    switch (this) {
      case Category.capacitors:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'value',
          'tolerance',
          'dielectricType',
        ]);
        break;
      case Category.connectors:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'current',
          'pinCount',
          'pitch',
          'row',
          'contactType',
        ]);
        break;
      case Category.discrete_semiconductors:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'speed',
          'voltageBreakdown',
          'voltageReverse',
          'voltageClamping',
          'loadCapacitance',
          'channelType',
          'subCategory',
        ]);
        break;
      case Category.displays:
        searchOptions.addAll([
          'voltage',
          'current',
          'interface',
          'resolution',
        ]);
        break;
      case Category.inductors:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'value',
          'tolerance',
        ]);
        break;
      case Category.integrated_circuits:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'power',
          'speed',
          'pinCount',
          'flash',
          'ram',
        ]);
        break;
      case Category.leds:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'temperature',
          'color',
        ]);
        break;
      case Category.mechanics:
        break;
      case Category.microcontrollers:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'speed',
          'pinCount',
          'flash',
          'ram',
        ]);
        break;
      case Category.miscellaneous:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
        ]);
        break;
      case Category.optocouplers:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'speed',
        ]);
        break;
      case Category.pcbs:
        break;
      case Category.power_supplies:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'power',
        ]);
        break;
      case Category.protection_circuits:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'power',
          'voltageBreakdown',
          'voltageReverse',
          'voltageClamping',
          'channelType',
          'subCategory',
        ]);
        break;
      case Category.resistors:
        searchOptions.addAll([
          'voltage',
          'mounting',
          'package',
          'power',
          'value',
          'tolerance',
        ]);
        break;
    }

    return searchOptions;
  }

  dynamic get unitValue {
    switch (this) {
      case Category.capacitors:
        return FaradsUnit;
      case Category.inductors:
        return HenryUnit;
      case Category.resistors:
        return OhmUnit;

      default:
        return null;
    }
  }

  List<dynamic> get unitValues {
    switch (this) {
      case Category.capacitors:
        return FaradsUnit.values;
      case Category.inductors:
        return HenryUnit.values;
      case Category.resistors:
        return OhmUnit.values;

      default:
        return [];
    }
  }

  List<String> get headers {
    List<String> headersTitles = [
      'mpn',
      'description',
      'manufacturer',
      'quantity',
    ];
    switch (this) {
      case Category.capacitors:
        headersTitles.addAll([
          'package',
          'value',
        ]);
        break;
      case Category.connectors:
        headersTitles.addAll([
          'pin count',
          'pitch',
          'row',
        ]);
        break;
      case Category.discrete_semiconductors:
      case Category.inductors:
      case Category.miscellaneous:
      case Category.power_supplies:
      case Category.protection_circuits:
        headersTitles.addAll([
          'voltage',
          'package',
          'current',
        ]);
        break;
      case Category.displays:
        headersTitles.addAll([
          'resolution',
          'interface',
        ]);
        break;

      case Category.integrated_circuits:
      case Category.microcontrollers:
        headersTitles.addAll([
          'package',
          'speed',
        ]);
        break;
      case Category.leds:
        headersTitles.addAll([
          'package',
          'color',
        ]);
        break;
      case Category.mechanics:
        headersTitles.addAll([]);
        break;
      case Category.optocouplers:
        headersTitles.addAll([
          'speed',
          'voltage',
          'package',
        ]);
        break;
      case Category.pcbs:
        headersTitles.addAll([]);
        break;
      case Category.resistors:
        headersTitles.addAll([
          'package',
          'power',
          'value',
        ]);
        break;
    }
    return headersTitles;
  }

  List<String> get allHeaders {
    List<String> headersTitles = [
      'mpn',
      'description',
      'unit price',
      'manufacturer',
      'quantity',
      'status',
    ];
    switch (this) {
      case Category.capacitors:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'value',
          'tolerance',
          'dielectric type',
          'material',
        ]);
        break;
      case Category.connectors:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'current',
          'pin count',
          'pitch',
          'row',
          'contact type',
        ]);
        break;
      case Category.discrete_semiconductors:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'speed',
          'voltage breakdown',
          'voltage reverse',
          'voltage clamping',
          'load capacitance',
          'channel type',
        ]);
        break;
      case Category.displays:
        headersTitles.addAll([
          'voltage',
          'current',
          'interface',
          'resolution',
        ]);
        break;
      case Category.inductors:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'value',
          'tolerance',
        ]);
        break;
      case Category.integrated_circuits:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'power',
          'speed',
          'pin count',
          'flash',
          'ram',
        ]);
        break;
      case Category.leds:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'temperature',
          'color',
        ]);
        break;
      case Category.mechanics:
        headersTitles.addAll([]);
        break;
      case Category.microcontrollers:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'speed',
          'pin count',
          'flash',
          'ram',
        ]);
        break;
      case Category.miscellaneous:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
        ]);
        break;
      case Category.optocouplers:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'speed',
        ]);
        break;
      case Category.pcbs:
        headersTitles.addAll([]);
        break;
      case Category.power_supplies:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'power',
        ]);
        break;
      case Category.protection_circuits:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'current',
          'power',
          'voltage breakdown',
          'voltage reverse',
          'voltage clamping',
          'channel type',
          'fuseType',
          'currentTrip',
          'timeTrip',
        ]);
        break;
      case Category.resistors:
        headersTitles.addAll([
          'voltage',
          'mounting',
          'package',
          'power',
          'value',
          'tolerance',
        ]);
        break;
    }
    return headersTitles;
  }

  String get databaseName {
    return toTitle(this.name).split(' ').join();
  }

  List<SubCategory> get subCategories {
    List<SubCategory> _subCategories = [];

    switch (this) {
      case Category.capacitors:
      case Category.connectors:
      case Category.displays:
      case Category.inductors:
      case Category.integrated_circuits:
      case Category.leds:
      case Category.mechanics:
      case Category.microcontrollers:
      case Category.miscellaneous:
      case Category.optocouplers:
      case Category.pcbs:
      case Category.power_supplies:
      case Category.resistors:
        break;
      case Category.discrete_semiconductors:
        _subCategories.addAll([
          SubCategory.diode,
          SubCategory.crystal,
          SubCategory.transistor,
          SubCategory.mosfet,
        ]);
        break;
      case Category.protection_circuits:
        _subCategories.addAll([
          SubCategory.protectionCircuits,
          SubCategory.fuses,
        ]);
        break;
    }

    return _subCategories;
  }

  Map<String, String>? getFilters({
    SubCategory? subCategory,
    Map<String, dynamic> params = const {},
  }) {
    switch (this) {
      case Category.capacitors:
        return {
          'value': 'float',
          'voltage': 'float',
          'package': 'string',
          'dielectricType': 'int',
        };
      case Category.connectors:
      case Category.displays:
      case Category.integrated_circuits:
      case Category.mechanics:
      case Category.microcontrollers:
      case Category.miscellaneous:
      case Category.optocouplers:
      case Category.pcbs:
      case Category.power_supplies:
        return null;
      case Category.discrete_semiconductors:
        if (subCategory != null) {
          switch (subCategory) {
            case SubCategory.diode:
              return {
                'subCategory': 'int',
                'voltageReverse': 'float',
                'voltageForward': 'float',
                'current': 'float',
                'package': 'string',
              };
            case SubCategory.crystal:
              return {
                'subCategory': 'int',
                'frequency': 'double',
                'loadCapacitance': 'float',
                'package': 'string',
              };
            case SubCategory.transistor:
              return {
                'subCategory': 'int',
                'channelType': 'string',
                'voltage': 'float',
                'current': 'float',
                'package': 'string',
              };
            case SubCategory.mosfet:
              return {
                'subCategory': 'int',
                'channelType': 'string',
                'voltage': 'float',
                'current': 'float',
                'package': 'string',
              };
            case SubCategory.protectionCircuits:
            case SubCategory.fuses:
              return null;
          }
        }
        break;

      case Category.inductors:
        return {
          'value': 'float',
          'current': 'float',
          'package': 'string',
        };
      case Category.leds:
        return {
          'voltage': 'float',
          'current': 'float',
          'color': 'int',
          'package': 'string',
        };
      case Category.protection_circuits:
        if (subCategory != null) {
          switch (subCategory) {
            case SubCategory.diode:
            case SubCategory.crystal:
            case SubCategory.transistor:
            case SubCategory.mosfet:
              break;
            case SubCategory.protectionCircuits:
              return null;
            case SubCategory.fuses:
              Map<String, String> f = {
                'subCategory': 'int',
                'fuseType': 'int',
                'voltage': 'float',
                'current': 'float',
                'package': 'string',
              };

              if (params['fuseType'] == FuseType.resettable.index) {
                f.addAll({'currentTrip': 'float', 'timeTrip': 'float'});
              }
              return f;
          }
        }
        break;
      case Category.resistors:
        return {
          'value': 'float',
          'power': 'float',
          'package': 'string',
          'tolerance': 'float',
        };
    }
    return null;
  }
}
