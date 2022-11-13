import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_schedule_management/admin/common/app_colors.dart';
import 'package:employee_schedule_management/admin/common/app_responsive.dart';
import 'package:employee_schedule_management/model/employee_model.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:employee_schedule_management/utility/web_firebase_connection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = MyStyle().primaryColor;
  String birth = "Date of birth";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController employeeIDController = TextEditingController();
  List<EmployeeModel> employees = [];
  EmployeeModel employeeModel = EmployeeModel();
  String employeeID = "";
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
          .where('role', isEqualTo: 200)
          .get();
      List<DocumentSnapshot> snapshots = users.docs;
      for (var snapshot in snapshots) {
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

        EmployeeModel userModel = EmployeeModel.fromMap(data);
        userModel.uid = snapshot.id;
        setState(() {
          employees.add(userModel);
          // employeeModel.setEmployeeToUserModel(userModel);
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    // print(image!.path);
    if (employeeModel != null && employeeModel != "") {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("${employeeModel.id.toLowerCase()}_profilepic.jpg");

      await ref.putFile(File(image!.path));

      ref.getDownloadURL().then((value) async {
        setState(() {
          employeeModel.profilePicLink = value;
        });

        await FirebaseFirestore.instance
            .collection("Employee")
            .doc(employeeModel.id)
            .update({
          'profilePic': value,
        });
      });
    }
  }

  Container employeeList() {
    return Container(
      width: 350,
      height: 800,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Employees List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                  fontSize: 18,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: MyStyle().darkColor,
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        employeeModel = EmployeeModel();
                        firstNameController.text = employeeModel.firstName;
                        lastNameController.text = employeeModel.lastName;
                        addressController.text = employeeModel.address;
                        birth = employeeModel.birthDate;
                        positionController.text = employeeModel.position;
                        employeeID = employeeModel.id;
                        employeeIDController.text = employeeModel.id;
                      });
                    },
                    child: Text(
                      "Add Employee",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColor.black),
                    )),
              )
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
                  if (!AppResponsive.isMobile(context)) tableHeader(""),
                ],
              ),
              for (var rowData in employees)
                tableRow(
                  context,
                  name: rowData.firstName + " " + rowData.lastName,
                  color: Colors.blue,
                  image: "assets/user1.jpg",
                  designation: rowData.position,
                  user: rowData,
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

  Widget tableHeader(text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.black),
      ),
    );
  }

  TableRow tableRow(context, {name, image, designation, color, user}) {
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

          // Menu icon
          if (!AppResponsive.isMobile(context))
            InkWell(
              onTap: () {
                // EmployeeModel employeeModel = user;

                setState(() {
                  employeeModel.setEmployeeToUserModel(user);
                  firstNameController.text = employeeModel.firstName;
                  lastNameController.text = employeeModel.lastName;
                  addressController.text = employeeModel.address;
                  birth = employeeModel.birthDate;
                  positionController.text = employeeModel.position;
                  employeeID = employeeModel.id;
                });
              },
              child: Image.asset(
                "assets/more.png",
                color: Colors.grey,
                height: 30,
              ),
            ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // screenHeight = 500;
    screenWidth = 500;
    screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        employeeList(),
        SizedBox(
          width: 20,
        ),
        profileDetail(),
      ],
    );
  }

  Container profileDetail() {
    return Container(
      width: 500,
      height: 800,
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              pickUploadProfilePic();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 0, bottom: 24),
              height: 120,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primary,
              ),
              child: Center(
                  child:
                      // UserModel.profilePicLink == " "
                      //     ?
                      const Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              )
                  // : ClipRRect(
                  //     borderRadius: BorderRadius.circular(20),
                  //     child: Image.network(UserModel.profilePicLink),
                  //   ),
                  ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: employeeID.isEmpty
                ? textField("Employee ID", "Employee ID", employeeIDController)
                : Text(
                    "Employee ID: ${employeeModel.id}",
                    style: const TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(
            height: 24,
          ),
          employeeModel.canEdit
              ? textField("First Name", "First name", firstNameController)
              : field("First Name", employeeModel.firstName),
          employeeModel.canEdit
              ? textField("Last Name", "Last name", lastNameController)
              : field("Last Name", employeeModel.lastName),
          employeeModel.canEdit
              ? textField("Position", "Position", positionController)
              : field("Position", employeeModel.position),
          employeeModel.canEdit
              ? GestureDetector(
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primary,
                                secondary: primary,
                                onSecondary: Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: primary,
                                ),
                              ),
                              textTheme: const TextTheme(
                                headline4: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                overline: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                                button: TextStyle(
                                  fontFamily: "NexaBold",
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        }).then((value) {
                      setState(() {
                        birth = DateFormat("MM/dd/yyyy").format(value!);
                      });
                    });
                  },
                  child: field("Date of Birth", birth),
                )
              : field("Date of Birth", employeeModel.birthDate),
          employeeModel.canEdit
              ? textField("Address", "Address", addressController)
              : field("Address", employeeModel.address),
          employeeModel.canEdit
              ? GestureDetector(
                  onTap: () async {
                    String firstName = firstNameController.text;
                    String lastName = lastNameController.text;
                    String positionName = positionController.text;
                    String birthDate = birth;
                    String address = addressController.text;

                    if (employeeModel.canEdit) {
                      if (firstName.isEmpty) {
                        showSnackBar("Please enter First name!");
                      } else if (lastName.isEmpty) {
                        showSnackBar("Please enter Last name!");
                      } else if (positionName.isEmpty) {
                        showSnackBar("Please enter Position!");
                      } else if (birthDate.isEmpty) {
                        showSnackBar("Please enter birth date!");
                      } else if (address.isEmpty) {
                        showSnackBar("Please enter address!");
                      } else {
                        await Firebase.initializeApp(
                          options: firebaseOptions(),
                        );
                        if (employeeModel.id.isEmpty) {
                          await FirebaseFirestore.instance
                              .collection("Employee")
                              .doc()
                              .set({
                            'id': employeeIDController.text,
                            'firstName': firstName,
                            'lastName': lastName,
                            'birthDate': birthDate,
                            'address': address,
                            'canEdit': true,
                            'position': positionName,
                            'password': employeeIDController.text,
                            'role': 200
                          }).then((value) {
                            setState(() {
                              employeeModel.canEdit = true;
                              employeeModel.firstName = firstName;
                              employeeModel.lastName = lastName;
                              employeeModel.birthDate = birthDate;
                              employeeModel.address = address;
                              employeeModel.position = positionName;
                              employeeModel.id = employeeIDController.text;
                              employees.add(employeeModel);
                            });
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection("Employee")
                              .doc(employeeModel.uid)
                              .update({
                            'firstName': firstName,
                            'lastName': lastName,
                            'birthDate': birthDate,
                            'address': address,
                            'canEdit': true,
                            'position': positionName
                          }).then((value) {
                            setState(() {
                              employeeModel.canEdit = true;
                              employeeModel.firstName = firstName;
                              employeeModel.lastName = lastName;
                              employeeModel.birthDate = birthDate;
                              employeeModel.address = address;
                              employeeModel.position = positionName;
                              for (EmployeeModel employee in employees) {
                                if (employee.id == employeeModel.id) {
                                  employee.canEdit = true;
                                  employee.firstName = firstName;
                                  employee.lastName = lastName;
                                  employee.birthDate = birthDate;
                                  employee.address = address;
                                  employee.position = positionName;
                                }
                              }
                            });
                          });
                        }
                      }
                    } else {
                      showSnackBar(
                          "You can't edit anymore, please contact support team.");
                    }
                  },
                  child: Container(
                    height: kToolbarHeight,
                    width: screenWidth,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: primary,
                    ),
                    child: const Center(
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NexaBold",
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget field(String title, String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.black54,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(
      String title, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}
