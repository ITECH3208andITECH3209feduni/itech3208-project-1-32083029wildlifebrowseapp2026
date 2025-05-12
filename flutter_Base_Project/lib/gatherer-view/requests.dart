import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          // Request board
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: 'Koala',
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
                          builder: (BuildContext context) => const DetailedRequest(title: 'Request Details'),
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
            Row(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image(
                    image: AssetImage('assets/images/koala.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '  Koala', // TODO Need to give proper padding
                      style: TextStyle(color: Color.fromARGB(235, 16, 17, 17)),
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
              child: Text("Browse", textAlign: TextAlign.left),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Eucalyptus leaves", textAlign: TextAlign.left),
            ),
            const SizedBox(
              height: 15.0,
            ), // TODO May need to change this to a relative unit
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(Icons.place, size: 14)),
                    _showAddress
                        ? TextSpan(
                          text:
                              "Delivery address\n231 Way, Ballarat Central, 3350",
                        )
                        : TextSpan(text: "Delivery address\nHidden"),
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
                    WidgetSpan(child: Icon(Icons.place, size: 14)),
                    TextSpan(text: "Nearest browse\n"),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () async {
                          const url =
                              'https://maps.app.goo.gl/M6uQuJx1E7zVB9vu9';
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
            ),
            const SizedBox(
              height: 10.0,
            ), // TODO May need to change this to a relative unit
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(Icons.timelapse, size: 14)),
                    TextSpan(text: "Submitted 2h ago"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
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
                      // Navigator.pop(context);
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
            ),
          ],
        ),
      ),
    );
  }
}