import 'package:employee_schedule_management/admin/common/app_responsive.dart';
import 'package:employee_schedule_management/admin/controllers/menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/app_colors.dart';

class HeaderWidget extends StatefulWidget {
  final String headerName;
  HeaderWidget({Key? key, required this.headerName}) : super(key: key);
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          if (!AppResponsive.isDesktop(context))
            IconButton(
              icon: Icon(
                Icons.menu,
                color: AppColor.black,
              ),
              onPressed: Provider.of<MenuController>(context, listen: false)
                  .controlMenu,
            ),
          Text(
            widget.headerName,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // if (!AppResponsive.isMobile(context)) ...{
          //   Spacer(),
          //   Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       navigationIcon(icon: Icons.search),
          //       navigationIcon(icon: Icons.send),
          //       navigationIcon(icon: Icons.notifications_none_rounded),
          //     ],
          //   )
          // }
        ],
      ),
    );
  }

  Widget navigationIcon({icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
        color: AppColor.black,
      ),
    );
  }
}
