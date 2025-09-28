import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../templates/drawer.dart';
import '../auth/auth.dart';

class CaretakerRoute extends StatelessWidget {
  final User user;
  const CaretakerRoute({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Request',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
      ),
      // Set username of caretaker here
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
  CaretakerHomePage({super.key, required this.title, required this.user});
  
  final String title;
  final User user;

  @override
  State<CaretakerHomePage> createState() => _CaretakerHomePageState();
}

class _CaretakerHomePageState extends State<CaretakerHomePage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  // List of delivery items
  // TODO create DeliveryItem on submission so can have impression of a empty list when open page
  final List<DeliveryItem> _deliveryItems = [];

  String selectedDrawerPage = '';

  GestureTapCallback drawerButton(String page) {
    return () {
      setState(() {
        selectedDrawerPage = page;
      });
      Navigator.pop(context);
    };
  }

  bool _isAnimalLock = false;

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Order';
    final String username = widget.user.claims['given_name'];

    return MaterialApp(
      theme: ThemeData(
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
              IconButton(
                icon: const Icon(Icons.edit_location_outlined),
                tooltip: 'List your land',
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
          drawer: UserDrawer(username: username, user: widget.user),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FormBuilder(
              key: _formKey, 
              child: ListView(
              children: [
                SizedBox(height:16),
                FormBuilderTextField(
                  name: 'caretakerName',
                  initialValue: "${widget.user.claims['given_name']} ${widget.user.claims['family_name']}",
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  ),
                  validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.required(),
                        //TODO add a validator for firstname and lastname
                      ]),
                  onChanged: (val) {
                      print(val); // Print the text value write into TextField
                  },
                ),
                SizedBox(height:16),
                FormBuilderTextField(
                    name: 'address',
                    initialValue: "${widget.user.claims['address']['formatted']}",
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
                    initialValue: "${widget.user.claims['postcode']}",
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
                  name: 'requestDetails',
                  decoration: const InputDecoration(
                    labelText: 'Please add additional requests to your request here (Optional)',
                    contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  ),
                  onChanged: (val) {
                      print(val); // Print the text value write into TextField
                  },
                ),
                SizedBox(height:16),
                FormBuilderDropdown<String>(
                  name: 'animal_ID', 
                  initialValue: 'Ring-tailed Possum',
                  decoration: InputDecoration(
                    labelText: 'Animal',
                    hintText: 'Select Animal'
                  ),
                  items: ['Koala','Ring-tailed Possum', 'Brush-tailed Possum', 'Kangaroo', 'Wombat', 'Kookaburra']
                    .map((animal) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: animal,
                          child: Text(animal),
                        ))
                    .toList(growable: false),
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()]
                  ),
                  // Disables changing of animal once a browse item is added to a request
                  onChanged: (selectedAnimal) {
                    _isAnimalLock
                        ? null
                        : (newValue) {
                          setState(() {
                            selectedAnimal = newValue;
                          });
                    };
                    print(selectedAnimal); // Print the text value write into TextField
                  },
                ),
                SizedBox(height:16),
                FormBuilderDropdown<String>(
                  name: 'browseData', 
                  initialValue: 'Manna Gum (Eucalyptus viminalis)',
                  decoration: const InputDecoration(
                    labelText: 'Browse',
                    hintText: 'Select Browse'
                  ),
                  items: ['Tasmanian Blue Gum (Eucalyptus globulus)', 'Manna Gum (Eucalyptus viminalis)', 'Banksia','Callistemon', 'Camellia', 'Correa', 'Grevillea', 'Lilly Pilly', 'Mealworms']
                    .map((browse) => DropdownMenuItem(
                          alignment: AlignmentDirectional.center,
                          value: browse,
                          child: Text(browse),
                        ))
                    .toList(growable: false),
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]
                  ),
                  onChanged: (val) {
                    print(val); // Print the text value write into TextField
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      child: 
                        FormBuilderTextField(
                          name: 'browseAmount',
                          initialValue: '1',
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            hintText: 'Enter amount of browse needed'
                          ),
                          validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.integer(),
                                FormBuilderValidators.range(1, 99)
                              ]),
                          onChanged: (val) {
                              print(val); // Print the text value write into TextField
                          },
                      )
                    ),
                    Flexible(
                      child:
                      FormBuilderDropdown<String>(
                        name: 'amountType', 
                        initialValue: 'branch/es',
                        decoration: const InputDecoration(
                          labelText: 'Amount type',
                          hintText: 'Select quantity type'
                        ),
                        items: ['branch/es', 'bucket/s']
                          .map((amountType) => DropdownMenuItem(
                                alignment: AlignmentDirectional.centerStart,
                                value: amountType,
                                child: Text(amountType),
                              ))
                          .toList(growable: false),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required()]
                        ),
                        onChanged: (val) {
                          print(val); // Print the text value write into TextField
                        },
                      )
                    )
                  ]
                ),
                ..._deliveryItems.map((item) {
                  // Returns a list of browse added so far to the order
                  return ListTile(
                    // Formats each DeliveryItem object in the deliveryItems list in a string format
                    title: Text("${item.browseName}: ${item.browseAmount} ${item.amountType}"),

                    trailing: Checkbox(
                      value: item.isSelected,
                      onChanged: (bool? newValue) {
                        setState(() {
                          item.isSelected = newValue!;
                        });
                      },
                    ),
                  );
                }),
                // Add delivery item button
                ElevatedButton(
                  onPressed: () {
                        // This adds to the order request list - not sent to database yet
                        _addDeliveryItem();                   
                  },
                  child: Text('Add Delivery Item'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    print("Delivery Item/s Removed");
                    if (_deliveryItems.isNotEmpty) {
                      setState(() {
                        // Removes all delivery items that are currently selected
                        _deliveryItems.removeWhere((item) => item.isSelected);
                      });
                    }
                  },
                  child: const Text('Remove Selected Items'),
                ),
                SizedBox(height: 32),
                // Button to send data to the DynamoDB Server Through AWS Gateway
                ElevatedButton(
                  onPressed: () async {
                    _submitForm();
                  },
                  child: Text('Submit order'),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  void _addDeliveryItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formData = _formKey.currentState!.value;

      final newItem = DeliveryItem(
        browseName: formData['browseData'],
        browseAmount: formData['browseAmount'],
        amountType: formData['amountType'],
      );

      setState(() {
        _isAnimalLock = true;
        _deliveryItems.add(newItem);
        print("Delivery Item Added");
      });
    } else {
      print('Please select a browse, amount and a quantity type');
      debugPrint(
        'browseName: ${_formKey.currentState!.fields['browseData']},\nbrowseAmount: ${_formKey.currentState!.fields['browseAmount']},\namountType: ${_formKey.currentState!.fields['amountType']}'
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formData = _formKey.currentState!.value;
      // Clear form once data is saved to formData
      _formKey.currentState!.reset();

      List<Map<String, dynamic>> items =
        _deliveryItems
            .map(
              (item) => {
                // TODO Plant names currently too long, will need to fix ListTiles in request.dart
                'plant_ID': item.browseName,
                // Quantity needs to be an int in database
                'quantity': int.parse(item.browseAmount),
                'type': item.amountType,
              },
            )
            .toList();

      final finalPayload = {
        ...formData,
        'request_ID': "Request_${DateTime.now().millisecondsSinceEpoch}",
        'timestamp': DateTime.now().toIso8601String(),
        "assigned_User_ID": null,
        'requester_ID': widget.user.claims['username'],
        'status_Num': 1,
        'delivery_items': items,
      };

      try {
        // Send HTTP POST request
        debugPrint(jsonEncode(finalPayload));
        final response = await http.post(
          Uri.parse('https://uuy1e4eofl.execute-api.us-east-1.amazonaws.com/requestsAPI'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(finalPayload),
        );

        // Checks if request was successful (status code 201)
        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          print(
            'Registration created for requester_ID: ${responseData['items']?[0]?['requester_ID']}',
          );
        } else {
          print('Server error: ${response.statusCode}');
          print(response.body);
        }
      } catch (error) {
        print('Failed to send registration data: $error');
      }
    } else {
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
    }
  }

}