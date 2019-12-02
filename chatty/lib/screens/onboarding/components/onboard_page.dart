import 'package:chatty/screens/onboarding/data/onboard_page_data.dart';
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

  _nextButtonPressed() {
   print('button pressed');
   widget.pageController.nextPage(
     duration: Duration(
       milliseconds: 500,
     ),
     curve: Curves.fastLinearToSlowEaseIn,
   );
  }

  final int _numPages = onboardData.length;


  @override
  Widget build(BuildContext context) {
    var _currentPage = widget.pageModel.pageNumber;

    Widget _indicator(bool isActive) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        height: 8.0,
        width: isActive ? 24.0 : 16.0,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );
    }

    List<Widget> _buildPageIndicator() {
      List<Widget> list = [];
      for (int i = 0; i < _numPages; i++) {
        list.add(i == _currentPage ? _indicator(true) : _indicator(false));
      }
      return list;
    }

    return Scaffold(
      body:
      Stack(
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
                            Text(widget.pageModel.caption,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(widget.pageModel.description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ],
              )
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _currentPage != _numPages - 1
                  ? Container(
                color: Colors.transparent,
                width: 50.0,
                height: 50.0,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _nextButtonPressed,
                ),
              )
                  : Text(''),
            ),
          )
        ],
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
        height: 100.0,
        width: double.infinity,
        color: Colors.white,
        child: GestureDetector(
          onTap: () => print('Get started'),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.0),
              child: Text(
                'Get started',
                style: TextStyle(
                  color: Color(0xFF5B16D0),
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
