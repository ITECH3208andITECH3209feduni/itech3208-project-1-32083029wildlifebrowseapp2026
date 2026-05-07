import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth.dart';

class LandholderTutorial extends StatelessWidget {
  final User user;

  const LandholderTutorial({super.key, required this.user});

  Future<void> _finishTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('landholder_tutorial_seen', true);

    Navigator.of(context, rootNavigator: true).pushNamed(
      '/landowner-registration',
      arguments: {'user': user},
    );
  }

  void _skipToListings(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      '/landowner',
      arguments: {
        'user': user,
        'browseFilter': <String>[],
        'uploadSuccess': false,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Landholder Guide'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'How to list your property for browse gathering',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _guideCard(
              icon: Icons.eco,
              title: '1. Choose browse plants',
              text:
                  'Select the browse plants available on your property, such as Banksia, Callistemon, Camellia, or Blue Gum.',
            ),
            _guideCard(
              icon: Icons.location_on,
              title: '2. Add land details',
              text:
                  'Enter your address, postcode, access instructions, and phone number so gatherers know where and how to visit.',
            ),
            _guideCard(
              icon: Icons.calendar_month,
              title: '3. Set availability',
              text:
                  'Choose the days and times that gatherers are allowed to come and collect browse.',
            ),
            _guideCard(
              icon: Icons.warning_amber,
              title: '4. Add preferences',
              text:
                  'Add warnings, restrictions, or extra notes such as pets, gates, garden areas, or safety concerns.',
            ),
            _guideCard(
              icon: Icons.check_circle,
              title: '5. Submit your listing',
              text:
                  'Once submitted, your listing will appear for gatherers to view. You can delete listings later if needed.',
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () => _finishTutorial(context),
              child: const Text('Start Listing My Property'),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => _skipToListings(context),
              child: const Text('Skip and view my listings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color.fromRGBO(232, 246, 238, 1),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}