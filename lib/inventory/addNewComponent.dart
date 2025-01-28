import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guadalajarav2/alert.dart';
import 'package:guadalajarav2/enums/subCategories.dart';
import 'package:guadalajarav2/extensions/date_time_ext.dart';
import 'package:guadalajarav2/inventory/classes/capacitor.dart';
import 'package:guadalajarav2/inventory/classes/connector.dart';
import 'package:guadalajarav2/inventory/classes/discreteSemiconductor.dart';
import 'package:guadalajarav2/inventory/classes/display.dart';
import 'package:guadalajarav2/inventory/classes/inductor.dart';
import 'package:guadalajarav2/inventory/classes/integratedCircuit.dart';
import 'package:guadalajarav2/inventory/classes/led.dart';
import 'package:guadalajarav2/inventory/classes/mechanic.dart';
import 'package:guadalajarav2/inventory/classes/microcontroller.dart';
import 'package:guadalajarav2/inventory/classes/miscellaneous.dart';
import 'package:guadalajarav2/inventory/classes/optocoupler.dart';
import 'package:guadalajarav2/inventory/classes/pcb.dart';
import 'package:guadalajarav2/inventory/classes/powerSupply.dart';
import 'package:guadalajarav2/inventory/classes/product.dart';
import 'package:guadalajarav2/inventory/classes/protectionCircuit.dart';
import 'package:guadalajarav2/inventory/classes/resistor.dart';
import 'package:guadalajarav2/inventory/deleteNotification.dart';
import 'package:guadalajarav2/inventory/enums/enumFuseType.dart';
import 'package:guadalajarav2/inventory/enums/enumHertz.dart';
import 'package:guadalajarav2/inventory/enums/enumTime.dart';
import 'package:guadalajarav2/utils/colors.dart';
import 'package:guadalajarav2/database.dart';
import 'package:guadalajarav2/inventory/enums/enumCategory.dart';
import 'package:guadalajarav2/inventory/enums/enumColors.dart';
import 'package:guadalajarav2/inventory/enums/enumCurrent.dart';
import 'package:guadalajarav2/inventory/enums/enumDielectricType.dart';
import 'package:guadalajarav2/inventory/enums/enumDistance.dart';
import 'package:guadalajarav2/inventory/enums/enumFarads.dart';
import 'package:guadalajarav2/inventory/enums/enumFlash.dart';
import 'package:guadalajarav2/inventory/enums/enumHenry.dart';
import 'package:guadalajarav2/inventory/enums/enumMounting.dart';
import 'package:guadalajarav2/inventory/enums/enumOhm.dart';
import 'package:guadalajarav2/inventory/enums/enumStatus.dart';
import 'package:guadalajarav2/inventory/enums/enumTemperature.dart';
import 'package:guadalajarav2/inventory/enums/enumVoltage.dart';
import 'package:guadalajarav2/inventory/searchMenu.dart';
import 'package:guadalajarav2/utils/inventory/digikey_api_handler.dart';
import 'package:guadalajarav2/utils/inventory/mouser_api_handler.dart';
import 'package:guadalajarav2/utils/styles.dart';
import 'package:guadalajarav2/utils/tools.dart';
import 'package:guadalajarav2/utils/url_handlers.dart';
import 'package:guadalajarav2/views/dialogs/basic_text_dialog.dart';
import 'package:guadalajarav2/views/dialogs/timed_dialog.dart';
import 'package:guadalajarav2/widgets/custom/custom_button.dart';

class NewComponentScreen extends StatefulWidget {
  final Category category;
  final Product? product;
  final bool isEditing;
  final Function(List<Product> components)? updateParts;

  NewComponentScreen({
    required this.category,
    this.product,
    this.updateParts,
    this.isEditing = true,
  });

  @override
  NewComponentState createState() => NewComponentState();
}

class NewComponentState extends State<NewComponentScreen> {
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
  TextEditingController vForwardController = TextEditingController();
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
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController materialController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController vgsController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController currentTripController = TextEditingController();
  TextEditingController TimeTripController = TextEditingController();

  ProductStatus selectedStatus = ProductStatus.active;
  VoltageUnit selectedVoltage = VoltageUnit.v;
  Mounting selectedMounting = Mounting.smt;
  CurrentUnit selectedCurrent = CurrentUnit.a;
  FlashUnit selectedFlash = FlashUnit.mb;
  FlashUnit selectedRam = FlashUnit.mb;
  VoltageUnit selectedVBreakdown = VoltageUnit.v;
  VoltageUnit selectedVReverse = VoltageUnit.v;
  VoltageUnit selectedVForward = VoltageUnit.v;
  VoltageUnit selectedVClamping = VoltageUnit.v;
  TemperatureUnit selectedTemperature = TemperatureUnit.c;
  FaradsUnit selectedLoadCapacitance = FaradsUnit.f;
  DielectricType selectedDielectricType = DielectricType.ceramic;
  String selectedPower = 'power.decimal';
  DistanceUnit selectedPitch = DistanceUnit.inch;
  LedColor selectedColor = LedColor.red;
  SubCategory selectedSubCategory = SubCategory.crystal;
  HertzUnit selectedHz = HertzUnit.hz;
  FuseType selectedFuseType = FuseType.resettable;
  CurrentUnit selectedCurrTrip = CurrentUnit.a;
  TimeUnit selectedTimeTrip = TimeUnit.ms;

  FaradsUnit selectionFarad = FaradsUnit.f;
  OhmUnit selectionOhm = OhmUnit.ohm;
  HenryUnit selectionHenry = HenryUnit.h;

  List<dynamic> selections = [];
  List<dynamic> selectionUnitValues = [];
  List<TextEditingController> controllers = [];
  Map<String, String> controllersKeys = {};
  List<bool> validValues = [];
  int rows = 1;

  String? digikeyLink;
  String? mouserLink;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      editData(widget.product!);
    }

    fillLists();
  }

  @override
  Widget build(BuildContext context) {
    return newComponentContainer(widget.category);
  }

  Container newComponentContainer(
    Category category,
  ) {
    // print(widget.product!.lastEdited!);
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      padding: EdgeInsets.only(
        left: width * 0.01,
        right: width * 0.01,
        top: height * 0.02,
        bottom: height * 0.02,
      ),
      width: width * 0.4,
      height: height * (0.2 + (rows / 10)),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    widget.product == null
                        ? 'New ${toTitle(category.nameSingular)}'
                        : widget.isEditing
                            ? 'Editing ${toTitle(category.nameSingular)}'
                            : 'Last Edit: ' +
                                (widget.product!.lastEdited != null
                                    ? (widget.product!.lastEdited!
                                            .dateFormatted +
                                        ' ' +
                                        widget
                                            .product!.lastEdited!.timeFormatted)
                                    : ''),
                    maxLines: 1,
                    style: subTitle,
                  ),
                ),
                CustomButton(
                  text: 'DigiKey',
                  onPressed: digikeyLink != null
                      ? () => openLink(
                            context,
                            digikeyLink!,
                            newTab: true,
                          )
                      : widget.product == null
                          ? null
                          : () async {
                              openDialog(
                                context,
                                container: BasicTextDialog(
                                  'Searching in DigiKey',
                                ),
                                block: true,
                              );
                              Map<String, dynamic>? part =
                                  await searchInDigikey(
                                controllers[1].text,
                              );

                              Navigator.pop(context);

                              if (part != null) {
                                setState(() {
                                  digikeyLink = part['ProductUrl'];
                                  openLink(
                                    context,
                                    digikeyLink!,
                                    newTab: true,
                                  );
                                });
                              } else {
                                openDialog(
                                  context,
                                  container: TimedDialog(
                                    text: controllers[1].text +
                                        '\nnot found in DigiKey',
                                  ),
                                );
                              }
                            },
                  color: red,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: CustomButton(
                    text: 'Mouser',
                    onPressed: mouserLink != null
                        ? () => openLink(
                              context,
                              mouserLink!,
                              newTab: true,
                            )
                        : widget.product == null
                            ? null
                            : () async {
                                openDialog(
                                  context,
                                  container: BasicTextDialog(
                                    'Searching in Mouser',
                                  ),
                                  block: true,
                                );
                                Map<String, dynamic>? part =
                                    await searchInMouser(
                                  controllers[1].text,
                                );

                                Navigator.pop(context);

                                if (part != null) {
                                  setState(() {
                                    mouserLink = part['ProductDetailUrl'];
                                    openLink(
                                      context,
                                      mouserLink!,
                                      newTab: true,
                                    );
                                  });
                                } else {
                                  openDialog(context,
                                      container: TimedDialog(
                                        text: controllers[1].text +
                                            '\nnot found in Mouser',
                                      ));
                                }
                              },
                    color: blue,
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            flex: 85,
            child: Column(
              children: newAttributesInputs(),
            ),
          ),
          Divider(),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: height * 0.05,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: gray,
                      ),
                      child: AutoSizeText(
                        'Cancel',
                        maxLines: 1,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: widget.isEditing
                      ? Container()
                      : CustomButton(
                          text: 'Delete',
                          color: red,
                          icon: Icons.delete_forever_rounded,
                          onPressed: () {
                            // Navigator.pop(context);
                            openDialog(
                              context,
                              block: true,
                              container: DeleteConfirmation(
                                product: widget.product!,
                              ),
                              barrierIntensity: 0.2,
                            );
                          },
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: height * 0.05,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: widget.product == null ? green : blue,
                      ),
                      child: AutoSizeText(
                        widget.isEditing
                            ? 'Confirm Component'
                            : 'Edit Component',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      onPressed: !widget.isEditing
                          ? () {
                              Navigator.pop(context);
                              openDialog(
                                context,
                                container: NewComponentScreen(
                                  category: widget.product!.category!,
                                  product: widget.product,
                                ),
                              );
                            }
                          : () async {
                              openDialog(
                                context,
                                container: BasicTextDialog('Loading'),
                                block: true,
                              );

                              bool isValid = true;
                              bool successful = false;

                              for (int i = 0; i < 3; i++) {
                                validValues[i] = controllers[i].text.isNotEmpty;
                              }
                              if (category != Category.pcbs &&
                                  category != Category.displays &&
                                  category != Category.connectors &&
                                  category != Category.mechanics) {
                                validValues[3] =
                                    controllers[3].text.isNotEmpty; //PACKAGE
                              }

                              validValues[10] =
                                  canConvertToDouble(controllers[10].text);
                              validValues[14] =
                                  canConvertToInt(controllers[14].text);

                              if (category != Category.pcbs &&
                                  category != Category.mechanics) {
                                validValues[17] =
                                    controllers[17].text.isNotEmpty &&
                                        canConvertToDouble(
                                            controllers[17].text); //VOLTAGE
                              }

                              for (int i = 11; i < 28; i++) {
                                if (controllers[i].text.isNotEmpty) {
                                  if (i > 13 && i < 17) {
                                    validValues[i] =
                                        canConvertToInt(controllers[i].text);
                                  } else {
                                    bool isFraction = selections[13]
                                            .toString()
                                            .split('.')[1] ==
                                        'fraction';
                                    if (i == 26 && isFraction) {
                                      validValues[i] = canConvertToDouble(
                                          fractionToDecimal(controllers[i].text)
                                              .toString());
                                    } else {
                                      validValues[i] = canConvertToDouble(
                                          controllers[i].text);
                                    }
                                  }
                                }
                              }
                              VoltageUnit vUnit = selections[2];
                              Mounting mounting = selections[3];
                              CurrentUnit cUnit = selections[4];
                              FlashUnit fUnit = selections[5];
                              FlashUnit rUnit = selections[6];
                              VoltageUnit vBUnit = selections[7];
                              VoltageUnit vRUnit = selections[8];
                              VoltageUnit vCUnit = selections[9];
                              FaradsUnit lCUnit = selections[11];
                              DielectricType dielectricType = selections[12];
                              String pUnit =
                                  selections[13].toString().split('.')[1];
                              FaradsUnit faradUnit = selections[14];
                              OhmUnit oUnit = selections[15];
                              HenryUnit hUnit = selections[16];
                              DistanceUnit pitchUnit = selections[17];
                              SubCategory subCategory = selections[19];
                              VoltageUnit vFUnit = selections[20];
                              HertzUnit hzUnit = selections[21];
                              FuseType fType = selections[22];
                              CurrentUnit cTripUnit = selections[23];
                              TimeUnit tTripUnit = selections[24];

                              if (category == Category.capacitors) {
                                if (dielectricType == DielectricType.ceramic) {
                                  validValues[9] =
                                      controllers[9].text.isNotEmpty;
                                } else {
                                  validValues[9] = true;
                                }
                              }

                              if (category ==
                                  Category.discrete_semiconductors) {
                                if (subCategory == SubCategory.transistor ||
                                    subCategory == SubCategory.mosfet ||
                                    subCategory == SubCategory.diode) {
                                  validValues[17] =
                                      canConvertToDouble(controllers[17].text);
                                } else {
                                  controllers[17].text = '';
                                  validValues[17] = true;
                                }
                              }

                              setState(() {
                                isValid = verifyAllValues(validValues);
                              });

                              if (isValid) {
                                String description = controllers[0].text;
                                String mpn = controllers[1].text;
                                String manufacturer = controllers[2].text;
                                String package = controllers[3].text;
                                String interface = controllers[4].text;
                                String resolution = controllers[5].text;
                                String channelType = controllers[6].text;
                                String contactType = controllers[7].text;
                                String material = controllers[9].text;

                                double unitPrice =
                                    double.parse(controllers[10].text);
                                double? speed =
                                    double.tryParse(controllers[11].text);
                                double? tolerance =
                                    double.tryParse(controllers[12].text);
                                double? pitch =
                                    double.tryParse(controllers[13].text);

                                int quantity = int.parse(controllers[14].text);
                                int? pinCount =
                                    int.tryParse(controllers[15].text);
                                int? row = int.tryParse(controllers[16].text);

                                double? voltage =
                                    double.tryParse(controllers[17].text);
                                print('voltage $voltage');

                                double? current =
                                    double.tryParse(controllers[18].text);
                                double? flash =
                                    double.tryParse(controllers[19].text);
                                double? ram =
                                    double.tryParse(controllers[20].text);
                                double? vBreakdown =
                                    double.tryParse(controllers[21].text);
                                double? vReverse =
                                    double.tryParse(controllers[22].text);
                                double? vClamping =
                                    double.tryParse(controllers[23].text);
                                double? temperature =
                                    double.tryParse(controllers[24].text);
                                double? loadCapacitance =
                                    double.tryParse(controllers[25].text);
                                double? power;
                                if (pUnit == 'fraction') {
                                  if (controllers[26].text.isNotEmpty) {
                                    power =
                                        fractionToDecimal(controllers[26].text);
                                  }
                                } else {
                                  power = double.tryParse(controllers[26].text);
                                }
                                double? value =
                                    double.tryParse(controllers[27].text);

                                ProductStatus status = selections[1];

                                if (voltage != null) {
                                  voltage =
                                      VoltageUnit.v.convertFrom(voltage, vUnit);
                                }
                                if (current != null) {
                                  current =
                                      CurrentUnit.a.convertFrom(current, cUnit);
                                }
                                if (flash != null) {
                                  flash =
                                      FlashUnit.mb.convertFrom(flash, fUnit);
                                }
                                if (ram != null) {
                                  ram = FlashUnit.mb.convertFrom(ram, rUnit);
                                }
                                if (vBreakdown != null) {
                                  vBreakdown = VoltageUnit.v
                                      .convertFrom(vBreakdown, vBUnit);
                                }
                                if (vReverse != null) {
                                  vReverse = VoltageUnit.v
                                      .convertFrom(vReverse, vRUnit);
                                }
                                if (vClamping != null) {
                                  vClamping = VoltageUnit.v
                                      .convertFrom(vClamping, vCUnit);
                                }

                                if (loadCapacitance != null) {
                                  loadCapacitance = FaradsUnit.f
                                      .convertFrom(loadCapacitance, lCUnit);
                                }

                                if (value != null) {
                                  switch (category.unitValue) {
                                    case FaradsUnit:
                                      value = FaradsUnit.f
                                          .convertFrom(value, faradUnit);
                                      break;
                                    case OhmUnit:
                                      value =
                                          OhmUnit.ohm.convertFrom(value, oUnit);
                                      break;
                                    case HenryUnit:
                                      value =
                                          HenryUnit.h.convertFrom(value, hUnit);
                                      break;
                                  }
                                }

                                if (pitch != null) {
                                  pitch = DistanceUnit.inch
                                      .convertFrom(pitch, pitchUnit);
                                }
                                LedColor color = selections[18];
                                double? vForward =
                                    double.tryParse(controllers[22].text);

                                if (vForward != null) {
                                  vForward = VoltageUnit.v
                                      .convertFrom(vForward, vFUnit);
                                }

                                double? frequency =
                                    double.tryParse(controllers[30].text);

                                if (frequency != null) {
                                  frequency = HertzUnit.hz
                                      .convertFrom(frequency, hzUnit);
                                }

                                int? vgs = int.tryParse(controllers[29].text);

                                double? currentTrip =
                                    double.tryParse(controllers[31].text);

                                if (currentTrip != null) {
                                  currentTrip = CurrentUnit.a
                                      .convertFrom(currentTrip, cTripUnit);
                                }
                                double? timeTrip =
                                    double.tryParse(controllers[31].text);

                                if (timeTrip != null) {
                                  timeTrip = TimeUnit.ms
                                      .convertFrom(timeTrip, tTripUnit);
                                }

                                switch (category) {
                                  case Category.capacitors:
                                    Capacitor capacitor = new Capacitor(
                                      category,
                                      description, // description
                                      unitPrice, //unitprice
                                      mpn, // mpn
                                      manufacturer, // manufacturer
                                      quantity, //quantity
                                      status, //Status
                                      DateTime.now(),
                                      voltage, //voltage
                                      mounting, // mounting
                                      package, //package
                                      value, //value
                                      tolerance, //tolerance
                                      dielectricType, //dielectric type
                                      material,
                                    );

                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          capacitor, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, capacitor);
                                    }

                                    //material
                                    break;
                                  case Category.connectors:
                                    Connector connector = new Connector(
                                        category,
                                        description,
                                        unitPrice,
                                        mpn,
                                        manufacturer,
                                        quantity,
                                        status,
                                        DateTime.now(),
                                        voltage,
                                        mounting,
                                        current,
                                        pinCount,
                                        pitch,
                                        row,
                                        contactType);

                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          connector, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, connector);
                                    }

                                    break;
                                  case Category.discrete_semiconductors:
                                    DiscreteSemiconductor
                                        discreteSemiconductor =
                                        new DiscreteSemiconductor(
                                      category,
                                      description,
                                      unitPrice,
                                      mpn,
                                      manufacturer,
                                      quantity,
                                      status,
                                      DateTime.now(),
                                      voltage,
                                      mounting,
                                      package,
                                      current,
                                      speed,
                                      vBreakdown,
                                      vReverse,
                                      vClamping,
                                      loadCapacitance,
                                      channelType,
                                      subCategory,
                                      voltageForward: vForward,
                                      frequency: frequency,
                                      vgs: vgs,
                                    );

                                    print(voltage);

                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          discreteSemiconductor,
                                          selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys,
                                          discreteSemiconductor);
                                    }

                                    break;
                                  case Category.displays:
                                    Display display = new Display(
                                        category,
                                        description,
                                        unitPrice,
                                        mpn,
                                        manufacturer,
                                        quantity,
                                        status,
                                        DateTime.now(),
                                        voltage,
                                        current,
                                        interface,
                                        resolution);

                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          display, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, display);
                                    }

                                    break;
                                  case Category.inductors:
                                    Inductor inductor = new Inductor(
                                        category,
                                        description,
                                        unitPrice,
                                        mpn,
                                        manufacturer,
                                        quantity,
                                        status,
                                        DateTime.now(),
                                        voltage,
                                        mounting,
                                        package,
                                        current,
                                        value,
                                        tolerance);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          inductor, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, inductor);
                                    }

                                    break;
                                  case Category.integrated_circuits:
                                    IntegratedCircuit integratedCircuit =
                                        new IntegratedCircuit(
                                            category,
                                            description,
                                            unitPrice,
                                            mpn,
                                            manufacturer,
                                            quantity,
                                            status,
                                            DateTime.now(),
                                            voltage,
                                            mounting,
                                            package,
                                            current,
                                            power,
                                            speed,
                                            pinCount,
                                            flash,
                                            ram);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          integratedCircuit, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, integratedCircuit);
                                    }

                                    break;
                                  case Category.leds:
                                    Led led = new Led(
                                      category,
                                      description,
                                      unitPrice,
                                      mpn,
                                      manufacturer,
                                      quantity,
                                      status,
                                      DateTime.now(),
                                      voltage,
                                      mounting,
                                      package,
                                      temperature,
                                      color,
                                      current: current,
                                    );
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          led, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, led);
                                    }

                                    break;
                                  case Category.mechanics:
                                    Mechanic mechanic = new Mechanic(
                                      category,
                                      description,
                                      unitPrice,
                                      mpn,
                                      manufacturer,
                                      quantity,
                                      status,
                                      DateTime.now(),
                                    );
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          mechanic, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, mechanic);
                                    }
                                    break;
                                  case Category.pcbs:
                                    Pcb pcb = new Pcb(
                                      category,
                                      description,
                                      unitPrice,
                                      mpn,
                                      manufacturer,
                                      quantity,
                                      status,
                                      DateTime.now(),
                                    );
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          pcb, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, pcb);
                                    }

                                    break;
                                  case Category.microcontrollers:
                                    Microcontroller microcontroller =
                                        new Microcontroller(
                                            category,
                                            description,
                                            unitPrice,
                                            mpn,
                                            manufacturer,
                                            quantity,
                                            status,
                                            DateTime.now(),
                                            voltage,
                                            mounting,
                                            package,
                                            speed,
                                            pinCount,
                                            flash,
                                            ram);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          microcontroller, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, microcontroller);
                                    }

                                    break;
                                  case Category.miscellaneous:
                                    Miscellaneous miscellaneous =
                                        new Miscellaneous(
                                            category,
                                            description,
                                            unitPrice,
                                            mpn,
                                            manufacturer,
                                            quantity,
                                            status,
                                            DateTime.now(),
                                            voltage,
                                            mounting,
                                            package,
                                            current);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          miscellaneous, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, miscellaneous);
                                    }

                                    break;
                                  case Category.optocouplers:
                                    Optocoupler optocoupler = new Optocoupler(
                                        category,
                                        description,
                                        unitPrice,
                                        mpn,
                                        manufacturer,
                                        quantity,
                                        status,
                                        DateTime.now(),
                                        voltage,
                                        mounting,
                                        package,
                                        current,
                                        speed);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          optocoupler, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, optocoupler);
                                    }

                                    break;

                                  case Category.power_supplies:
                                    PowerSupply powerSupply = new PowerSupply(
                                        category,
                                        description,
                                        unitPrice,
                                        mpn,
                                        manufacturer,
                                        quantity,
                                        status,
                                        DateTime.now(),
                                        voltage,
                                        mounting,
                                        package,
                                        current,
                                        power);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          powerSupply, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, powerSupply);
                                    }

                                    break;
                                  case Category.protection_circuits:
                                    ProtectionCircuit protectionCircuit =
                                        new ProtectionCircuit(
                                      category,
                                      description,
                                      unitPrice,
                                      mpn,
                                      manufacturer,
                                      quantity,
                                      status,
                                      DateTime.now(),
                                      voltage,
                                      mounting,
                                      package,
                                      current,
                                      power,
                                      vBreakdown,
                                      vReverse,
                                      vClamping,
                                      channelType,
                                      subCategory,
                                      fuseType: fType,
                                      currentTrip: currentTrip,
                                      timeTrip: timeTrip,
                                    );

                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          protectionCircuit, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, protectionCircuit);
                                    }

                                    break;
                                  case Category.resistors:
                                    Resistor resistor = new Resistor(
                                        category,
                                        description,
                                        unitPrice,
                                        mpn,
                                        manufacturer,
                                        quantity,
                                        status,
                                        DateTime.now(),
                                        voltage,
                                        mounting,
                                        package,
                                        power,
                                        value,
                                        tolerance);
                                    if (widget.product == null) {
                                      successful = await addNewComponent(
                                          resistor, selectedCategory);
                                    } else {
                                      successful = await editComponent(
                                          controllersKeys, resistor);
                                    }

                                    break;
                                }
                              }
                              if (!isValid) {
                                Navigator.pop(context);
                                containerDialog(
                                  context,
                                  false,
                                  AlertNotification(
                                    color: red,
                                    icon: Icons.warning_amber_rounded,
                                    str: 'Invalid Values',
                                  ),
                                  0.15,
                                );
                              } else {
                                if (successful) {
                                  List<Product> components =
                                      await searchProductsByCategoryInDatabase(
                                          category);

                                  if (widget.updateParts != null) {
                                    widget.updateParts!.call(components);
                                  }

                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  containerDialog(
                                    context,
                                    true,
                                    AlertNotification(
                                      color: green,
                                      icon: Icons.check_circle,
                                      str: widget.product == null
                                          ? 'Component Added'
                                          : 'Component ${widget.product!.mpn} Edited',
                                    ),
                                    0.15,
                                  );
                                } else {
                                  bool exists = false;
                                  List<Product> products =
                                      await searchProductByMPNInDatabase(
                                          mpnController.text);

                                  exists = products.length > 0;
                                  Navigator.pop(context);

                                  if (exists) {
                                    openDialog(
                                      context,
                                      container: TimedDialog(
                                        text: 'Product already exists',
                                      ),
                                    );
                                  } else {
                                    openDialog(
                                      context,
                                      container: TimedDialog(
                                        text:
                                            'There was an error while adding Component',
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding input(String name, Widget inputContainer) {
    if (toTitle(name) == 'Speed') {
      name = 'Speed (Mbps)';
    } else if (toTitle(name) == 'Power') {
      name = 'Power (Watts)';
    } else if (toTitle(name) == 'Temperature') {
      name = 'Milicandela Rating (mcd)';
    }
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.01,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  '$name',
                  minFontSize: 1,
                  maxFontSize: 13,
                  style: inputLabelText,
                ),
                name.toLowerCase() == 'mpn'
                    ? IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: controllers[1].text,
                            ),
                          );
                          showToast(
                            context,
                            text: 'Copied to clipboard',
                            icon: Icons.copy,
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          size: 15,
                          color: gray,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(child: inputContainer),
        ],
      ),
    );
  }

  AutoSizeTextField fillInput(
    TextEditingController controller, {
    VoidCallback? onEnter,
  }) {
    bool enabled = true;
    int controllerIndex = controllers.indexOf(controller);
    if (selectedCategory == Category.capacitors) {
      enabled = (controllerIndex != 9 ||
          (controllerIndex == 9 &&
              selections[12] != DielectricType.electrolytic));
    } else if (selectedCategory == Category.protection_circuits) {
      if (controllerIndex == 31 || controllerIndex == 32) {
        enabled = selections[22] == FuseType.resettable;
      }
    }
    if (!enabled) {
      controller.text = '';
    } else {
      if (widget.product != null && controllerIndex == 1) {
        enabled = false;
      }
    }

    return AutoSizeTextField(
      wrapWords: false,
      enabled: enabled && widget.isEditing,
      controller: controller,
      // expands: true,
      textAlignVertical: TextAlignVertical.center,
      // minLines: null,
      // maxLines: null,

      textAlign: TextAlign.center,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: enabled ? '' : 'N/A',
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        fillColor: enabled ? lightGrey : backgroundColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: validValues[controllerIndex] ? backgroundColor : red,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: backgroundColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: backgroundColor,
          ),
        ),
        focusColor: darkGrey,
      ),
      onSubmitted: (String value) {
        if (controller == quantityController) {
          String equation = value.replaceAll(
            new RegExp(r"\s+"),
            "",
          );
          int sum = 0;
          bool isValid = true;
          for (String s in equation.split('+')) {
            if (s.contains('-')) {
              String s1 = s.split('-')[0];
              int? toAdd = int.tryParse(s1);
              if (toAdd != null) {
                sum += toAdd;
              } else {
                isValid = false;
                break;
              }
              for (String s2 in s.split('-').sublist(1)) {
                int? toRest = int.tryParse(s2);
                if (toRest != null) {
                  sum -= toRest;
                } else {
                  isValid = false;
                  break;
                }
              }
            } else {
              int? toAdd = int.tryParse(s);
              if (toAdd != null) {
                sum += toAdd;
              } else {
                isValid = false;
                break;
              }
            }
            if (!isValid) {
              break;
            }
          }
          if (!isValid) {
            controller.text = '';
          } else {
            controller.text = '$sum';
          }
        } else {
          if (onEnter != null) {
            onEnter.call();
          }
        }
      },
    );
  }

  Widget dropdownInput<T>(
    List<T> values,
    int index, {
    bool enabled = false,
    Function(T? value)? onChanged,
  }) {
    enabled = widget.isEditing || enabled;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        color: lightGrey,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            style: dropdownButtonGrey,
            items: values.map(
              (T item) {
                String name = separateWords(
                        item.toString().split('.')[1].split('_').join(' '))
                    .toUpperCase();

                return DropdownMenuItem<T>(
                  value: item,
                  child: Center(
                    child: AutoSizeText(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 1,
                      style: subTitleSearchMenu,
                    ),
                  ),
                );
              },
            ).toList(),
            isExpanded: true,
            isDense: true,
            value: selections[index],
            onChanged: enabled
                ? onChanged == null
                    ? (T? newValue) {
                        setState(() {
                          selections[index] = newValue;
                        });
                      }
                    : onChanged
                : null,
          ),
        ),
      ),
    );
  }

  Row fillDropdownInput<T>(
    TextEditingController controller,
    List<T> values,
    int index,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: width * 0.01),
            child: fillInput(controller),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                  child: dropdownInput<T>(
                    values,
                    index,
                    enabled: true,
                    onChanged: widget.isEditing
                        ? null
                        : (T? value) =>
                            changeValue<T>(value, controller, index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void changeValue<T>(T? value, TextEditingController controller, int index) {
    if (value == null) {
      return;
    } else {
      switch (value.runtimeType) {
        case VoltageUnit:
          controller.text = (value as VoltageUnit)
              .convertFrom(double.parse(controller.text), selections[index])
              .toString();

          break;
        case FaradsUnit:
          if (widget.category != Category.discrete_semiconductors) {
            controller.text = FaradsUnit.f
                .convertTo(
                    (widget.product! as dynamic).value, (value as FaradsUnit))
                .toString();
          } else {
            controller.text = FaradsUnit.f
                .convertTo(
                    (widget.product! as DiscreteSemiconductor).loadCapacitance,
                    (value as FaradsUnit))
                .toString();
          }
          break;
        case FlashUnit:
          if (widget.category == Category.integrated_circuits) {
            if (index == 5) {
              controller.text = FlashUnit.mb
                  .convertTo((widget.product! as IntegratedCircuit).flash,
                      (value as FlashUnit))
                  .toString();
            } else if (index == 6) {
              controller.text = FlashUnit.mb
                  .convertTo((widget.product! as IntegratedCircuit).ram,
                      (value as FlashUnit))
                  .toString();
            }
          } else if (widget.category == Category.microcontrollers) {
            if (index == 5) {
              controller.text = FlashUnit.mb
                  .convertTo((widget.product! as Microcontroller).flash,
                      (value as FlashUnit))
                  .toString();
            } else if (index == 6) {
              controller.text = FlashUnit.mb
                  .convertTo((widget.product! as Microcontroller).ram,
                      (value as FlashUnit))
                  .toString();
            }
          } else {}
          break;
        case String:
          if (value.toString().toLowerCase() == 'power.fraction') {
            controller.text =
                decimalToFraction((widget.product! as dynamic).power)
                    .toString();
          } else {
            controller.text = (widget.product! as dynamic).power.toString();
          }
          break;
        case HenryUnit:
          controller.text = HenryUnit.h
              .convertTo(
                  (widget.product! as dynamic).value, (value as HenryUnit))
              .toString();

          break;
        case OhmUnit:
          controller.text = OhmUnit.ohm
              .convertTo((widget.product! as dynamic).value, (value as OhmUnit))
              .toString();

          break;
        case CurrentUnit:
          controller.text = CurrentUnit.a
              .convertTo(
                  (widget.product! as dynamic).current, (value as CurrentUnit))
              .toString();
          break;
        case DistanceUnit:
          controller.text = DistanceUnit.inch
              .convertTo(
                  (widget.product! as dynamic).pitch, (value as DistanceUnit))
              .toString();
          break;

        default:
          // print(value.runtimeType);
          break;
      }
    }
    setState(() {
      selections[index] = value;
    });
  }

  List<Widget> newAttributesInputs() {
    // print(selectedSubCategory.toString());
    Widget description = input('Description', fillInput(controllers[0]));
    Widget mpn = input(
      'MPN',
      fillInput(
        controllers[1],
        onEnter: () async {
          Map<String, dynamic>? part =
              await searchInDigikey(controllers[1].text);

          // print(part);

          if (part != null) {
            digikeyLink = part['ProductUrl'];
            controllers[0].text = part['ProductDescription'];
            Map<String, dynamic>? partManufacturer = part['Manufacturer'];
            if (partManufacturer != null) {
              controllers[2].text = partManufacturer['Value'];
            }
            controllers[10].text = part['UnitPrice'].toString();
            if (part['ProductStatus'] == 'Active') {
              selections[1] = ProductStatus.active;
            } else {
              selections[1] = ProductStatus.obsolete;
            }

            Map<String, dynamic>? family = part['Family'];
            if (family != null) {
              if (family['Value'].toString().contains('Surface Mount')) {
                selections[3] = Mounting.smt;
              } else if (family['Value'].toString().contains('Capacitors')) {
                if (family['Value'].toString().contains('Ceramic')) {
                  selections[12] = DielectricType.ceramic;
                } else {
                  selections[12] = DielectricType.electrolytic;
                }
              }
            }

            setParameters(part['Parameters']);
          }
          Map<String, dynamic>? mouserPart =
              await searchInMouser(controllers[1].text);
          if (mouserPart != null) {
            mouserLink = mouserPart['ProductDetailUrl'];
            if (part == null) {
              controllers[0].text = mouserPart['Description'];
              controllers[2].text = mouserPart['Manufacturer'];
              if (mouserPart['PriceBreaks'].length != 0) {
                controllers[10].text = mouserPart['PriceBreaks'][0]['Price']
                    .toString()
                    .replaceAll('\$', '');
              }
            }
          } else {
            mouserLink = null;
            // print('not found');
          }

          setState(() {});
        },
      ),
    );
    Widget manufacturer = input('Manufacturer', fillInput(controllers[2]));
    Widget package = input('Package', fillInput(controllers[3]));
    Widget interface = input('Interface', fillInput(controllers[4]));
    Widget resolution = input('Resolution', fillInput(controllers[5]));
    Widget channelType = input('Channel Type', fillInput(controllers[6]));
    Widget contactType = input('Contact Type', fillInput(controllers[7]));
    Widget material =
        input('Temperature Coefficient', fillInput(controllers[9]));

    Widget unitPrice = input('Unit Price', fillInput(controllers[10]));
    Widget speed = input('Speed', fillInput(controllers[11]));
    Widget tolerance = input('Tolerance', fillInput(controllers[12]));

    Widget quantity = input('Quantity', fillInput(controllers[14]));
    Widget pinCount = input('Pin Count', fillInput(controllers[15]));
    Widget row = input('Row', fillInput(controllers[16]));
    Widget temperature = input('Temperature', fillInput(controllers[24]));
    Widget status =
        input('Status', dropdownInput<ProductStatus>(ProductStatus.values, 1));
    Widget mounting =
        input('Mounting', dropdownInput<Mounting>(Mounting.values, 3));
    Widget dielectricType = input('Dielectric Type',
        dropdownInput<DielectricType>(DielectricType.values, 12));

    Widget color = input('Color', dropdownInput<LedColor>(LedColor.values, 18));
    Widget voltage = input('Voltage',
        fillDropdownInput<VoltageUnit>(controllers[17], VoltageUnit.values, 2));
    Widget current = input('Current',
        fillDropdownInput<CurrentUnit>(controllers[18], CurrentUnit.values, 4));
    Widget flash = input('Flash',
        fillDropdownInput<FlashUnit>(controllers[19], FlashUnit.values, 5));
    Widget ram = input('Ram',
        fillDropdownInput<FlashUnit>(controllers[20], FlashUnit.values, 6));
    Widget vBreakdown = input('V. Breakdown',
        fillDropdownInput<VoltageUnit>(controllers[21], VoltageUnit.values, 7));
    Widget vReverse = input('V. Reverse',
        fillDropdownInput<VoltageUnit>(controllers[22], VoltageUnit.values, 8));
    Widget vFordward = input(
        'V. Forward',
        fillDropdownInput<VoltageUnit>(
            controllers[28], VoltageUnit.values, 20));
    Widget vClamping = input('V. Clamping',
        fillDropdownInput<VoltageUnit>(controllers[23], VoltageUnit.values, 9));

    Widget loadCapacitance = input('Load Capacitance',
        fillDropdownInput<FaradsUnit>(controllers[25], FaradsUnit.values, 11));

    Widget power = input(
        'Power',
        fillDropdownInput<String>(
            controllers[26], ['power.decimal', 'power.fraction'], 13));
    Widget value;
    switch (selectedCategory) {
      case Category.capacitors:
        value = input(
            'Value',
            fillDropdownInput<FaradsUnit>(
                controllers[27], FaradsUnit.values, 14));
        break;
      case Category.resistors:
        value = input('Value',
            fillDropdownInput<OhmUnit>(controllers[27], OhmUnit.values, 15));
        break;
      case Category.inductors:
        value = input(
            'Value',
            fillDropdownInput<HenryUnit>(
                controllers[27], HenryUnit.values, 16));
        break;

      default:
        value = Container();
        break;
    }

    Widget pitch = input(
        'Pitch',
        fillDropdownInput<DistanceUnit>(
            controllers[13], DistanceUnit.values, 17));

    Widget subCategory = input(
      'SubCategory',
      dropdownInput<SubCategory>(selectedCategory.subCategories, 19),
    );

    Widget vgs = input('VGS (V)', fillInput(controllers[29]));
    Widget frequency = input('Frequency',
        fillDropdownInput<HertzUnit>(controllers[30], HertzUnit.values, 21));

    Widget fuseType = input(
      'Fuse Type',
      dropdownInput<FuseType>(FuseType.values, 22),
    );

    Widget currentTrip = input(
        'Current Trip',
        fillDropdownInput<CurrentUnit>(
            controllers[31], CurrentUnit.values, 23));
    Widget timeTrip = input('Time Trip',
        fillDropdownInput<TimeUnit>(controllers[32], TimeUnit.values, 24));

    switch (widget.category) {
      case Category.capacitors:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description],
          [voltage, tolerance],
          [value, package],
          [dielectricType, material]
        ]);

      case Category.connectors:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description],
          [voltage, current],
          [pinCount, row],
          [pitch, contactType],
        ]);

      case Category.discrete_semiconductors:
        switch (selections[19]) {
          case SubCategory.diode:
            return createGrid([
              [mpn, manufacturer, status],
              [unitPrice, quantity, mounting],
              [description],
              [voltage, subCategory],
              [vReverse, current],
              [vFordward, package],
            ]);
          case SubCategory.crystal:
            return createGrid([
              [mpn, manufacturer, status],
              [unitPrice, quantity, mounting],
              [description, subCategory],
              [frequency, package],
              [loadCapacitance],
            ]);
          case SubCategory.transistor:
            return createGrid([
              [mpn, manufacturer, status],
              [unitPrice, quantity, mounting],
              [description, subCategory],
              [channelType, voltage],
              [current, package],
            ]);
          case SubCategory.mosfet:
            return createGrid([
              [mpn, manufacturer, status],
              [unitPrice, quantity, mounting],
              [description, subCategory, package],
              [channelType, voltage],
              [current, vgs],
            ]);
          case SubCategory.protectionCircuits:
          case SubCategory.fuses:
            break;
        }
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description, subCategory, package],
          [voltage, current],
          [speed, channelType],
          [vBreakdown, vReverse],
          [vClamping, loadCapacitance]
        ]);

      case Category.displays:
        return createGrid([
          [mpn, manufacturer],
          [unitPrice, quantity, status],
          [description],
          [voltage, current],
          [interface, resolution]
        ]);

      case Category.inductors:
        return createGrid([
          [mpn, manufacturer],
          [unitPrice, quantity, status],
          [description],
          [mounting, value],
          [voltage, current],
          [package, tolerance],
        ]);

      case Category.integrated_circuits:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description],
          [voltage, current],
          [package, power],
          [speed, pinCount],
          [flash, ram],
        ]);

      case Category.leds:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description, package],
          [voltage, current],
          [temperature, color]
        ]);

      case Category.pcbs:
      case Category.mechanics:
        return createGrid([
          [mpn, manufacturer],
          [unitPrice, quantity, status],
          [description],
        ]);
      case Category.microcontrollers:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description],
          [voltage, package],
          [speed, pinCount],
          [flash, ram],
        ]);
      case Category.miscellaneous:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description, package],
          [voltage, current],
        ]);
      case Category.optocouplers:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description],
          [voltage, current],
          [package, speed],
        ]);
      case Category.power_supplies:
        return createGrid([
          [mpn, manufacturer, status],
          [unitPrice, quantity, mounting],
          [description],
          [voltage, current],
          [package, power],
        ]);
      case Category.protection_circuits:
        switch (selections[19]) {
          case SubCategory.diode:
          case SubCategory.crystal:
          case SubCategory.transistor:
          case SubCategory.mosfet:
            break;
          case SubCategory.protectionCircuits:
            // TODO: Handle this case.
            break;
          case SubCategory.fuses:
            return createGrid(
              [
                [mpn, manufacturer, status],
                [unitPrice, quantity, mounting],
                [description, subCategory],
                [fuseType, package],
                [voltage, current],
                [currentTrip, timeTrip]
              ],
            );
        }

        return createGrid(
          [
            [mpn, manufacturer, status],
            [unitPrice, quantity, mounting],
            [description, subCategory],
            [voltage, current],
            [package, power],
            [vBreakdown, vReverse],
            [vClamping, channelType],
          ],
        );
      case Category.resistors:
        return createGrid(
          [
            [mpn, manufacturer, status],
            [unitPrice, quantity, mounting],
            [description, package],
            [voltage, tolerance],
            [value, power],
          ],
        );
    }
  }

  List<Widget> createGrid(List<List<Widget>> children) {
    List<Widget> columns = [];
    int columnCount = 0;
    for (List<Widget> widgets in children) {
      List<Widget> rows = [];
      int rowCount = 0;
      for (Widget widget in widgets) {
        rows.add(
          Expanded(
            flex:
                columnCount == 2 && widgets.length > 1 && rowCount == 0 ? 2 : 1,
            child: Container(
              child: Center(
                child: widget,
              ),
            ),
          ),
        );
        rowCount++;
      }

      columnCount++;

      columns.add(
        Expanded(
          child: Row(
            children: rows,
          ),
        ),
      );
    }

    return columns;
  }

  void editData(Product product) {
    Map<String, dynamic> attributes = product.toJson();
    for (String key in attributes.keys) {
      dynamic value = attributes[key];

      if (value == null) {
        value = '';
      }

      switch (key) {
        case 'description':
          descriptionController.text = value.toString();
          break;
        case 'mpn':
          mpnController.text = value.toString();
          break;
        case 'manufacturer':
          manufacturerController.text = value.toString();
          break;
        case 'quantity':
          quantityController.text = value.toString();
          break;
        case 'unitPrice':
          unitPriceController.text = value.toString();
          break;
        case 'voltage':
          voltageController.text = value.toString();
          break;
        case 'package':
          packageController.text = value.toString();
          break;
        case 'current':
          currentController.text = value.toString();
          break;
        case 'power':
          powerController.text = value.toString();
          break;
        case 'speed':
          speedController.text = value.toString();
          break;
        case 'value':
          valueController.text = value.toString();
          break;
        case 'pinCount':
          pinCountController.text = value.toString();
          break;
        case 'tolerance':
          toleranceController.text = value.toString();
          break;
        case 'flash':
          flashController.text = value.toString();
          break;
        case 'ram':
          ramController.text = value.toString();
          break;
        case 'voltageBreakdown':
          vBreakdownController.text = value.toString();
          break;
        case 'voltageReverse':
          vReverseController.text = value.toString();
          break;
        case 'voltageForward':
          vForwardController.text = value.toString();
          break;
        case 'voltageClamping':
          vClampingController.text = value.toString();
          break;
        case 'temperature':
          temperatureController.text = value.toString();
          break;
        case 'pitch':
          pitchController.text = value.toString();
          break;
        case 'row':
          rowController.text = value.toString();
          break;
        case 'interface':
          interfaceController.text = value.toString();
          break;
        case 'resolution':
          resolutionController.text = value.toString();
          break;
        case 'loadCapacitance':
          loadCapacitanceController.text = value.toString();
          break;
        case 'channelType':
          channelTypeController.text = value.toString();
          break;
        case 'contactType':
          contactTypeController.text = value.toString();
          break;
        case 'color':
          selectedColor = LedColor.values[value];
          break;
        case 'material':
          materialController.text = value.toString();
          break;
        case 'status':
          selectedStatus = ProductStatus.values[value];
          break;
        case 'mounting':
          selectedMounting = Mounting.values[value];
          break;
        case 'dielectricType':
          selectedDielectricType = DielectricType.values[value];
          break;
        case 'subCategory':
          if (value.toString().isEmpty) {
            value = 0;
          }
          selectedSubCategory = SubCategory.values[value];
          break;
        case 'vgs':
          vgsController.text = value.toString();
          break;
        case 'fuseType':
          if (value.toString().isEmpty) {
            value = 0;
          }
          selectedFuseType = FuseType.values[value];
          break;
        case 'frequency':
          frequencyController.text = value.toString();
          break;
        case 'currentTrip':
          currentTripController.text = value.toString();
          break;
        case 'timeTrip':
          TimeTripController.text = value.toString();
          break;
      }
    }

    // print('edited');
  }

  void fillLists() {
    if (selectedCategory == Category.discrete_semiconductors ||
        selectedCategory == Category.protection_circuits) {
      if (widget.product != null && widget.product!.subCategory != null) {
        selectedSubCategory = widget.product!.subCategory!;
      } else {
        selectedSubCategory = selectedCategory.subCategories[0];
      }
    }

    selections = [
      selectedCategory, //0
      selectedStatus, // 1 <-
      selectedVoltage, //2
      selectedMounting, // 3 <-
      selectedCurrent, //4
      selectedFlash, //5
      selectedRam, //6
      selectedVBreakdown, //7
      selectedVReverse, //8
      selectedVClamping, //9
      selectedTemperature, //10
      selectedLoadCapacitance, //11
      selectedDielectricType, //12
      selectedPower, //13
      selectionFarad, //14
      selectionOhm, //15
      selectionHenry, //16
      selectedPitch, //17
      selectedColor, //18
      selectedSubCategory, // 19
      selectedVForward, //20
      selectedHz, //21
      selectedFuseType, //22
      selectedCurrTrip, //23,
      selectedTimeTrip, //24
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
      packageController, //3
      interfaceController, //4
      resolutionController, //5
      channelTypeController, //6
      contactTypeController, //7
      colorController, //8
      materialController, //9

      unitPriceController, //10
      speedController, //11
      toleranceController, //12
      pitchController, //13

      quantityController, //14
      pinCountController, //15
      rowController, //16

      voltageController, //17
      currentController, //18
      flashController, //19
      ramController, //20
      vBreakdownController, //21
      vReverseController, //22
      vClampingController, //23
      temperatureController, //24
      loadCapacitanceController, //25
      powerController, //26
      valueController, //27

      vForwardController, //28
      vgsController, //29
      frequencyController, //30

      currentTripController, //31
      TimeTripController, //32
    ];
    validValues = [];

    for (TextEditingController _ in controllers) {
      // controller.text = '';
      validValues.add(true);
    }

    controllersKeys = {
      'description': 'string',
      'mpn': 'string',
      'manufacturer': 'string',
      'voltage': 'float',
      'package': 'string',
      'current': 'float',
      'power': 'float',
      'speed': 'float',
      'value': 'float',
      'pinCount': 'int',
      'tolerance': 'float',
      'flash': 'float',
      'ram': 'float',
      'voltageBreakdown': 'float',
      'voltageReverse': 'float',
      'voltageClamping': 'float',
      'dielectricType': 'int',
      'temperature': 'float',
      'pitch': 'float',
      'row': 'int',
      'interface': 'string',
      'resolution': 'string',
      'loadCapacitance': 'float',
      'channelType': 'string', //23
      'contactType': 'string',
      'status': 'int',
      'mounting': 'int',
      'quantity': 'int',
      'unitPrice': 'float',
      'color': 'int',
      'material': 'string',
      'subCategory': 'int',
      'voltageForward': 'float',
      'vgs': 'int',
      'frequency': 'float',
      'fuseType': 'int',
      'currentTrip': 'float',
      'timeTrip': 'float',
    };

    switch (selectedCategory) {
      case Category.mechanics:
      case Category.pcbs:
        rows = 3;
        break;
      case Category.miscellaneous:
        rows = 4;
        break;
      case Category.capacitors:
      case Category.connectors:
      case Category.displays:
      case Category.leds:
      case Category.optocouplers:
      case Category.power_supplies:
      case Category.resistors:
      case Category.discrete_semiconductors:
        rows = 5;
        break;
      case Category.inductors:
      case Category.microcontrollers:
        rows = 6;
        break;
      case Category.integrated_circuits:
      case Category.protection_circuits:
        if (selectedSubCategory == SubCategory.fuses) {
          rows = 5;
        } else {
          rows = 7;
        }
        break;
    }
  }

  void setParameters(List<dynamic> params) {
    Map<String, dynamic> parameters = {};
    for (dynamic param in params) {
      parameters[param['Parameter']] = param['Value'];
    }

    for (MapEntry<String, dynamic> param in parameters.entries) {
      String key = param.key;
      String value = param.value.toString();
      value = value.replaceAll('µ', 'u');
      if (value == '-') {
        continue;
      }
      switch (key) {
        case 'Tolerance':
          controllers[12].text =
              (int.parse(value.replaceAll('%', '').replaceAll('±', '')) / 100)
                  .toString();
          break;
        case 'Package / Case':
          controllers[3].text = value;
          break;
        case 'Capacitance':
          String v = value.split(' ')[0];
          String u = value.split(' ')[1].toLowerCase();
          controllers[27].text = v;
          for (FaradsUnit fu in FaradsUnit.values) {
            if (fu.unit.toLowerCase() == u) {
              selections[14] = fu;
              break;
            }
          }
          break;

        case 'Voltage - Forward (Vf) (Typ)':
        case 'Voltage - Rated':
        case 'Voltage - Supply (Vcc/Vdd)':
        case 'Voltage - Output (Min/Fixed)':
        case 'Voltage - Max':
          value = value.split(' ')[0];
          for (VoltageUnit vu in VoltageUnit.values) {
            if (value.toLowerCase().contains(vu.unit.toLowerCase())) {
              selections[2] = vu;
              String v = value.toLowerCase();
              v = v.replaceAll(vu.unit.toLowerCase(), '');
              if (double.tryParse(v) == null) {
                continue;
              }
              controllers[17].text = v;
              break;
            }
          }
          break;
        case 'Voltage - Reverse Standoff (Typ)':
          value = value.split(' ')[0];
          for (VoltageUnit vu in VoltageUnit.values) {
            if (value.toLowerCase().contains(vu.unit.toLowerCase())) {
              selections[8] = vu;
              String v = value.toLowerCase();
              v = v.replaceAll(vu.unit.toLowerCase(), '');
              if (double.tryParse(v) == null) {
                continue;
              }
              controllers[22].text = v;
              break;
            }
          }
          break;
        case 'Voltage - Breakdown (Min)':
          value = value.split(' ')[0];
          for (VoltageUnit vu in VoltageUnit.values) {
            if (value.toLowerCase().contains(vu.unit.toLowerCase())) {
              selections[7] = vu;
              String v = value.toLowerCase();
              v = v.replaceAll(vu.unit.toLowerCase(), '');
              if (double.tryParse(v) == null) {
                continue;
              }
              controllers[21].text = v;
              break;
            }
          }
          break;
        case 'Voltage - Clamping (Max) @ Ipp':
          value = value.split(' ')[0];
          for (VoltageUnit vu in VoltageUnit.values) {
            if (value.toLowerCase().contains(vu.unit.toLowerCase())) {
              selections[9] = vu;
              String v = value.toLowerCase();
              v = v.replaceAll(vu.unit.toLowerCase(), '');
              if (double.tryParse(v) == null) {
                continue;
              }
              controllers[23].text = v;
              break;
            }
          }
          break;
        case 'Temperature Coefficient':
          controllers[9].text = value;
          break;
        case 'Interface':
          controllers[4].text = value;
          break;

        case 'Mounting Type':
          if (value.contains('Through Hole')) {
            selections[3] = Mounting.pth;
          } else if (value.contains('Surface Mount')) {
            selections[3] = Mounting.smt;
          } else {
            selections[3] = Mounting.panel;
          }
          break;

        case 'Number of Positions':
          controllers[15].text = value;
          break;
        case 'Number of Rows':
          controllers[16].text = value;
          break;
        case 'Pitch':
        case 'Pitch - Mating':
          if (value.contains('\"')) {
            controllers[13].text = value.split('\"')[0];
            selections[17] = DistanceUnit.inch;
          }
          break;
        case 'Contact Type':
        case 'Cable Type':
          controllers[7].text = value;
          break;
        case 'Number of Conductors':
          controllers[15].text = value;
          break;

        case 'Current - Collector (Ic) (Max)':
        case 'Current Rating (Amps)':
        case 'Current - Hold (Ih) (Max)':
          controllers[18].text = value.split(' ')[0];
          String u = value.split(' ')[1];
          for (CurrentUnit unit in CurrentUnit.values) {
            if (u.toLowerCase() == unit.unit.toLowerCase()) {
              selections[4] = unit;
              break;
            }
          }
          break;
        case 'Current - Output / Channel':
        case 'Current - Peak Pulse (10/1000µs)':
        case 'Current - Output':
          value = value.split(' ')[0];
          for (CurrentUnit unit in CurrentUnit.values) {
            if (value.toLowerCase().contains(unit.unit.toLowerCase())) {
              selections[4] = unit;
              String v = value.toLowerCase();
              v = v.replaceAll(unit.unit.toLowerCase(), '');
              if (double.tryParse(v) == null) {
                continue;
              }
              controllers[18].text = v;
              break;
            }
          }
          break;

        case 'Inductance':
          controllers[27].text = value.split(' ')[0];
          String u = value.split(' ')[1];
          for (HenryUnit unit in HenryUnit.values) {
            if (u.toLowerCase() == unit.unit.toLowerCase()) {
              selections[16] = unit;
              break;
            }
          }
          break;
        case 'Color':
          for (LedColor unit in LedColor.values) {
            if (value.toLowerCase() == unit.name.toLowerCase()) {
              selections[18] = unit;
              break;
            }
          }
          break;
        case 'Millicandela Rating':
          controllers[24].text = value.replaceAll('mcd', '');
          break;
        case 'Speed':
          controllers[11].text = value.replaceAll('MHz', '');
          break;
        case 'Program Memory Size':
          value = value.split(' ')[0];
          for (FlashUnit unit in FlashUnit.values) {
            if (value.toLowerCase().contains(unit.unit.toLowerCase())) {
              selections[5] = unit;
              String v = value.toLowerCase();
              v = v.replaceAll(unit.unit.toLowerCase(), '');
              controllers[19].text = v;
              break;
            }
          }
          break;
        case 'RAM Size':
          value = value.split(' ')[0];
          for (FlashUnit unit in FlashUnit.values) {
            if (value.toLowerCase().contains(unit.unit.toLowerCase()[0])) {
              selections[6] = unit;
              String v = value.toLowerCase();
              v = v.replaceAll(unit.unit.toLowerCase()[0], '');
              controllers[20].text = v;
              break;
            }
          }
          break;
        case 'Resistance':
          String v = value.split(' ')[0];
          String u = value.split(' ')[1];
          for (OhmUnit unit in OhmUnit.values) {
            // print('${u.toLowerCase()} ${unit.unit.toLowerCase()}');
            if (u.toLowerCase() == (unit.unit.toLowerCase() + 's')) {
              selections[15] = unit;
              controllers[27].text = v;
              break;
            }
          }
          break;
        case 'Power - Peak Pulse':
        case 'Power (Watts)':
          value = value.replaceAll(RegExp('[a-zA-Z]'), '');
          value = value.split(',')[0];
          if (value.contains('/')) {
            selections[13] = 'power.fraction';
          } else {
            selections[13] = 'power.decimal';
          }

          controllers[26].text = value.toString();
          break;
      }
    }
  }
}
