import 'package:flutter/material.dart';

class QuoteTableClass {
  int? id_quotePreview;
  int? id_quote;
  String? description;
  String? unitario;
  String? cantidad;
  String? total;
  String? notas;
  String? image;
  QuoteTableClass(
      {this.id_quotePreview,
      this.id_quote,
      this.description,
      this.unitario,
      this.cantidad,
      this.total,
      this.notas,
      this.image});
  QuoteTableClass copy(
          {String? description,
          String? unitario,
          String? cantidad,
          String? total,
          String? image}) =>
      QuoteTableClass(
          description: description ?? this.description,
          unitario: unitario ?? this.unitario,
          cantidad: cantidad ?? this.cantidad,
          image: image ?? this.image,
          total: total ?? this.total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteTableClass &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          unitario == other.unitario &&
          cantidad == other.cantidad &&
          image == other.image &&
          total == other.total;
  @override
  int get hashCode =>
      description.hashCode ^
      unitario.hashCode ^
      cantidad.hashCode ^
      image.hashCode ^
      total.hashCode;
}

class QuoteTableWidgetClass {
  Widget? description;
  String? unitario;
  String? cantidad;
  String? total;
  QuoteTableWidgetClass(
      {this.description, this.unitario, this.cantidad, this.total});
  QuoteTableWidgetClass copy({
    Widget? description,
    String? unitario,
    String? cantidad,
    String? total,
  }) =>
      QuoteTableWidgetClass(
          description: description ?? this.description,
          unitario: unitario ?? this.unitario,
          cantidad: cantidad ?? this.cantidad,
          total: total ?? this.total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteTableWidgetClass &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          unitario == other.unitario &&
          cantidad == other.cantidad &&
          total == other.total;
  @override
  int get hashCode =>
      description.hashCode ^
      unitario.hashCode ^
      cantidad.hashCode ^
      total.hashCode;
}
