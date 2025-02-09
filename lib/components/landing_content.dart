import 'package:flutter/material.dart';
import 'package:login/theme/app_colors.dart';

class LandingContent extends StatelessWidget {
  const LandingContent({Key? key, required this.onGetStarted}) : super(key: key);

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Lorem ipsum dolor sit amet",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium",
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: onGetStarted,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_right, color: AppColors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
