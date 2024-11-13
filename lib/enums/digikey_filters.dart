import 'package:guadalajarav2/inventory/enums/enumCategory.dart';

enum DigikeyFilter {
  resistor,
  capacitor,
  inductor,
  discreteSemiconductor,
  protectionCircuit,
  powerSupply,
  leds,
  connector,
  integratedCircuit,
}

extension DigikeyFilterExt on DigikeyFilter {
  List<int?> get filtersId {
    switch (this) {
      case DigikeyFilter.resistor:
        return [
          _allFilters['resistance']!,
          _allFilters['power']!,
          _allFilters['package']!,
          _allFilters['tolerance']!,
        ];
      case DigikeyFilter.capacitor:
        return [
          _allFilters['capacitance']!,
          _allFilters['voltage']!,
          _allFilters['package']!,
        ];
      case DigikeyFilter.inductor:
        return [
          _allFilters['inductance']!,
          _allFilters['current']!,
          _allFilters['package']!,
        ];
      case DigikeyFilter.discreteSemiconductor:
      case DigikeyFilter.protectionCircuit:
      case DigikeyFilter.powerSupply:
      case DigikeyFilter.integratedCircuit:
        return [
          _allFilters['voltage']!,
          _allFilters['current']!,
          _allFilters['package']!,
        ];
      case DigikeyFilter.leds:
        return [
          _allFilters['color']!,
          _allFilters['package']!,
          _allFilters['voltage']!,
        ];
      case DigikeyFilter.connector:
        return [
          _allFilters['pinCount']!,
          _allFilters['row']!,
          _allFilters['pitch']!,
          _allFilters['contactType']!,
        ];
    }
  }

  List<String> get filters {
    switch (this) {
      case DigikeyFilter.resistor:
        return [
          'value',
          'power',
          'package',
          'tolerance',
        ];
      case DigikeyFilter.capacitor:
        return [
          'value',
          'voltage',
          'package',
        ];
      case DigikeyFilter.inductor:
        return [
          'value',
          'current',
          'package',
        ];
      case DigikeyFilter.discreteSemiconductor:
      case DigikeyFilter.protectionCircuit:
      case DigikeyFilter.powerSupply:
      case DigikeyFilter.integratedCircuit:
        return [
          'voltage',
          'current',
          'package',
        ];
      case DigikeyFilter.leds:
        return [
          'color',
          'package',
          'voltage',
        ];
      case DigikeyFilter.connector:
        return [
          'pinCount',
          'row',
          'pitch',
          'contactType',
        ];
    }
  }
}

Map<String, int> get _allFilters => {
      'power': 2,
      'tolerance': 3,
      'voltage': 14,
      'package': 16,
      'color': 37,
      'row': 90,
      'contactType': 512,
      'pinCount': 564,
      'inductance': 1222,
      'pitch': 1790,
      'capacitance': 2049,
      'resistance': 2085,
      'current': 2088,
    };

Map<int, DigikeyFilter> get categoryParameterId => {
      2: DigikeyFilter.resistor,
      3: DigikeyFilter.capacitor,
      4: DigikeyFilter.inductor,
      7: DigikeyFilter.leds,
      8: DigikeyFilter.powerSupply,
      9: DigikeyFilter.protectionCircuit,
      20: DigikeyFilter.connector,
      25: DigikeyFilter.discreteSemiconductor,
      32: DigikeyFilter.integratedCircuit,
    };
Map<Category, DigikeyFilter> get categoryParameterCategory => {
      Category.resistors: DigikeyFilter.resistor,
      Category.capacitors: DigikeyFilter.capacitor,
      Category.inductors: DigikeyFilter.inductor,
      Category.leds: DigikeyFilter.leds,
      Category.power_supplies: DigikeyFilter.powerSupply,
      Category.protection_circuits: DigikeyFilter.protectionCircuit,
      Category.connectors: DigikeyFilter.connector,
      Category.discrete_semiconductors: DigikeyFilter.discreteSemiconductor,
      Category.integrated_circuits: DigikeyFilter.integratedCircuit,
    };
