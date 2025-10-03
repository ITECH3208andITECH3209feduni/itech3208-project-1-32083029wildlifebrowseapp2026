import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../templates/drawer.dart';
import '../auth/auth.dart';
import '../auth/config.dart';
import '../auth/user_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:change_case/change_case.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProfileRoute extends StatelessWidget {

  final User user;
  const ProfileRoute({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${user.claims['given_name'].toString().toCapitalCase()}\'s profile',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      // Set username of Gatherer here
      home: Profile(title: '${user.claims['given_name'].toString().toCapitalCase()}\'s profile', user: user),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.title,
    required this.user,
  });

  final String title;
  final User user;

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }


  void showEditDialogOne(String key) {
    // Disables the capitalising when loading values for birthdate, picture and email fields
    TextEditingController firstController = TextEditingController(text:  key != 'birthdate' && key != 'picture' && key != 'email'
      ? widget.user.claims[key].toString().toCapitalCase()
      : widget.user.claims[key].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${key.split('_').join(' ').toCapitalCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: firstController,
              // Label in edit dialog
              decoration: InputDecoration(labelText: key.split('_').join(' ').toCapitalCase()),
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) {
                    // Disables the capitalising for birthdate, picture and email fields when inputting new text
                    return key != 'birthdate' &&  key != 'picture' && key != 'email'
                      ? newValue.copyWith(text: newValue.text.toCapitalCase())
                      : newValue;
                  },
                )
              ],
              autovalidateMode: AutovalidateMode.always,
              validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(),
              getValidatorForKeys(key)
            ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                widget.user.claims[key] = firstController.text.toLowerCase();
              });
              
              if (mounted) {
                Navigator.pop(context);
              }
              
             updateUserAttributes(
              {key: firstController.text.toLowerCase()}
             );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void showEditDialogTwo(String key1, String key2, String editDialog) {
    TextEditingController firstController = TextEditingController(
      text: key1 == 'address' 
    ? widget.user.claims[key1]['formatted'].toString().toCapitalCase()
    : widget.user.claims[key1].toString().toCapitalCase(),
    );

    TextEditingController secondController = TextEditingController(text: widget.user.claims[key2].toString().toCapitalCase());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $editDialog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          TextFormField(
              controller: firstController,
              decoration: InputDecoration(labelText: key1.split('_').join(' ').toCapitalCase()),
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.toCapitalCase());
                  },
                )
              ],
              autovalidateMode: AutovalidateMode.always,
              validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(),
              getValidatorForKeys(key1)
            ]),
            ),
            TextFormField(
              controller: secondController,
              inputFormatters: [
                TextInputFormatter.withFunction(
                  (oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.toCapitalCase());
                  },
                )
              ],
              decoration: InputDecoration(labelText: key2.split('_').join(' ').toCapitalCase()),
              autovalidateMode: AutovalidateMode.always,
              validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(),
              getValidatorForKeys(key2)
            ]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                widget.user.claims[key1] = firstController.text.toLowerCase();
                widget.user.claims[key2] = secondController.text.toLowerCase();
              });
              
              if (mounted) {
                Navigator.pop(context);
              }
              
             updateUserAttributes({
              key1: firstController.text.toLowerCase(),
              key2: secondController.text.toLowerCase(),
             });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  FormFieldValidator<String> getValidatorForKeys(String key) {
    switch(key) {
      case 'birthdate':
        return FormBuilderValidators.datePast();
      case 'email':
        return FormBuilderValidators.email();
      case 'picture':
        return FormBuilderValidators.fileSize(5000000);
      case 'custom:role':
        return FormBuilderValidators.match(RegExp(r"^Gatherer$|^Caretaker$|^Landholder$"));
      case 'given_name':
        return FormBuilderValidators.firstName();
      case 'family_name':
        return FormBuilderValidators.lastName();
      case 'custom:postcode':
        return FormBuilderValidators.range(999, 9999);
      case 'address':
        // Regex will pass following variations: 407/82 Hay St, A314/1 O'Brien Street, (LOT1022) 60 Johnston Rd, 17 Jump St, LOT1022 Johnston Rd, (LOT1022) Johnston Rd
        // Regex uses negative lookaheads in the optional 1st group and 2nd group to not pass if there's a 0 in the format 0/1, A0/1, (LOT0000), LOT0000 or 0
        // More advanced validation will require an API
        return FormBuilderValidators.street(regex: RegExp(r"^(?![A-Za-z]*0|\(?LOT0000)([a-zA-Z0-9\/\(\)]*)\s?(?!0)[1-9]*[0-9]*\s[a-zA-Z']+\s[a-zA-Z]+$"));
      default:
        throw('No validator available');
    }
  }

  @override
  // Profile initial state
  Widget build(BuildContext context) {
    final String appTitle = '${widget.user.claims['given_name'].toString().toCapitalCase()}\'s profile';

    return MaterialApp(
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      title: appTitle,
      // SafeArea ensures that the view isn't obstructed by phone notch/status bar/bezel
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(appTitle),
            actions: [
               // Icon to move to gatherer request board page
              IconButton(
                icon: const Icon(Icons.pageview_outlined),
                tooltip: 'View the request board',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    '/request-board',
                    arguments: {'user': widget.user},
                    );
                },
              ),
               // Icon to move to caretaker order request page
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Make a order request',
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    '/caretaker', 
                    arguments: {'user': widget.user},
                    );
                },
              ),
               // Icon to move to browse info page
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Explore browse',
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    '/education'
                    );
                },
              ),
            ],
          ),
          drawer: UserDrawer(username: widget.user.claims['given_name'].toString().toCapitalCase(), user:widget.user),
          // Profile body
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Name: ${widget.user.claims['given_name'].toString().toCapitalCase()} ${widget.user.claims['family_name'].toString().toCapitalCase()}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogTwo('given_name', 'family_name', 'Name');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Birthdate: ${widget.user.claims['birthdate']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('birthdate');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Image: ${widget.user.claims['picture']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('picture');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Email: ${widget.user.claims['email']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('email');
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Email verified? ${widget.user.claims['email_verified'].toString().toCapitalCase()}'),
              ),
              Row(
                children: [
                  Icon(Icons.place, size: 14),
                  Text(
                    "Your address: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text('${widget.user.claims['address']['formatted'].toString().toCapitalCase()}, ${widget.user.claims['custom:postcode']}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogTwo('address', 'custom:postcode', 'Address');
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Role: ${widget.user.claims['custom:role'].toString().toCapitalCase()}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showEditDialogOne('custom:role');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> updateUserAttributes(Map<String, String> attributes) async {
  final config = await loadConfig();
  final authService = UserPoolAuthService(config.userPoolID, config.clientID);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? password = prefs.getString('password');

  final success = await authService.updateUserAttributes(
    attributes, password!
  );

  if (success) {
    print("Attributes updated successfully");
  } else {
    print("Attributes weren't updated");
  }
}