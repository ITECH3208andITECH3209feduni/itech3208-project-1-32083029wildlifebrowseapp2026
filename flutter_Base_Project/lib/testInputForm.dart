import 'package:flutter/material.dart';

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

  String? _selectedAnimal;
  String? _selectedBrowse;

  // List of delivery items 
  final List<DeliveryItem> _deliveryItems = [
    DeliveryItem(browseName: "Eculptus", browseQuantity: "1"),
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
      }).toList(),


      ElevatedButton(
        onPressed: () {
          print("Delivery Item Added");
          setState(() {
            _deliveryItems.add(
              DeliveryItem(
                browseName: "$_selectedBrowse",
                browseQuantity: _quantityBrowseController.text
              ),
            );
          });
        },
        child: Text('Add Delivery Item'),
      ),

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

      ElevatedButton(
        onPressed: () {
          print("Full Name: ${_firstNameController.text}");
          print("Address: ${_addressController.text}");
          print("Specifications: ${_specificationsController.text}");
          print("Selected Animal: $_selectedAnimal");
          print("Animal Age: ${_selectedAnimalAgeController.text}");
          print("DeliveryItems:");
          for (int i = 0; i < _deliveryItems.length; i++) {
            print('     ${i + 1}. ${_deliveryItems[i].browseName}:${_deliveryItems[i].browseQuantity}m³');
          }
        },
        child: Text('Submit Complete Form'),
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
          ['Koala', 'Wombat', 'Kangaroo', "Other"]
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
          ['Eculptus', 'Treee', 'Wood', "Bush", "Other"]
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
