import 'package:flutter/material.dart';
import 'package:audiometer/constant/color.dart';

class NoDataWidget extends StatelessWidget {
  final VoidCallback onTakeTest;

  const NoDataWidget({super.key, required this.onTakeTest});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment:
              isLandscape ? MainAxisAlignment.start : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLandscape) const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/no_data.jpg',
                height: isLandscape ? 150 : 200,
                width: isLandscape ? 150 : 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: isLandscape ? 15 : 20),
            Text(
              "No Data Found",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Take a test and check back later to\nsee your results.",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: kSecondaryColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: isLandscape ? 10 : 30),
            (!isLandscape)
                ? ElevatedButton.icon(
                    onPressed: onTakeTest,
                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                    label: const Text(
                      "Take a Test",
                      style: TextStyle(color: kTextColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : const SizedBox(),
            if (isLandscape) const Spacer(),
          ],
        ),
      ),
    );
  }
}
