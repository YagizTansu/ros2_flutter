import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class RobotDetail extends StatelessWidget {
  const RobotDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Robot Details:    ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DropdownButtonExample()
            ],
          ),
          SizedBox(height: defaultPadding),
          Chart(percent:80),
          StorageInfoCard(
            svgSrc: "assets/icons/robot.svg",
            title: "Robot Name:",
            amountOfFiles: "Robot-1",
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/status.svg",
            title: "Robot status: ",
            amountOfFiles: "Navigating",
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/map.svg",
            title: "Map Name:",
            amountOfFiles: "Turtlebot3 world",
          ),
        ],
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = "Robot1";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.white38),
      underline: Container(
        height: 0,
        color: Colors.white,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: <String>['Robot1', 'Robot2', 'Robot3', 'Robot4'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

