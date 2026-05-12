import '../config/api_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../auth/auth.dart';

class LandownerRegistration extends StatelessWidget {
  final User user;
  final Map? existingListing;

  const LandownerRegistration({
    super.key,
    required this.user,
    this.existingListing,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
      ),
      child: LandownerFormTabs(
        user: user,
        existingListing: existingListing,
      ),
    );
  }
}

class LandownerFormTabs extends StatefulWidget {
  const LandownerFormTabs({
    super.key,
    required this.user,
    this.existingListing,
  });

  final User user;
  final Map? existingListing;

  @override
  State<LandownerFormTabs> createState() => _LandownerFormTabs();
}

class _LandownerFormTabs extends State<LandownerFormTabs>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _phoneFieldKey = GlobalKey<FormBuilderFieldState>();

  late TabController _tabController;
  int _currentTab = 0;

  bool get isEditMode => widget.existingListing != null;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  String getUserRole() {
    return widget.user.claims['custom:role']
            ?.toString()
            .replaceAll('[', '')
            .replaceAll(']', '')
            .trim()
            .toLowerCase() ??
        '';
  }

  String getUserEmailOrUsername() {
    return widget.user.claims['email']?.toString() ??
        widget.user.claims['username']?.toString() ??
        '';
  }

  String getExistingString(String key) {
    final value = widget.existingListing?[key];
    if (value == null) return '';
    return value.toString();
  }

  List<String> getExistingList(String key) {
    final value = widget.existingListing?[key];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return <String>[];
  }

  void _goToLandholderOverview({required bool uploadSuccess}) {
    Navigator.of(context).pushReplacementNamed(
      '/landowner',
      arguments: {
        'user': widget.user,
        'browseFilter': <String>[],
        'uploadSuccess': uploadSuccess,
      },
    );
  }

  Widget _tutorialBox() {
    return Card(
      color: const Color.fromRGBO(232, 246, 238, 1),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? 'Edit your listing' : 'How to list your property',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Select the browse plants available on your property.'),
            const Text('2. Add your address, postcode, and phone number.'),
            const Text('3. Choose the days and times gatherers can visit.'),
            const Text('4. Add access instructions, warnings, or restrictions.'),
            const Text('5. Submit the listing so gatherers can view it.'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_currentTab > 0)
          ElevatedButton(
            onPressed: () {
              _tabController.animateTo(_currentTab - 1);
            },
            child: const Text('Back'),
          ),
        const SizedBox(width: 10),
        if (_currentTab < 2)
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.saveAndValidate()) {
                _tabController.animateTo(_currentTab + 1);
              } else {
                _showInvalidDialog();
              }
            },
            child: const Text('Next'),
          ),
        if (_currentTab == 2)
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(isEditMode ? 'Update Listing' : 'Submit'),
          ),
      ],
    );
  }

  void _showInvalidDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inputs Missing/Invalid'),
          content: const Text(
            'Please check all fields are filled out correctly.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    final user = widget.user;
    final role = getUserRole();
    final userId = getUserEmailOrUsername();

    final String? existingCreatedBy =
        widget.existingListing?['createdBy']?.toString();

    final bool canCreate = role == 'landholder' || role == 'caretaker';

    final bool canEdit =
        role == 'landholder' && existingCreatedBy == userId;

    if (!isEditMode && !canCreate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You do not have permission to create a listing.'),
        ),
      );
      return;
    }

    if (isEditMode && !canEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only edit listings you created.'),
        ),
      );
      return;
    }

    if (_formKey.currentState!.saveAndValidate()) {
      final formData = _formKey.currentState!.value;

      final fullName =
          '${widget.user.claims['given_name']} ${widget.user.claims['family_name']}';

      final finalPayload = <String, dynamic>{
  ...formData,
  'userID': user.claims['username'].toString(),
  'createdBy': isEditMode ? existingCreatedBy : userId,
  'createdByRole': isEditMode
      ? (widget.existingListing?['createdByRole']?.toString() ?? role)
      : role,
  'landownerName': fullName,
  'landholderName': fullName,
  'isActive': 'True',
  'timestamp': isEditMode
      ? (widget.existingListing?['timestamp']?.toString() ??
          DateTime.now().toIso8601String())
      : DateTime.now().toIso8601String(),
  'updatedAt': DateTime.now().toIso8601String(),
};

      try {
        debugPrint(jsonEncode(finalPayload));

        late http.Response response;

        if (isEditMode) {
          final id = widget.existingListing?['_id'];

          response = await http.put(
            Uri.parse('${ApiConfig.baseUrl}/landholders/$id'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(finalPayload),
          );
        } else {
          response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}/landholders'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(finalPayload),
          );
        }

        if (response.statusCode == 201 ||
            response.statusCode == 200 ||
            response.statusCode == 204) {
          debugPrint('Landholder listing saved successfully');
          debugPrint(response.body);

          _goToLandholderOverview(uploadSuccess: true);
        } else {
          debugPrint('Server error: ${response.statusCode}');
          debugPrint(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Server error: ${response.statusCode}')),
          );
        }
      } catch (error) {
        debugPrint('Failed to save listing: $error');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save listing: $error')),
        );
      }
    } else {
      _showInvalidDialog();
      _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = getUserRole();
    final canAccessForm = role == 'landholder' || role == 'caretaker';

    if (!canAccessForm) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Access denied'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Gatherers cannot create listings. Gatherers can only accept listings and edit accepted listings.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(
        title: Text(
          isEditMode
              ? 'Edit landholder listing'
              : 'List your property for browse gathering',
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            _goToLandholderOverview(uploadSuccess: false);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Land details'),
            Tab(text: 'Availability'),
            Tab(text: 'Preferences'),
          ],
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            _tutorialBox(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  LandDetailsTab(
                    formKey: _formKey,
                    phoneFieldKey: _phoneFieldKey,
                    initialBrowseData: getExistingList('browseData'),
                    initialAddress: getExistingString('address'),
                    initialPostcode: getExistingString('postcode'),
                    initialAccessDetails: getExistingString('accessDetails'),
                    initialPhone: getExistingString('phone'),
                  ),
                  AvailabilityTab(
                    formKey: _formKey,
                    phoneFieldKey: _phoneFieldKey,
                    initialDaysData: getExistingList('daysData'),
                    initialTimesData: getExistingList('timesData'),
                  ),
                  PreferencesTab(
                    formKey: _formKey,
                    phoneFieldKey: _phoneFieldKey,
                    initialWarningRequired:
                        widget.existingListing?['warningRequired'] == false
                            ? false
                            : true,
                    initialRestrictions: getExistingString('restrictions'),
                    initialExtraDetails: getExistingString('extraDetails'),
                    initialPrivatePropertyAcknowledgement:
                        isEditMode ? true : false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildNavigationButtons(),
    );
  }
}

class LandDetailsTab extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  final List<String> initialBrowseData;
  final String initialAddress;
  final String initialPostcode;
  final String initialAccessDetails;
  final String initialPhone;

  const LandDetailsTab({
    required this.formKey,
    required this.phoneFieldKey,
    required this.initialBrowseData,
    required this.initialAddress,
    required this.initialPostcode,
    required this.initialAccessDetails,
    required this.initialPhone,
    super.key,
  });

  @override
  State<LandDetailsTab> createState() => _LandDetailsTabState();
}

class _LandDetailsTabState extends State<LandDetailsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormBuilderCheckboxGroup<String>(
            name: 'browseData',
            initialValue: widget.initialBrowseData,
            decoration: const InputDecoration(
              labelText: 'What browse do you have on your property?',
            ),
            validator: FormBuilderValidators.required(),
            options: [
              'Banksia',
              'Callistemon',
              'Camellia',
              'Correa',
              'Manna Gum',
              'Blue Gum',
              'Grevillea',
              'Lilly Pilly',
            ]
                .map(
                  (browse) => FormBuilderFieldOption(
                    value: browse,
                    child: Text(browse),
                  ),
                )
                .toList(),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'address',
            initialValue: widget.initialAddress,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'postcode',
            initialValue: widget.initialPostcode,
            decoration: const InputDecoration(labelText: 'Postcode'),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.integer(),
              FormBuilderValidators.equalLength(4),
            ]),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'accessDetails',
            initialValue: widget.initialAccessDetails,
            decoration: const InputDecoration(
              labelText: 'How should gatherers access the property? (optional)',
            ),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            key: widget.phoneFieldKey,
            name: 'phone',
            initialValue: widget.initialPhone,
            decoration: const InputDecoration(labelText: 'Phone number'),
            keyboardType: TextInputType.phone,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.equalLength(10),
            ]),
          ),
        ],
      ),
    );
  }
}

class AvailabilityTab extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  final List<String> initialDaysData;
  final List<String> initialTimesData;

  const AvailabilityTab({
    super.key,
    required this.formKey,
    required this.phoneFieldKey,
    required this.initialDaysData,
    required this.initialTimesData,
  });

  @override
  State<AvailabilityTab> createState() => _AvailabilityTabState();
}

class _AvailabilityTabState extends State<AvailabilityTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormBuilderCheckboxGroup<String>(
            name: 'daysData',
            initialValue: widget.initialDaysData,
            decoration: const InputDecoration(
              labelText: 'What days is your property open to browsing?',
            ),
            validator: FormBuilderValidators.required(),
            options: [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday',
            ]
                .map(
                  (value) => FormBuilderFieldOption(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
          ),
          const SizedBox(height: 16),
          FormBuilderCheckboxGroup<String>(
            name: 'timesData',
            initialValue: widget.initialTimesData,
            decoration: const InputDecoration(
              labelText: 'What time of day are you open to browsing?',
            ),
            validator: FormBuilderValidators.required(),
            options: [
              'Morning (8am - 11am)',
              'Noon (11am - 1pm)',
              'Afternoon (1pm - 5pm)',
              'Evening (5pm - 8pm)',
            ]
                .map(
                  (value) => FormBuilderFieldOption(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
          ),
        ],
      ),
    );
  }
}

class PreferencesTab extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final GlobalKey<FormBuilderFieldState> phoneFieldKey;

  final bool initialWarningRequired;
  final String initialRestrictions;
  final String initialExtraDetails;
  final bool initialPrivatePropertyAcknowledgement;

  const PreferencesTab({
    super.key,
    required this.formKey,
    required this.phoneFieldKey,
    required this.initialWarningRequired,
    required this.initialRestrictions,
    required this.initialExtraDetails,
    required this.initialPrivatePropertyAcknowledgement,
  });

  @override
  State<PreferencesTab> createState() => _PreferencesTabState();
}

class _PreferencesTabState extends State<PreferencesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormBuilderRadioGroup<bool>(
            name: 'warningRequired',
            initialValue: widget.initialWarningRequired,
            decoration: const InputDecoration(
              labelText:
                  'Do you require advance warning from gatherers before entry?',
            ),
            validator: FormBuilderValidators.required(),
            options: const [
              FormBuilderFieldOption(value: true, child: Text('Yes')),
              FormBuilderFieldOption(value: false, child: Text('No')),
            ],
            controlAffinity: ControlAffinity.leading,
            orientation: OptionsOrientation.wrap,
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'restrictions',
            initialValue: widget.initialRestrictions,
            decoration: const InputDecoration(
              labelText: 'Restrictions (optional)',
              hintText: 'Example: Please avoid the garden bed near the fence.',
            ),
            maxLines: 4,
            maxLength: 500,
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'extraDetails',
            initialValue: widget.initialExtraDetails,
            decoration: const InputDecoration(
              labelText: 'Extra details (optional)',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          FormBuilderCheckbox(
            name: 'privatePropertyAcknowledgement',
            initialValue: widget.initialPrivatePropertyAcknowledgement,
            title: const Text(
              'I acknowledge that this listing is for private property only and not public or Crown land.',
              style: TextStyle(fontSize: 14),
            ),
            validator: FormBuilderValidators.equal(
              true,
              errorText: 'You must accept this disclaimer to proceed.',
            ),
          ),
        ],
      ),
    );
  }
}