import 'package:flutter/material.dart';
import 'package:login/theme/app_colors.dart';
import 'package:login/components/landing_content.dart';
import 'package:login/components/login.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key, required this.title});
  final String title;

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late PageController _pageController;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _progress = _pageController.page ?? 0;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 250),
              child: Center(
                child: Image.asset(
                  "assets/images/bg.png",
                  width: MediaQuery.of(context).size.width *
                      0.7, // Adjust the width as needed
                  height: MediaQuery.of(context).size.height *
                      0.5, // Adjust the height as needed
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                height:
                    MediaQuery.of(context).size.height * 0.35 + _progress * 150,
                child: Column(
                  children: [
                    Expanded(
                        child: PageView(
                      controller: _pageController,
                      children: [
                        LandingContent(onGetStarted: () {
                          _pageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }),
                        Login(),
                      ],
                    ))
                  ],
                )),
          )
        ],
      ),
    );
  }
}
