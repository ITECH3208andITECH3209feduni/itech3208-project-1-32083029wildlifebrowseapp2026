import 'package:flutter/material.dart';

import '../auth/auth.dart';

class LandownerRegistration extends StatelessWidget {
  final User user;
  const LandownerRegistration({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landowner registration',
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
            title: Row(
              children: [
                Image.asset(
                  'assets/images/browse_logo.png',
                  height: 40),
                SizedBox(width: 10,),
                Text('Register your land for browse collection'),
              ]
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Land details'),
                Tab(text: 'Gatherer preferences'),
                Tab(text: 'Advance warning request'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LandDetails(),
              // GathererPreferences(),
              // AdvanceWarningRequest(),
            ],
          ),
        ),
      ),
    );
  }
}

class LandDetails extends StatefulWidget {
  @override
  _LandDetails createState() => _LandDetails();
}

class _LandDetails extends State<LandDetails> {

  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _browseController = TextEditingController();
  final _preferredDaysController = TextEditingController();
  final _preferredTimeController = TextEditingController();
  final _advanceWarningController = TextEditingController();
  // late final CognitoManager _cognitoManager;

  // @override
  // void initState() {
  //   super.initState();
  //   _cognitoManager = CognitoManager();
  //   _initCognitoManager();
  // }

  // Future<void> _initCognitoManager() async {
  //   await _cognitoManager.init();
  // }

  void _landDetails() async {
    final phone = _phoneController.text;
    final address = _addressController.text;
    final browse = _browseController.text;
    final preferredDays = _preferredDaysController.text;
    final preferredTimes = _preferredTimeController.text;
    final advanceWarning = _advanceWarningController.text;

    // try {
    //   await _cognitoManager.signUp(email, address, birthdate, picture, givenName, familyName, password);
    //   DefaultTabController.of(context).animateTo(1);
    // } on CognitoServiceException catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(e.message)),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        ),
      body: ListView (
        padding: const EdgeInsets.all(8.0),
        children: [
          SizedBox(height: 16),
          inputField("What browse do you have on your property?", _browseController),
          SizedBox(height: 16),
          inputField("Address", _addressController),
          SizedBox(height: 16),
          inputField("Phone number", _phoneController),
          SizedBox(height: 16),
          inputField("What days is your property open to browsing?", _preferredDaysController),
          SizedBox(height: 16),
          inputField("What time of day are you open to browsing", _preferredTimeController),
          SizedBox(height: 16),
          inputField("Do you require advance warning from Gatherers on entering your land?", _advanceWarningController),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _landDetails,
            child: const Text('Confirm details'),
          ),
        ],
      ),
    );
  }
}

class ConfirmSignUpView extends StatefulWidget {
  @override
  _ConfirmSignUpViewState createState() => _ConfirmSignUpViewState();
}

class _ConfirmSignUpViewState extends State<ConfirmSignUpView> {
  final _emailController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  // late final CognitoManager _cognitoManager;

  @override
  void initState() {
    super.initState();
    // _cognitoManager = CognitoManager();
    // _initCognitoManager();
  }

  // Future<void> _initCognitoManager() async {
  //   await _cognitoManager.init();
  // }

  void _signUp() async {
    final email = _emailController.text;
    final confirmationCode = _confirmationCodeController.text;

    // try {
    //   await _cognitoManager.confirmUser(email, confirmationCode);
    //   DefaultTabController.of(context).animateTo(2);
    // } on CognitoServiceException catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(e.message)),
    //   );
    // }
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
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _confirmationCodeController,
              decoration: const InputDecoration(labelText: 'Confirmation Code'),
            ),
            SizedBox(height: 16,),
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
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // late final CognitoManager _cognitoManager;

  // @override
  // void initState() {
  //   super.initState();
  //   _cognitoManager = CognitoManager();
  //   _initCognitoManager();
  // }

  // Future<void> _initCognitoManager() async {
  //   await _cognitoManager.init();
  // }

  void _signIn() async {
    // Dummy var value
    final user = 'David';
    Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed(
        '/request-board',
        arguments: {'user': user},
        );
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
            SizedBox(height: 16,),
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



TextField inputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) => TextField(
  controller: controller,
  decoration: InputDecoration(
    labelText: labelName,
    hintText: hint,
  ),
);


// Input field that accepts only letters and digits. No special characters
// TODO Add support for - / \ for units
TextField addressInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) => TextField(
  controller: controller,
  decoration: InputDecoration(
    labelText: labelName,
    hintText: hint,
  ),
  keyboardType: TextInputType.streetAddress,
// Doesn't work, need to support whitespace
//   inputFormatters: [
//   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\s-]+')),
// ],
);