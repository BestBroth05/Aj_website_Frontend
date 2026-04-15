import 'package:guadalajarav2/views/Delivery_Certificate/adminClases/CustomerClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteClass.dart';
import 'package:guadalajarav2/views/Quotes/Clases/QuoteTableClass.dart';

// Mantén tus defaults aquí:
const String kDefaultNotesEs =
    'Estas son las notas por defecto en español. Puedes editarlas...';
const String kDefaultNotesEn =
    'These are the default notes in English. You can edit them...';

// Normaliza para comparar sin líos de espacios y mayúsculas.
String _normalizeNotes(String? s) {
  if (s == null) return '';
  // quita espacios extra y baja a minúsculas
  final compact = s.trim().replaceAll(RegExp(r'\s+'), ' ');
  return compact.toLowerCase();
}

// ¿El usuario dejó las notas tal cual estaban de fábrica (ES o EN)?
bool _isDefaultNotes(String? current) {
  final n = _normalizeNotes(current);
  return n == _normalizeNotes(kDefaultNotesEs) ||
      n == _normalizeNotes(kDefaultNotesEn);
}

// Devuelve las notas que realmente debes imprimir.
// Si están “de fábrica”, aplica el idioma elegido; si no, respeta lo escrito.
String resolveNotesForExport({
  required String currentNotes,
  required bool isEnglish,
}) {
  if (_isDefaultNotes(currentNotes)) {
    return isEnglish ? kDefaultNotesEn : kDefaultNotesEs;
  }
  return currentNotes;
}

// assembly_description_factory.dart

// Mapea el color del PCB a ES/EN
String pcbColorEs(String colorEn) {
  switch (colorEn) {
    case "Green":
      return "Verde";
    case "Purple":
      return "Morado";
    case "Red":
      return "Rojo";
    case "Yellow":
      return "Amarillo";
    case "Blue":
      return "Azul";
    case "White":
      return "Blanco";
    default:
      return "Negro";
  }
}

String pcbColorEn(String colorEn) {
  // Viene en EN, lo dejamos en EN
  switch (colorEn) {
    case "Green":
    case "Purple":
    case "Red":
    case "Yellow":
    case "Blue":
    case "White":
      return colorEn;
    default:
      return "Black";
  }
}

// Helpers de tiempo de entrega
String leadTimeEs(String? s) {
  if (s == null) return "";
  // Tu UI ya venía con replaceAll("to","a"). Esto lo mantenemos seguro:
  final norm = s.replaceAll("to", "a").replaceAll("days", "dias");
  return "Tiempo de entrega $norm hábiles";
}

String leadTimeEn(String? s) {
  if (s == null) return "";
  // Asumimos que viene en inglés tipo "3 to 5 days"
  return "Lead time $s";
}

// ======== PLANTILLAS DEFAULT (ES) ========

List<QuoteTableClass> assemblyDefaultRowsES({
  required QuoteClass quote,
  required CustomersClass customer,
  required bool addComponents,
  required bool addPCB,
  required String currencyFormatted(double v), // p.ej. (v)=>formatter.format(v)
}) {
  final colorNameEs = pcbColorEs(quote.PCBColor ?? "Black");

  // Fragmentos
  final rowAssembly = QuoteTableClass(
    description: "Ensamble \"${quote.proyectName}\"\n"
        "               ${quote.assemblyLayers}\n"
        "               ${quote.assemblyMPN} MPN\n"
        "               ${quote.assemblySMT} SMT${(quote.assemblyTH ?? '').toString().isEmpty ? "\n               ${quote.assemblyTH} TH" : ""}\n"
        "Incluye inspección visual, limpieza y empaque antiestático.\n"
        "${leadTimeEs(quote.assemblyDeliveryTime)}",
    unitario: currencyFormatted(quote.perAssemblyMXN ?? 0),
    cantidad: "${quote.quantity}",
    total: currencyFormatted(quote.assemblyTotalMXN ?? 0),
  );

  final rowPCB = QuoteTableClass(
    description: "Fabricación de PCB \"${quote.proyectName}\"\n"
        "                ${quote.PCBLayers}. Top y Bottom 1oz FR4 .062¨ Color: $colorNameEs\n"
        "                Size: ${quote.PCBSize}\n"
        "${leadTimeEs(quote.PCBDeliveryTime)}",
    unitario: currencyFormatted(quote.PCBPerMXN ?? 0),
    cantidad: "${quote.quantity}",
    total: currencyFormatted(quote.PCBTotalMXN ?? 0),
  );

  final rowComponents = QuoteTableClass(
    description: "Componentes \"${quote.excelName ?? ''}\"\n"
        "               ${quote.componentsMPN} MPN PUESTOS EN MEXICO\n"
        "               ${quote.componentsAvailables} no disponibles-envía ${customer.name}\n"
        "${leadTimeEs(quote.componentsDeliverTime)}",
    unitario: currencyFormatted(quote.perComponentMXN ?? 0),
    cantidad: "${quote.quantity}",
    total: currencyFormatted(quote.totalComponentsMXN ?? 0),
  );

  final rowShipping = QuoteTableClass(
    description: "Envío GDL – \nPAQUETE ASEGURADO",
    unitario: "0.0",
    cantidad: "1",
    total: "0.0",
  );

  // Combinaciones según flags, igual que tu fillColumnsSpanish
  if (!addComponents && !addPCB) {
    return [rowAssembly, rowShipping];
  } else if (!addComponents) {
    return [rowPCB, rowAssembly, rowShipping];
  } else if (!addPCB) {
    return [rowComponents, rowAssembly, rowShipping];
  } else {
    return [rowComponents, rowPCB, rowAssembly, rowShipping];
  }
}

// ======== PLANTILLAS DEFAULT (EN) ========

List<QuoteTableClass> assemblyDefaultRowsEN({
  required QuoteClass quote,
  required CustomersClass customer,
  required bool addComponents,
  required bool addPCB,
  required String currencyFormatted(double v),
}) {
  final colorNameEn = pcbColorEn(quote.PCBColor ?? "Black");

  final rowAssembly = QuoteTableClass(
    description: "Assembly \"${quote.proyectName}\"\n"
        "               ${quote.assemblyLayers}\n"
        "               ${quote.assemblyMPN} MPN\n"
        "               ${quote.assemblySMT} SMT${(quote.assemblyTH ?? '').toString().isEmpty ? "\n               ${quote.assemblyTH} TH" : ""}\n"
        "Includes visual inspection, cleaning, and anti-static packaging.\n"
        "${leadTimeEn(quote.assemblyDeliveryTime)}",
    unitario: currencyFormatted(quote.perAssemblyMXN ?? 0),
    cantidad: "${quote.quantity}",
    total: currencyFormatted(quote.assemblyTotalMXN ?? 0),
  );

  final rowPCB = QuoteTableClass(
    description: "PCB fabrication \"${quote.proyectName}\"\n"
        "                ${quote.PCBLayers}. Top and Bottom 1oz FR4 .062\", Color: $colorNameEn\n"
        "                Size: ${quote.PCBSize}\n"
        "${leadTimeEn(quote.PCBDeliveryTime)}",
    unitario: currencyFormatted(quote.PCBPerMXN ?? 0),
    cantidad: "${quote.quantity}",
    total: currencyFormatted(quote.PCBTotalMXN ?? 0),
  );

  final rowComponents = QuoteTableClass(
    description: "Components \"${quote.excelName ?? ''}\"\n"
        "               ${quote.componentsMPN} MPN PLACED IN MEXICO\n"
        "               ${quote.componentsAvailables} not available — send by ${customer.name}\n"
        "${leadTimeEn(quote.componentsDeliverTime)}",
    unitario: currencyFormatted(quote.perComponentMXN ?? 0),
    cantidad: "${quote.quantity}",
    total: currencyFormatted(quote.totalComponentsMXN ?? 0),
  );

  final rowShipping = QuoteTableClass(
    description: "Shipping GDL – \nINSURED PACKAGE",
    unitario: "0.0",
    cantidad: "1",
    total: "0.0",
  );

  if (!addComponents && !addPCB) {
    return [rowAssembly, rowShipping];
  } else if (!addComponents) {
    return [rowPCB, rowAssembly, rowShipping];
  } else if (!addPCB) {
    return [rowComponents, rowAssembly, rowShipping];
  } else {
    return [rowComponents, rowPCB, rowAssembly, rowShipping];
  }
}
