import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/scheduler.dart';
import 'package:chatty/screens/mainscreen/main_screen.dart';
import 'package:intl/intl.dart';

class chatScreen extends StatefulWidget {
  final String userId;
  final String endName;

  chatScreen({Key key, this.userId, this.endName}) : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}

// The base class for the different types of items the list can contain.
abstract class ListItem {}

// A ListItem that contains data to display a heading.
class myMessage implements ListItem {
  final String message;
  final String time;
  myMessage(this.message, this.time);
}

// A ListItem that contains data to display a heading.
class yourMessage implements ListItem {
  final String message;
  final String time;
  yourMessage(this.message, this.time);
}

class _chatScreenState extends State<chatScreen> {
  String welcomeMessage = "welcome to the chat";

  void initState() {
    super.initState();
    String b = widget.userId;
    String c = widget.endName;
    String a = "$c says: $welcomeMessage";
    var now = DateTime.now();
    String formattedDate = DateFormat('Hm').format(now);
    print(formattedDate);

    if (Platform.isIOS) {
//      receiveMessageIOS();
    }

    if (Platform.isAndroid) {
      Nearby().sendPayload(b, Uint8List.fromList(a.codeUnits));
      Nearby().acceptConnection(
        b,
        onPayLoadRecieved: (endid, payload) {
          if (payload.type == PayloadType.BYTES) {
//                                  print(String.fromCharCodes(payload.bytes));
            setState(() => sentText =
                (widget.endName + ": " + String.fromCharCodes(payload.bytes)));
          }
          listMessagesItems.add(yourMessage(
              (String.fromCharCodes(payload.bytes)), formattedDate));
          setState(() {});
        },
        onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
          if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRRESS) {
            print("progress");
          } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
            print("failed");
          } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
            print("success");
          }
        },
      );
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const platform =
      const MethodChannel('be.xavierallen.chatty/multipeerConnectivity');

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

  //list of messages
  List<String> listMessages = [
    "test",
    "test2",
    "test3",
    "test4",
    "Longer test for maximum testing"
  ];
  List<ListItem> listMessagesItems = [];
  ScrollController _scrollController = new ScrollController();

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
                    Container(
                      height: 150.0,
                    ),
                    Flexible(
                      child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: listMessagesItems.length,
                          // ignore: missing_return
                          itemBuilder: (BuildContext ctxt, int index) {
                            final item = listMessagesItems[index];
                            if (item is yourMessage) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                          topRight: Radius.circular(30.0),
                                          bottomLeft: Radius.circular(30.0),
                                          bottomRight: Radius.circular(30.0),
                                        ),
                                        color: Colors.white30,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0,
                                            bottom: 12.0,
                                            left: 16.0,
                                            right: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              item.message,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text(
                                                item.time,
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (item is myMessage) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    new Container(
                                      decoration: new BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          bottomLeft: Radius.circular(30.0),
                                          bottomRight: Radius.circular(30.0),
                                        ),
                                        color:
                                            Colors.greenAccent.withOpacity(0.8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0,
                                            bottom: 12.0,
                                            left: 16.0,
                                            right: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              item.message,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2.0),
                                              child: Text(
                                                item.time,
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Divider(
                        color: Colors.white30,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Send a message',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 116,
                            height: 51.0,
                            child: TextField(
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                              controller: myController,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                    ),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                  hintText: "Type in your text...",
                                  fillColor: Colors.white30),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 0.0),
                            child: Container(
                              width: 100.0,
                              height: 51.0,
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                  ),
                                ),
                                textColor: Colors.white,
                                color: Colors.blue,
                                onPressed: () {
                                  var now = DateTime.now();
                                  String formattedDate =
                                      DateFormat('Hm').format(now);
                                  print(formattedDate);
                                  String a = myController.text;
                                  String b = widget.userId;
                                  myController.clear();

                                  if (Platform.isIOS) {
                                    sendMessageIOS(a);
                                    listMessagesItems
                                        .add(myMessage(a, formattedDate));
                                    setState(() {});
                                    receiveMessageIOS();
                                  }

                                  if (Platform.isAndroid) {
                                    Nearby().sendPayload(
                                        b, Uint8List.fromList(a.codeUnits));
                                    listMessagesItems
                                        .add(myMessage(a, formattedDate));

                                    Nearby().acceptConnection(
                                      b,
                                      onPayLoadRecieved: (endid, payload) {
                                        if (payload.type == PayloadType.BYTES) {
//                                  print(String.fromCharCodes(payload.bytes));
                                          setState(() => sentText =
                                              (widget.endName +
                                                  ": " +
                                                  String.fromCharCodes(
                                                      payload.bytes)));

                                          listMessagesItems.add(yourMessage(
                                              String.fromCharCodes(
                                                  payload.bytes),
                                              formattedDate));
                                          setState(() {});

                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeOut,
                                            );
                                          });
                                        }
                                      },
                                      onPayloadTransferUpdate:
                                          (endid, payloadTransferUpdate) {
                                        if (payloadTransferUpdate.status ==
                                            PayloadStatus.IN_PROGRRESS) {
                                          print("progress");
                                        } else if (payloadTransferUpdate
                                                .status ==
                                            PayloadStatus.FAILURE) {
                                          print("failed");
                                        } else if (payloadTransferUpdate
                                                .status ==
                                            PayloadStatus.SUCCESS) {
                                          print("success");
                                        }
                                      },
                                    );
                                  }

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      curve: Curves.easeOut,
                                    );
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Send',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: showLogo(32.0),
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
                        if (Platform.isAndroid) {
                          Navigator.of(context).pop();
                          Nearby().stopAllEndpoints();
                        }

                        if (Platform.isIOS) {
                          Navigator.of(context).pop();

                          //add close connections
                          closeConnectionIOS();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void sendMessageIOS(String a) async {
    String value;

    try {
      value = await platform.invokeMethod("sendMessageIOS", a);
    } catch (e) {
      print(e);
    }

    print(value);
  }

  void receiveMessageIOS() async {
    String value;

    try {
      value = await platform.invokeMethod("receiveMessageIOS");
    } catch (e) {
      print(e);
    }

    var now = DateTime.now();
    String formattedDate =
    DateFormat('Hm').format(now);

    listMessagesItems.add(yourMessage(value, formattedDate));
    setState(() {});

    print(value);
  }

  void closeConnectionIOS() async {
    String value;

    try {
      value = await platform.invokeMethod("closeConnectionIOS");
    } catch (e) {
      print(e);
    }

    print(value);
  }
}
