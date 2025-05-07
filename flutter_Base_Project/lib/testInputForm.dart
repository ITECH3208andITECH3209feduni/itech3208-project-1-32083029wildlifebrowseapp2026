import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(148, 236, 140, 1),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class DeliveryItem {
  final String browseName;
  final String browseQuantity;
  bool selected;

  DeliveryItem({
    required this.browseName,
    required this.browseQuantity,
    this.selected = false,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specificationsController =
      TextEditingController();
  final TextEditingController _selectedAnimalAgeController =
      TextEditingController();
  final TextEditingController _quantityBrowseController =
      TextEditingController();

  final List<String> animalList = ['Koala', 'Wombat', 'Kangaroo', "Other"];
  final List<String> browseList = ['Eucalyptus','Silverbeet','Wattle'];

 


  String? _selectedAnimal;
  String? _selectedBrowse;

  // List of delivery items
  final List<DeliveryItem> _deliveryItems = [
    DeliveryItem(browseName: "Eucalyptus", browseQuantity: "1"),
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _addressController.dispose();
    _specificationsController.dispose();
    _selectedAnimalAgeController.dispose();
    _quantityBrowseController.dispose();
    super.dispose();
  }

  Widget _buildList() => ListView(
    padding: EdgeInsets.all(16),
    children: [
      inputField("Full Name", _firstNameController),
      SizedBox(height: 32),
      inputField("Address", _addressController),
      SizedBox(height: 32),
      inputField("Specifications", _specificationsController),
      SizedBox(height: 32),
      animalDropdown(),
      SizedBox(height: 32),
      inputField("Animal Age", _selectedAnimalAgeController),
      SizedBox(height: 32),
      browseDropdown(),
      SizedBox(height: 12),
      inputField("Quantity Of Browse", _quantityBrowseController, hint: "m³"),
      SizedBox(height: 12),

      ..._deliveryItems.map((item) {
        // Changed to ListTile to format browseName and browseQuantity together
        return ListTile(
          // Format as browseName: browseQuantity
          title: Text("${item.browseName}: ${item.browseQuantity}m³"),

          trailing: Checkbox(
            value: item.selected,
            onChanged: (bool? newValue) {
              setState(() {
                item.selected = newValue!;
              });
            },
          ),
        );
      }),

      ElevatedButton(
        onPressed: () {
          print("Delivery Item Added");
          setState(() {
            _deliveryItems.add(
              DeliveryItem(
                browseName: "$_selectedBrowse",
                browseQuantity: _quantityBrowseController.text,
              ),
            );
          });
        },
        child: Text('Add Delivery Item'),
      ),

      // NEEDS TO BE MADE
      ElevatedButton(
        onPressed: () {
          print("Delivery Item Removed");
          if (_deliveryItems.isNotEmpty) {
            setState(() {
              // Currently Just removes the last item in the List
              _deliveryItems.removeLast();
            });
          }
        },
        child: Text('Remove Delivery Item'),
      ),

      SizedBox(height: 32),
      // Button to send data to terminal so its properly being read
      ElevatedButton(
        onPressed: () {
          print("Full Name: ${_firstNameController.text}");
          print("Address: ${_addressController.text}");
          print("Specifications: ${_specificationsController.text}");
          int animalIndex = _selectedAnimal != null ? animalList.indexOf(_selectedAnimal!) : -1;
          print("Selected Animal: $_selectedAnimal (Index: $animalIndex)");
          print("Animal Age: ${_selectedAnimalAgeController.text}");
          print("DeliveryItems:");
          for (int i = 0; i < _deliveryItems.length; i++) {
            int browseIndex = _selectedBrowse != null ? browseList.indexOf(_selectedBrowse!) : -1;
            print('     ${i + 1}. ${_deliveryItems[i].browseName}(Index: $browseIndex):${_deliveryItems[i].browseQuantity}m³');
          }
        },
        child: Text('Test Complete Form To Terminal'),
      ),


      SizedBox(height: 12),
      
      // Button to send data to the PostgreS Server Through Node.JS
      ElevatedButton(
        onPressed: () async {
          // Build your items list from _deliveryItems
          int? animalIndex = _selectedAnimal != null ? animalList.indexOf(_selectedAnimal!) : null;

          List<Map<String, dynamic>> items =
              _deliveryItems
                  .map(
                    (item) => {
                      'plant_ID': browseList.indexOf(item.browseName) + 1, // Assuming browseName comes from browseList
                      'quantity': item.browseQuantity,
                    },
                  )
                  .toList();

          // Build the final JSON body
          Map<String, dynamic> deliveryData = {
            "name": _firstNameController.text,
            "address": _addressController.text,
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

            if (response.statusCode == 201) {
              final responseData = jsonDecode(response.body);
              print('Delivery Created ID: ${responseData['delivery_ID']}');
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
  );

  ListTile inputField(
    String browseName,
    TextEditingController controller, {
    String? hint,
  }) => ListTile(
    title: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: browseName,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    ),
  );

  ListTile animalDropdown() => ListTile(
    title: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Animal',
        border: OutlineInputBorder(),
      ),
      value: _selectedAnimal,
      items:
          animalList
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

  ListTile browseDropdown() => ListTile(
    title: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Browse',
        border: OutlineInputBorder(),
      ),
      value: _selectedBrowse,
      items:
          browseList
              .map(
                (browse) =>
                    DropdownMenuItem(value: browse, child: Text(browse)),
              )
              .toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedBrowse = newValue;
        });
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green, title: Text(widget.title)),
      body: Center(child: _buildList()),
    );
  }
}
