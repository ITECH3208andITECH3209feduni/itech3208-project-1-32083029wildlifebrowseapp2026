import 'package:url_launcher/url_launcher.dart';

class Donate {
  
  static const String paypalUrl = "https://www.paypal.com/pools/c/9ita2sgkh9";

  static Future<void> openPayPal() async {
    final uri = Uri.parse(paypalUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch PayPal");
    }
  }
}