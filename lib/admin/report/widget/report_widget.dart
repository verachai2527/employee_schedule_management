import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_schedule_management/model/employee_model.dart';
import 'package:employee_schedule_management/model/record_model.dart';
import 'package:employee_schedule_management/model/user.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:html' as webFile;

class ReportWidget extends StatefulWidget {
  const ReportWidget({Key? key}) : super(key: key);

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = MyStyle().primaryColor;
  List<EmployeeModel> employees = [];
  List<RecordModel> records = [];
  String _month = DateFormat('MMMM').format(DateTime.now());
  DateTime? startDate;
  DateTime? endDate;
  String _dateRange = "";
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day - 14),
    DateTime.now(),
  ];
  @override
  Widget build(BuildContext context) {
    screenHeight = 500;
    screenWidth = 500;

    return Container(
      width: 900,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Attendance History",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: screenWidth / 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 900,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  _dateRange,
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 22,
                  ),
                ),
              ),
              //////////
              _buildCalendarDialogButton(),
              _exportButton(),
              //////////
            ],
          ),
        ],
      ),
    );
  }

  _buildCalendarDialogButton() {
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      shouldCloseDialogAfterCancelTapped: true,
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                initialValue: _dialogCalendarPickerValue,
                dialogBackgroundColor: Colors.white,
                selectableDayPredicate: (day) => !day
                    .difference(_dialogCalendarPickerValue[0]!
                        .subtract(const Duration(days: 5)))
                    .isNegative,
              );
              if (values != null) {
                // ignore: avoid_print
                String dateRange = _getValueText(
                  config.calendarType,
                  values,
                );
                // print(dateRange);
                setState(() {
                  _dialogCalendarPickerValue = values;
                  _dateRange = dateRange;
                });
              }
            },
            child: const Text(
              "Choose date range",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: 500 / 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _exportButton() {
    return GestureDetector(
      onTap: () async {
        List<String> exportFile = [];
        String header =
            "Employee ID, First Name, Last Name, Position, Number of Shifts, Total Duration Hours, Total Duration Minutes\n";
        exportFile.add(header);
        final users = await FirebaseFirestore.instance
            .collection("Employee")
            .where('role', isEqualTo: 200)
            .get();
        List<DocumentSnapshot> snapshots = users.docs;
        for (var snapshot in snapshots) {
          Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
          EmployeeModel userModel = EmployeeModel.fromMap(data);
          userModel.uid = snapshot.id;
          setState(() {
            employees.add(userModel);
          });
          final records1 = await FirebaseFirestore.instance
              .collection("Employee")
              .doc(snapshot.id)
              .collection("Record")
              .where('date', isGreaterThanOrEqualTo: startDate)
              .where('date', isLessThanOrEqualTo: endDate)
              .orderBy('date', descending: true)
              .get();
          List<DocumentSnapshot> snapshots_records = records1.docs;
          int hours = 0;
          int minutes = 0;
          String record = "";
          int shifts = 0;
          for (var snapshot_rec in snapshots_records) {
            Map<String, dynamic> data02 =
                snapshot_rec.data()! as Map<String, dynamic>;
            RecordModel recordModel = RecordModel.fromMap(data02);
            recordModel.date = data02['date'].toDate();
            if (data02['checkInDate'] != null &&
                data02['checkOutDate'] != null) {
              DateTime dt1 = data02['checkInDate'].toDate();
              DateTime dt2 = data02['checkOutDate'].toDate();
              Duration diff = dt2.difference(dt1);
              hours += diff.inHours;
              minutes += diff.inMinutes % 60;
              if ((minutes / 60) > 0) {
                hours += (minutes / 60).toInt();
                minutes = minutes % 60;
              }
              recordModel.setEmployeeToUserModel(userModel);
              setState(() {
                records.add(recordModel);
              });
              shifts++;
            }
          }
          record =
              "${userModel.id},${userModel.firstName},${userModel.lastName},${userModel.position},${shifts},${hours},${minutes}\n";

          exportFile.add(record);
        }

        var blob = webFile.Blob(exportFile, 'text/plain', 'native');
        var anchorElement = webFile.AnchorElement(
          href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
        )
          ..setAttribute("download", "data.csv")
          ..click();
      },
      child: Container(
        height: kToolbarHeight,
        width: screenWidth,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: primary,
        ),
        child: const Center(
          child: Text(
            "EXPORT FILE",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "NexaBold",
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = 'START DATE :: $startDate  END DATE :: $endDate';
        setState(() {
          this.startDate = values[0];
          this.endDate = values.length > 1 ? values[1] : null;
        });
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
