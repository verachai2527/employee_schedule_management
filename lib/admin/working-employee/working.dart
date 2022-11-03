import 'package:employee_schedule_management/admin/common/app_colors.dart';
import 'package:employee_schedule_management/admin/common/app_responsive.dart';
import 'package:employee_schedule_management/admin/dashboard/widget/header_widget.dart';
import 'package:employee_schedule_management/admin/working-employee/widget/employee_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WorkingEmployee extends StatefulWidget {
  const WorkingEmployee({super.key});

  @override
  State<WorkingEmployee> createState() => _WorkingEmployeeState();
}

class _WorkingEmployeeState extends State<WorkingEmployee> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          /// Header Part
          HeaderWidget(headerName: "Emplyee"),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: [
                          WorkingEmployeeList(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
