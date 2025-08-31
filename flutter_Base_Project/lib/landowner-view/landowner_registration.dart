import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

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


  final _formKey = GlobalKey<FormBuilderState>();

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

    return SingleChildScrollView(
      // backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
      //   backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      //   ),
      child: FormBuilder(
        key: _formKey,
        child: Column( 
        children: [FormBuilderCheckboxGroup<String>(
            name: 'browse',
            decoration: const InputDecoration(
                  labelText: 'What browse do you have on your property?',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: ['Banksia','Callistemon', 'Camellia', 'Correa', 'Eucalytpus', 'Grevillea', 'Lilly Pilly']
              .map((browse) => FormBuilderFieldOption(
                    value: browse,
                    child: Text(browse),
                  ))
              .toList(growable: false),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
          FormBuilderTextField(
              name: 'address',
              decoration: const InputDecoration(
                labelText: 'Address',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
          ),
          FormBuilderTextField(
            name: 'access',
            decoration: const InputDecoration(
              labelText: 'Please detail how to access your property (optional)',
              contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            ),
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
          FormBuilderTextField(
              name: 'phone',
              decoration: const InputDecoration(
                labelText: 'Phone number',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
          ),
          FormBuilderCheckboxGroup<String>(
            name: 'daysPreferred',
            decoration: const InputDecoration(
                  labelText: 'What days is your property open to browsing?',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: ['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
              .map((day) => FormBuilderFieldOption(
                    value: day,
                    child: Text(day),
                  ))
              .toList(growable: false),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
          FormBuilderCheckboxGroup<String>(
            name: 'timesPreferred',
            decoration: const InputDecoration(
                  labelText: 'What time of day are you open to browsing?',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: ['Morning (8am - 11am)','Noon (11am - 1pm)', 'Afternoon (1pm - 5pm)', 'Evening (5pm - 8pm)']
              .map((time) => FormBuilderFieldOption(
                    value: time,
                    child: Text(time),
                  ))
              .toList(growable: false),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
           FormBuilderFieldDecoration<bool>(
              name: 'advanceWarning',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.equal(true),
              ]),
              decoration: const InputDecoration(labelText: 'Do you require advance warning from Gatherers on entering your land?'),
              builder: (FormFieldState<bool?> field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    errorText: field.errorText,
                  ),
                  child: SwitchListTile(
                    title: const Text(
                        'I require advance warning from Gatherers before coming onto my property'),
                    onChanged: field.didChange,
                    value: field.value ?? false,
                  ),
                );
              },
            ),
            FormBuilderTextField(
            name: 'access',
            decoration: const InputDecoration(
              labelText: 'Please add extra details here (optional)',
              contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            ),
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
          ]
        )
      )
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