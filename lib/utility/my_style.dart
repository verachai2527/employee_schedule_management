import 'package:flutter/material.dart';

import 'BackgroundPainter.dart';

class MyStyle {
  Color darkColor = Color.fromARGB(183, 69, 179, 78);
  Color primaryColor = Color.fromARGB(255, 92, 171, 91);
  Color lightColor = Color(0xff9df79d);
  Color bgColor = Color.fromARGB(255, 50, 66, 50);
  TextStyle darkStyle() => TextStyle(color: darkColor);
  TextStyle whiteStyle() => TextStyle(color: Colors.white);
  TextStyle brownStyle() => TextStyle(color: Color.fromARGB(255, 142, 91, 73));
  TextStyle primaryStyle() => TextStyle(color: Color(0xff6bc46e));
  TextStyle lightStyle() => TextStyle(color: Color(0xff9df79d));
  Widget showLogo() => Image(
        height: 150,
        image: AssetImage('images/Llama_logo.png'),
      );
  Widget profilePic(String path) {
    print('path=>$path');
    if (path == "") {
      return Image(height: 170, image: AssetImage('images/ProfilePicture.png'));
    } else {
      return CircleAvatar(
        maxRadius: 120,
        backgroundImage: NetworkImage(path),
      );
      // Container(
      //   // width: 170,
      //   height: 200,
      //   child: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(0),
      //       image: DecorationImage(image: NetworkImage(path)),
      //     ),
      //   ),
      // );
    }
  }

  Scaffold buildBackground(double screenWidth, double screenHeight) {
    return Scaffold(
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child: Stack(
            children: [],
          ),
        ),
      ),
    );
  }

  MyStyle();
}
