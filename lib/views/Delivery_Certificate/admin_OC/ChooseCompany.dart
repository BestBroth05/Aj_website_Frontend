import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guadalajarav2/views/admin_view/AdminWidgets/Title.dart';
import 'package:guadalajarav2/views/dashboard_main_top_bar.dart/dashboard_main_top_dar.dart';
import '../Controllers/DAO.dart';
import '../adminClases/CustomerClass.dart';
import '../../../widgets/custom/Custom_Customers/CustomTableCustomers.dart';
import '../../admin_view/admin_DeliverCertificate/LoadingData.dart';

class ChooseCompany extends StatefulWidget {
  const ChooseCompany({Key? key}) : super(key: key);

  @override
  State<ChooseCompany> createState() => _ChooseCompanyState();
}

class _ChooseCompanyState extends State<ChooseCompany> {
  List<CustomersClass> customers = [];
  Color backgroundColorButton = Colors.teal;
  bool isAllCustomersLoaded = false;

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardTopBar(selected: 4),
        TitleH1(context, "Purch Orders"),
        Container(
          height: 650,
          child: SetImages(),
        )
      ],
    );
  }

  getCustomers() async {
    List<CustomersClass> customers1 = await DataAccessObject.getCustomer();
    setState(() {
      customers = customers1;
      isAllCustomersLoaded = true;
    });
  }

  Widget SetImages() {
    return !isAllCustomersLoaded
        ? LoadingData()
        : CustomTableCustomers(
            customers: customers,
            isOC: true,
          );
  }
}
// Container(
//         margin: EdgeInsets.only(top: 15, bottom: 15),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               CustomCicleAvatar(convertListToInt(customers[i].logo!)),
//               Container(
//                 margin: EdgeInsets.only(top: 10),
//                 child: Text(
//                   '${customers[i].name}',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//               )
//             ],
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => Workspace_Certificate(
//                         companyName: customers[i].name!,
//                       )),
//             );
//           },
//         ),
//       ),