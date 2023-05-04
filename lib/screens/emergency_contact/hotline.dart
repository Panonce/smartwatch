import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmergencyHotline extends StatefulWidget {
  @override
  State<EmergencyHotline> createState() => _EmergencyHotlineState();
}

class _EmergencyHotlineState extends State<EmergencyHotline>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          /// ERUF
          Card(
            child: ListTile(
              title: Text('Emergency Rescue Unit Foundation'),
              subtitle: Text('161\n0918 921 0000\n233-900/255-7287'),
            ),
          ),
          /// C3
          Card(
            child: ListTile(
              title: Text('Cebu City Command and Control Center'),
              subtitle: Text('166\n0932 537 7770\n262-1424\n0923524'),
            ),
          ),
          ///LAPU-LAPU COMMAND CENTER
          Card(
            child: ListTile(
              title: Text('Lapu-Lapu City Nerve Command Center'),
              subtitle: Text('431-3771'),
            ),
          ),
          /// MANDAUE COMMAND CENTER
          Card(
            child: ListTile(
              title: Text('Mandaue City Command Center'),
              subtitle: Text('383-1658'),
            ),
          ),
          ///LAPU-LAPU COMMAND CENTER
          Card(
            child: ListTile(
              title: Text('Lapu-Lapu City Nerve Command Center'),
              subtitle: Text('431-3771'),
            ),
          ),
          /// 911 EMERGENCY HOTLINE
          Card(
            child: ListTile(
              title: Text('911 Emergency Hotline'),
              subtitle: Text('911'),
            ),
          ),
        ],
      ),
    );
  }

}