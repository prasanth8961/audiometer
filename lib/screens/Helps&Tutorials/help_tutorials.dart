import 'package:flutter/material.dart';
import 'package:audiometer/constant/color.dart';

class HelpAndTutorialsScreen extends StatelessWidget {
  const HelpAndTutorialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Tutorials',
          style: TextStyle(color: kTextColor, fontWeight: FontWeight.w700),
        ),
        backgroundColor: kSecondaryColor,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Audio Meter!",
              style: TextStyle(
                fontSize: 24,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "This guide will help you understand and use the Audio Meter app effectively.",
              style: TextStyle(fontSize: 16),
            ),
            Divider(height: 20, thickness: 2),
            Text(
              "Features",
              style: TextStyle(
                fontSize: 20,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "- Test your hearing sensitivity at different audio frequencies.\n"
              "- Adjust volume to find the threshold level for each frequency.\n"
              "- Visualize your hearing results on an easy-to-read chart.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(height: 20, thickness: 2),
            Text(
              "How to Use the App",
              style: TextStyle(
                fontSize: 20,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "1. Tap on 'Increase' or 'Decrease' to adjust the audio tone volume.\n"
              "2. Use the 'Done' button to record the current sensitivity for the selected frequency.\n"
              "3. Navigate between frequencies using the '<<' and '>>' buttons.\n"
              "4. The results are plotted on a chart to track your hearing sensitivity at different frequencies.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(height: 20, thickness: 2),
            Text(
              "Understanding the Chart",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "- The chart displays audio frequencies on the X-axis and decibel levels on the Y-axis.\n"
              "- Each data point represents your hearing threshold for a specific frequency.\n"
              "- Use this information to monitor changes in your hearing over time.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(height: 20, thickness: 2),
            Text(
              "Tips for Accurate Results",
              style: TextStyle(
                fontSize: 20,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "- Use headphones in a quiet environment to minimize external noise.\n"
              "- Start with a low volume and increase gradually until you hear the tone.\n"
              "- Ensure consistent placement of headphones during the test.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Divider(height: 20, thickness: 2),
            Text(
              "Need Help?",
              style: TextStyle(
                fontSize: 20,
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "If you encounter any issues or have questions, feel free to contact our support team at support.audiometer@gmail.com.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
