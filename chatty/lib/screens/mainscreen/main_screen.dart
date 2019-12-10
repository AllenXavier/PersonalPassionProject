import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:flutter/services.dart';
import 'package:chatty/animation/EnterExitRoute.dart';
import 'package:chatty/screens/chatscreen/chat_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' show ImageFilter;
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
    restore();
  }

  String userName = Random().nextInt(1000).toString();

  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (sharedPrefs.getString('userName') ??
          Random().nextInt(1000).toString());
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final sharedPrefs = SharedPreferences.getInstance();

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  //Set channel for platform specific code
  static const platform =
      const MethodChannel('be.xavierallen.chatty/multipeerConnectivity');

  //Set username, Strategy and id
  final Strategy strategy = Strategy.P2P_STAR;
  String cId = "0";
  String endpointName = "";

  String sentText = "testText";

  //Add text input field controller
  final myController = TextEditingController();
  final userController = TextEditingController();

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  //Username edit visibility
  bool _visible = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _showDialog(title) {
    // flutter defined function
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)), //this right here
              child: Container(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$title',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black54),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Container(
                              child: FlatButton(
                                textColor: Colors.white,
                                color: Color(0xFFFF606D).withOpacity(0.6),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                                onPressed: () async {
                                  await Nearby().stopAllEndpoints();
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Stop',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)),
          child: SizedBox(
            width: 250.0,
            child: Drawer(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: _image == null
                                      ? Container(
                                          width: 150.0,
                                          height: 150.0,
                                          margin: EdgeInsets.only(
                                              top: 25.0, bottom: 10.0),
                                          child: CircleAvatar(
                                            radius: 30.0,
                                            backgroundImage: ExactAssetImage(
                                                "assets/images/Avatar.png"),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        )
                                      : Container(
                                          height: 150.0,
                                          width: 150.0,
                                          margin: EdgeInsets.only(
                                              top: 25.0, bottom: 10.0),
                                          child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundImage:
                                                  FileImage(_image))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipOval(
                                    child: Container(
                                      color: Colors.black,
                                      child: IconButton(
                                        color: Colors.black54,
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          getImage();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: FlatButton(
                                  color: Colors.white30,
                                  onPressed: () {
                                    setState(() {
                                      _visible = !_visible;
                                    });
                                    print(_visible);
                                  },
                                  child: Text(
                                    "Username: $userName",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            _visible == true
                                ? Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 150.0,
                                        child: TextField(
                                          controller: userController,
                                          decoration: InputDecoration(
                                              hintText: 'Change username '),
                                        ),
                                      ),
                                      IconButton(
                                        color: Colors.black54,
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black54,
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          if (userController.text != "") {
                                            userName = userController.text;
                                            save('userName',
                                                userController.text);
                                          }
                                          userController.clear();
                                          setState(() {
                                            _visible = !_visible;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Text(
                                    "",
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
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
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          child: Text(
                            "v. 0.0.0.1",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'Become a Host or Join a Chat',
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
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        textColor: Colors.white,
                        color: Colors.white30,
                        onPressed: () async {
                          if (Platform.isIOS) {
                            _showDialog("Waiting for people to join...");
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
                            _showDialog("Waiting for people to join...");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
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
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: new BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  new BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              40.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              40.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 32.0),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 32.0),
                                                  child: Text(
                                                    "Ask to connect:",
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 32.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "id: " + id,
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 24.0,
                                                  ),
                                                ),
                                                Text(
                                                  "Name: " + name,
                                                  style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 24.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 16.0,
                                                          top: 16.0),
                                                  child: Container(
                                                    width: 230.0,
                                                    child: FlatButton(
                                                      textColor: Colors.white,
                                                      color: Color(0xFF96c93d)
                                                          .withOpacity(0.6),
                                                      shape: new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  30.0)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Nearby()
                                                            .requestConnection(
                                                          userName,
                                                          id,
                                                          onConnectionInitiated:
                                                              (id, info) {
                                                            oci(id, info);
                                                          },
                                                          onConnectionResult:
                                                              (id, status) {
                                                            print(status);
                                                          },
                                                          onDisconnected: (id) {
                                                            print(id);
                                                          },
                                                        );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Text(
                                                              'Ask',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20.0,
                                                              ),
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.cloud_done,
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
                            _showDialog("Looking for a host...");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      color: Colors.black54,
                      icon: Icon(
                        Icons.account_circle,
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
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Container(
                    child: IconButton(
                      color: Colors.black54,
                      icon: Icon(
                        Icons.chat,
                        color: Colors.white,
                        size: 32,
                      ),
                      tooltip: 'Test',
                      onPressed: () {
                        Navigator.push(
                            context, EnterExitRoute(enterPage: chatScreen()));
                      },
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: showLogo(),
            ),
          ],
        ));
  }

  void showSnackbar(dynamic a) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  void printy() async {
    String value;

    try {
      value = await platform.invokeMethod("Printy");
    } catch (e) {
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
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Column(
                  children: <Widget>[
                    Text("id: " + id),
                    Text("Token: " + info.authenticationToken),
                    Text("Name" + info.endpointName),
                    Text("Incoming: " + info.isIncomingConnection.toString()),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                      child: Container(
                        width: 230.0,
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Color(0xFF96c93d).withOpacity(0.6),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            Navigator.pop(context);
                            endpointName = info.endpointName;
                            cId = id;
                            Nearby().acceptConnection(
                              id,
                              onPayLoadRecieved: (endid, payload) {
                                if (payload.type == PayloadType.BYTES) {
//                                  print(String.fromCharCodes(payload.bytes));
                                  setState(() => sentText = (info.endpointName +
                                      ":" +
                                      String.fromCharCodes(payload.bytes)));
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
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                EnterExitRoute(
                                    enterPage: chatScreen(
                                      userId: cId,
                                      endName: endpointName,
                                    )));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Connect',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.cloud_done,
                                color: Colors.white,
                                size: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Container(
                        width: 230.0,
                        child: FlatButton(
                          textColor: Colors.white,
                          color: Color(0xFFFF606D).withOpacity(0.6),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () async {
                            Navigator.pop(context);
                            try {
                              await Nearby().rejectConnection(id);
                            } catch (e) {
                              print(e);
                            }
                            await Nearby().stopAllEndpoints();
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Reject',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.cancel,
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
            ),
          ),
        );
      },
    );
  }
}

Widget showLogo() {
  return new Hero(
    tag: 'hero',
    child: Padding(
      padding: EdgeInsets.only(top: 80.0),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/chatty_logo.png'),
      ),
    ),
  );
}
