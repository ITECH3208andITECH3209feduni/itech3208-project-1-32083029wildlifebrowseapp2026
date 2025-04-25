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
                      '5 years\nEucalyptus Leaves\nCanadian',
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
                              body: 
                              Padding(padding: EdgeInsets.only(left: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/koala.jpg',
                                      ),
                                      radius: 1,
                                    ),
                                    title: const Text('Koala'),
                                    subtitle: const Text('5 years'),
                                    textColor: Color.fromARGB(235, 16, 17, 17),
                                  ),
                                  const SizedBox(height: 40.0,), // May need to change this to a relative unit
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Browse", textAlign: TextAlign.left),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Eucalyptus leaves",
                                      textAlign: TextAlign.left,
                                    )
                                  ),
                                  const SizedBox(height: 15.0,), // May need to change this to a relative unit
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(Icons.place, size: 14),
                                        ),
                                        TextSpan(
                                          text:
                                              "Delivery address\n231 Way, Ballarat Central, 3350",
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                  const SizedBox(height: 10.0,), // May need to change this to a relative unit
                                  Align(
                                    alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(Icons.place, size: 14),
                                        ),
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
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                  const SizedBox(height: 10.0,), // May need to change this to a relative unit
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
                                  ),),
                                  const SizedBox(height: 20.0,),
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
                                              alignment: Alignment.bottomCenter,
                                              child: FractionallySizedBox(
                                                widthFactor: 0.6,
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: ListTile(
                                                    title: Text(
                                                      'Accept',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                          0,
                                                          4,
                                                          7,
                                                          0.881,
                                                        ),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    tileColor:
                                                        const Color.fromARGB(
                                                          218,
                                                          182,
                                                          239,
                                                          154,
                                                        ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
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
                                              alignment: Alignment.bottomCenter,
                                              child: FractionallySizedBox(
                                                widthFactor: 0.6,
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: ListTile(
                                                    title: Text(
                                                      'Close',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                          0,
                                                          4,
                                                          7,
                                                          0.881,
                                                        ),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    tileColor:
                                                        const Color.fromARGB(
                                                          218,
                                                          255,
                                                          255,
                                                          255,
                                                        ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
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
                    subtitle: const Text('3 years\nGrass and Fruit\nWendouree'),
                    trailing: const Text('25m ago'),
                    tileColor: Color.fromARGB(235, 245, 246, 246),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('Eastern Grey Kangaroo'),
                              ),
                              body: Center(
                                child: Hero(
                                  tag: 'ListTile-Hero',
                                  child: Material(
                                    child: ListTile(
                                      title: const Text(
                                        'Close request',
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 4, 7, 0.881),
                                        ),
                                      ),
                                      tileColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.853,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
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
                        'assets/images/barenosedWombat.jpg',
                      ),
                      radius: 20,
                    ),
                    title: const Text('Bare-Nosed Wombat'),
                    subtitle: const Text('4 years\nGrass\nInvermay Park'),
                    trailing: const Text('45m ago'),
                    tileColor: Color.fromARGB(235, 245, 246, 246),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('Bare-Nosed Wombat'),
                              ),
                              body: Center(
                                child: Hero(
                                  tag: 'ListTile-Hero',
                                  child: Material(
                                    child: ListTile(
                                      title: const Text(
                                        'Close request',
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 4, 7, 0.881),
                                        ),
                                      ),
                                      tileColor: const Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.853,
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
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
