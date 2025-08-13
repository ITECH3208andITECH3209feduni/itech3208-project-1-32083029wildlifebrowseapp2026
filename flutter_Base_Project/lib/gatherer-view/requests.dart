import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../templates/drawer.dart';
import '../jsonParser.dart';
import '../test/test_data.dart';  // testRequestJson from here
import '../auth/auth.dart';

class GathererRoute extends StatelessWidget {

  final User user;
  const GathererRoute({super.key, required this.user});

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
      // Set username of Gatherer here
      home: GathererHomePage(title: 'Request Board', user: user),
    );
  }
}

class GathererHomePage extends StatefulWidget {
  const GathererHomePage({
    super.key,
    required this.title,
    required this.user,
  });

  final String title;
  final User user;

  @override
  State<GathererHomePage> createState() => _RequestBoardState();
}

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

  // Args passed from Request board initial state widget
  // String animal = animal.animal_Name
  // String browse = item.plant_Name
  // int quantity = item.quantity
  // int postcode = request.postcode
  Widget requestTile(Request request, Items item, Animal animal) {
    return Hero(
      tag: animal,
      child: Material(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/${animal.animal_Name}.jpg',
            ),
            radius: 20,
          ),
          title: Text(animal.animal_Name),
          subtitle: Text(
            '${item.quantity}x ${item.plant_Name}...\n${request.postcode}',
          ),
          trailing: Text(
              "${formatTimelapse(getTimelapse(request.time))} ago",
              style: isStale(getTimelapse(request.time)) 
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.black)
            ),
          tileColor: const Color.fromARGB(235, 245, 246, 246),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                // Redirects from board to a detailed request page
                builder:
                    (BuildContext context) => DetailedRequest(
                      title: 'Request Details',
                      request: request,
                      item: item,
                      animal: animal,
                    ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  // Request board initial state
  Widget build(BuildContext context) {
    // *************************************
    // JSON parsed and variables initialised
    // Set json file to parse here
    // Args across gatherer's side of app are updated from here
    // *************************************
    var (request, item, animal) = jsonParser(testRequestJson); // Pass the Json, returning a 3 objects, request, item and animal

    const String appTitle = 'Requests';
    final String username = widget.user.claims['given_name'];

    return MaterialApp(
      title: appTitle,
      // SafeArea ensures that the view isn't obstructed by phone notch/status bar/bezel
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(appTitle),
            // Icon to move to caretaker order request page
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: 'Make a order request',
                onPressed: () {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    '/caretaker', 
                    arguments: {'user': widget.user},
                    );
                },
              ),
            ],
          ),
          drawer: UserDrawer(username: username),
          // Request board area
          body: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // Request tiles populate here
                children: isActive(request.state) ? <Widget>[requestTile(request, item, animal)]:[],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailedRequest extends StatefulWidget {
  const DetailedRequest({
    super.key,
    required this.title,
    required this.request,
    required this.item,
    required this.animal,
  });

  final String title;
  final Request request;
  final Items item;
  final Animal animal;
  
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                animal, // TODO Need to give proper padding
                style: TextStyle(color: Color.fromARGB(235, 16, 17, 17)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget browsePanel(plant, quantity) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Browse"), Text("$plant x$quantity")],
      ),
    );
  }

  Widget deliveryAddress(address, postcode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.place, size: 14)),
            _showAddress
                ? TextSpan(text: "Delivery address\n$address, $postcode")
                // Will probably reimplement this to dynamically call for address once request accepted, for security
                // TODO lookup postcode for name of suburb to add to address
                : TextSpan(text: "Delivery address\n******** $postcode"),
          ],
        ),
      ),
    );
  }

  // Use item.plant_Name to lookup for closest browse then return google map link
  Widget directionsPanel(item) {
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

  Widget timelapse(request) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.timelapse, size: 14)),
            // TODO use a timestamp here
            TextSpan(
              text: " Submitted ${formatTimelapse(getTimelapse(request.time))} ago",
              style: isStale(getTimelapse(request.time)) 
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.black)
            ),
          ],
        ),
      ),
    );
  }

  Widget requestButtons(request) {
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
                request.updateState = 'WIP';
              });
              String jsonString = jsonEncode(request.toJson());
              debugPrint(jsonString);
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

  // Builder for detail requests
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.animal.animal_Name} request')),
      // Detailed request view
      body: ListView(
        padding: EdgeInsets.only(left: 30.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              header(widget.animal.animal_Name),
              SizedBox(
                height: 20.0,
              ), // TODO May need to change this to a relative unit
              browsePanel(widget.item.plant_Name, widget.item.quantity),
              const SizedBox(
                height: 15.0,
              ), // TODO May need to change this to a relative unit
              deliveryAddress(widget.request.address, widget.request.postcode),
              const SizedBox(
                height: 10.0,
              ), // TODO May need to change this to a relative unit
              directionsPanel(widget.item),
              const SizedBox(
                height: 10.0,
              ), // TODO May need to change this to a relative unit
              timelapse(widget.request),
              const SizedBox(height: 20.0),
              requestButtons(widget.request),
            ],
          ),
        ],
      ),
    );
  }
}


bool isActive(state) {
  if(state == 'Active') {
    return true;
  } else {
    return false;
  }
}

// TODO use DateTime.difference
String getTimelapse(requestTime) {
  final DateTime now = DateTime.now();
  final List<int> timeParts = requestTime.substring(0, requestTime.length - 1).split(":").map<int>((str) => int.parse(str)).toList();

  int daysElapsed = now.day - timeParts[0];
  int hourElapsed = now.hour - timeParts[3];
  int minElapsed = now.minute - timeParts[4];

  String timelapse = '${daysElapsed}:${hourElapsed}:${minElapsed}';

  return timelapse;
}

String formatTimelapse(timelapse) {
  List<int> timeParts = timelapse.split(":").map<int>((str) => int.parse(str)).toList();

  int daysElapsed = timeParts[0];
  int hourElapsed = timeParts[1];
  int minElapsed = timeParts[2];

    if(daysElapsed != 0) {
    timelapse = '${daysElapsed} days';
  } else {
    if(hourElapsed != 0) {
      timelapse = '${hourElapsed}h ${minElapsed}m';
      
    } else {
      timelapse = '${hourElapsed}m';
    }
  }

  return timelapse;
}

bool isStale(timelapse) {
  List<int> timeParts = timelapse.split(":").map<int>((str) => int.parse(str)).toList();

  return timeParts[0] > 0 || timeParts[1] > 16;
}