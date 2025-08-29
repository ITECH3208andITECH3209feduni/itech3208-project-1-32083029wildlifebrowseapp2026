import 'package:flutter/material.dart';

import '../templates/drawer.dart';
import '../jsonParser.dart';
import '../auth/auth.dart';

import '../models/request.dart';

// Dummy request json data
import '../test/dummy_request.dart';
import '../test/dummy_request2.dart';

class LandownerRoute extends StatelessWidget {

  final User user;
  const LandownerRoute({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landowner Profiles',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.white),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
      ),
      // Set username of Gatherer here
      home: LandownerHomePage(title: 'Places to find browse', user: user),
    );
  }
}

class LandownerHomePage extends StatefulWidget {
  const LandownerHomePage({
    super.key,
    required this.title,
    required this.user,
  });

  final String title;
  final User user;

  @override
  State<LandownerHomePage> createState() => _RequestBoardState();
}

class _RequestBoardState extends State<LandownerHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  final List<Request> allRequests = [
    jsonParser(dummyRequest),
    jsonParser(dummyRequest2),
  ];


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
  Widget requestTile(Request request) {
    return Hero(
      tag: request.animal,
      child: Material(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/${request.name}.jpg',
            ),
            radius: 20,
          ),
          title: Text(request.name),
          subtitle: Text(
            // TODO iterate over list of plant quantities and names
            '${request.getPlantQuantities()[0]}x ${request.getPlantNames()[0]}...\n${request.postcode}',
          ),
          trailing: Text(
              "Active ${formatTimelapse(getTimelapse(request.time))} ago",
              style: isStale(getTimelapse(request.time)) 
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.black)
            ),
          tileColor: const Color.fromARGB(235, 245, 246, 246),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Widget>(
                // Redirects from board to a landowner profile
                builder:
                    (BuildContext context) => LandownerProfile(
                      title: 'Landowner Profile',
                      request: request,
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
    // Request = jsonParser(testRequestJson); // Pass the Json, returning a 3 objects, request, item and animal

    const String appTitle = 'Nearby places to find browse';
    final String username = widget.user.claims['given_name'];
    // TODO iterate over requests here

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
               // Icon to move to gatherer request board page
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
               // Icon to move to caretaker order request page
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
               // Icon to move to browse info page
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
          drawer: UserDrawer(username: username),
          // Request board area
          body: ListView.builder(
            itemCount: allRequests.length,
            itemBuilder: (context, index) {
                final request = allRequests[index];
                if (isActive(request.state)) {
                    return requestTile(request);
                  }
                  return Container();
            }
          ),
        ),
      ),
    );
  }
}

class LandownerProfile extends StatefulWidget {
  const LandownerProfile({
    super.key,
    required this.title,
    required this.request,
  });

  final String title;
  final Request request;
  
  @override
  State<LandownerProfile> createState() => _LandownerProfileState();
}

class _LandownerProfileState extends State<LandownerProfile> {
  bool _showAddress = false;
  bool _showPhone = false;

  Widget header(Request request) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          height: 100,
          child: Image(
            image: AssetImage('assets/images/${request.name}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                request.name, // TODO Need to give proper padding
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
        children: [Text("Browse Available"), Text("$plant x$quantity")],
      ),
    );
  }

  Widget landownerAddress(address, postcode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.place, size: 14)),
            _showAddress
                ? TextSpan(text: "Address\n$address, $postcode")
                // Will probably reimplement this to dynamically call for address once request accepted, for security
                // TODO lookup postcode for name of suburb to add to address
                : TextSpan(text: "Address\n******** $postcode"),
          ],
        ),
      ),
    );
  }


  Widget phoneNumber(phone) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.phone_android_outlined, size: 14)),
            _showPhone
                ? TextSpan(text: "Phone\n$phone")
                // Will probably reimplement this to dynamically call for address once request accepted, for security
                // TODO lookup postcode for name of suburb to add to address
                : TextSpan(),
          ],
        ),
      ),
    );
  }

// Archived, feature to be added after project conclusion
  // Widget directionsPanel() {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: RichText(
  //       text: TextSpan(
  //         children: [
  //           WidgetSpan(child: Icon(Icons.place, size: 14)),
  //           TextSpan(text: "Nearest browse\n"),
  //           WidgetSpan(
  //             child: GestureDetector(
  //               onTap: () async {
  //                 const url = 'https://maps.app.goo.gl/M6uQuJx1E7zVB9vu9';
  //                 try {
  //                   await launchUrl(Uri.parse(url));
  //                 } catch (e) {
  //                   print(
  //                     'Can not launch, must allow query in android/app/src/main/AndroidManifest.xml',
  //                   );
  //                 }
  //               },
  //               child: const Text(
  //                 "View on google maps",
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                   decoration: TextDecoration.underline,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget timelapse(request) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(child: Icon(Icons.timelapse, size: 14)),
            // TODO use a timestamp here
            TextSpan(
              text: " Active ${formatTimelapse(getTimelapse(request.time))} ago",
              style: isStale(getTimelapse(request.time)) 
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.black)
            ),
          ],
        ),
      ),
    );
  }

  Widget contactButton(request) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                _showPhone = true;
              });
            },
            child: Text(
              'Contact Landowner',
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
      appBar: AppBar(title: Text('${widget.request.name}\'s profile')),
      // Detailed request view
      body: ListView(
        padding: EdgeInsets.only(left: 30.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              header(widget.request),
              SizedBox(
                height: 20.0,
              ), 
              // TODO update phone to arg
              phoneNumber('0342212456'),
              const SizedBox(
                height: 15.0,
              ), // TODO May need to change this to a relative unit// TODO May need to change this to a relative unit
              browsePanel(widget.request.getPlantNames()[0], widget.request.getPlantQuantities()[0]),
              const SizedBox(
                height: 15.0,
              ), // TODO May need to change this to a relative unit
              landownerAddress(widget.request.address, widget.request.postcode),
              const SizedBox(
                height: 10.0,
              ), // TODO May need to change this to a relative unit
              // Archived directions
              // directionsPanel(),
              // const SizedBox(
              //   height: 10.0,
              // ), // TODO May need to change this to a relative unit
              timelapse(widget.request),
              const SizedBox(height: 20.0),
              contactButton(widget.request),
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

  // timeParts[0] = Days elapsed
  return timeParts[0] > 90;
}