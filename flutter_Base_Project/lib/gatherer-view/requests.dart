import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../test/test_data.dart';

class GathererRoute extends StatelessWidget {
  const GathererRoute({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Requests',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.white),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
      ),
      home: const GathererHomePage(title: 'Request Board'),
    );
  }
}

class GathererHomePage extends StatefulWidget {
  const GathererHomePage({super.key, required this.title});

  final String title;

  @override
  State<GathererHomePage> createState() => _RequestBoardState();
}

class Request {
  Request({
    required this.name,
    required this.items,
    required this.animal,
    required this.address,
    required this.postcode,
    required this.delivery_ID,
    this.specifications,
  });

  final String name;
  final List<Items> items;
  final Animal animal;
  final String address;
  final int postcode;
  final int delivery_ID;
  final String? specifications;

  factory Request.fromJson(Map<String, dynamic> testRequestJson) {
    try {
    final name = testRequestJson['name'];
    if (name is! String) {
      // will throw if name is missing or not a String
      throw FormatException(
        'Invalid JSON: required "name" field of type String in $testRequestJson',
      );
    }

    final itemsData = testRequestJson['items'];
    if (itemsData is! List<dynamic>) {
      // will throw if items is missing or not a List
      throw FormatException(
        'Invalid JSON: required "items" array of type List<dynamic> in $testRequestJson',
      );
    }

    final animalsData = testRequestJson['animal'];
    // if (animalsData is! Animal) {
    //   // will throw if animal is missing or not a object
    //   throw FormatException(
    //     'Invalid JSON: required "animal" object of type Animal in $testRequestJson',
    //   );
    // }

    final address = testRequestJson['address'];
    if (address is! String) {
      // will throw if address is missing or not a String
      throw FormatException(
        'Invalid JSON: required "address" field of type int in $testRequestJson',
      );
    }

    final postcode = testRequestJson['postcode'];
    if (postcode is! int) {
      // will throw if postcode is missing or not a Int
      throw FormatException(
        'Invalid JSON: required "postcode" field of type int in $testRequestJson',
      );
    }

    final delivery_ID = testRequestJson['delivery_ID'];
    if (delivery_ID is! int) {
      // will throw if delivery_ID is missing or not a Int
      throw FormatException(
        'Invalid JSON: required "delivery_ID" field of type int in $testRequestJson',
      );
    }

    final specifications = testRequestJson['specifications'];
    if (specifications is! String) {
      // will throw if specifications is missing or not a String
      throw FormatException(
        'Invalid JSON: required "specifications" field of type int in $testRequestJson',
      );
    }

    final items = itemsData.map((itemData) {
      if (itemData is! Map<String, dynamic>) {
        throw FormatException('Invalid JSON: required "items" array of type Map<String, dynamic> in $testRequestJson');
      }
      return Items.fromJson(itemData);
    }).toList();

    return Request(
      name: name,
      items: items,
      animal: animalsData,
      address: address,
      postcode: postcode,
      delivery_ID: delivery_ID,
      specifications: specifications,
    );
    } catch (e) {
      throw FormatException('Failed to parse Request: $e');
    }
  }
}

class Items {
  Items({
    required this.plant_ID,
    required this.quantity,
    required this.plant_Name,
  });

  final int plant_ID;
  final int quantity;
  final String plant_Name;

  factory Items.fromJson(Map<String, dynamic> testRequestJson) {
    final plant_ID = testRequestJson['plant_ID']; 
    if (plant_ID is! int) {
      // will throw if plant_ID is missing or not a Int
      throw FormatException(
        'Invalid JSON: required "plant_ID" field of type int in $testRequestJson',
      );
    }

    final quantity = testRequestJson['quantity']; 
    if (quantity is! int) {
      // will throw if quantity is missing or not a Int
      throw FormatException(
        'Invalid JSON: required "quantity" field of type int in $testRequestJson',
      );
    }

    final plant_Name = testRequestJson['plant_Name'];
    if (plant_Name is! String) {
      // will throw if plant_Name is missing or not a String
      throw FormatException(
        'Invalid JSON: required "plant_Name" field of type int in $testRequestJson',
      );
    }

    return Items(
      plant_ID: plant_ID,
      quantity: quantity,
      plant_Name: plant_Name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_ID': plant_ID,
      'quantity': quantity,
      'plant_Name': plant_Name,
    };
  }
}


class Animal {
  int? animalID;
  String? animalName;

  Animal({this.animalID, this.animalName});

  Animal.fromJson(Map<String, dynamic> json) {
    animalID = json['animal_ID'];
    animalName = json['animal_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['animal_ID'] = this.animalID;
    data['animal_Name'] = this.animalName;
    return data;
  }
}

// class Animal {
//   int? animalID;
//   String? animalName;

//   Animal({this.animalID, this.animalName})

//   Animal.fromJson(Map<String, dynamic> json) {
//     animalID = json['animal_ID'];
//     animalName = json['animal_Name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['animal_ID'] = this.animalID;
//     data['animal_Name'] = this.animalName;
//     return data;
//   }

//   // factory Animal.fromJson(Map<String, dynamic> testRequestJson) {
//     // final animal_ID = testRequestJson['animal_ID']; 
//     // if (animal_ID is! int) {
//     //   // will throw if animal_ID is missing or not a Int
//     //   throw FormatException(
//     //     'Invalid JSON: required "animal_ID" field of type int in $testRequestJson',
//     //   );
//     // }

//     // final animal_Name = testRequestJson['animal_Name'];
//     // if (animal_Name is! String) {
//     //   // will throw if animal_Name is missing or not a String
//     //   throw FormatException(
//     //     'Invalid JSON: required "animal_Name" field of type int in $testRequestJson',
//     //   );
//     // }

//     // return Animal(animal_ID: animal_ID, animal_Name: animal_Name);

//   // }

//   // Map<String, dynamic> toJson() => {
//   //   'animal_ID': animal_ID, 
//   //   'animal_Name': animal_Name};
// }

class _RequestBoardState extends State<GathererHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start animations
    _fadeController.forward();
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

  Widget requestTile(String animal) {
    return Hero(
      tag: animal,
      child: Material(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/$animal.jpg'),
            radius: 20,
          ),
          title: Text(animal),
          subtitle: const Text('Eucalyptus Leaves\nCanadian'),
          trailing: const Text('5m ago'),
          tileColor: const Color.fromARGB(235, 245, 246, 246),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                builder:
                    (BuildContext context) =>
                        const DetailedRequest(title: 'Request Details'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsedJson = jsonDecode(testRequestJson) as Map<String, dynamic>;
    final request = Request.fromJson(parsedJson);
    final item = Items.fromJson(parsedJson);
    final animal = Animal.fromJson(parsedJson);

    const String appTitle = 'Requests';

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
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Make a order request',
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/caretaker');
                },
              ),
            ],
          ),
          drawer: _buildDrawer(),
          // Request board
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              requestTile('Koala'),
              // requestTile(animal.animal_Name),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailedRequestRoute extends StatelessWidget {
  const DetailedRequestRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Details',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
      ),
      home: const DetailedRequest(title: 'Request Details'),
    );
  }
}

class DetailedRequest extends StatefulWidget {
  const DetailedRequest({super.key, required this.title});

  final String title;

  @override
  State<DetailedRequest> createState() => _DetailedRequestState();
}

class _DetailedRequestState extends State<DetailedRequest> {
  bool _showAddress = false;

  Widget header(String animal) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          height: 100,
          child: Image(
            image: AssetImage('assets/images/$animal.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              animal, // TODO Need to give proper padding
              style: TextStyle(color: Color.fromARGB(235, 16, 17, 17)),
            ),
          ],
        ),
      ],
    );
  }

  Widget browsePanel() {
    return Align(
      alignment:
          Alignment.bottomLeft, // TODO fix formatting, implement differently?
      child: Column(
        children: [
          Text("Browse", textAlign: TextAlign.left),
          Text("Eucalyptus leaves", textAlign: TextAlign.left),
        ],
      ),
    );
  }

  Widget deliveryAddress() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.place, size: 14)),
            _showAddress
                ? TextSpan(text: "Delivery address\n231 Way, Canadian, 3350")
                // Will probably reimplement this to dynamically call for address once request accepted for security
                : TextSpan(text: "Delivery address\n******** Canadian, 3350"),
          ],
        ),
      ),
    );
  }

  Widget directionsPanel() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.place, size: 14)),
            TextSpan(text: "Nearest browse\n"),
            WidgetSpan(
              child: GestureDetector(
                onTap: () async {
                  const url = 'https://maps.app.goo.gl/M6uQuJx1E7zVB9vu9';
                  try {
                    await launchUrl(Uri.parse(url));
                  } catch (e) {
                    print(
                      'Can not launch, must allow query in android/app/src/main/AndroidManifest.xml',
                    );
                  }
                },
                child: const Text(
                  "View on google maps",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timelapse() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.timelapse, size: 14)),
            TextSpan(text: "Submitted 2h ago"),
          ],
        ),
      ),
    );
  }

  Widget requestButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(218, 166, 247, 146),
              minimumSize: Size(101, 38),
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {
              // Accept button action
              setState(() {
                _showAddress = true;
              });
            },
            child: Text(
              'Accept',
              style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Flexible(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color.fromARGB(218, 250, 250, 250),
              side: BorderSide(color: Colors.black12),
              minimumSize: Size(101, 38),
              padding: EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Koala request')),
      // Detailed request view
      body: Padding(
        padding: EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            header('Koala'),
            SizedBox(
              height: 20.0,
            ), // TODO May need to change this to a relative unit
            browsePanel(),
            const SizedBox(
              height: 15.0,
            ), // TODO May need to change this to a relative unit
            deliveryAddress(),
            const SizedBox(
              height: 10.0,
            ), // TODO May need to change this to a relative unit
            directionsPanel(),
            const SizedBox(
              height: 10.0,
            ), // TODO May need to change this to a relative unit
            timelapse(),
            const SizedBox(height: 20.0),
            requestButtons(),
          ],
        ),
      ),
    );
  }
}
