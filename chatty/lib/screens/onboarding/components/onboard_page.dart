
import 'package:chatty/screens/onboarding/models/onboard_page_model.dart';
import 'package:flutter/material.dart';

class OnboardPage extends StatefulWidget {
  final PageController pageController;
  final OnboardPageModel pageModel;
  const OnboardPage(
      {Key key, @required this.pageModel, @required this.pageController})
      : super(key: key);

  @override
  _OnboardPageState createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
//  _nextButtonPressed() {
//    print('button pressed');
//    widget.pageController.nextPage(
//      duration: Duration(
//        milliseconds: 500,
//      ),
//      curve: Curves.fastLinearToSlowEaseIn,
//    );
//  }

  @override
  Widget build(BuildContext context) {


//    Widget buildExampleIndicatorWithShapeAndBottomPos(
//        Shape shape, double bottomPos) {
//      return Positioned(
//        bottom: bottomPos,
//        left: 0,
//        right: 0,
//        child: WormIndicator(
//          length: onboardData.length,
//          controller: widget.pageController,
//          shape: shape,
//          color: Colors.white30,
//          indicatorColor: Colors.white,
//        ),
//      );
//    }
//
//    final circleShape = Shape(
//      size: 8,
//      shape: DotShape.Circle,
//      spacing: 8,
//    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    widget.pageModel.gradientColor1,
                    widget.pageModel.gradientColor2,
                    widget.pageModel.gradientColor3,
                    widget.pageModel.gradientColor4,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Image.asset(widget.pageModel.imagePath),
                  ),
                  Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.pageModel.caption,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              widget.pageModel.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      )),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: _buildPageIndicator(),
//                  ),
                ],
              )),
//          Align(
//            alignment: Alignment.bottomRight,
//            child: Padding(
//              padding: const EdgeInsets.all(32.0),
//              child: _currentPage != _numPages - 1
//                  ? FlatButton(
//                      padding: EdgeInsets.all(0),
//                      onPressed: _nextButtonPressed,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Text(
//                              'Next',
//                              style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 22.0,
//                              ),
//                            ),
//                          ),
//                          Icon(
//                            Icons.arrow_forward,
//                            color: Colors.white,
//                            size: 32,
//                          ),
//                        ],
//                      ),
//                    )
//                  : Text(''),
//            ),
//          ),
        ],
      ),
//      bottomSheet: _currentPage == _numPages - 1
//          ? Container(
//              height: 100.0,
//              width: double.infinity,
//              color: Colors.transparent,
//              child: GestureDetector(
//                onTap: () => print('Get Started!'),
//                child: Center(
//                  child: Padding(
//                    padding: EdgeInsets.only(bottom: 30.0),
//                    child: Text(
//                      'Get started',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontSize: 20.0,
//                        fontWeight: FontWeight.bold,
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            )
//          : Text(''),
    );
  }
}
