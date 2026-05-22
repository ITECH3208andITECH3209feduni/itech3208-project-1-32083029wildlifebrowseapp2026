import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../models/image.dart';

bool showSignUp = false;
String? enteredEmail;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User registration',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset('assets/images/browse_logo.png', height: 40),
                const SizedBox(width: 10),
                const Text('Browse App'),
              ],
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Sign-In'),
                Tab(text: 'Sign-Up'),
                Tab(text: 'Confirm Sign-Up'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              SignInView(),
              SignUpView(),
              ConfirmSignUpView(),
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
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String roleTmp = 'Gatherer';

  File? galleryFile;
  final ImagePicker picker = ImagePicker();

  final _emailController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();

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

    final y = _birthYearCtrl.text.trim();
    final m = _birthMonthCtrl.text.trim().padLeft(2, '0');
    final d = _birthDayCtrl.text.trim().padLeft(2, '0');

    final yearOk = RegExp(r'^\d{4}$').hasMatch(y) &&
        int.parse(y) >= 1900 &&
        int.parse(y) <= DateTime.now().year;

    final monthOk = RegExp(r'^(0?[1-9]|1[0-2])$').hasMatch(m);
    final dayOk = RegExp(r'^(0?[1-9]|[12][0-9]|3[01])$').hasMatch(d);

    if (!(yearOk && monthOk && dayOk)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid birth date.'),
        ),
      );
      return;
    }

    _birthdateController.text = '$y-$m-$d';

    final role = roleTmp;
    final email = _emailController.text.trim();
    final postcode = _postcodeController.text.trim();
    final address = _addressController.text.trim();
    final birthdate = _birthdateController.text.trim();
    final picture = prefs.getString('profilePic') ?? defaultPicture;
    final givenName = _givenNameController.text.trim();
    final familyName = _familyNameController.text.trim();
    final password = _passwordController.text;

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
    
    //final hasGName = givenName.length >= 30;

    //postcode Victorian only
    final int? parsedPostcode = int.tryParse(postcode);

    if(parsedPostcode == null){
      debugPrint('postcode is null');
      return;
    }
    
    if (parsedPostcode < 3000 || parsedPostcode > 3996){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'To use this app you must list a Victorian postcode (3000-3996).',
          ),
        ),
      );
      debugPrint('postcode out of range(3000-3996)');
      return;
    }
    
    try {
      await _cognitoManager.signUp(
        role,
        email,
        postcode,
        address,
        birthdate,
        picture,
        givenName,
        familyName,
        password,
      );

      enteredEmail = email;
      showSignUp = true;
      DefaultTabController.of(context).animateTo(1);
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

    const List<String> roles = <String>[
      'Gatherer',
      'Caretaker',
      'Landholder',
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          DropdownButtonFormField<String>(
            value: roleTmp,
            icon: const Icon(Icons.arrow_downward),
            elevation: 10,
            decoration: const InputDecoration(
              labelText: 'What role are you signing up for?',
            ),
            items: roles.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value == null) return;
              setState(() {
                roleTmp = value;
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
          const Text(
            'Date of Birth',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _birthYearField("Year", _birthYearCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _birthMonthField("Month", _birthMonthCtrl)),
              const SizedBox(width: 8),
              Expanded(child: _birthDayField("Day", _birthDayCtrl)),
            ],
          ),
          const SizedBox(height: 16),
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
          ImagePickerWidget(
            onImageSelected: onImageSelected,
          ),
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
            onPressed: _signUp,
            child: const Text(
              'Submit details',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _birthYearField(String label, TextEditingController c) {
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

  Widget _birthMonthField(String label, TextEditingController c) {
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

  Widget _birthDayField(String label, TextEditingController c) {
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
  State<ConfirmSignUpView> createState() => _ConfirmSignUpViewState();
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
            content: Text(
              'Sign-up successful! Please check your email for the confirmation code.',
            ),
          ),
        );
      });
      showSignUp = false;
    }
  }

  Future<void> _initCognitoManager() async {
    await _cognitoManager.init();
  }

  void _confirmSignUp() async {
    final email = _emailController.text.trim();
    final confirmationCode = _confirmationCodeController.text.trim();

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
    if (enteredEmail != null && _emailController.text.isEmpty) {
      _emailController.text = enteredEmail!;
    }

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
            Text(
              'A confirmation code has been sent to ${enteredEmail ?? 'your email'}',
            ),
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
              onPressed: _confirmSignUp,
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
  State<SignInView> createState() => _SignInViewState();
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
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString('password', password);

      final user = await _cognitoManager.signIn(email, password);

      final roleRaw = user.claims['custom:role']?.toString().trim();

      final role = roleRaw
          ?.replaceAll('[', '')
          .replaceAll(']', '')
          .trim()
          .toLowerCase();

      debugPrint("ROLE RAW IS: $roleRaw");
      debugPrint("ROLE CLEAN IS: $role");

      String defaultView;

      if (role == 'gatherer') {
        defaultView = '/request-board';
      } else if (role == 'landholder') {
        defaultView = '/landholder-tutorial';
      } else if (role == 'caretaker') {
        defaultView = '/caretaker';
      } else {
        defaultView = '/request-board';
      }

      debugPrint("GOING TO: $defaultView");

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
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                final tabController = DefaultTabController.of(context);
                if (tabController != null) {
                  tabController.animateTo(1);
                } else {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

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
            ...user.claims.entries.map(
              (entry) => Text('${entry.key}: ${entry.value}'),
            ),
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