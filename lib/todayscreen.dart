import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_schedule_management/model/user.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:employee_schedule_management/utility/web_firebase_connection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  String checkIn = "--/--";
  String checkOut = "--/--";
  String? location = " ";
  String scanResult = " ";
  String officeCode = " ";

  Color primary = MyStyle().primaryColor;

  @override
  void initState() {
    super.initState();

    _getRecord();
    _getOfficeCode();
    _getLocation();
  }

  void _getOfficeCode() async {
    await Firebase.initializeApp(
      options: firebaseOptions(),
    );
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("Attributes")
        .doc("Office1")
        .get();
    setState(() {
      officeCode = snap['code'];
    });
  }

  // Future<void> scanQRandCheck() async {
  //   String result = " ";

  //   try {
  //     result = await FlutterBarcodeScanner.scanBarcode(
  //       "#ffffff",
  //       "Cancel",
  //       false,
  //       ScanMode.QR,
  //     );
  //   } catch (e) {
  //     print("error");
  //   }

  //   setState(() {
  //     scanResult = result;
  //   });

  //   if (scanResult == officeCode) {
  //     if (UserModel.lat != 0) {
  //       _getLocation();

  //       QuerySnapshot snap = await FirebaseFirestore.instance
  //           .collection("Employee")
  //           .where('id', isEqualTo: UserModel.employeeId)
  //           .get();

  //       DocumentSnapshot snap2 = await FirebaseFirestore.instance
  //           .collection("Employee")
  //           .doc(snap.docs[0].id)
  //           .collection("Record")
  //           .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
  //           .get();

  //       try {
  //         String checkIn = snap2['checkIn'];

  //         setState(() {
  //           checkOut = DateFormat('hh:mm').format(DateTime.now());
  //         });

  //         await FirebaseFirestore.instance
  //             .collection("Employee")
  //             .doc(snap.docs[0].id)
  //             .collection("Record")
  //             .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
  //             .update({
  //           'date': Timestamp.now(),
  //           'checkIn': checkIn,
  //           'checkOut': DateFormat('hh:mm').format(DateTime.now()),
  //           'checkInLocation': location,
  //         });
  //       } catch (e) {
  //         setState(() {
  //           checkIn = DateFormat('hh:mm').format(DateTime.now());
  //         });

  //         await FirebaseFirestore.instance
  //             .collection("Employee")
  //             .doc(snap.docs[0].id)
  //             .collection("Record")
  //             .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
  //             .set({
  //           'date': Timestamp.now(),
  //           'checkIn': DateFormat('hh:mm').format(DateTime.now()),
  //           'checkOut': "--/--",
  //           'checkOutLocation': location,
  //         });
  //       }
  //     } else {
  //       Timer(const Duration(seconds: 3), () async {
  //         _getLocation();

  //         QuerySnapshot snap = await FirebaseFirestore.instance
  //             .collection("Employee")
  //             .where('id', isEqualTo: UserModel.employeeId)
  //             .get();

  //         DocumentSnapshot snap2 = await FirebaseFirestore.instance
  //             .collection("Employee")
  //             .doc(snap.docs[0].id)
  //             .collection("Record")
  //             .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
  //             .get();

  //         try {
  //           String checkIn = snap2['checkIn'];

  //           setState(() {
  //             checkOut = DateFormat('hh:mm').format(DateTime.now());
  //           });

  //           await FirebaseFirestore.instance
  //               .collection("Employee")
  //               .doc(snap.docs[0].id)
  //               .collection("Record")
  //               .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
  //               .update({
  //             'date': Timestamp.now(),
  //             'checkIn': checkIn,
  //             'checkOut': DateFormat('hh:mm').format(DateTime.now()),
  //             'checkInLocation': location,
  //           });
  //         } catch (e) {
  //           setState(() {
  //             checkIn = DateFormat('hh:mm').format(DateTime.now());
  //           });

  //           await FirebaseFirestore.instance
  //               .collection("Employee")
  //               .doc(snap.docs[0].id)
  //               .collection("Record")
  //               .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
  //               .set({
  //             'date': Timestamp.now(),
  //             'checkIn': DateFormat('hh:mm').format(DateTime.now()),
  //             'checkOut': "--/--",
  //             'checkOutLocation': location,
  //           });
  //         }
  //       });
  //     }
  //   }
  // }

  void _getLocation() async {
    // List<Placemark> placemark =
    //     await placemarkFromCoordinates(UserModel.lat, UserModel.long);

    // setState(() {
    //   location =
    //       "${placemark[0].street}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}";
    // });

    // var googleGeocoding =
    //     GoogleGeocoding("AIzaSyBU6egr2eCCJl3SzhvZYXLkOqKbtRyuKLc");
    // var result = await googleGeocoding.geocoding
    //     .getReverse(LatLon(UserModel.lat, UserModel.long));
    // if (result != null && result.results != null) {
    //   setState(() {
    //     location = result.results![0].addressComponents![0].shortName;
    //   });
    // }
  }

  void _getRecord() async {
    try {
      await Firebase.initializeApp(
        options: firebaseOptions(),
      );
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: UserModel.employeeId)
          .get();
      print('EmployeeID:' + snap.docs[0].id);
      List<String> keys = [];
      keys.add(DateFormat('dd MMMM yyyy').format(DateTime.now()));
      QuerySnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .orderBy('date', descending: true)
          .get();
      // .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
      // .get();
      print('checkIn:' + snap2.docs[0]['checkIn']);
      print('checkOut:' + snap2.docs[0]['checkOut']);
      setState(() {
        checkIn = snap2.docs[0]['checkIn'];
        checkOut = snap2.docs[0]['checkOut'];
      });
    } catch (e) {
      print('error:' + e.toString());
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = 500;
    screenWidth = 500;

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          width: 500,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Welcome,",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 20,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  UserModel.firstName + "!!",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  "Today's Status",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 32),
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            checkIn,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                              fontFamily: "NexaRegular",
                              fontSize: screenWidth / 20,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            checkOut,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: DateTime.now().day.toString(),
                      style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: "NexaBold",
                      ),
                      children: [
                        TextSpan(
                          text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 20,
                            fontFamily: "NexaBold",
                          ),
                        ),
                      ],
                    ),
                  )),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a').format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  );
                },
              ),
              // checkOut == "--/--"
              //     ?
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 12),
                child: Builder(
                  builder: (context) {
                    final GlobalKey<SlideActionState> key = GlobalKey();

                    return SlideAction(
                      text: checkIn == "--/--"
                          ? "Slide to Check In"
                          : checkOut == "--/--"
                              ? "Slide to Check Out"
                              : "Slide to Check In",
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaRegular",
                      ),
                      outerColor: Colors.white,
                      innerColor: primary,
                      key: key,
                      onSubmit: () async {
                        await Firebase.initializeApp(
                          options: firebaseOptions(),
                        );
                        if (UserModel.lat != 0) {
                          _getLocation();
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employee")
                              .where('id', isEqualTo: UserModel.employeeId)
                              .get();

                          // DocumentSnapshot snap2 = await FirebaseFirestore
                          //     .instance
                          //     .collection("Employee")
                          //     .doc(snap.docs[0].id)
                          //     .collection("Record")
                          //     .doc(DateFormat('dd MMMM yyyy')
                          //         .format(DateTime.now()))
                          //     .get();
                          QuerySnapshot snap2 = await FirebaseFirestore.instance
                              .collection("Employee")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .orderBy('date', descending: true)
                              .get();
                          try {
                            String s_checkIn = snap2.docs[0]['checkIn'];
                            String s_checkOut = snap2.docs[0]['checkOut'];
                            if (s_checkOut == "--/--") {
                              setState(() {
                                checkOut =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });

                              // await FirebaseFirestore.instance
                              //     .collection("Employee")
                              //     .doc(snap.docs[0].id)
                              //     .collection("Record")
                              //     .doc(DateFormat('dd MMMM yyyy')
                              //             .format(DateTime.now()) +
                              //         " " +
                              //         s_checkIn)
                              //     .update({
                              //   'date': Timestamp.now(),
                              //   'checkIn': s_checkIn,
                              //   'checkOut':
                              //       DateFormat('hh:mm').format(DateTime.now()),
                              //   'checkInLocation': location,
                              // });
                              QuerySnapshot snap3 = await FirebaseFirestore
                                  .instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .orderBy('date', descending: true)
                                  .get();
                              Map<String, dynamic> record = {
                                'date': Timestamp.now(),
                                'checkIn': s_checkIn,
                                'checkOut':
                                    DateFormat('hh:mm').format(DateTime.now()),
                                'checkInLocation': location,
                              };
                              snap3.docs[0].reference.update(record);
                            } else {
                              setState(() {
                                checkIn =
                                    DateFormat('hh:mm').format(DateTime.now());
                                checkOut = "--/--";
                              });

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()) +
                                      " " +
                                      DateFormat('hh:mm')
                                          .format(DateTime.now()))
                                  .set({
                                'date': Timestamp.now(),
                                'checkIn':
                                    DateFormat('hh:mm').format(DateTime.now()),
                                'checkOut': "--/--",
                                'checkOutLocation': location,
                              });
                            }
                          } catch (e) {
                            setState(() {
                              checkIn =
                                  DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                        .format(DateTime.now()) +
                                    " " +
                                    DateFormat('hh:mm').format(DateTime.now()))
                                .set({
                              'date': Timestamp.now(),
                              'checkIn':
                                  DateFormat('hh:mm').format(DateTime.now()),
                              'checkOut': "--/--",
                              'checkOutLocation': location,
                            });
                          }

                          key.currentState!.reset();
                        } else {
                          Timer(const Duration(seconds: 3), () async {
                            _getLocation();

                            QuerySnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .where('id', isEqualTo: UserModel.employeeId)
                                .get();

                            // DocumentSnapshot snap2 = await FirebaseFirestore
                            //     .instance
                            //     .collection("Employee")
                            //     .doc(snap.docs[0].id)
                            //     .collection("Record")
                            //     .doc(DateFormat('dd MMMM yyyy')
                            //         .format(DateTime.now()))
                            //     .get();
                            QuerySnapshot snap2 = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .orderBy('date', descending: true)
                                .get();
                            try {
                              String s_checkIn = snap2.docs[0]['checkIn'];
                              String s_checkOut = snap2.docs[0]['checkOut'];
                              if (s_checkOut == "--/--") {
                                setState(() {
                                  checkOut = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });

                                // await FirebaseFirestore.instance
                                //     .collection("Employee")
                                //     .doc(snap.docs[0].id)
                                //     .collection("Record")
                                //     .doc(DateFormat('dd MMMM yyyy')
                                //             .format(DateTime.now()) +
                                //         " " +
                                //         s_checkIn)
                                //     .update({
                                //   'date': Timestamp.now(),
                                //   'checkIn': s_checkIn,
                                //   'checkOut': DateFormat('hh:mm')
                                //       .format(DateTime.now()),
                                //   'checkInLocation': location,
                                // });
                                QuerySnapshot snap3 = await FirebaseFirestore
                                    .instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .orderBy('date', descending: true)
                                    .get();
                                Map<String, dynamic> record = {
                                  'date': Timestamp.now(),
                                  'checkIn': s_checkIn,
                                  'checkOut': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  'checkInLocation': location,
                                };
                                snap3.docs[0].reference.update(record);
                              } else {
                                setState(() {
                                  checkIn = DateFormat('hh:mm')
                                      .format(DateTime.now());
                                });

                                await FirebaseFirestore.instance
                                    .collection("Employee")
                                    .doc(snap.docs[0].id)
                                    .collection("Record")
                                    .doc(DateFormat('dd MMMM yyyy')
                                            .format(DateTime.now()) +
                                        " " +
                                        DateFormat('hh:mm')
                                            .format(DateTime.now()))
                                    .set({
                                  'date': Timestamp.now(),
                                  'checkIn': DateFormat('hh:mm')
                                      .format(DateTime.now()),
                                  'checkOut': "--/--",
                                  'checkOutLocation': location,
                                });
                              }
                            } catch (e) {
                              setState(() {
                                checkIn =
                                    DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()) +
                                      " " +
                                      DateFormat('hh:mm')
                                          .format(DateTime.now()))
                                  .set({
                                'date': Timestamp.now(),
                                'checkIn':
                                    DateFormat('hh:mm').format(DateTime.now()),
                                'checkOut': "--/--",
                                'checkOutLocation': location,
                              });
                            }

                            key.currentState!.reset();
                          });
                        }
                      },
                    );
                  },
                ),
              ),
              // : Container(
              //     margin: const EdgeInsets.only(top: 32, bottom: 32),
              //     child: Text(
              //       "You have completed this day!",
              //       style: TextStyle(
              //         fontFamily: "NexaRegular",
              //         fontSize: screenWidth / 20,
              //         color: Colors.black54,
              //       ),
              //     ),
              //   ),
              location != " "
                  ? Text(
                      "Location: " + location!,
                    )
                  : const SizedBox(),
              // GestureDetector(
              //   onTap: () {
              //     scanQRandCheck();
              //   },
              //   child: Container(
              //     height: screenWidth / 2,
              //     width: screenWidth / 2,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(20),
              //       boxShadow: const [
              //         BoxShadow(
              //           color: Colors.black26,
              //           offset: Offset(2, 2),
              //           blurRadius: 10,
              //         ),
              //       ],
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             Icon(
              //               FontAwesomeIcons.expand,
              //               size: 70,
              //               color: primary,
              //             ),
              //             Icon(
              //               FontAwesomeIcons.camera,
              //               size: 25,
              //               color: primary,
              //             ),
              //           ],
              //         ),
              //         Container(
              //           margin: const EdgeInsets.only(
              //             top: 8,
              //           ),
              //           child: Text(
              //             checkIn == "--/--"
              //                 ? "Scan to Check In"
              //                 : "Scan to Check Out",
              //             style: TextStyle(
              //               fontFamily: "NexaRegular",
              //               fontSize: screenWidth / 20,
              //               color: Colors.black54,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
