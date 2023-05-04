import 'package:flutter/material.dart';
import 'package:smart_watch/screens/home.dart';
import 'package:smart_watch/screens/notification/notif_respond.dart';
import 'package:smart_watch/screens/notification/notification.dart';

/// display alert dialog for reason of cancellation

class Decline extends StatefulWidget {
  @override
  _DeclineState createState() => _DeclineState();
}

class _DeclineState extends State<Decline> {

  /// --- display decline alert dialog
  void _showDeclineDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Decline Alert'),
        content: Text(
            'This person may be in great danger. Are you sure that you wish to decline this alert?'),
        actions: [

          /// -- YES
          MaterialButton(
            onPressed: () {
              showDialog(context: context, builder: (builder) {
                return Reason();
              });
            },
            child: Text('Yes'),
            color: Colors.white,
          ),

          /// -- NO
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notif()),
              );
            },
            child: Text('No'),
            color: Colors.deepOrange.shade200,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // center align the buttons horizontally
          children: [
            ElevatedButton(
              onPressed: () {
                _showDeclineDialog();
              },
              child: Text('Decline' ,
                style: TextStyle(
                    fontSize: 25
                ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
              ),
            ),
            SizedBox(width: 60,),
            ElevatedButton(
              onPressed: () {
                Respond();
              },
              child: Text('Respond' ,
                style: TextStyle(
                    fontSize: 25
                ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Reason extends StatefulWidget {

  @override
  State<Reason> createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
  String _selectedOption = 'Responder is unavailable';
  bool _showTextField = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancel Reason'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason:'),
          DropdownButton<String>(
            value: _selectedOption,
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue!;
                _showTextField = _selectedOption == 'Others';
              });
            },
            items: <String>[
              'Responder is unavailable',
              'Lack of Resources',
              'Miscommunication',
              'Others'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          _showTextField
              ? TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter a reason',
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
      actions: [

        // cancel text button
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => Decline()));
          },
          child: Text('Cancel'),
        ),

        // okay text button
        TextButton(
          onPressed: () {
            String reason =
            _selectedOption == 'Others' ? _textEditingController.text : _selectedOption;
            print('Reason: $reason');
            Navigator.push(context, MaterialPageRoute(builder: (builder) => Home()));
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}


