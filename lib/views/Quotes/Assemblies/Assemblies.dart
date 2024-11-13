// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../../utils/SuperGlobalVariables/ObjVar.dart';
import '../../../utils/colors.dart';
import '../../Delivery_Certificate/widgets/Texts.dart';
import 'Form_Assemblies.dart';

class Assemblies extends StatefulWidget {
  Assemblies({super.key});

  @override
  State<Assemblies> createState() => _AssembliesState();
}

class _AssembliesState extends State<Assemblies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: teal.add(black, 0.3),
          foregroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text(
            "Assemblies",
            style: titleh1,
          ),
        ),
        body: Form_Assemblies(
            customer: currentUser.customerNameQuotes!,
            quoteType: "Assemblies"));
  }
}
