import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// Used to track if the user has just uploaded a new potentail account
// If so signal to the next page to show the success snackbar
bool showSignUp = false;


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // This widget is the root of your application.
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
            title: Row(
              children: [
                Image.asset(
                  'assets/images/browse_logo.png',
                  height: 40),
                SizedBox(width: 10,),
                Text('Browse App'),
              ]
            ),
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
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

// Global scope var should limit it
String? enteredEmail;

class _SignUpViewState extends State<SignUpView> {
  String roleTmp = '';

  final _emailController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _addressController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _pictureController = TextEditingController();
  final _givenNameController = TextEditingController();
  final _familyNameController = TextEditingController();
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

  void _signUp() async {
    final role = roleTmp;
    final email = _emailController.text;
    final postcode = _postcodeController.text;
    final address = _addressController.text;
    final birthdate = _birthdateController.text;
    final picture = _pictureController.text;
    final givenName = _givenNameController.text;
    final familyName = _familyNameController.text;
    final password = _passwordController.text;

    // final fullBirthDate = '${birthYear}-${birthMonth}-${birthDay}'

    try {
      await _cognitoManager.signUp(role, email, postcode, address, birthdate, picture, givenName, familyName, password);
      DefaultTabController.of(context).animateTo(1);
      showSignUp = true;
    
    } on CognitoServiceException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<String> roles = <String>['Gatherer', 'Caretaker', 'Landowner'];
    roleTmp = roles.first;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        ),
      body: ListView (
        padding: const EdgeInsets.all(8.0),
        children: [
          DropdownButtonFormField(
            value: roleTmp,
            icon: const Icon(Icons.arrow_downward),
            elevation: 10,
            decoration: const InputDecoration(
              labelText: 'What role are you signing up for?'),
            items:
              roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(), 
            onChanged: (String? value) {
              setState(() {
                roleTmp = value!;
            });}),
          SizedBox(height: 16),
          emailInputField("Email", _emailController),
          SizedBox(height: 16),
          nameInputField("First name", _givenNameController),
          SizedBox(height: 16),
          nameInputField("Surname", _familyNameController),
          SizedBox(height: 16),
          postcodeInputField("Postcode", _postcodeController),
          SizedBox(height: 16),
          addressInputField("Address", _addressController),
          SizedBox(height: 16),
          Row(
            children: [
              // Expanded widget helps to constrain the widge of birthdateInputField to that of Row
              Expanded(
                // Replace with calls to the 3 new birthdate functions
                child: birthdateInputField("Birthdate", _birthdateController),
              ),
          ],),
          SizedBox(height: 16),
          // TODO add image upload support (prob need to add a new package to pubspec)
          inputField("Upload profile picture", _pictureController),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              enteredEmail = _emailController.text;
              _signUp();
            },
            child: Text(
              'Accept',
              style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),
              textAlign: TextAlign.center,
            ),
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
  late final CognitoManager _cognitoManager;

  @override
  void initState() {
    super.initState();
    _cognitoManager = CognitoManager();
    _initCognitoManager();

    // Checks if the transition to this tab was from a successful sign-up
    // If so, shows a snackbar to inform the user
    if(showSignUp) {
      // Build its own thing
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up successful! Please check your email for the confirmation code.')),
        );
      });
      // Resets it so it doesn't keep showing up, only on the first time a user signs up
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
      if(user.claims['custom:role'] == 'Gatherer') {
          defaultView = '/request-board';
      } else if(user.claims['custom:role'] == 'Caretaker') {
          defaultView = '/caretaker'; 
      } else {
          defaultView = '/landowner-registration'; 
      }
      Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(
          defaultView,
          arguments: {'user': user},
          );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => UserDetailsPage(user: user)),
      // );
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
            ...user.claims.entries
                .map((entry) => Text('${entry.key}: ${entry.value}'))
                .toList(),
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


// Input field that only accepts alphabetical characters - specialised for names
TextField nameInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) => TextField(
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


TextField postcodeInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) => TextField(
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
}) => TextField(
  controller: controller,
  decoration: InputDecoration(
    labelText: labelName,
    hintText: hint,
  ),
  keyboardType: TextInputType.emailAddress,
);


// TODO replace with showDatePicker()
// Requires dates to be 10 char long
// So either in this format if day is one digit: 9-Oct-1940 or 09-10-1940
// Or this if day is two digits: 21/08/1920
TextFormField birthdateInputField(
  String labelName,
  TextEditingController controller, {
  String? hint,
}) => TextFormField(
  controller: controller,
  decoration: InputDecoration(
    labelText: labelName,
    hintText: hint,
  ),
);