import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class CaretakerRoute extends StatelessWidget {
  const CaretakerRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Request',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
      ),
      home: const CaretakerHomePage(title: 'Order Request'),
    );
  }
}

class DeliveryItem {
  final String browseName;
  final String browseQuantity;
  bool isSelected;

  DeliveryItem({
    required this.browseName,
    required this.browseQuantity,

    this.isSelected = false,
  });
}

class CaretakerHomePage extends StatefulWidget {
  const CaretakerHomePage({super.key, required this.title});
  final String title;

  @override
  State<CaretakerHomePage> createState() => _CaretakerHomePageState();
}

class _CaretakerHomePageState extends State<CaretakerHomePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _specificationsController =
      TextEditingController();
  final TextEditingController _browseQuantityController =
      TextEditingController();

  final List<String> _animalOptions = ['Koala', 'Wombat', 'Kangaroo', "Other"];
  final List<String> _browseOptions = ['Eucalyptus', 'Silverbeet', 'Wattle'];

  String? _selectedAnimal;
  String? _selectedBrowseItem;

  // List of delivery items
  // TODO create DeliveryItem on submission so can have impression of a empty list when open page
  final List<DeliveryItem> _deliveryItems = [
    DeliveryItem(browseName: "Eucalyptus", browseQuantity: "1"),
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _deliveryAddressController.dispose();
    _specificationsController.dispose();
    _browseQuantityController.dispose();
    super.dispose();
  }

  String selectedDrawerPage = '';

  GestureTapCallback drawerButton(String page) {
    return () {
      setState(() {
        selectedDrawerPage = page;
      });
      Navigator.pop(context);
    };
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromRGBO(46, 165, 107, 1)),
            child: Text(
              'Hi David',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
            onTap: drawerButton('Messages'),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: drawerButton('Profile'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: drawerButton('Settings'),
          ),
        ],
      ),
    );
  }

  bool _isAnimalLock = false;

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Order';
    return MaterialApp(
      title: appTitle,
      // SafeArea ensures that the view isn't obstructed by phone notch/status bar/bezel
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(appTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.pageview_outlined),
                tooltip: 'View the request board',
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed('/');
                },
              ),
            ],
          ),
          drawer: _buildDrawer(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(height: 32),
                inputField("Full Name", _fullNameController),
                SizedBox(height: 32),
                inputField("Address", _deliveryAddressController),
                SizedBox(height: 32),
                inputField("Specifications", _specificationsController),
                SizedBox(height: 32),
                animalDropdown(),
                SizedBox(height: 32),
                browseDropdown(),
                SizedBox(height: 12),
                inputFieldInt(
                  "Quantity Of Browse",
                  _browseQuantityController,
                  hint: "m³",
                ),
                SizedBox(height: 12),

                ..._deliveryItems.map((item) {
                  // Changed to ListTile to format browseName and browseQuantity together
                  return ListTile(
                    // Format as browseName: browseQuantity
                    title: Text("${item.browseName}: ${item.browseQuantity}m³"),

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
                    // _browseQuantityController.text can't be 0 due to input formatter in inputFieldInt widget
                    if (_selectedBrowseItem != null &&
                        _browseQuantityController.text != "") {
                      print("Delivery Item Added");
                      setState(() {
                        _isAnimalLock = true;
                        _deliveryItems.add(
                          DeliveryItem(
                            browseName: "$_selectedBrowseItem",
                            browseQuantity: _browseQuantityController.text,
                          ),
                        );
                        // Clears the browse selection and quantity input after adding
                        _selectedBrowseItem = null;
                        _browseQuantityController.clear();
                      });
                    } else {
                      print('Please select a browse and quantity');
                    }
                    ;
                  },
                  child: Text('Add Delivery Item'),
                ),

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
                // Button to send data to terminal so its properly being read
                ElevatedButton(
                  onPressed: () {
                    print("Full Name: ${_fullNameController.text}");
                    print("Address: ${_deliveryAddressController.text}");
                    print("Specifications: ${_specificationsController.text}");
                    int animalIndex =
                        _selectedAnimal != null
                            ? _animalOptions.indexOf(_selectedAnimal!)
                            : -1;
                    print(
                      "Selected Animal: $_selectedAnimal (Index: $animalIndex)",
                    );
                    print("DeliveryItems:");
                    for (int i = 0; i < _deliveryItems.length; i++) {
                      int browseIndex =
                          _selectedBrowseItem != null
                              ? _browseOptions.indexOf(_selectedBrowseItem!)
                              : -1;
                      print(
                        '     ${i + 1}. ${_deliveryItems[i].browseName}(Index: $browseIndex):${_deliveryItems[i].browseQuantity}m³',
                      );
                    }
                  },
                  child: Text('Test Complete Form To Terminal'),
                ),

                SizedBox(height: 12),

                // Button to send data to the PostgreS Server Through Node.JS
                ElevatedButton(
                  onPressed: () async {
                    // Build your items list from _deliveryItems
                    int? animalIndex;
                    _selectedAnimal != null
                        ? _animalOptions.indexOf(_selectedAnimal!)
                        : print('Please select an animal');

                    List<Map<String, dynamic>> items =
                        _deliveryItems
                            .map(
                              (item) => {
                                'plant_ID':
                                    _browseOptions.indexOf(item.browseName) +
                                    1, // Assuming browseName comes from browseList
                                // Checks a int is passed to quantity field
                                'quantity': item.browseQuantity,
                              },
                            )
                            .toList();

                    // Build the final JSON payload
                    Map<String, dynamic> deliveryData = {
                      "name": _fullNameController.text,
                      "address": _deliveryAddressController.text,
                      "specifications": _specificationsController.text,
                      "items": items,
                      "animal_ID": animalIndex != null ? animalIndex + 1 : null,
                    };

                    try {
                      // Send HTTP POST request
                      final response = await http.post(
                        Uri.parse('http://localhost:3000/create-delivery'),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(deliveryData),
                      );

                      // Checks if request was successful (status code 201)
                      if (response.statusCode == 201) {
                        final responseData = jsonDecode(response.body);
                        print(
                          'Delivery Created ID: ${responseData['delivery_ID']}',
                        );
                        // Clears form on successful submission
                        setState(() {
                          _fullNameController.clear();
                          _deliveryAddressController.clear();
                          _specificationsController.clear();
                          _selectedAnimal = null;
                          _deliveryItems.clear();
                        });
                      } else {
                        print('Server Error: ${response.statusCode}');
                        print(response.body);
                      }
                    } catch (error) {
                      print('Failed Send Delivery: $error');
                    }
                  },
                  child: Text('Submit Complete Form To PostGres'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
      border: OutlineInputBorder(),
    ),
  );

  // Input field that only accepts int
  TextField inputFieldInt(
    String labelName,
    TextEditingController controller, {
    String? hint,
  }) => TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelName,
      hintText: hint,
      border: OutlineInputBorder(),
    ),
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      FilteringTextInputFormatter.deny(RegExp('^0+')),
    ],
  );

  DropdownButtonFormField<String> animalDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Animal',
        border: OutlineInputBorder(),
      ),
      value: _selectedAnimal,
      items:
          _animalOptions
              .map(
                (animal) =>
                    DropdownMenuItem(value: animal, child: Text(animal)),
              )
              .toList(),
      onChanged:
          _isAnimalLock
              ? null
              : (newValue) {
                setState(() {
                  _selectedAnimal = newValue;
                });
              },
    );
  }

  DropdownButtonFormField<String> browseDropdown() =>
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Browse',
          border: OutlineInputBorder(),
        ),
        value: _selectedBrowseItem,
        items:
            _browseOptions
                .map(
                  (browse) =>
                      DropdownMenuItem(value: browse, child: Text(browse)),
                )
                .toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedBrowseItem = newValue;
          });
        },
      );
}
