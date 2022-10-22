import 'package:employee_schedule_management/staff_attendance/home.dart';
import 'package:employee_schedule_management/login.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext context) => LoginScreen(),
  '/home': (BuildContext context) => HomeScreen(),
};
