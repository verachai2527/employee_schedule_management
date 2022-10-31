import 'package:employee_schedule_management/admin/common/app_colors.dart';
import 'package:employee_schedule_management/admin/controllers/menu_controller.dart';
import 'package:employee_schedule_management/admin/employee/employee.dart';
import 'package:employee_schedule_management/admin/employee/employee_page.dart';
import 'package:employee_schedule_management/admin/home_page.dart';
import 'package:employee_schedule_management/admin/report/report_page.dart';
import 'package:employee_schedule_management/login.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: AppColor.bgSideMenu,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "SCHEDULE MANAGEMENT",
                style: TextStyle(
                  color: MyStyle().darkColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DrawerListTile(
              title: "Home",
              icon: "assets/menu_home.png",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                    create: (context) => MenuController()),
                              ],
                              child: HomePage(),
                            )));
              },
            ),
            DrawerListTile(
              title: "Employee",
              icon: "assets/menu_recruitment.png",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                    create: (context) => MenuController()),
                              ],
                              child: EmployeePage(),
                            )));
              },
            ),
            DrawerListTile(
              title: "Roster",
              icon: "assets/menu_onboarding.png",
              press: () {},
            ),
            DrawerListTile(
              title: "Reports",
              icon: "assets/menu_report.png",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                    create: (context) => MenuController()),
                              ],
                              child: ReportPage(),
                            )));
              },
            ),
            DrawerListTile(
              title: "Calendar",
              icon: "assets/menu_calendar.png",
              press: () {},
            ),
            DrawerListTile(
              title: "Logout",
              icon: "assets/menu_calendar.png",
              press: () async {
                late SharedPreferences sharedPreferences;
                sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.clear();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
            // DrawerListTile(
            //   title: "Settings",
            //   icon: "assets/menu_settings.png",
            //   press: () {},
            // ),
            Spacer(),
            Image.asset("assets/sidebar_image.png")
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title, icon;
  final VoidCallback press;

  const DrawerListTile(
      {Key? key, required this.title, required this.icon, required this.press})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        icon,
        color: AppColor.white,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColor.white),
      ),
    );
  }
}
