// TODO Get timestamp on submission, set state active and attach user's Cognito userID
// TODO Convert final formData to JSON object
// TODO add back button to top of registration to allow cancelling halfway through

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      home: LandownerFormTabs(user: user),
    );
  }
}

class LandownerFormTabs extends StatefulWidget {
  const LandownerFormTabs({super.key, required this.user,});

  final User user;

  @override
  _LandownerFormTabs createState() => _LandownerFormTabs();
}



class _LandownerFormTabs extends State<LandownerFormTabs> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _phoneFieldKey = GlobalKey<FormBuilderFieldState>();

  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed(
              '/landowner', 
              arguments: {'user': widget.user},
              );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Land details'),
            Tab(text: 'Availability'),
            Tab(text: 'Preferences'),
          ],
        )
      ),
      body: FormBuilder(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            LandDetailsTab(formKey: _formKey, phoneFieldKey: _phoneFieldKey),
            AvailabilityTab(formKey: _formKey, phoneFieldKey: _phoneFieldKey),
            PreferencesTab(formKey: _formKey, phoneFieldKey: _phoneFieldKey),
          ],
        ),
      ),
      floatingActionButton: _buildNavigationButtons(),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_currentTab > 0)
          ElevatedButton(
            onPressed: _goToPreviousTab,
            child: Text('Back'),
          ),
        SizedBox(width: 10),
        if (_currentTab < 2)
          ElevatedButton(
            onPressed: _goToNextTab,
            child: Text('Next'),
          ),
        if (_currentTab == 2)
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit'),
          ),
      ],
    );
  }

  void _goToNextTab() {
    if (_formKey.currentState!.validate()) {
      // Check if phone already exist if on tab 0
      // if (true) {
      // _phoneFieldKey.currentState?.invalidate('Phone number already exists.');
      // }
      _tabController.animateTo(_currentTab + 1);
    }
    // Checking if the current tab is avalabiliy tab, validate both it, and the previous tab
    else if (_currentTab == 1){
      //First check if avaliability tab is valid
      if (!_formKey.currentState!.fields['daysData']!.validate() ||
          !_formKey.currentState!.fields['timesData']!.validate()) {;
      }
      // Check if Land Details tab is valid and go back if not 
      
      // The reason for this is becuase of a issue that *could* happen, where if the user fills out the avaliability tab corretly
      // but the land details tab is invalid, the user would be stuck on the avaliability tab with no error shown
      // Now when a user tries to go to the third tab in that scenario, they are instead redirected to the tab with the mistakes. 
      else if (
      
          !_formKey.currentState!.fields['browseData']!.validate() ||
          !_formKey.currentState!.fields['address']!.validate() ||
          !_formKey.currentState!.fields['postcode']!.validate() ||
          !_formKey.currentState!.fields['phone']!.validate()) {
        _tabController.animateTo(_currentTab - 1);
      }
    }
  }

  void _goToPreviousTab() {
    _tabController.animateTo(_currentTab - 1);
  }

  void _submitForm() async {
    final user = widget.user;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formData = _formKey.currentState!.value;

      final finalPayload = {
        ...formData,
        'userID': '${user.claims['username']}',
        'landownerName': '${widget.user.claims['given_name']} ${widget.user.claims['family_name']}',
        'isActive': 'True',
        'timestamp': DateTime.now().toIso8601String(),
      };

      try {
        // Send HTTP POST request
        debugPrint(jsonEncode(finalPayload));
        final response = await http.post(
          Uri.parse('https://uuy1e4eofl.execute-api.us-east-1.amazonaws.com/landownerAPI'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(finalPayload),
        );

        // Checks if request was successful (status code 201)
        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          print(
            'Registration created for userID: ${responseData['userID']}',
          );
        } else {
          print('Server error: ${response.statusCode}');
          print(response.body);
        }
      } catch (error) {
        print('Failed to send registration data: $error');
      }
      
      // Redirects user back to landowner overview page
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed(
        '/landowner',
        arguments: {'user': user},
        );
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Inputs Missing/Invalid'),
            content: Text('Please check all fields are filled out correctly.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      _tabController.animateTo(_currentTab - 2);

    }
  }
}

class LandDetailsTab extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  // Need to remember why phone field needs its own key
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  const LandDetailsTab({required this.formKey, required this.phoneFieldKey, super.key});

  @override
  _LandDetailsTabState createState() => _LandDetailsTabState();

}
class _LandDetailsTabState extends State<LandDetailsTab> with AutomaticKeepAliveClientMixin {
   // To keep this tab's state when switching tabs (used for cross tab validation)
   // Otherwise the state of the field would reset when switching tabs thus the validation would always fail.
  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return Padding(
      padding: EdgeInsets.all(16.0),
        child: Column(  
        children: [
          FormBuilderCheckboxGroup<String>(
            name: 'browseData',
            decoration: const InputDecoration(
                  labelText: 'What browse do you have on your property?',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: ['Banksia','Callistemon', 'Camellia', 'Correa', 'Manna Gum', 'Blue Gum', 'Grevillea', 'Lilly Pilly']
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
          SizedBox(height:16),
          FormBuilderTextField(
              name: 'address',
              decoration: const InputDecoration(
                labelText: 'Address',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.street(),
                  ]),
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
          ),
          SizedBox(height:16),
          FormBuilderTextField(
              name: 'postcode',
              decoration: const InputDecoration(
                labelText: 'Postcode',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.integer(),
                    FormBuilderValidators.equalLength(4),
                    FormBuilderValidators.positiveNumber()

                  ]),
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
          ),
          SizedBox(height:16),
          FormBuilderTextField(
            name: 'accessDetails',
            decoration: const InputDecoration(
              labelText: 'Please detail how to access your property (optional)',
              contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            ),
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
          SizedBox(height:16),
          FormBuilderTextField(
              key: widget.phoneFieldKey,
              name: 'phone',
              decoration: const InputDecoration(
                labelText: 'Phone number',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.phoneNumber(),
                    FormBuilderValidators.equalLength(10)
                  ]),
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
          ),
        ],
      ),
    );
  }
}



class AvailabilityTab extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  AvailabilityTab({required this.formKey, required this.phoneFieldKey});
  @override
  _AvalabilityTabState createState() => _AvalabilityTabState();
}
class  _AvalabilityTabState extends State <AvailabilityTab> with AutomaticKeepAliveClientMixin {
// To keep this tab's state when switching tabs (used for cross tab validation)
// Otherwise the state of the field would reset when switching tabs thus the validation would always fail.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
        child: Column(  
        children: [
          FormBuilderCheckboxGroup<String>(
            name: 'daysData',
            decoration: const InputDecoration(
                  labelText: 'What days is your property open to browsing?',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: ['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
              .map((value) => FormBuilderFieldOption(
                    value: value,
                    child: Text(value),
                  ))
              .toList(growable: false),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
          SizedBox(height:16),
          FormBuilderCheckboxGroup<String>(
            name: 'timesData',
            decoration: const InputDecoration(
                  labelText: 'What time of day are you open to browsing?',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                ),
            validator: FormBuilderValidators.compose(
                [FormBuilderValidators.required()]),
            options: ['Morning (8am - 11am)','Noon (11am - 1pm)', 'Afternoon (1pm - 5pm)', 'Evening (5pm - 8pm)']
              .map((value) => FormBuilderFieldOption(
                    value: value,
                    child: Text(value),
                  ))
              .toList(growable: false),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
            onChanged: (val) {
                print(val); // Print the text value write into TextField
            },
          ),
        ],
      ),
    );
  }
}

class PreferencesTab extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  PreferencesTab({required this.formKey, required this.phoneFieldKey});
  
  @override
  _PreferencesTabState createState() => _PreferencesTabState();
  
  }
class _PreferencesTabState extends State<PreferencesTab> with AutomaticKeepAliveClientMixin {
  @override
  // To keep this tab's state when switching tabs (used for cross tab validation)
  // Otherwise the state of the field would reset when switching tabs thus the validation would always fail.
  bool get wantKeepAlive => true;
  @override
Widget build(BuildContext context) {
  super.build(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
        child: Column( 
          children: [
            SizedBox(height: 16,),
            FormBuilderRadioGroup<bool>(
              name: 'warningRequired',
              initialValue: true,
              decoration: const InputDecoration(
                    labelText: 'Do you require advance warning from Gatherers on entering your land?',
                    contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  ),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
                options: [
                  FormBuilderFieldOption(
                    value: true,
                    child: Text('Yes'),
                  ),
                  FormBuilderFieldOption(
                    value: false, 
                    child: Text('No'),
                  ),
                ],
              controlAffinity: ControlAffinity.leading,
              orientation: OptionsOrientation.wrap,
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
            ),
            SizedBox(height:16),
            FormBuilderTextField(
              name: 'extraDetails',
              decoration: const InputDecoration(
                labelText: 'Please add extra details here (optional)',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              onChanged: (val) {
                  print(val); // Print the text value write into TextField
              },
            ),
        ],
      ),
    );
  }
}