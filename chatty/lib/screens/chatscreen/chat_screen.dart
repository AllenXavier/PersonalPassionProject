import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:chatty/screens/mainscreen/main_screen.dart';
import 'package:chatty/animation/EnterExitRoute.dart';


class chatScreen extends StatefulWidget {
  final String userId;
  final String endName;

  chatScreen({Key key, this.userId, this.endName}) : super (key: key);


  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {

  String welcomeMessage = "welcome to the chat";

  void initState() {
    super.initState();
    String a = welcomeMessage;
    String b = widget.userId;
    Nearby().sendPayload(b, Uint8List.fromList(a.codeUnits));
    Nearby().acceptConnection(
      b,
      onPayLoadRecieved: (endid, payload) {
        if (payload.type == PayloadType.BYTES) {
//                                  print(String.fromCharCodes(payload.bytes));
          setState(() => sentText = (widget.endName +": " + String.fromCharCodes(payload.bytes)));
        }
        Nearby().sendPayload(b, Uint8List.fromList(a.codeUnits));
      },
      onPayloadTransferUpdate:
          (endid, payloadTransferUpdate) {
        if (payloadTransferUpdate.status ==
            PayloadStatus.IN_PROGRRESS) {
          print("progress");
        } else if (payloadTransferUpdate.status ==
            PayloadStatus.FAILURE) {
          print("failed");
        } else if (payloadTransferUpdate.status ==
            PayloadStatus.SUCCESS) {
          print("success");
        }
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const platform = const MethodChannel('be.xavierallen.chatty/multipeerConnectivity');

  final String userName = Random().nextInt(1000).toString();
  String sentText = "Waiting on user...";
  final Strategy strategy = Strategy.P2P_STAR;
  String cId = "0";

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(32.0),
                              color: Colors.white30,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "$sentText",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: Divider(
                          color: Colors.white30,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Send a message',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          style: new TextStyle(color: Colors.white),
                          controller: myController,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.white),
                              hintText: "Type in your text",
                              fillColor: Colors.white30),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Container(
                              width: 150.0,
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0)),
                                textColor: Colors.white,
                                color: Colors.blue,
                                onPressed: () {
                                  String a = myController.text;
                                  String b = widget.userId;
                                  print("Sending $a to $b");
                                  print("send");
                                  myController.clear();
                                  Nearby().sendPayload(b, Uint8List.fromList(a.codeUnits));

                                  Nearby().acceptConnection(
                                    b,
                                    onPayLoadRecieved: (endid, payload) {
                                      if (payload.type == PayloadType.BYTES) {
//                                  print(String.fromCharCodes(payload.bytes));
                                        setState(() => sentText = (widget.endName +": " + String.fromCharCodes(payload.bytes)));
                                      }
                                    },
                                    onPayloadTransferUpdate:
                                        (endid, payloadTransferUpdate) {
                                      if (payloadTransferUpdate.status ==
                                          PayloadStatus.IN_PROGRRESS) {
                                        print("progress");
                                      } else if (payloadTransferUpdate.status ==
                                          PayloadStatus.FAILURE) {
                                        print("failed");
                                      } else if (payloadTransferUpdate.status ==
                                          PayloadStatus.SUCCESS) {
                                        print("success");
                                      }
                                    },
                                  );

                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Send',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

            ),
            Align(
              alignment: Alignment.topCenter,
              child: showLogo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 40.0),
                  child: Container(
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Nearby().stopAllEndpoints();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}
