import 'package:flutter/material.dart';
import 'auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Browse App'),
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

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
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
    final email = _emailController.text;
    final address = _addressController.text;
    final birthdate = _birthdateController.text;
    final picture = _pictureController.text;
    final givenName = _givenNameController.text;
    final familyName = _familyNameController.text;
    final password = _passwordController.text;

    try {
      await _cognitoManager.signUp(email, address, birthdate, picture, givenName, familyName, password);
      DefaultTabController.of(context).animateTo(1);
    } on CognitoServiceException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _givenNameController,
              decoration: const InputDecoration(labelText: 'First name'),
            ),
            TextField(
              controller: _familyNameController,
              decoration: const InputDecoration(labelText: 'Surname'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _birthdateController,
              decoration: const InputDecoration(labelText: 'Birthdate'),
            ),
            TextField(
              controller: _pictureController,
              decoration: const InputDecoration(labelText: 'Profile picture'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),
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
      appBar: AppBar(title: const Text('Sign-Up Confirmation')),
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

    try {
      final user = await _cognitoManager.signIn(email, password);
      Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed(
          '/request-board',
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
      appBar: AppBar(title: const Text('Sign In')),
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