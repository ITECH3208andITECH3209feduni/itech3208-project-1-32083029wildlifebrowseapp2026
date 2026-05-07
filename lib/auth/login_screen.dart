import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/image.dart';

// Used to track if the user has just uploaded a new potentail account
// If so signal to the next page to show the success snackbar
bool showSignUp = false;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User registration',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
          appBar: AppBar(
            title: Row(children: [
              Image.asset('assets/images/browse_logo.png', height: 40),
              const SizedBox(width: 10),
              const Text('Browse App'),
            ]),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Sign-Up'),
                Tab(text: 'Confirm Sign-Up'),
                Tab(text: 'Sign-In'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              SignUpView(),
              ConfirmSignUpView(),
              SignInView(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

// Global scope var should limit it
String? enteredEmail;

class _SignUpViewState extends State<SignUpView> {
  String roleTmp = '';

  File? galleryFile;
  final ImagePicker picker = ImagePicker();
  final _emailController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _addressController = TextEditingController();

  // I added: keep the original hidden controller for the final YYYY-MM-DD we send
  final _birthdateController = TextEditingController();

  // I added: three separate controllers for Year / Month / Day
  final _birthYearCtrl = TextEditingController();
  final _birthMonthCtrl = TextEditingController();
  final _birthDayCtrl = TextEditingController();

  final _givenNameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final S3ImageManager _s3Manager = S3ImageManager(
    region: 'us-east-1',
    bucketName: 'profile-pictures33',
  );

  // Default profile picture
  final defaultPicture = 'assets/images/default_profile_pic.jpg';

  late final CognitoManager _cognitoManager;

  @override
  void initState() {
    super.initState();
    _cognitoManager = CognitoManager();
    _redirectIfFirstTime();
  }

  Future<void> _redirectIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasAgreed = prefs.getBool('user_agreed') ?? false;
    if (!hasAgreed && mounted) {
      Navigator.of(context).pushReplacementNamed('/agreement');
    } else {
      _initCognitoManager();
    }
  }

  Future<void> _initCognitoManager() async {
    await _cognitoManager.init();
  }

  void _signUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // I added: basic validation and compose YYYY-MM-DD from the 3 fields
    final y = _birthYearCtrl.text.trim();
    final m = _birthMonthCtrl.text.trim().padLeft(2, '0');
    final d = _birthDayCtrl.text.trim().padLeft(2, '0');

    // quick checks (kept simple on purpose)
    final yearOk = RegExp(r'^\d{4}$').hasMatch(y) && int.parse(y) >= 1900 && int.parse(y) <= DateTime.now().year;
    final monthOk = RegExp(r'^(0?[1-9]|1[0-2])$').hasMatch(m);
    final dayOk = RegExp(r'^(0?[1-9]|[12][0-9]|3[01])$').hasMatch(d);

    if (!(yearOk && monthOk && dayOk)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid birth date (Year, Month, Day).')),
      );
      return;
    }

    // set the hidden single string that backend expects
    _birthdateController.text = '$y-$m-$d';
    // I added (end)

    final role = roleTmp;
    final email = _emailController.text;
    final postcode = _postcodeController.text;
    final address = _addressController.text;
    final birthdate = _birthdateController.text; // this is now YYYY-MM-DD
    final picture = prefs.getString('profilePic') ?? defaultPicture;
    final givenName = _givenNameController.text;
    final familyName = _familyNameController.text;
    final password = _passwordController.text;

    // I ADDED: simple password-strength validation (same rules as I used before)
    final hasLen = password.length >= 8;
    final hasNum = RegExp(r'[0-9]').hasMatch(password);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    if (!(hasLen && hasNum && hasUpper && hasSpecial)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must be at least 8 characters and include a number, an uppercase letter, and a special character.',
          ),
        ),
      );
      return;
    }
    // <<< ADDED

    try {
      await _cognitoManager.signUp(
        role, email, postcode, address, birthdate, picture, givenName, familyName, password,
      );
      DefaultTabController.of(context).animateTo(1);
      showSignUp = true;
      _s3Manager.putS3Image(picture);
    } on CognitoServiceException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    File? profileImage;

    void onImageSelected(File? image) {
      setState(() {
        profileImage = image;
      });
    }

    const List<String> roles = <String>['Gatherer', 'Caretaker', 'Landowner'];
    roleTmp = roles.first;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          DropdownButtonFormField(
            initialValue: roleTmp,
            icon: const Icon(Icons.arrow_downward),
            elevation: 10,
            decoration: const InputDecoration(labelText: 'What role are you signing up for?'),
            items: roles.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                roleTmp = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          emailInputField("Email", _emailController),
          const SizedBox(height: 16),
          nameInputField("First name", _givenNameController),
          const SizedBox(height: 16),
          nameInputField("Surname", _familyNameController),
          const SizedBox(height: 16),
          postcodeInputField("Postcode", _postcodeController),
          const SizedBox(height: 16),
          addressInputField("Address", _addressController),
          const SizedBox(height: 16),

          // I added this: label for DOB fields to clearly identify them
          const Text(
            'Date of Birth',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              ),
              ),
              SizedBox(height: 8),

          // I added: three DOB fields (Year / Month / Day)
          Row(
            children: [
              Expanded(
                child: _birthYearField("Year", _birthYearCtrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _birthMonthField("Month", _birthMonthCtrl),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _birthDayField("Day", _birthDayCtrl),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // I ADDED: helper text to identify pw requirements + small spacing (same as previous task)
          const Text(
            'Password must be at least 8 characters and include a number, '
            'an uppercase letter, and a special character.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),

          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 16),

          // Image picker
          ImagePickerWidget(
            onImageSelected: onImageSelected,
          ),
          // Image display
          profileImage != null
              ? SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: Center(child: Image.file(profileImage!)),
                )
              : Container(),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              enteredEmail = _emailController.text;
              _signUp();
            },
            child: const Text(
              'Submit details',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------
  // I added: the 3 DOB field builders
  // -----------------------

  Widget _digitOnlyField({
    required String label,
    required TextEditingController controller,
    required List<TextInputFormatter> inputFormatters,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, hintText: hint),
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }

  // Year: 4 digits
  Widget _birthYearField(String label, TextEditingController c) {
    // I added this to limit to 4 digits
    return _digitOnlyField(
      label: label,
      controller: c,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      hint: 'YYYY',
    );
  }

  // Month: 1–12 (2 digits max)
  Widget _birthMonthField(String label, TextEditingController c) {
    // I added this to limit to 2 digits
    return _digitOnlyField(
      label: label,
      controller: c,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      hint: 'MM',
    );
  }

  // Day: 1–31 (2 digits max)
  Widget _birthDayField(String label, TextEditingController c) {
    // I added this to limit to 2 digits
    return _digitOnlyField(
      label: label,
      controller: c,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(2),
      ],
      hint: 'DD',
    );
  }
}

class ConfirmSignUpView extends StatefulWidget {
  const ConfirmSignUpView({super.key});

  @override
  _ConfirmSignUpViewState createState() => _ConfirmSignUpViewState();
}

class _ConfirmSignUpViewState extends State<ConfirmSignUpView> {
  final _emailController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  late final CognitoManager _cognitoManager;

  @override
  void initState() {
    super.initState();
    _cognitoManager = CognitoManager();
    _initCognitoManager();

    if (showSignUp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Sign-up successful! Please check your email for the confirmation code.')),
        );
      });
      showSignUp = false;
    }
  }

  Future<void> _initCognitoManager() async {
    await _cognitoManager.init();
  }

  void _signUp() async {
    final email = _emailController.text;
    final confirmationCode = _confirmationCodeController.text;

    try {
      await _cognitoManager.confirmUser(email, confirmationCode);
      DefaultTabController.of(context).animateTo(2);
    } on CognitoServiceException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign-Up Confirmation'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('A confirmation code has been sent to ${enteredEmail ?? 'your email'}'),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _confirmationCodeController,
              decoration: const InputDecoration(labelText: 'Confirmation Code'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Confirm Sign-Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final CognitoManager _cognitoManager;

  @override
  void initState() {
    super.initState();
    _cognitoManager = CognitoManager();
    _initCognitoManager();
  }

  Future<void> _initCognitoManager() async {
    await _cognitoManager.init();
  }

  void _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString('password', password);
      final user = await _cognitoManager.signIn(email, password);
      final String defaultView;
      if (user.claims['custom:role'] == 'Gatherer') {
        defaultView = '/request-board';
      } else if (user.claims['custom:role'] == 'Caretaker') {
        defaultView = '/caretaker';
      } else {
        defaultView = '/landholder-tutorial';
      }
      Navigator.of(context, rootNavigator: true).pushNamed(
        defaultView,
        arguments: {'user': user},
      );
    } on CognitoServiceException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

// For testing
class UserDetailsPage extends StatelessWidget {
  final User user;

  const UserDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(title: Text('User Details: ${user.username}')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text("Token Valid: ${user.sessionValid}"),
            ...user.claims.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
          ],
        ),
      ),
    );
  }
}

TextField inputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelName,
        hintText: hint,
      ),
    );

// Input field that only accepts alphabetical characters - specialised for names
TextField nameInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelName,
        hintText: hint,
      ),
      keyboardType: TextInputType.name,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      ],
    );

// Input field that accepts only letters and digits. No special characters
// TODO Add support for - / \ for units
TextField addressInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelName,
        hintText: hint,
      ),
      keyboardType: TextInputType.streetAddress,
    );

// Doesn't work, need to support whitespace
// inputFormatters: [
// FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\s-]+')),
// ],

TextField postcodeInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelName,
        hintText: hint,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.deny(RegExp('^0+')),
      ],
    );

// Input field for email
// TODO add validation that checks if in email format
TextField emailInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) =>
    TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelName,
        hintText: hint,
      ),
      keyboardType: TextInputType.emailAddress,
    );

// (kept for reference; not used anymore for DoB UI — I kept it because backend still reads from _birthdateController)
TextFormField birthdateInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelName,
        hintText: hint,
      ),
    );