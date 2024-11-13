import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Texts.dart';

Widget fieldDeliver(controller, text, keyboardtype, filter) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Align(
        //   alignment: Alignment.topLeft,
        //   child: Text(
        //     "* $text:",
        //     style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        //   ),
        // ),
        Container(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 360,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$text is required';
                }
                return null;
              },
              keyboardType: keyboardtype,
              controller: controller,
              inputFormatters: [filter],
              style: TextStyle(),
              decoration: InputDecoration(
                labelText: "* $text",
                labelStyle: TextStyle(
                  color: Colors.teal,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        )),
      ],
    ),
  );
}

Widget fieldQuotesOperations(
    controller, text, keyboardtype, filter, onChange, readOnly) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 360,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$text is required';
                }
                return null;
              },
              readOnly: readOnly,
              keyboardType: keyboardtype,
              controller: controller,
              inputFormatters: [filter],
              style: TextStyle(),
              decoration: InputDecoration(
                labelText: "* $text",
                labelStyle: TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.normal),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: onChange,
            ),
          ),
        )),
      ],
    ),
  );
}

Widget fieldQuotesOperationsusdOrMxn(
    controller, text, keyboardtype, filter, onChange, readOnly, usdOrMxn) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 360,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$text is required';
                }
                return null;
              },
              readOnly: readOnly,
              keyboardType: keyboardtype,
              controller: controller,
              inputFormatters: [filter],
              style: TextStyle(),
              decoration: InputDecoration(
                labelText: "* $text ($usdOrMxn)",
                labelStyle: TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.normal),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: onChange,
            ),
          ),
        )),
      ],
    ),
  );
}

Widget fieldPercentages(
    controller, icon, text, keyboardtype, filter, onChange, width) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: width,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '$text is required';
                }
                return null;
              },
              keyboardType: keyboardtype,
              controller: controller,
              inputFormatters: [filter],
              style: TextStyle(),
              decoration: InputDecoration(
                labelText: "* $text",
                labelStyle: TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.normal),
                suffixIcon: icon,
                suffixIconColor: Colors.teal,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: onChange,
            ),
          ),
        )),
      ],
    ),
  );
}

Widget textArea(controller, text, keyboardtype, filter) {
  return Container(
    child: Row(
      children: [
        Text("$text:"),
        Container(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 350,
            child: TextFormField(
              keyboardType: keyboardtype,
              maxLines: 3,
              controller: controller,
              inputFormatters: [filter],
              style: TextStyle(),
              decoration: InputDecoration(
                hintText: "Notes...",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        )),
      ],
    ),
  );
}

Widget fieldDeliverNoValidator(controller, text, keyboardtype, filter) {
  return Container(
    margin: EdgeInsets.only(left: 25),
    child: Row(
      children: [
        Text("$text:"),
        Container(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: SizedBox(
            width: 350,
            child: TextFormField(
              keyboardType: keyboardtype,
              controller: controller,
              inputFormatters: [filter],
              style: TextStyle(),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        )),
      ],
    ),
  );
}

Widget dropdown(
  valor,
  text,
  list,
) {
  return Container(
    alignment: Alignment.center,
    child: SizedBox(
      width: 360,
      child: DropdownButtonFormField(
        value: valor,
        validator: (value) {
          if (value == null) {
            return '$text is required';
          }
          return null;
        },
        style: fieldStyle,
        decoration: InputDecoration(
            labelText: "* $text",
            labelStyle: hintStyle,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.green),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            )),
        isExpanded: true,
        hint: Text("--Select Option--", style: fieldStyle),
        onChanged: (v) {},
        items: list
            .map((category) => DropdownMenuItem(
                value: category.name,
                child: Text(category.name!, style: fieldStyle)))
            .toList(),
      ),
    ),
  );
}
