import 'package:employee_schedule_management/admin/controllers/menu_controller.dart';
import 'package:employee_schedule_management/admin/dashboard/dashboard.dart';
import 'package:employee_schedule_management/admin/home_page.dart';
import 'package:employee_schedule_management/staff_attendance/home.dart';
import 'package:employee_schedule_management/login.dart';
import 'package:employee_schedule_management/model/user.dart';
import 'package:employee_schedule_management/utility/web_firebase_connection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  String role = '200';
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString('employeeId') != null) {
        setState(() {
          UserModel.employeeId = sharedPreferences.getString('employeeId')!;
          userAvailable = true;
          role = sharedPreferences.getString('role')!;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable
        ? role == "100"
            ? MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (context) => MenuController()),
                ],
                child: HomePage(),
              )
            : const HomeScreen()
        : const LoginScreen();
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (context) => MenuController()),
    //   ],
    //   child: HomePage(),
    // );
  }
}
