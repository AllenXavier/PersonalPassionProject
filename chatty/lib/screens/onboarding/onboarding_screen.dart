import 'package:chatty/screens/onboarding/components/onboard_page.dart';
import 'package:chatty/screens/onboarding/data/onboard_page_data.dart';

import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {

  final PageController pageController = PageController();

  _skipButtonPressed() {
    print('button pressed');
    pageController.jumpToPage(
      2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        PageView.builder(
          controller: pageController,
          itemCount: onboardData.length,
          itemBuilder: (context, index) {
            return OnboardPage(
              pageController: pageController,
              pageModel:  onboardData[index],
            );
          },
        ),
        Container(
          width: double.infinity,
          height: 100,
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
                    child: Text('skip',
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
        )
      ],
    );
  }
}
