import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_schedule_management/model/user.dart';
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
  TextEditingController addressController = TextEditingController();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${UserModel.employeeId.toLowerCase()}_profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        UserModel.profilePicLink = value;
      });

      await FirebaseFirestore.instance
          .collection("Employee")
          .doc(UserModel.id)
          .update({
        'profilePic': value,
      });
    });
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
                GestureDetector(
                  onTap: () {
                    pickUploadProfilePic();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 80, bottom: 24),
                    height: 120,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primary,
                    ),
                    child: Center(
                      child: UserModel.profilePicLink == " "
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 80,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(UserModel.profilePicLink),
                            ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Employee ID: ${UserModel.employeeId}",
                    style: const TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                UserModel.canEdit
                    ? textField("First Name", "First name", firstNameController)
                    : field("First Name", UserModel.firstName),
                UserModel.canEdit
                    ? textField("Last Name", "Last name", lastNameController)
                    : field("Last Name", UserModel.lastName),
                UserModel.canEdit
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
                    : field("Date of Birth", UserModel.birthDate),
                UserModel.canEdit
                    ? textField("Address", "Address", addressController)
                    : field("Address", UserModel.address),
                UserModel.canEdit
                    ? GestureDetector(
                        onTap: () async {
                          String firstName = firstNameController.text;
                          String lastName = lastNameController.text;
                          String birthDate = birth;
                          String address = addressController.text;

                          if (UserModel.canEdit) {
                            if (firstName.isEmpty) {
                              showSnackBar("Please enter your first name!");
                            } else if (lastName.isEmpty) {
                              showSnackBar("Please enter your last name!");
                            } else if (birthDate.isEmpty) {
                              showSnackBar("Please enter your birth date!");
                            } else if (address.isEmpty) {
                              showSnackBar("Please enter your address!");
                            } else {
                              await Firebase.initializeApp(
                                options: firebaseOptions(),
                              );
                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(UserModel.id)
                                  .update({
                                'firstName': firstName,
                                'lastName': lastName,
                                'birthDate': birthDate,
                                'address': address,
                                'canEdit': false,
                              }).then((value) {
                                setState(() {
                                  UserModel.canEdit = false;
                                  UserModel.firstName = firstName;
                                  UserModel.lastName = lastName;
                                  UserModel.birthDate = birthDate;
                                  UserModel.address = address;
                                });
                              });
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
          ),
        ),
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
