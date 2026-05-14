import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:change_case/change_case.dart';

import '../templates/drawer.dart';
import '../auth/auth.dart';
import '../config/api_config.dart';

class CaretakerRoute extends StatelessWidget {
  final User user;
  const CaretakerRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Request',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
        useMaterial3: true,
      ),
      home: CaretakerHomePage(title: 'Order Request', user: user),
    );
  }
}

class DeliveryItem {
  final String browseName;
  final String browseAmount;
  final String amountType;
  bool isSelected;

  DeliveryItem({
    required this.browseName,
    required this.browseAmount,
    required this.amountType,
    this.isSelected = false,
  });
}

class CaretakerHomePage extends StatefulWidget {
  const CaretakerHomePage({
  super.key,
  required this.title,
  required this.user,
  this.existingRequest,
});

  final String title;
  final User user;
 final dynamic existingRequest;
  @override
  State<CaretakerHomePage> createState() => _CaretakerHomePageState();
}

class _CaretakerHomePageState extends State<CaretakerHomePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final List<DeliveryItem> _deliveryItems = [];

  String selectedDrawerPage = '';
bool get isEditMode => widget.existingRequest != null;
  bool get isCaretaker {
    final role = widget.user.claims['custom:role']
        .toString()
        .toLowerCase()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .trim();

    return role == 'caretaker';
  }

  GestureTapCallback drawerButton(String page) {
    return () {
      setState(() {
        selectedDrawerPage = page;
      });
      Navigator.pop(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Order';

    final String username =
        widget.user.claims['given_name'].toString().toCapitalCase();

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
        useMaterial3: true,
      ),
      title: appTitle,
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text(appTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.pageview_outlined),
                  tooltip: 'View, edit or delete your order requests',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      '/request-board',
                      arguments: {'user': widget.user},
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Explore browse',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pushNamed('/education');
                  },
                ),
              ],
            ),
            drawer: UserDrawer(username: username, user: widget.user),
            body: isCaretaker
                ? _buildCaretakerOrderForm()
                : _buildAccessDeniedMessage(),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessDeniedMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Access Denied',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Only caretakers can create order requests.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      '/request-board',
                      arguments: {'user': widget.user},
                    );
                  },
                  child: const Text('Go to Request Board'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCaretakerOrderForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FormBuilder(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 16),

            FormBuilderTextField(
              name: 'caretakerName',
              initialValue:
                  "${widget.user.claims['given_name'].toString().toCapitalCase()} ${widget.user.claims['family_name'].toString().toCapitalCase()}",
              decoration: const InputDecoration(
                labelText: 'Full name',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.match(
                  RegExp(
                    r"^[a-zA-Z]+([-' ][a-zA-Z]+)*\s+[a-zA-Z]+([-' ][a-zA-Z]+)*$",
                  ),
                  errorText: 'Please enter your first and last name',
                ),
              ]),
            ),

            const SizedBox(height: 16),

            FormBuilderTextField(
              name: 'address',
              initialValue:
                  widget.user.claims['custom:address'].toString().toCapitalCase(),
              decoration: const InputDecoration(
                labelText: 'Address',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.street(
                  regex: RegExp(
                    r"^(?![A-Za-z]*0|\(?LOT0000)([a-zA-Z0-9\/\(\)]*)\s?(?!0)[1-9]*[0-9]*\s[a-zA-Z']+\s[a-zA-Z]+$",
                  ),
                ),
                FormBuilderValidators.minWordsCount(3),
              ]),
            ),

            const SizedBox(height: 16),

            FormBuilderTextField(
              name: 'postcode',
              initialValue: "${widget.user.claims['custom:postcode']}",
              decoration: const InputDecoration(
                labelText: 'Postcode',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.integer(),
                FormBuilderValidators.equalLength(4),
                FormBuilderValidators.positiveNumber(),
              ]),
            ),

            const SizedBox(height: 16),

            FormBuilderTextField(
              name: 'requestDetails',
              initialValue: isEditMode
    ? widget.existingRequest.requestDetails
    : '',
              decoration: const InputDecoration(
                labelText:
                    'Please add additional requests to your request here (Optional)',
                contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              ),
            ),

            const SizedBox(height: 16),

            FormBuilderDropdown<String>(
              name: 'animal_ID',
              initialValue: isEditMode
    ? widget.existingRequest.animal_ID
    : null,
              enabled: true,
              decoration: const InputDecoration(
                labelText: 'Animal',
                hintText: 'Select Animal',
              ),
              items: [
                'Koala',
                'Ring-tailed Possum',
                'Brush-tailed Possum',
                'Kangaroo',
                'Wombat',
                'Kookaburra',
              ]
                  .map(
                    (animal) => DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.center,
                      value: animal,
                      child: Text(animal),
                    ),
                  )
                  .toList(growable: false),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),

            const SizedBox(height: 16),

            FormBuilderDropdown<String>(
              name: 'browseData',
              initialValue: 'Manna Gum (Eucalyptus viminalis)',
              decoration: const InputDecoration(
                labelText: 'Browse',
                hintText: 'Select Browse',
              ),
              items: [
                'Tasmanian Blue Gum (Eucalyptus globulus)',
                'Manna Gum (Eucalyptus viminalis)',
                'Banksia',
                'Callistemon',
                'Camellia',
                'Correa',
                'Grevillea',
                'Lilly Pilly',
                'Mealworms',
              ]
                  .map(
                    (browse) => DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.center,
                      value: browse,
                      child: Text(browse),
                    ),
                  )
                  .toList(growable: false),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),

            Row(
              children: [
                Flexible(
                  child: FormBuilderTextField(
                    name: 'browseAmount',
                    initialValue: '1',
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter amount of browse needed',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer(),
                      FormBuilderValidators.positiveNumber(),
                      FormBuilderValidators.between(1, 50),
                    ]),
                  ),
                ),
                Flexible(
                  child: FormBuilderDropdown<String>(
                    name: 'amountType',
                    initialValue: 'branch/es',
                    decoration: const InputDecoration(
                      labelText: 'Amount type',
                      hintText: 'Select quantity type',
                    ),
                    items: ['branch/es', 'bucket/s']
                        .map(
                          (amountType) => DropdownMenuItem<String>(
                            alignment: AlignmentDirectional.centerStart,
                            value: amountType,
                            child: Text(amountType),
                          ),
                        )
                        .toList(growable: false),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (_deliveryItems.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: _deliveryItems.map((item) {
                      return ListTile(
                        title: Text(
                          "${item.browseName}: ${item.browseAmount} ${item.amountType}",
                        ),
                        trailing: Checkbox(
                          value: item.isSelected,
                          onChanged: (bool? newValue) {
                            setState(() {
                              item.isSelected = newValue ?? false;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: _addDeliveryItem,
              child: const Text('Add delivery item'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: _deliveryItems.isEmpty
                  ? null
                  : () {
                      setState(() {
                        _deliveryItems.removeWhere((item) => item.isSelected);
                      });
                    },
              child: const Text('Remove selected items'),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _submitForm,
              child: Text(isEditMode ? 'Update order' : 'Submit order'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void showSnack(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

 void _addDeliveryItem() {
  if (!isCaretaker) {
    showSnack('Only caretakers can add delivery items.');
    return;
  }

  _formKey.currentState?.save();

  final formData = _formKey.currentState!.value;

  final animal = formData['animal_ID'];
  final browse = formData['browseData'];
  final amount = formData['browseAmount'];
  final amountType = formData['amountType'];

  if (animal == null ||
      browse == null ||
      amount == null ||
      amountType == null) {
    showSnack(
      'Please select animal, browse, amount and amount type.',
    );
    return;
  }

  setState(() {
    _deliveryItems.add(
      DeliveryItem(
        browseName: browse.toString(),
        browseAmount: amount.toString(),
        amountType: amountType.toString(),
      ),
    );
  });
}
  void _submitForm() async {
    if (!isCaretaker) {
      showSnack('Only caretakers can create orders.');
      return;
    }

    if ((_formKey.currentState?.saveAndValidate() ?? false) &&
        _deliveryItems.isNotEmpty) {
      final formData = _formKey.currentState!.value;

      final List<Map<String, dynamic>> items = _deliveryItems
          .map(
            (item) => {
              'name': item.browseName,
              'quantity': int.parse(item.browseAmount),
              'type': item.amountType,
            },
          )
          .toList();

      final finalPayload = {
        ...formData,
       'request_ID': isEditMode
    ? widget.existingRequest.request_ID
    : "Request_${DateTime.now().millisecondsSinceEpoch}",
        'timestamp': DateTime.now().toIso8601String(),
        'assigned_User_ID': null,
        'requester_ID': widget.user.claims['username'],
        'createdBy': widget.user.claims['username'],
        'createdByRole': 'Caretaker',
        'status_Num': 1,
        'delivery_items': items,
      };

      try {
        debugPrint('Posting to: ${ApiConfig.requestsAPI}');

       final response = isEditMode
    ? await http.patch(
        Uri.parse(
          '${ApiConfig.requestsAPI}/${widget.existingRequest.request_ID}/1',
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(finalPayload),
      )
    : await http.post(
        Uri.parse(ApiConfig.requestsAPI),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(finalPayload),
      );

        if (response.statusCode == 200 || response.statusCode == 201) {
          dynamic responseData;
          try {
            responseData = jsonDecode(response.body);
          } catch (_) {
            responseData = null;
          }

          final requestId =
              responseData?['items']?[0]?['request_ID'] ??
              finalPayload['request_ID'];

          debugPrint('Request $requestId successfully sent');

          _formKey.currentState?.reset();

          setState(() {
            _deliveryItems.clear();
          });

          showSnack('Request order $requestId sent successfully');

          // Stay on this same page after submit.
          // This avoids the blank screen caused by rebuilding /caretaker without valid route args.
        } else {
          debugPrint('Server error: ${response.statusCode}');
          debugPrint(response.body);
          showSnack('Something went wrong. Status code: ${response.statusCode}');
        }
      } catch (error) {
        debugPrint('Failed to send order data: $error');
        showSnack('Something went wrong. Please try again. Error: $error');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Inputs Missing/Invalid'),
            content: const Text(
              'Please check all fields are filled out correctly and add at least one delivery item.',
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
  }
}
