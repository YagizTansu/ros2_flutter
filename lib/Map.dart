import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math' as math;



class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late Ros _client;
  late Topic _subscriber;
  late Topic _robot_pose;
  late Topic _robot_goal;
  late List<int> data ;
  Offset flutterMapPoint = Offset.zero;
  Offset rosMapPoint = Offset.zero;
  Offset robotCoordinate = Offset.zero;
  Offset robotOrientation = Offset.zero;
  Offset robotFlutterMapPoint = Offset.zero;
  double direction = 0.0;
  int counter = 0;
  double _x = 0;
  double _y = 0;



  late String msgReceived = "";

  @override
  void initState() {
    super.initState();
    _client = Ros(url: 'ws://127.0.0.1:9090');
    //_subscriber = Topic(ros: _client, name: '/chatter', type: "std_msgs/String", reconnectOnClose: true, queueLength: 10, queueSize: 10);
    _robot_pose = Topic(ros: _client, name: '/amcl_pose', type: "geometry_msgs/msg/PoseWithCovarianceStamped", reconnectOnClose: true, queueLength: 1, queueSize: 1);
    _robot_goal = Topic(ros: _client, name: '/goal_pose', type: "geometry_msgs/msg/PoseStamped", reconnectOnClose: true, queueLength: 1, queueSize: 1);
    _client.connect();
    _robot_pose.subscribe(robotPoseSubscribeHandler);


  }

  Future<void> subscribeHandler(Map<String, dynamic> msg) async {
    msgReceived = json.encode(msg);
    setState(() {});
  }

  Future<void> robotPoseSubscribeHandler(Map<String, dynamic> msg) async {
    msgReceived = json.encode(msg);
    //print(msg);
    Map position = msg['pose']['pose']['position'];
    Map orientation = msg['pose']['pose']['orientation'];

    double coorX = position['x'];
    double coorY = position['y'];

    double oorZ = orientation['z'];
    double oorW = orientation['w'];


    robotCoordinate = Offset(coorX, coorY);
    robotOrientation = Offset(oorW, oorZ);

    robotFlutterMapPoint = transformPointToFlutterMap(robotCoordinate);

    print("Position: $robotFlutterMapPoint");
    print("orientation: ($oorZ, $oorW)");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //Text(msgReceived),
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 800,
                  width: 800,
                  child: SvgPicture.asset(
                    'assets/images/map.svg',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: robotFlutterMapPoint.dx-20 ,
                  top: robotFlutterMapPoint.dy-20 ,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: SvgPicture.asset(
                      'assets/icons/location.svg',
                      fit: BoxFit.contain,
                      ),
                    ),
                  ),
                Positioned(
                  left: flutterMapPoint.dx-20,
                  top: flutterMapPoint.dy-20,
                  child: Transform(
                    alignment: FractionalOffset.center,
                    transform: new Matrix4.identity()
                      ..rotateZ(direction),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: SvgPicture.asset(
                          'assets/icons/arrow.svg',
                          fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onPanUpdate: (value){
                        _x += value.delta.dx/2 ; // Adjust the sensitivity here
                        _y += value.delta.dy/2 ; // Adjust the sensitivity here
                        double radians = math.atan2(_y, _x);
                        direction = radians;//radians * 180 / math.pi;
                        counter =0;
                      counter++;
                      //print(direction);
                      setState(() {});
                    },
                    onTapDown: (details) async{

                      rosMapPoint = transformPointToRosMap(details.localPosition);
                      flutterMapPoint = details.localPosition;
                      // Perform some action
                      setState(() {});

                     print('*****************************************');
                     print('Tapped at source: (${details.localPosition})');
                     print('Tapped at ros map point: (${rosMapPoint.dx})(${rosMapPoint.dy})');
                    },
                    onTapUp:(value){

                      final databaseRef = FirebaseDatabase.instance.ref();// Get a reference to the root of your database
                      Map<String, dynamic> jsonData = { // The JSON object you want to write to the database
                        "dx": rosMapPoint.dx,
                        "dy": rosMapPoint.dy,
                        "orientation": direction
                      };
                      databaseRef.child("users").child('robot1').set(jsonData);

                      _x = 0.0;
                      _y = 0.0;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Offset transformPointToRosMap(Offset point){
  return Offset(0.75*(-4.00+(point.dx/100)), -0.75*(-4.00+(point.dy/100)));
}

Offset transformPointToFlutterMap(Offset point){
  return Offset( (100*point.dx/0.75)+400,(100*point.dy/-0.75)+400);
}
