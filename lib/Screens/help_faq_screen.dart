import 'package:flutter/material.dart';

class HelpFAQScreen extends StatefulWidget {
  const HelpFAQScreen({super.key});

  @override
  State<HelpFAQScreen> createState() => _HelpFAQScreenState();
}

class _HelpFAQScreenState extends State<HelpFAQScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _faqTile(String title, String content) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ExpansionTile(
          leading: const Icon(
            Icons.help_outline,
            color: Color.fromRGBO(46, 165, 107, 1),
          ),
          iconColor: const Color.fromRGBO(46, 165, 107, 1),
          collapsedIconColor: Colors.grey,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),

      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 165, 107, 1),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Help & FAQ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Browse Wildlife App Help Guide",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Quick answers for new users.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 25),

              _faqTile(
                "What is Browse?",
                "Browse means fresh leaves and branches collected for wildlife such as possums and koalas.",
              ),

              _faqTile(
                "What does a Gatherer do?",
                "Gatherers accept requests and safely collect browse from approved locations.",
              ),

              _faqTile(
                "What does a Caretaker do?",
                "Caretakers create browse requests for animals in care.",
              ),

              _faqTile(
                "What does a Landholder do?",
                "Landholders register their property and available browse plants.",
              ),

              _faqTile(
                "How do I accept a request?",
                "Gatherers can open the request board and accept available browse requests.",
              ),

              _faqTile(
                "What safety equipment should I use?",
                "Wear gloves, long sleeves, safety glasses, and closed shoes before harvesting.",
              ),

              _faqTile(
                "What should I check before harvesting?",
                "Check for hazards such as power lines, insects, unstable branches, and unsafe ground.",
              ),

              _faqTile(
                "Who can I contact for help?",
                "Contact your organisation administrator or wildlife support coordinator.",
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "Thank you for supporting wildlife care 🐨",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}