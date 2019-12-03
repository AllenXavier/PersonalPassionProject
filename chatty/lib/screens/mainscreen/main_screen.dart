import 'package:flutter/material.dart';


class mainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Click button to back to Main Page'),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.redAccent,
                child: Text('Become host'),
                onPressed: () {
                  // TODO
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.redAccent,
                child: Text('Join Chat'),
                onPressed: () {
                  // TODO
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}