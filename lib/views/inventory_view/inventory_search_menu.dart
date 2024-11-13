import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumColors.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumFlash.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumTemperature.dart';
import 'package:guadalajarav2/inventory/enums/enumValueUnit.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/inventory/inventoryListView.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/views/inventory_view/inventory_search_menu/search_menu_dropdown.dart';

class CustomInventorySearchMenu extends StatefulWidget {
  final Category category;
  final Function(List<Product> products) setParts;
  final Function(Category newCategory) onCategoryChanged;

  CustomInventorySearchMenu({
    this.category = Category.capacitors,
    required this.onCategoryChanged,
    required this.setParts,
  });

  @override
  _CustomInventorySearchMenu createState() => _CustomInventorySearchMenu();
}

class _CustomInventorySearchMenu extends State<CustomInventorySearchMenu> {
  List<Widget> filters = [];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController mpnController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController voltageController = TextEditingController();
  TextEditingController packageController = TextEditingController();
  TextEditingController currentController = TextEditingController();
  TextEditingController powerController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController pinCountController = TextEditingController();
  TextEditingController toleranceController = TextEditingController();
  TextEditingController flashController = TextEditingController();
  TextEditingController ramController = TextEditingController();
  TextEditingController vBreakdownController = TextEditingController();
  TextEditingController vReverseController = TextEditingController();
  TextEditingController vClampingController = TextEditingController();
  TextEditingController dielectricTypeController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController pitchController = TextEditingController();
  TextEditingController rowController = TextEditingController();
  TextEditingController interfaceController = TextEditingController();
  TextEditingController resolutionController = TextEditingController();
  TextEditingController loadCapacitanceController = TextEditingController();
  TextEditingController channelTypeController = TextEditingController();
  TextEditingController contactTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  ProductStatus? selectedStatus;
  VoltageUnit selectedVoltage = VoltageUnit.v;
  Mounting? selectedMouting;
  CurrentUnit selectedCurrent = CurrentUnit.a;
  ValueUnit selectedValueUnit = ValueUnit.farad;
  FlashUnit selectedFlash = FlashUnit.mb;
  FlashUnit selectedRam = FlashUnit.mb;
  VoltageUnit selectedVBreakdown = VoltageUnit.v;
  VoltageUnit selectedVReverse = VoltageUnit.v;
  VoltageUnit selectedVClamping = VoltageUnit.v;
  TemperatureUnit selectedTemperature = TemperatureUnit.c;
  FaradsUnit selectedLoadCapacitance = FaradsUnit.f;
  LedColor? selectedColor;
  String selectedPower = 'power.decimal';
  SubCategory? selectedSubCategory;

  FaradsUnit selectionFarad = FaradsUnit.f;
  OhmUnit selectionOhm = OhmUnit.ohm;
  HenryUnit selectionHenry = HenryUnit.h;

  List<dynamic> selections = [];
  List<dynamic> selectionUnitValues = [];
  List<TextEditingController> controllers = [];
  Map<String, String> controllersKeys = {};

  Type? unitValue;

  @override
  void initState() {
    selections = [
      widget.category, //0
      selectedStatus, // 1 <-
      selectedVoltage, //2
      selectedMouting, // 3 <-
      selectedCurrent, //4
      selectedValueUnit, //5
      selectedFlash, //6
      selectedRam, //7
      selectedVBreakdown, //8
      selectedVReverse, //9
      selectedVClamping, //10
      selectedTemperature, //11
      selectedLoadCapacitance, //12
      selectedColor, //13
      selectedPower, //14
      selectedSubCategory, //15
    ];

    selectionUnitValues = [
      selectionFarad,
      selectionOhm,
      selectionHenry,
    ];

    controllers = [
      descriptionController, //0
      mpnController, //1
      manufacturerController, //2
      voltageController, //3
      packageController, //4
      currentController, //5
      powerController, //6
      speedController, //7
      valueController, //8
      pinCountController, //9
      toleranceController, //10
      flashController, //11
      ramController, //12
      vBreakdownController, //13
      vReverseController, //14
      vClampingController, //15
      dielectricTypeController, //16
      temperatureController, //17
      pitchController, //18
      rowController, //19
      interfaceController, //20
      resolutionController, //21
      loadCapacitanceController, //22
      channelTypeController, //23
      contactTypeController, //24
      quantityController //25
    ];
    controllersKeys = {
      'description': 'string', //0
      'mpn': 'string',
      'manufacturer': 'string',
      'voltage': 'float',
      'package': 'string',
      'current': 'float',
      'power': 'float',
      'speed': 'float',
      'value': 'float',
      'pinCount': 'int',
      'tolerance': 'float', //10
      'flash': 'float',
      'ram': 'float',
      'voltageBreakdown': 'float',
      'voltageReverse': 'float',
      'voltageClamping': 'float',
      'dielectricType': 'int',
      'temperature': 'float',
      'pitch': 'float',
      'row': 'int',
      'interface': 'string', //20
      'resolution': 'string',
      'loadCapacitance': 'float',
      'channelType': 'string', //23
      'contactType': 'string',
      'quantity': 'int',
      'status': 'int',
      'mounting': 'int',
      'color': 'int',
      'subCategory': 'int',
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int searchBarFlex = countFiltersOptions(widget.category);
    // idController.text = searchBarFlex.toString() + ' ${20 - searchBarFlex}';

    unitValue = widget.category.unitValue;

    // print('${widget.category.name} flex: $searchBarFlex');
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width * 0.01,
                ),
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: DropdownButtonHideUnderline(
                    child: SearchMenuDropdown(
                      onChanged: (newValue) {
                        if (newValue != widget.category) {
                          widget.onCategoryChanged.call(newValue);
                          resetFilters();
                        }
                      },
                      value: widget.category,
                      values: Category.values,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.01,
              ),
              child: Divider(),
            ),
            Expanded(
              flex: 88,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.01,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Column(
                        children: [
                          // Expanded(
                          //   flex: 2,
                          //   child: SearchMenuTextField(
                          //     controller: controllers[1],
                          //     title: 'MPN',
                          //     onEnter: () async =>
                          //         await areFiltersEmpty(widget.category),
                          //   ),
                          // ),
                          getSearchFilterDropdown<SubCategory>(
                            'Sub Category',
                            widget.category.subCategories,
                            -1,
                            15,
                          ),
                          getSearchFilterFill('MPN', 2, 1),
                          getSearchFilterFill('Description', 2, 0),
                          getSearchFilterFill('Manufacturer', 2, 2),
                          getSearchFilterFill('Quantity', 2, 25),
                          getSearchFilterDropdown<ProductStatus>(
                            'Status',
                            ProductStatus.values,
                            -1,
                            1,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: searchBarFlex,
                      child: Column(
                        children: [
                          getSearchFilterDropdown<VoltageUnit>(
                            'Voltage',
                            VoltageUnit.values,
                            3,
                            2,
                          ),
                          getSearchFilterDropdown<Mounting>(
                            'Mounting',
                            Mounting.values,
                            -1,
                            3,
                          ),
                          getSearchFilterFill('Package', 2, 4),
                          getSearchFilterDropdown<CurrentUnit>(
                            'Current',
                            CurrentUnit.values,
                            5,
                            4,
                          ),
                          getSearchFilterDropdown<String>(
                            'Power',
                            ['power.decimal', 'power.fraction'],
                            6,
                            14,
                          ),
                          getSearchFilterFill('Speed', 2, 7),
                          getSearchFilterDropdown<ValueUnit>(
                            'Value',
                            ValueUnit.values,
                            8,
                            5,
                          ),
                          getSearchFilterFill('Pin Count', 2, 9),
                          getSearchFilterFill('Tolerance', 2, 10),
                          getSearchFilterDropdown<FlashUnit>(
                            'Flash',
                            FlashUnit.values,
                            11,
                            6,
                          ),
                          getSearchFilterDropdown<FlashUnit>(
                            'Ram',
                            FlashUnit.values,
                            12,
                            7,
                          ),
                          getSearchFilterDropdown<VoltageUnit>(
                            'Voltage Breakdown',
                            VoltageUnit.values,
                            13,
                            8,
                          ),
                          getSearchFilterDropdown<VoltageUnit>(
                            'Voltage Reverse',
                            VoltageUnit.values,
                            14,
                            9,
                          ),
                          getSearchFilterDropdown<VoltageUnit>(
                            'Voltage Clamping',
                            VoltageUnit.values,
                            15,
                            10,
                          ),
                          getSearchFilterFill('Dielectric Type', 2, 16),
                          getSearchFilterFill('Temperature', 2, 17),
                          getSearchFilterFill('Pitch', 2, 18),
                          getSearchFilterFill('Row', 2, 19),
                          getSearchFilterFill('Interface', 2, 20),
                          getSearchFilterFill('Resolution', 2, 21),
                          getSearchFilterDropdown<FaradsUnit>(
                            'Load Capacitance',
                            FaradsUnit.values,
                            22,
                            12,
                          ),
                          getSearchFilterFill('Channel Type', 2, 23),
                          getSearchFilterFill('Contact Type', 2, 24),
                          getSearchFilterDropdown<LedColor>(
                            'Color',
                            LedColor.values,
                            -1,
                            13,
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 20 - searchBarFlex, child: Container())
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.01,
              ),
              child: Divider(),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: red.add(black, 0.2),
                        ),
                        child: AutoSizeText('Clear Filters'),
                        onPressed: () async {
                          resetFilters();
                          widget.onCategoryChanged.call(widget.category);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded searchFilterFill(
    int flex,
    String title,
    int controllerIndex,
  ) {
    if (title == 'Speed') {
      title = 'Speed (Mbps)';
    }
    if (title == 'Temperature') {
      title = 'Milicandela Rating (mcd)';
    }

    List<Widget> children = [];
    Expanded titleText = Expanded(
      child: AutoSizeText(
        title,
        style: subTitleSearchMenu,
        maxLines: 1,
        minFontSize: 2,
      ),
    );
    Expanded textField = Expanded(
      child: AutoSizeTextField(
        controller: controllers[controllerIndex],
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(fontStyle: FontStyle.italic),
          fillColor: lightGrey,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: backgroundColor,
            ),
          ),
          focusColor: darkGrey,
        ),
        style: textfieldSearchMenu,
        minFontSize: 1,
        maxFontSize: 30,
        onEditingComplete: () async => await areFiltersEmpty(widget.category),
      ),
    );

    if (flex == 2) {
      children = [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [titleText],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    textField,
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      children = [
        titleText,
        textField,
      ];
    }

    return Expanded(
      flex: flex,
      child: Container(
        child: Row(children: children),
      ),
    );
  }

  Expanded searchFilterDropdown<T>(
    int flex,
    String title,
    TextEditingController? controller,
    List<dynamic> values,
    int indexOfValue,
  ) {
    List<Widget> children = [];
    if (title == 'Power') {
      title = 'Power (Watts)';
    }
    if (title == 'Temperature') {
      title = 'Milicandela Rating (mcd)';
    }
    Expanded titleText = Expanded(
      child: AutoSizeText(
        title,
        style: subTitleSearchMenu,
        maxLines: 1,
        minFontSize: 2,
      ),
    );

    if (controller != null) {
      Expanded textField = Expanded(
        child: AutoSizeTextField(
          // expands: true,
          // maxLines: null,
          // minLines: null,
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintStyle: TextStyle(fontStyle: FontStyle.italic),
            fillColor: lightGrey,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: backgroundColor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: backgroundColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: backgroundColor,
              ),
            ),
            focusColor: darkGrey,
          ),
          style: textfieldSearchMenu,
          minFontSize: 1,
          maxFontSize: 30,
          onEditingComplete: () async => await areFiltersEmpty(widget.category),
        ),
      );
      children = [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [titleText],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    textField,
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: DropdownButtonHideUnderline(
                          child: dropDownMenu<T>(values, indexOfValue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    } else {
      children = [
        titleText,
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropdownButtonHideUnderline(
              child: dropDownMenu<T>(values, indexOfValue),
            ),
          ),
        ),
      ];
    }
    return Expanded(
      flex: flex,
      child: Container(
        child: Row(
          children: children,
        ),
      ),
    );
  }

  DropdownButton dropDownMenu<T>(List<dynamic> values, int indexOfValue) {
    // print(selectionUnitValues[0].toString() +
    //     ' $indexOfValue ${selectionUnitValues[0].toString()}');
    T? value;
    if (T == FaradsUnit) {
      value = selectionUnitValues[0];
    } else if (T == OhmUnit) {
      value = selectionUnitValues[1];
    } else if (T == HenryUnit) {
      value = selectionUnitValues[2];
    } else {
      value = selections[indexOfValue];
    }

    List<dynamic> valuesList = [];
    if (indexOfValue == 1 || indexOfValue == 3 || indexOfValue == 13) {
      valuesList.add('null');
    }
    valuesList.addAll(values);

    // print('$T ${value.runtimeType}');
    return DropdownButton<dynamic>(
        hint: Center(
          child: AutoSizeText(
            'None',
            textAlign: TextAlign.center,
            maxLines: 1,
            minFontSize: 1,
            style: subTitleSearchMenu,
          ),
        ),
        style: dropdownButtonGrey,
        items: valuesList.map(
          (dynamic item) {
            String name = '';
            if (item.toString() == 'null') {
              name = 'None';
            } else {
              name = item.toString().split('.')[1];
              switch (item.runtimeType) {
                case Category:
                  name = name.toUpperCase().split('_').join(' ');
                  break;
                case ProductStatus:
                  name = name.substring(0, 1).toUpperCase() +
                      name.substring(1).toLowerCase();
                  break;

                case VoltageUnit:
                  if (name.length > 1) {
                    name = name.substring(0, 1).toLowerCase() +
                        name.substring(1).toUpperCase();
                  } else {
                    name = name.toUpperCase();
                  }
              }
            }

            return DropdownMenuItem<dynamic>(
              value: item,
              child: Center(
                child: AutoSizeText(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: name.split(' ').length,
                  minFontSize: 1,
                  style: subTitleSearchMenu,
                ),
              ),
            );
          },
        ).toList(),
        isExpanded: true,
        isDense: true,
        value: value,
        onChanged: (dynamic newValue) async {
          setState(
            () {
              if (newValue == 'null') {
                newValue = null;
              }
              if (T == FaradsUnit) {
                selectionUnitValues[0] = newValue;
              } else if (T == OhmUnit) {
                selectionUnitValues[1] = newValue;
              } else if (T == HenryUnit) {
                selectionUnitValues[2] = newValue;
              } else {
                selections[indexOfValue] = newValue;
              }
              // if (indexOfValue == 0) {
              //   widget.category = selections[indexOfValue];
              // }
            },
          );
          if (indexOfValue == 0) {
            resetFilters();
            List<Product> components =
                await searchProductsByCategoryInDatabase(widget.category);

            inventoryState.setState(() {
              products = components;
            });
          }

          await areFiltersEmpty(widget.category);
        });
  }

  int countFiltersOptions(Category category) {
    int searchBarFlex = 0;
    for (int i = 4; i < category.searchSpaces.length; i++) {
      if (category.searchSpaces[i] == "mounting") {
        searchBarFlex += 2;
      } else {
        searchBarFlex += 2;
      }
    }
    searchBarFlex += 2;

    return searchBarFlex;
  }

  Widget getSearchFilterDropdown<T>(
    String title,
    List<T> values,
    int searchControllerIndex,
    int selectionIndex,
  ) {
    String toCompare = '$title';

    if (title.split(' ').length > 1) {
      toCompare = title.split(' ')[0].toLowerCase() + title.split(' ')[1];
      // print('$toCompare ${widget.category.searchSpaces} ');
    } else {
      toCompare = title.toLowerCase();
    }

    if (widget.category.searchSpaces.contains(toCompare) == false) {
      return Container();
    }

    if (title != 'Value') {
      return searchFilterDropdown<T>(
        searchControllerIndex == -1 ? 2 : 2,
        '$title',
        // ignore: null_check_always_fails
        searchControllerIndex == -1 ? null : controllers[searchControllerIndex],
        values,
        selectionIndex,
      );
    } else {
      // ignore: unnecessary_null_comparison
      if (unitValue == null) {
        return searchFilterDropdown<T>(
          2,
          '$title',
          searchControllerIndex == -1
              ? null
              : controllers[searchControllerIndex],
          values,
          selectionIndex,
        );
      } else {
        switch (unitValue) {
          case FaradsUnit:
            return searchFilterDropdown<FaradsUnit>(
              2,
              '$title',
              searchControllerIndex == -1
                  ? null
                  : controllers[searchControllerIndex],
              widget.category.unitValues,
              selectionIndex,
            );
          case OhmUnit:
            return searchFilterDropdown<OhmUnit>(
              2,
              '$title',
              searchControllerIndex == -1
                  ? null
                  : controllers[searchControllerIndex],
              widget.category.unitValues,
              selectionIndex,
            );
          case HenryUnit:
            return searchFilterDropdown<HenryUnit>(
              2,
              '$title',
              searchControllerIndex == -1
                  // ignore: null_check_always_fails
                  ? null
                  : controllers[searchControllerIndex],
              widget.category.unitValues,
              selectionIndex,
            );

          default:
            return Container();
        }
      }
    }
  }

  Widget getSearchFilterFill(
    String title,
    flex,
    controllerIndex,
  ) {
    String toCompare = '$title';
    if (title.split(' ').length > 1) {
      toCompare = title.split(' ')[0].toLowerCase() + title.split(' ')[1];
      // print('$toCompare ${widget.category.searchSpaces} ');
    } else {
      toCompare = title.toLowerCase();
    }

    if (widget.category.searchSpaces.contains(toCompare) == false) {
      return Container();
    }
    return searchFilterFill(
      flex,
      '$title',
      controllerIndex,
    );
  }

  void resetFilters() {
    setState(() {
      for (TextEditingController controller in controllers) {
        controller.text = '';
      }
      selections = [
        widget.category, //0
        selectedStatus, // 1 <-
        selectedVoltage, //2
        selectedMouting, // 3 <-
        selectedCurrent,
        selectedValueUnit,
        selectedFlash, //5
        selectedRam, //6
        selectedVBreakdown,
        selectedVReverse,
        selectedVClamping,
        selectedTemperature,
        selectedLoadCapacitance,
        selectedColor,
        selectedPower,
        selectedSubCategory,
      ];
    });
  }

  Future<void> areFiltersEmpty(Category category) async {
    // print('Filtering');
    Map<String, dynamic> filters = {'category': category.databaseName};
    for (TextEditingController controller in controllers) {
      if (controller.text.isNotEmpty) {
        // inventoryState.setState(() {
        //   isSearching = true;
        // });
        // break;
        String key =
            controllersKeys.keys.elementAt(controllers.indexOf(controller));
        dynamic value;
        String type = controllersKeys[key]!;
        if (type == 'int') {
          value = int.tryParse(controller.text);
        } else if (type == 'float') {
          if (selections[14].toString().split('.')[1] == 'fraction' &&
              controllers.indexOf(controller) == 6) {
            value = fractionToDecimal(controller.text);
          } else {
            value = double.tryParse(controller.text);
          }
        } else {
          value = controller.text;
        }

        if (value == null) {
          containerDialog(
              context,
              false,
              AlertNotification(
                  color: red,
                  icon: Icons.cancel_rounded,
                  str: "Wrong Values in Search Filter"),
              0.4);
          return;
        }

        if (key == 'voltage') {
          value = VoltageUnit.v.convertFrom(value, selections[2]);
        } else if (key == 'current') {
          value = CurrentUnit.a.convertFrom(value, selections[3]);
        } else if (key == 'value') {
          switch (category.unitValue) {
            case FaradsUnit:
              value = FaradsUnit.f.convertFrom(value, selectionUnitValues[0]);
              break;
            case OhmUnit:
              value = OhmUnit.ohm.convertFrom(value, selectionUnitValues[1]);
              break;
            case HenryUnit:
              value = HenryUnit.h.convertFrom(value, selectionUnitValues[2]);
              break;
          }
        } else if (key == 'flash') {
          value = FlashUnit.mb.convertFrom(value, selections[5]);
        } else if (key == 'ram') {
          value = FlashUnit.mb.convertFrom(value, selections[6]);
        } else if (key == 'voltageBreakdown') {
          value = VoltageUnit.v.convertFrom(value, selections[7]);
        } else if (key == 'voltageReverse') {
          value = VoltageUnit.v.convertFrom(value, selections[8]);
        } else if (key == 'voltageClamping') {
          value = VoltageUnit.v.convertFrom(value, selections[9]);
        } else if (key == 'loadCapacitance') {
          value = FaradsUnit.f.convertFrom(value, selections[11]);
        } else if (key == 'subCategory') {
        } else if (key == 'power') {}

        filters.putIfAbsent(key, () => {'value': value, 'type': type});
      }
    }

    if (selections[1] != null) {
      filters.putIfAbsent(
        'status',
        () => {
          'value': ProductStatus.values.indexOf(selections[1]),
          'type': 'int',
        },
      );
    }
    if (selections[3] != null) {
      filters.putIfAbsent(
        'mounting',
        () => {
          'value': Mounting.values.indexOf(selections[3]),
          'type': 'int',
        },
      );
    }
    if (selections[13] != null) {
      filters.putIfAbsent(
        'color',
        () => {
          'value': LedColor.values.indexOf(selections[13]),
          'type': 'int',
        },
      );
    }
    if (selections[15] != null) {
      filters.putIfAbsent(
        'subCategory',
        () => {
          'value': SubCategory.values.indexOf(selections[15]),
          'type': 'int',
        },
      );
    }

    if (filters.length > 1) {
      List<Product> components =
          await searchProductsByFiltersInDatabase(category, filters);
      widget.setParts.call(components);
    }
  }
}

// Category get selectedInventoryCategory {
//   return widget.category;
// }
