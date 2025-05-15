import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  final TextEditingController _specialInstructionsController =
      TextEditingController();
  final TextEditingController _animalAgeController = TextEditingController();
  final TextEditingController _browseQuantityController =
      TextEditingController();

  final List<String> _animalOptions = ['Koala', 'Wombat', 'Kangaroo', "Other"];
  final List<String> _browseOptions = ['Eucalyptus', 'Silverbeet', 'Wattle'];

  String? _selectedAnimal;
  String? _selectedBrowseItem;

  // List of delivery items
  final List<DeliveryItem> _deliveryItemsList = [
    DeliveryItem(browseName: "Eucalyptus", browseQuantity: "1"),
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _deliveryAddressController.dispose();
    _specialInstructionsController.dispose();
    _animalAgeController.dispose();
    _browseQuantityController.dispose();
    super.dispose();
  }

  String _selectedDrawerPage = '';

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Order';
    return MaterialApp(
      title: appTitle,
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(46, 165, 107, 1),
                  ),
                  child: Text(
                    'Hi David',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Messages'),
                  onTap: () {
                    setState(() {
                      _selectedDrawerPage = 'Messages';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Profile'),
                  onTap: () {
                    setState(() {
                      _selectedDrawerPage = 'Profile';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    setState(() {
                      _selectedDrawerPage = 'Settings';
                    });
                  },
                ),
              ],
            ),
          ),
          body: ListView(
            children: [
              _buildInputField("Full Name", _fullNameController),
              const SizedBox(height: 32),
              _buildInputField("Address", _deliveryAddressController),
              const SizedBox(height: 32),
              _buildInputField("Specifications", _specialInstructionsController),
              const SizedBox(height: 32),
              _buildAnimalDropdown(),
              const SizedBox(height: 32),
              _buildInputField("Animal Age", _animalAgeController),
              const SizedBox(height: 32),
              _buildBrowseDropdown(),
              const SizedBox(height: 12),
              _buildInputField(
                "Quantity Of Browse",
                _browseQuantityController,
                hint: "m³",
              ),
              const SizedBox(height: 12),

              ..._deliveryItemsList.map((item) {
                return ListTile(
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

              ElevatedButton(
                onPressed: () {
                  // Check if a browse item is selected and quantity is entered
                  if (_selectedBrowseItem != null &&
                      _browseQuantityController.text.isNotEmpty) {
                    setState(() {
                      // Add a new delivery item to the list
                      _deliveryItemsList.add(
                        DeliveryItem(
                          browseName: _selectedBrowseItem!,
                          browseQuantity: _browseQuantityController.text,
                        ),
                      );
                      // Clear the browse selection and quantity input after adding
                      _selectedBrowseItem = null;
                      _browseQuantityController.clear();
                    });
                  } else {
                    // Show a snackbar if browse or quantity is not selected/entered
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please select a browse item and enter a quantity.'),
                      ),
                    );
                  }
                },
                child: const Text('Add Delivery Item'),
              ),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Remove all delivery items that are currently selected
                    _deliveryItemsList.removeWhere((item) => item.isSelected);
                  });
                },
                child: const Text('Remove Selected Items'),
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Print all the form data to the terminal for testing
                  print("Full Name: ${_fullNameController.text}");
                  print("Address: ${_deliveryAddressController.text}");
                  print(
                      "Specifications: ${_specialInstructionsController.text}");
                  int animalIndex = _selectedAnimal != null
                      ? _animalOptions.indexOf(_selectedAnimal!)
                      : -1;
                  print(
                    "Selected Animal: $_selectedAnimal (Index: $animalIndex)",
                  );
                  print("Animal Age: ${_animalAgeController.text}");
                  print("DeliveryItems:");
                  for (int i = 0; i < _deliveryItemsList.length; i++) {
                    int browseIndex =
                        _browseOptions.indexOf(_deliveryItemsList[i].browseName);
                    print(
                      '    ${i + 1}. ${_deliveryItemsList[i].browseName}(Index: $browseIndex):${_deliveryItemsList[i].browseQuantity}m³',
                    );
                  }
                },
                child: const Text('Test Complete Form To Terminal'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () async {
                  int? animalIndex = _selectedAnimal != null
                      ? _animalOptions.indexOf(_selectedAnimal!)
                      : null;

                  // Create a list of maps for the selected delivery items
                  List<Map<String, dynamic>> items = _deliveryItemsList
                      .where((item) => item.isSelected)
                      .map(
                        (item) => {
                          'plant_ID': _browseOptions.indexOf(item.browseName) + 1,
                          'quantity': item.browseQuantity,
                        },
                      )
                      .toList();

                  // Create the final JSON payload
                  Map<String, dynamic> deliveryData = {
                    "name": _fullNameController.text,
                    "address": _deliveryAddressController.text,
                    "specifications": _specialInstructionsController.text,
                    "items": items,
                    "animal_ID": animalIndex != null ? animalIndex + 1 : null,
                  };

                  try {
                    // Send HTTP POST request to the specified endpoint
                    final response = await http.post(
                      Uri.parse('http://localhost:3000/create-delivery'),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode(deliveryData),
                    );

                    // Check if the request was successful (status code 201 Created)
                    if (response.statusCode == 201) {
                      final responseData = jsonDecode(response.body);
                      print(
                        'Delivery Created ID: ${responseData['delivery_ID']}',
                      );
                      // Show a success snackbar to the user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delivery request submitted successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Optionally clear the form and delivery items after successful submission
                      setState(() {
                        _fullNameController.clear();
                        _deliveryAddressController.clear();
                        _specialInstructionsController.clear();
                        _selectedAnimal = null;
                        _animalAgeController.clear();
                        _deliveryItemsList.clear();
                        _deliveryItemsList.add(DeliveryItem(
                            browseName: "Eucalyptus", browseQuantity: "1"));
                      });
                    } else {
                      // Log the error and show an error snackbar
                      print('Server Error: ${response.statusCode}');
                      print(response.body);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Failed to submit delivery request. Error: ${response.statusCode}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (error) {
                    // Handle network or other errors during the request
                    print('Failed Send Delivery: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to connect to the server: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Submit Selected Items To PostGres'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds a reusable input field widget
  ListTile _buildInputField(
    String labelText,
    TextEditingController controller, {
    String? hint,
  }) =>
      ListTile(
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
      );

  // Builds the animal selection dropdown widget
  ListTile _buildAnimalDropdown() => ListTile(
        title: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Animal',
            border: OutlineInputBorder(),
          ),
          value: _selectedAnimal,
          items: _animalOptions
              .map(
                (animal) =>
                    DropdownMenuItem(value: animal, child: Text(animal)),
              )
              .toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedAnimal = newValue;
            });
          },
        ),
      );

  // Builds the browse item selection dropdown widget
  ListTile _buildBrowseDropdown() => ListTile(
        title: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Browse',
            border: OutlineInputBorder(),
          ),
          value: _selectedBrowseItem,
          items: _browseOptions
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
        ),
      );
}
