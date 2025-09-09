import 'package:flutter/material.dart';

import '../templates/drawer.dart';
import '../templates/browseList.dart';
import '../jsonParser.dart';
import '../auth/auth.dart';

import '../models/landowner.dart';

// Dummy request json data
import '../test/dummy_landowner.dart';

class LandownerRoute extends StatelessWidget {

  final User user;
  const LandownerRoute({super.key, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landowner Profiles',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
        scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 237, 1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
        useMaterial3: true,
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

  final List<Landowner> allProfiles = [
    jsonToObject(dummyLandowner, Landowner.fromJson),
    jsonToObject(dummyLandowner, Landowner.fromJson),
    jsonToObject(dummyLandowner, Landowner.fromJson),
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
  Widget requestTile(Landowner request) {
    return Hero(
      tag: request.userID,
      // Note if splash effects are needed, will need to change Card() to Material(), this will cause the margin to be lost
      child: Card(
        elevation: 4,
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/${request.userID}.jpg',
            ),
            radius: 20,
          ),
          title: Text(request.userID),
          subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < request.getBrowseNames().length; i++)
                Text('${request.getBrowseNames()[i]}')
            ],
          ),
          trailing: Text(
              " ${formatTimelapse(getTimelapse(request.timestamp))} ago",
              style: isStale(getTimelapse(request.timestamp)) 
                ? TextStyle(color: Colors.red)
                : TextStyle(color: Colors.black)
            ),
          tileColor: const Color.fromARGB(255, 246, 251, 244),
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
  // Landowner profiles overview board initial state
  Widget build(BuildContext context) {
    const String appTitle = 'Nearby places to find browse';
    final String username = widget.user.claims['given_name'];

    return MaterialApp(
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.black),
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
              // Icon to move to create new landowner listing
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromRGBO(245, 245, 237, 1),
                  minimumSize: Size(101, 38),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
                child: Text(
                  'Create new listing',
                  style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    '/landowner-registration',
                    arguments: {'user': widget.user},
                    );
                },
              )
            ],
          ),
          drawer: UserDrawer(username: username, user: widget.user),
          // Request board area
          body: ListView.builder(
            itemCount: allProfiles.length,
            itemBuilder: (context, index) {
                final request = allProfiles[index];
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
  final Landowner request;
  
  @override
  State<LandownerProfile> createState() => _LandownerProfileState();
}

class _LandownerProfileState extends State<LandownerProfile> {
  bool _showAddress = false;
  bool _showPhone = false;

  Widget header(Landowner request) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 100,
          height: 100,
          child: Image(
            image: AssetImage('assets/images/${request.userID}.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                request.userID, // TODO Need to give proper padding
                style: TextStyle(color: Color.fromARGB(235, 16, 17, 17)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget browsePanel(browses) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset.zero,
                blurRadius: 4,
                spreadRadius: 3,
              ),
            ]
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    color: const Color.fromARGB(255, 230, 230, 230),
                  ),
                  child: Text(
                    "Browse Available",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                for (int i = 0; i < widget.request.getBrowseNames().length; i++)
                  Text(
                    '${widget.request.getBrowseNames()[i]}',
                    style: TextStyle(color: Color.fromARGB(255, 230, 230, 230))
                    ),
              ],
            )
          )
        )
      )
    );
  }

  Widget landownerAddress(address, postcode) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.place, size: 14),
              Text(
                "Address:",
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ], 
          ),
          _showAddress
            ? Text("$address, $postcode")
            // Will probably reimplement this to dynamically call for address once request accepted, for security
            // TODO lookup postcode for name of suburb to add to address
            : Text("Postcode: $postcode"),
        ]
      ),
    );
  }

  Widget phoneNumber(phone) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone_android_outlined, size: 14),
              Text(
                "Phone:",
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ], 
          ),
          _showPhone
              ? Text("$phone")
              : Text("To contact the landowner, please click 'contact' below to reveal their phone number"),
        ]
      ),
    );
  }

  Widget visitingTimes(visit) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.time_to_leave, size: 14),
              Text(
                "Visiting Times:",
                style: TextStyle(fontWeight: FontWeight.bold),
                ),
            ], 
          ),
          Text('$visit'),
        ]
      ),
    );
  }

  Widget accessDetails(details) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        // Need this to force left alignment of children
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.call_to_action_outlined, size: 14),
              Text(
                "Property access details:", 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ], 
          ),
          Text(
            details,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              inherit: false,
              ),
            ),
        ]
      ),
    );
  }

  Widget advanceWarning(preference) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        // Need this to force left alignment of children
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notification_add, size: 14),
              Text(
                "Advance warning needed?", 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ], 
          ),
          Text(
            preference,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              inherit: false,
              ),
            ),
        ]
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
              text: " Active ${formatTimelapse(getTimelapse(request.timestamp))} ago",
              style: isStale(getTimelapse(request.timestamp)) 
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
      backgroundColor: const Color.fromRGBO(245, 245, 237, 1),
      appBar: AppBar(title: Text('${widget.request.userID}\'s profile')),
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
              phoneNumber(widget.request.phone),
              const SizedBox(
                height: 15.0,
              ), // TODO May need to change this to a relative unit
              browsePanel(widget.request.getBrowseNames()),
              const SizedBox(
                height: 15.0,
              ),
              landownerAddress(widget.request.address, widget.request.postcode),
              const SizedBox(
                height: 10.0,
              ),
              timelapse(widget.request),
              const SizedBox(height: 10.0),
              visitingTimes("Monday & Thursday evenings"),
              const SizedBox(height: 10.0),
              advanceWarning("Yes"),
              const SizedBox(height: 20.0),
              contactButton(widget.request),
              const SizedBox(height: 10.0),
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

String getTimelapse(requestTime) {
  // Will need to handle parsing better once dealing with different timezones, use toUTC or toLocal?
  DateTime parsedDate = DateTime.parse(requestTime);
  Duration difference = DateTime.now().difference(parsedDate);
  int parsedDifference = difference.inSeconds;

  int daysElapsed = parsedDifference ~/ (24 * 3600);
  int hoursElapsed = (parsedDifference % (24 * 3600)) ~/ 3600;
  int minutesElapsed = (parsedDifference % 3600) ~/ 60;

  String timelapse = '${daysElapsed}:${hoursElapsed}:${minutesElapsed}';

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
      timelapse = '${minElapsed}m';
    }
  }

  return timelapse;
}

bool isStale(timelapse) {
  List<int> timeParts = timelapse.split(":").map<int>((str) => int.parse(str)).toList();

  // timeParts[0] = Days elapsed
  return timeParts[0] > 90;
}