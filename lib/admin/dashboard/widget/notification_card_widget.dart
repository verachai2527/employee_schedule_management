import 'package:employee_schedule_management/admin/common/app_colors.dart';
import 'package:employee_schedule_management/utility/my_style.dart';
import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyStyle().darkColor, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 16, color: AppColor.black),
                  children: [
                    TextSpan(text: "Good Morning "),
                    TextSpan(
                      text: "..!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Don’t stop thinking about tomorrow. \nIt’ll soon be here.",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColor.black,
                  height: 1.5,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "Read More",
              //   style: TextStyle(
              //       fontSize: 14,
              //       color: AppColor.black,
              //       fontWeight: FontWeight.bold,
              //       decoration: TextDecoration.underline),
              // )
            ],
          ),
          if (MediaQuery.of(context).size.width >= 620) ...{
            Spacer(),
            Image.asset(
              "assets/notification_image.png",
              height: 160,
            )
          }
        ],
      ),
    );
  }
}
