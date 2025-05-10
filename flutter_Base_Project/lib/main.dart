import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const GathererRoute(),
        '/caretaker': (context) => const CaretakerRoute(),
        '/landowner': (context) => const LandOwnerRoute(),
      },
    ),
  ); //MaterialApp
}

class GathererRoute extends StatelessWidget {
  const GathererRoute({Key? key}) : super(key: key);

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
  State<GathererHomePage> createState() => _ListTileState();
}

class _ListTileState extends State<GathererHomePage>
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

  String selectedPage = '';

  @override
  Widget build(BuildContext context) {
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
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(46, 165, 107, 1)
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
                      selectedPage = 'Messages';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Profile'),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Profile';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Settings';
                    });
                  },
                ),
              ],
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'ListTile-Hero',
                child: Material(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/koala.jpg'),
                      radius: 20,
                    ),
                    title: const Text('Koala'),
                    subtitle: const Text('Eucalyptus Leaves\nCanadian'),
                    trailing: const Text('5m ago'),
                    tileColor: const Color.fromARGB(235, 245, 246, 246),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('Koala request'),
                              ),
                              body: Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/koala.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              '  Koala', // TODO Need to give proper padding
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                  235,
                                                  16,
                                                  17,
                                                  17,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ), // TODO May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Browse",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Eucalyptus leaves",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ), // TODO May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.place,
                                                size: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  "Delivery address\n231 Way, Ballarat Central, 3350",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ), // TODO May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.place,
                                                size: 14,
                                              ),
                                            ),
                                            TextSpan(text: "Nearest browse\n"),
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      'https://maps.app.goo.gl/M6uQuJx1E7zVB9vu9';
                                                  try {
                                                    await launchUrl(
                                                      Uri.parse(url),
                                                    );
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
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ), // TODO May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.timelapse,
                                                size: 14,
                                              ),
                                            ),
                                            TextSpan(text: "Submitted 2h ago"),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Hero(
                                            tag: 'ListTile-Hero',
                                            child: Material(
                                              // Accept request button
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                          218,
                                                          166,
                                                          247,
                                                          146,
                                                        ),
                                                    minimumSize: Size(101, 38),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  7,
                                                                ),
                                                              ),
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        0,
                                                        4,
                                                        7,
                                                        0.881,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Hero(
                                            tag: 'ListTile-Hero',
                                            child: Material(
                                              // Close request button
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                          218,
                                                          250,
                                                          250,
                                                          250,
                                                        ),
                                                    side: BorderSide(
                                                      color: Colors.black12,
                                                    ),
                                                    minimumSize: Size(101, 38),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  7,
                                                                ),
                                                              ),
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Close',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        0,
                                                        4,
                                                        7,
                                                        0.881,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 5),
              Hero(
                tag: 'ListTile-Hero',
                child: Material(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        'assets/images/egKangaroo.jpg',
                      ),
                      radius: 20,
                    ),
                    title: const Text('Eastern Grey Kangaroo'),
                    subtitle: const Text('Grasses\nMt Helen'),
                    trailing: const Text('30m ago'),
                    tileColor: const Color.fromARGB(235, 245, 246, 246),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text(
                                  'Eastern Grey Kangaroo request',
                                ),
                              ),
                              body: Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image(
                                            image: AssetImage(
                                              'assets/images/egKangaroo.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              '  Eastern Grey Kangaroo', // Need to give proper padding
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                  235,
                                                  16,
                                                  17,
                                                  17,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ), // May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Browse",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Grasses",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ), // May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.place,
                                                size: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  " Delivery address\n231 Way, Ballarat Central, 3350", // Fix with proper padding
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ), // May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.place,
                                                size: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " Nearest browse\n",
                                            ), // Fix with proper padding
                                            WidgetSpan(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  const url =
                                                      'https://maps.app.goo.gl/M6uQuJx1E7zVB9vu9';
                                                  try {
                                                    await launchUrl(
                                                      Uri.parse(url),
                                                    );
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
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ), // May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.timelapse,
                                                size: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " Submitted 2h ago",
                                            ), // Fix with proper padding
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Hero(
                                            tag: 'ListTile-Hero',
                                            child: Material(
                                              // Accept request button
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                          218,
                                                          166,
                                                          247,
                                                          146,
                                                        ),
                                                    minimumSize: Size(101, 38),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  7,
                                                                ),
                                                              ),
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        0,
                                                        4,
                                                        7,
                                                        0.881,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Hero(
                                            tag: 'ListTile-Hero',
                                            child: Material(
                                              // Close request button
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                          218,
                                                          250,
                                                          250,
                                                          250,
                                                        ),
                                                    side: BorderSide(
                                                      color: Colors.black12,
                                                    ),
                                                    minimumSize: Size(101, 38),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                        ),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(
                                                                  7,
                                                                ),
                                                              ),
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Close',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                        0,
                                                        4,
                                                        7,
                                                        0.881,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaretakerRoute extends StatelessWidget {
  const CaretakerRoute({Key? key}) : super(key: key);

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
  bool selected;

  DeliveryItem({
    required this.browseName,
    required this.browseQuantity,
    this.selected = false,
  });
}

class CaretakerHomePage extends StatefulWidget {
  const CaretakerHomePage({super.key, required this.title});
  final String title;

  @override
  State<CaretakerHomePage> createState() => _CaretakerHomePageState();
}

class _CaretakerHomePageState extends State<CaretakerHomePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specificationsController =
      TextEditingController();
  final TextEditingController _selectedAnimalAgeController =
      TextEditingController();
  final TextEditingController _quantityBrowseController =
      TextEditingController();

  final List<String> animalList = ['Koala', 'Wombat', 'Kangaroo', "Other"];
  final List<String> browseList = ['Eucalyptus', 'Silverbeet', 'Wattle'];

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

  String selectedPage = '';

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
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/');
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
                      selectedPage = 'Messages';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Profile'),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Profile';
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    setState(() {
                      selectedPage = 'Settings';
                    });
                  },
                ),
              ],
            ),
          ),
          body: ListView(
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
              inputField(
                "Quantity Of Browse",
                _quantityBrowseController,
                hint: "m³",
              ),
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
                  int animalIndex =
                      _selectedAnimal != null
                          ? animalList.indexOf(_selectedAnimal!)
                          : -1;
                  print(
                    "Selected Animal: $_selectedAnimal (Index: $animalIndex)",
                  );
                  print("Animal Age: ${_selectedAnimalAgeController.text}");
                  print("DeliveryItems:");
                  for (int i = 0; i < _deliveryItems.length; i++) {
                    int browseIndex =
                        _selectedBrowse != null
                            ? browseList.indexOf(_selectedBrowse!)
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
                  int? animalIndex =
                      _selectedAnimal != null
                          ? animalList.indexOf(_selectedAnimal!)
                          : null;

                  List<Map<String, dynamic>> items =
                      _deliveryItems
                          .map(
                            (item) => {
                              'plant_ID':
                                  browseList.indexOf(item.browseName) +
                                  1, // Assuming browseName comes from browseList
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
                      print(
                        'Delivery Created ID: ${responseData['delivery_ID']}',
                      );
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
    );
  }

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
}

class LandOwnerRoute extends StatelessWidget {
  const LandOwnerRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tap Me Page"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ), // AppBar
    ); // Scaffold
  }
}
