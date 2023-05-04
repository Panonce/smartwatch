import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Security extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Security Settings",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left),
            color: Colors.black54),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Two-Factor Authentication',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Two-Factor Authentication'),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Password Strength',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Password must include:'),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text('At least one uppercase letter'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      CheckboxListTile(
                        title: Text('At least one lowercase letter'),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text('At least one number'),
                        value: true,
                        onChanged: (value) {},
                      ),
                      CheckboxListTile(
                        title: Text('At least one special character'),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Device Encryption',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Device Encryption'),
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}