import 'package:flutter/material.dart';
import '../auth/auth.dart';

class CaretakerDashboard extends StatelessWidget {
  final User user;

  const CaretakerDashboard({super.key, required this.user});

  String _cleanName(dynamic name) {
    final value = name?.toString().trim();
    if (value == null || value.isEmpty) return 'Caretaker';
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = _cleanName(user.claims['given_name']);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Caretaker Dashboard'),
        backgroundColor: const Color.fromRGBO(46, 165, 107, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome, $firstName',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Create and manage browse requests for wildlife in your care.',
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 24),

          _dashboardCard(
            context,
            title: 'Create Browse Request',
            subtitle: 'Request plants or branches for animals.',
            icon: Icons.add_circle_outline,
            onTap: () {
              Navigator.pushNamed(context, '/order', arguments: {'user': user});
            },
          ),

          _dashboardCard(
            context,
            title: 'View Request Board',
            subtitle: 'See current requests and their status.',
            icon: Icons.list_alt,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/request-board',
                arguments: {'user': user},
              );
            },
          ),

          _dashboardCard(
            context,
            title: 'My Account',
            subtitle: 'View your account details.',
            icon: Icons.person_outline,
            onTap: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/profile', arguments: {'user': user});
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/help-faq');
        },
        child: const Icon(Icons.help_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _dashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon,
          color: const Color.fromRGBO(46, 165, 107, 1),
          size: 36,
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
