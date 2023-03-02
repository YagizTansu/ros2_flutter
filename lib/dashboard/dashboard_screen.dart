import 'package:ros2_flutter/dashboard/components/robot_proporties.dart';
import 'package:ros2_flutter/responsive.dart';
import 'package:flutter/material.dart';
import '../../Map.dart';
import '../../constants.dart';
import 'components/header.dart';
import 'components/Robot_details.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            child: Container(
                              padding: EdgeInsets.all(defaultPadding),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Map",
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  MapPage(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) RobotDetail(),
                      if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) RobotProporties(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        RobotDetail(),
                        SizedBox(height: defaultPadding),
                        RobotProporties(),
                      ],
                    ),
                  ),




              ],
            )
          ],
        ),
      ),
    );
  }
}