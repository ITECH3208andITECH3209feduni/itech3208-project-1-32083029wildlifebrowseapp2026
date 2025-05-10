import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const BrowseApp());
}

class BrowseApp extends StatelessWidget {
  const BrowseApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Browse',
      theme: ThemeData(
        listTileTheme: const ListTileThemeData(textColor: Colors.white),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(46, 165, 107, 1),
        ),
      ),
      home: const HomePage(title: 'Request Board'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _ListTileState();
}

class _ListTileState extends State<HomePage> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Browse';
    return MaterialApp(
      title: appTitle,
      // SafeArea ensures that the view isn't obstructed by phone notch/status bar/bezel
      home: SafeArea(
        minimum: const EdgeInsets.all(12.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(appTitle),
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
                    subtitle: const Text(
                      'Eucalyptus Leaves\nCanadian',
                    ),
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
                                          '  Koala', // Need to give proper padding
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
                                    )]),
                                    SizedBox(
                                      height: 20.0,
                                    ), // May need to change this to a relative unit
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
                                                  "Delivery address\n231 Way, Ballarat Central, 3350",
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
                      backgroundImage: AssetImage('assets/images/egKangaroo.jpg'),
                      radius: 20,
                    ),
                    title: const Text('Eastern Grey Kangaroo'),
                    subtitle: const Text(
                      'Grasses\nMt Helen',
                    ),
                    trailing: const Text('30m ago'),
                    tileColor: const Color.fromARGB(235, 245, 246, 246),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('Eastern Grey Kangaroo request'),
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
                                    )]),
                                    SizedBox(
                                      height: 20.0,
                                    ), // May need to change this to a relative unit
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Browse",
                                        style: TextStyle(fontWeight: FontWeight.w600),
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
                                            TextSpan(text: " Nearest browse\n"), // Fix with proper padding
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
                                            TextSpan(text: " Submitted 2h ago"), // Fix with proper padding
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
