import 'package:chatty/screens/onboarding/components/onboard_page.dart';
import 'package:chatty/screens/onboarding/data/onboard_page_data.dart';
import 'package:chatty/screens/mainscreen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:worm_indicator/shape.dart';
import 'package:worm_indicator/worm_indicator.dart';

class Onboarding extends StatefulWidget {

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController pageController = PageController();

  int _currentPage = 0;
  final int _numPages = onboardData.length;

  _skipButtonPressed() {
    print('button pressed');
    pageController.animateToPage(
      2,
      duration: Duration(
        milliseconds: 800,
      ),
      curve: Curves.fastLinearToSlowEaseIn,

    );
  }

  _nextButtonPressed() {
    pageController.nextPage(
      duration: Duration(
        milliseconds: 500,
      ),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget buildExampleIndicatorWithShapeAndBottomPos(
        Shape shape, double bottomPos) {
      return Positioned(
        bottom: bottomPos,
        left: 0,
        right: 0,
        child: WormIndicator(
          length: onboardData.length,
          controller: pageController,
          shape: shape,
          color: Colors.white30,
          indicatorColor: Colors.white,
        ),
      );
    }

    final circleShape = Shape(
      size: 8,
      shape: DotShape.Circle,
      spacing: 8,
    );


    return Scaffold(
      body: Stack(
        children: <Widget>[

          PageView.builder(
            controller: pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: onboardData.length,
            itemBuilder: (context, index) {
              return OnboardPage(
                pageController: pageController,
                pageModel:  onboardData[index],
              );
            },
          ),
          buildExampleIndicatorWithShapeAndBottomPos(circleShape, 150),

          Container(
            width: double.infinity,
            height: 120,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text('Onboarding',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: FlatButton(
                      color: Colors.white30,
                      child: Text('Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: _skipButtonPressed ,
                    ),
                  ),

                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _currentPage != onboardData.length - 1
                  ? FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: _nextButtonPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              )
                  : Text(''),
            ),
          ),
        ],
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
        decoration: new BoxDecoration(
            color: Colors.white30,
            borderRadius: new BorderRadius.only(
                topLeft:  const  Radius.circular(40.0),
                topRight: const  Radius.circular(40.0))
        ),
        height: 100.0,
        width: double.infinity,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mainScreen()),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                'Get started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      )
          : Text(''),
    );
  }
}
