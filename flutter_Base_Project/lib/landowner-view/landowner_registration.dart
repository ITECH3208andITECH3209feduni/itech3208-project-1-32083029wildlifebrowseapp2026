// TODO Get timestamp on submission, set state active and attach user's Cognito userID
// TODO Convert final formData to JSON object
// TODO add back button to top of registration to allow cancelling halfway through

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
  }

  void _goToPreviousTab() {
    _tabController.animateTo(_currentTab - 1);
  }

  void _submitForm() {
    final user = widget.user;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formData = _formKey.currentState!.value;
      debugPrint(formData.toString());

      // TODO Add code to process form details
      
      // Redirects user back to landowner overview page
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed(
        '/landowner',
        arguments: {'user': user},
        );
    }
  }
}

class LandDetailsTab extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  LandDetailsTab({required this.formKey, required this.phoneFieldKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
        child: Column(  
        children: [
          FormBuilderCheckboxGroup<String>(
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
            name: 'access',
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
              key: phoneFieldKey,
              name: 'phone',
              decoration: const InputDecoration(
                labelText: 'Phone number',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.phoneNumber(),
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

class AvailabilityTab extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  AvailabilityTab({required this.formKey, required this.phoneFieldKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
        child: Column(  
        children: [
          FormBuilderCheckboxGroup<String>(
            name: 'daysPreferred',
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
            name: 'timesPreferred',
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

class PreferencesTab extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  PreferencesTab({required this.formKey, required this.phoneFieldKey});

  @override
Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
        child: Column( 
          children: [
            SizedBox(height: 16,),
            FormBuilderRadioGroup<String>(
              name: 'advanceWarning',
              initialValue: 'Yes',
              decoration: const InputDecoration(
                    labelText: 'Do you require advance warning from Gatherers on entering your land?',
                    contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  ),
              validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()]),
              options: ['Yes', 'No']
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