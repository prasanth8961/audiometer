import 'package:flutter/material.dart';
import 'package:audiometer/constant/color.dart';
import '../widget/app_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kTertiaryColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        DashboardContainer(
                          icon: Icons.multitrack_audio,
                          title: "Real-Time Monitoring",
                          onTap: () {
                            Navigator.pushNamed(context, "/realTimeMonitoring");
                          },
                        ),
                        DashboardContainer(
                          icon: Icons.bar_chart,
                          title: "Audio Analysis",
                          onTap: () {
                            Navigator.pushNamed(context, "/audioAnalysis");
                          },
                        ),
                        DashboardContainer(
                          icon: Icons.save,
                          title: "Saved Data",
                          onTap: () {
                            Navigator.pushNamed(context, "/savedData");
                          },
                        ),
                        DashboardContainer(
                          icon: Icons.report,
                          title: "Reports",
                          onTap: () {
                            Navigator.pushNamed(context, "/reports");
                          },
                        ),
                        DashboardContainer(
                          icon: Icons.settings,
                          title: "Settings",
                          onTap: () {
                            Navigator.pushNamed(context, "/settings");
                          },
                        ),
                        DashboardContainer(
                          icon: Icons.help,
                          title: "Help & Tutorials",
                          onTap: () {
                            Navigator.pushNamed(context, "/help");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const CustomAppBar(),
          ],
        ),
      ),
    );
  }
}

class DashboardContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kTransperentColor,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(31, 60, 59, 59),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: kPrimaryColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: kTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
