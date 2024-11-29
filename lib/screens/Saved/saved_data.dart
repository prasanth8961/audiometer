import 'package:audiometer/provider/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audiometer/constant/color.dart';
import 'package:audiometer/provider/firebase_provider.dart';
import 'package:audiometer/widget/not_found.dart';
import 'detailed_view.dart';

class SavedDataScreen extends StatelessWidget {
  const SavedDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseProvider = Provider.of<FirebaseProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Data',
          style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('patients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return NoDataWidget(
              onTakeTest: () =>
                  Navigator.pushNamed(context, '/realTimeMonitoring'),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return NoDataWidget(
              onTakeTest: () =>
                  Navigator.pushNamed(context, '/realTimeMonitoring'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];

              final patientId = doc.id;
              final name = doc['name'];
              final contact = doc['contact'] ?? 'Not Provided';
              final age = doc['age'] ?? 'Not Provided';
              final leftEarData =
                  firebaseProvider.firestoreToTestData(doc['leftEarData']);
              final rightEarData =
                  firebaseProvider.firestoreToTestData(doc['rightEarData']);
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: (themeProvider.isDarkMode)
                                ? Colors.white
                                : kTextColor.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            name ?? 'Unknown',
                            style: TextStyle(
                                color: (themeProvider.isDarkMode)
                                    ? Colors.white
                                    : kTextColor.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: (themeProvider.isDarkMode)
                                ? Colors.white
                                : kTextColor.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Contact: $contact',
                            style: TextStyle(
                                color: (themeProvider.isDarkMode)
                                    ? Colors.white
                                    : kTextColor.withOpacity(0.7),
                                fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.cake,
                            color: (themeProvider.isDarkMode)
                                ? Colors.white
                                : kTextColor.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Age: $age',
                            style: TextStyle(
                                color: (themeProvider.isDarkMode)
                                    ? Colors.white
                                    : kTextColor.withOpacity(0.7),
                                fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                    title: name,
                                    leftEarData: leftEarData,
                                    rightEarData: rightEarData,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.drive_file_move_outline),
                            label: const Text('View Details'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: kSecondaryColor,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Item'),
                                  content: const Text(
                                      'Are you sure you want to delete this data?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        firebaseProvider
                                            .deletePatientData(patientId);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
