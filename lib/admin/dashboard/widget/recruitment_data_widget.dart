import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_schedule_management/admin/common/app_colors.dart';
import 'package:employee_schedule_management/admin/common/app_responsive.dart';
import 'package:employee_schedule_management/model/employee_model.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:employee_schedule_management/utility/web_firebase_connection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RecruitmentDataWidget extends StatefulWidget {
  @override
  _RecruitmentDataWidgetState createState() => _RecruitmentDataWidgetState();
}

class _RecruitmentDataWidgetState extends State<RecruitmentDataWidget> {
  List<EmployeeModel> employees = [];
  @override
  void initState() {
    super.initState();

    _getRecord();
  }

  void _getRecord() async {
    try {
      await Firebase.initializeApp(
        options: firebaseOptions(),
      );
      final users = await FirebaseFirestore.instance
          .collection("Employee")
          .where('workingStatus', isEqualTo: true)
          .get();
      List<DocumentSnapshot> snapshots = users.docs;
      for (var snapshot in snapshots) {
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

        EmployeeModel userModel = EmployeeModel.fromMap(data);
        setState(() {
          employees.add(userModel);
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Clock-in Employees",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              /// Table Header
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  )),
                ),
                children: [
                  tableHeader("Full Name"),
                  if (!AppResponsive.isMobile(context))
                    tableHeader("Designation"),
                  tableHeader("Status"),
                ],
              ),
              for (var rowData in employees)
                tableRow(
                  context,
                  name: rowData.firstName + " " + rowData.lastName,
                  color: Colors.blue,
                  image: "assets/user1.jpg",
                  designation: rowData.position,
                  status: "Working",
                ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Showing ${employees.length} Results"),
                // Text(
                //   "View All",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  TableRow tableRow(context, {name, image, designation, status, color}) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        children: [
          //Full Name
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(1000),
                //   child: Image.asset(
                //     image,
                //     width: 30,
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                Text(name)
              ],
            ),
          ),
          // Designation
          if (!AppResponsive.isMobile(context)) Text(designation),
          //Status
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                height: 10,
                width: 10,
              ),
              SizedBox(
                width: 10,
              ),
              Text(status),
            ],
          ),
        ]);
  }

  Widget tableHeader(text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.black),
      ),
    );
  }
}
