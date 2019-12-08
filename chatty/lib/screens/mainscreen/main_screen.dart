import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {

  void initState() {
    super.initState();
    Nearby().askPermission();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const platform = const MethodChannel('be.xavierallen.chatty/multipeerConnectivity');

  final String userName = Random().nextInt(1000).toString();
  final Strategy strategy = Strategy.P2P_STAR;
  String cId = "0";

  void _showDialog() {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(32.0)), //this right here
            child: Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Waiting for people to join...'),
                    ),
                    new CircularProgressIndicator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: SizedBox(
                            width: 150.0,
                            child: RaisedButton(
                              onPressed: () async {
                                await Nearby().stopAllEndpoints();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Stop",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: const Color(0xFF3594DD),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Container(
                    child: IconButton(
                      color: const Color(0xFF3594DD),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: const Color(0xFF3594DD),
                        size: 32,
                      ),
                      tooltip: 'Test',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: showLogo(),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('Join or become a host.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: 230.0,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.white30,
                      onPressed: () async {
                        if (Platform.isIOS) {
                          _showDialog();
                        }
                        if (Platform.isAndroid) {
                          try {
                            bool a = await Nearby().startAdvertising(
                              userName,
                              strategy,
                              onConnectionInitiated: (id, info) {
                                oci(id, info);
                              },
                              onConnectionResult: (id, status) {
                                print(status);
                              },
                              onDisconnected: (id) {
                                print(id);
                              },
                            );
                            print(a);
                          } catch (e) {
                            print(e);
                          }
                          _showDialog();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Become host',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.wifi,
                            color: Colors.white,
                            size: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: 230.0,
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.white30,
                      onPressed: () async {
                        if (Platform.isIOS) {
                          printy();
                          print("ios");
                        }
                        if (Platform.isAndroid) {
                          print("android");
                          try {
                            bool a = await Nearby().startDiscovery(
                              userName,
                              strategy,
                              onEndpointFound: (id, name, serviceId) {
                                print("in callback");
                                showModalBottomSheet(
                                  context: context,
                                  builder: (builder) {
                                    return Center(
                                      child: Column(
                                        children: <Widget>[
                                          Text("id: " + id),
                                          Text("Name: " + name),
                                          Text("ServiceId: " + serviceId),
                                          RaisedButton(
                                            child: Text("Request Connection"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Nearby().requestConnection(
                                                userName,
                                                id,
                                                onConnectionInitiated: (id, info) {
                                                  oci(id, info);
                                                },
                                                onConnectionResult: (id, status) {
                                                  print(status);
                                                },
                                                onDisconnected: (id) {
                                                  print(id);
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              onEndpointLost: (id) {
                                print(id);
                              },
                            );
                            print(a);
                          } catch (e) {
                           print(e);
                          }
                          _showDialog();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Join chat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.message,
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
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Container(
                  child: IconButton(
                    color: Colors.black,
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 32,
                    ),
                    tooltip: 'Test',
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }

  void printy() async {
    String value;

    try{
      value = await platform.invokeMethod("Printy");
    }catch (e){
      print(e);
    }

    print(value);
  }

  /// Called on a Connection request (on both devices)
  void oci(String id, ConnectionInfo info) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: " + id),
              Text("Token: " + info.authenticationToken),
              Text("Name" + info.endpointName),
              Text("Incoming: " + info.isIncomingConnection.toString()),
              RaisedButton(
                child: Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  cId = id;
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) {
                      if (payload.type == PayloadType.BYTES) {
                        print(endid + ": " + String.fromCharCodes(payload.bytes));
                      } else if (payload.type == PayloadType.FILE) {
                        print(endid + ": File transfer started");
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        print(endid + ": FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        print(
                            "success, total bytes = ${payloadTransferUpdate.totalBytes}");
                        print(endid +
                            ": SUCCESS in file transfer (file is un-named in downloads) ");
                      }
                    },
                  );
                },
              ),
              RaisedButton(
                child: Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

//void openDrawer() {
//  if (_endDrawerKey.currentState != null && _endDrawerOpened)
//    _endDrawerKey.currentState.close();
//  _drawerKey.currentState?.open();
//}

Widget showLogo() {
  return new Hero(
    tag: 'hero',
    child: Padding(
      padding: EdgeInsets.all(32.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/chatty_logo.png'),
      ),
    ),
  );
}

