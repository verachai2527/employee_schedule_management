import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_schedule_management/staff_attendance/calendar.dart';
import 'package:employee_schedule_management/location/location_service.dart';
import 'package:employee_schedule_management/login.dart';
import 'package:employee_schedule_management/staff_attendance/profile.dart';
import 'package:employee_schedule_management/staff_attendance/todayscreen.dart';
import 'package:employee_schedule_management/model/user.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = MyStyle().primaryColor;

  int currentIndex = 1;

  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
    FontAwesomeIcons.signOut,
  ];

  @override
  void initState() {
    super.initState();
    _startLocationService();
    getId().then((value) {
      _getCredentials();
      // _getProfilePic();
    });
  }

  void _getCredentials() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(UserModel.id)
          .get();
      setState(() {
        UserModel.canEdit = doc['canEdit'];
        UserModel.firstName = doc['firstName'];
        UserModel.lastName = doc['lastName'];
        UserModel.birthDate = doc['birthDate'];
        UserModel.address = doc['address'];
      });
    } catch (e) {
      return;
    }
  }

  void _getProfilePic() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Employee")
        .doc(UserModel.id)
        .get();
    setState(() {
      UserModel.profilePicLink = doc['profilePic'];
    });
  }

  void _startLocationService() async {
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        UserModel.long = value!;
      });

      LocationService().getLatitude().then((value) {
        setState(() {
          UserModel.lat = value!;
        });
      });
    });
  }

  Future<void> getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employee")
        .where('id', isEqualTo: UserModel.employeeId)
        .get();

    setState(() {
      UserModel.id = snap.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          CalendarScreen(),
          TodayScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        currentIndex = i;
                      });
                      if (i == 3) {
                        late SharedPreferences sharedPreferences;
                        sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.clear();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }
                    },
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color:
                                  i == currentIndex ? primary : Colors.black54,
                              size: i == currentIndex ? 30 : 26,
                            ),
                            i == currentIndex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    height: 3,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(40)),
                                      color: primary,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
