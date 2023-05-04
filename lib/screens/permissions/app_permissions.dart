import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_watch/screens/home.dart';
import 'package:smart_watch/screens/login.dart';
import 'package:smart_watch/screens/permissions/permission_pages/perm_page_1.dart';
import 'package:smart_watch/screens/permissions/permission_pages/perm_page_2.dart';
import 'package:smart_watch/screens/permissions/permission_pages/perm_page_3.dart';
import 'package:smart_watch/screens/permissions/permission_pages/perm_page_4.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreen();
}

class _OnBoardingScreen extends State<OnBoardingScreen> {

  /// controller to keep track of which page we're on
  PageController _controller = PageController();

  /// keep track if we are on the last page or not
  bool onLastPage = false;
  bool onFirstPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: [
              PermPage1(),
              PermPage2(),
              PermPage3(),
              PermPage4()
            ],
          ),

          /// dot indicators
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // BACK
                onFirstPage ?
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text('Back'),
                ) : GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return LogIn((email, password, name, isLogIn, role, ctx, hr) { });
                    })
                    );
                  },
                  child: Text('Back'),
                ),

                // DOT INDICATOR
                SmoothPageIndicator(controller: _controller, count: 4),

                //NEXT
                onLastPage ?
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Home();
                    })
                    );
                  },
                  child: Text('Done'),
                ) : GestureDetector(
                  onTap: () {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}