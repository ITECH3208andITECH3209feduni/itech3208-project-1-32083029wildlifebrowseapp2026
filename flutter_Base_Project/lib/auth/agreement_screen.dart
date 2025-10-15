import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<AgreementScreen> createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  bool _saving = false;

  Future<void> _agreeAndContinue() async {
    if (_saving) return;
    setState(() => _saving = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_agreed', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('User Agreement'),
        backgroundColor: const Color.fromRGBO(46, 165, 107, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ——— Client-supplied legal text (kept as-is) ———
            const Text(
              "Ballarat Wildlife Rehabilitation & Conservation Inc App User Agreement\n"
              "Effective Date: 18/10/2025\n"
              "Organisation: Ballarat Wildlife Rehabilitation & Conservation Inc (BWRAC)\n"
              "Jurisdiction: Victoria, Australia\n\n"
              "1. Purpose\n"
              "This mobile application (“the App”) is operated by Ballarat Wildlife Rehabilitation & Conservation Inc (BWRAC). "
              "The App provides a platform to connect:\n"
              "• Volunteer landowners offering access to flora on their property,\n"
              "• Volunteer collectors who may collect flora for wildlife care, and\n"
              "• Registered wildlife foster carers and shelters.\n"
              "The App is designed to support wildlife rehabilitation and conservation efforts within Victoria, Australia.\n\n"
              "2. Acceptance of Terms\n"
              "By downloading, registering, or using the App, you acknowledge and agree that:\n"
              "• You have read, understood, and accepted this User Agreement.\n"
              "• You will comply with all relevant laws and regulations in Victoria, Australia.\n"
              "• You are responsible for your own actions and safety while using the App or participating in any related activities.\n\n"
              "3. Responsibilities of Users\n"
              "• Volunteer Landowners: You may choose to list flora available on your property. "
              "You are solely responsible for ensuring compliance with all property, environmental, and safety laws, including any local government requirements.\n"
              "• Volunteer Collectors: You agree to collect flora only where permission has been granted, to comply with any collection conditions, and to respect the landowner’s property at all times.\n"
              "• Wildlife Carers and Shelters: You are responsible for ensuring flora collected is suitable for wildlife in your care and that its use complies with all relevant legislation and codes of practice.\n\n"
              "4. No Liability\n"
              "BWRAC provides the App as a community platform only and does not monitor, verify, or guarantee the accuracy, safety, or legality of any listings, offers, or activities.\n"
              "Participation in activities arranged through the App is entirely voluntary and at your own risk.\n"
              "To the fullest extent permitted by law, BWRAC, its members, officers, and volunteers accept no liability whatsoever for any loss, injury, damage, claim, or expense arising from use of the App or participation in any related activities.\n\n"
              "5. Compliance with Laws\n"
              "All users must comply with:\n"
              "• Victorian laws and regulations, including but not limited to those relating to flora and fauna, environmental protection, land access, and occupational health and safety.\n"
              "• Any relevant permits or authorisations that may apply to the collection or use of flora.\n\n"
              "6. Indemnity\n"
              "By using the App, you agree to indemnify and hold harmless BWRAC, its members, officers, and volunteers from any claims, liabilities, losses, damages, or costs (including legal costs) arising out of or connected with:\n"
              "• Your use of the App,\n"
              "• Any activities you undertake as a result of the App, or\n"
              "• Your breach of this Agreement or any law.\n\n"
              "7. Privacy\n"
              "BWRAC respects your privacy. Any personal information provided will be managed in accordance with the Privacy and Data Protection Act 2014 (Vic). "
              "Information will only be used for the purposes of facilitating the App’s functions unless required by law.\n\n"
              "8. Termination of Access\n"
              "BWRAC may suspend or terminate access to the App for any user who breaches this Agreement or engages in unsafe, unlawful, or inappropriate behaviour.\n\n"
              "9. Amendments\n"
              "BWRAC may update or amend this Agreement from time to time. Continued use of the App following changes constitutes acceptance of the revised terms.\n\n"
              "10. Governing Law\n"
              "This Agreement is governed by the laws of Victoria, Australia. Any disputes arising under this Agreement will be subject to the jurisdiction of Victorian courts.\n\n"
              "Acknowledgement\n"
              "By registering for or using this App, you confirm that you:\n"
              "• Have read and understood this Agreement,\n"
              "• Accept full responsibility for your own actions, and\n"
              "• Release BWRAC from any and all liability in relation to your use of the App and participation in related activities.\n",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saving ? null : _agreeAndContinue,
                child: Text(_saving ? 'Saving…' : 'I Agree'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}