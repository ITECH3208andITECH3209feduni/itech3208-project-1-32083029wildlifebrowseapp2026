import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(46, 165, 107, 1)),
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
                subtitle: const Text('5 years\nEucalyptus Leaves\nCanadian\t5m ago'),
                tileColor: const Color.fromARGB(235, 245, 246, 246),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: const Text('Koala request')),
                          body: Center(
                            child: Hero(
                              tag: 'ListTile-Hero',
                              child: Material(
                                child: ListTile(
                                  title: const Text(
                                    'Close request',
                                    style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),),
                                  tileColor: const Color.fromRGBO(255, 255, 255, 0.853),
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
          SizedBox(height: 5,),
          Hero(
            tag: 'ListTile-Hero',
            child: Material(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/egKangaroo.jpg'),
                  radius: 20,
                ),
                title: const Text('Eastern Grey Kangaroo'),
                subtitle: const Text('3 years\nGrass and Fruit\nWendouree\t25m ago'),
                tileColor: Color.fromARGB(235, 245, 246, 246),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: const Text('Eastern Grey Kangaroo')),
                          body: Center(
                            child: Hero(
                              tag: 'ListTile-Hero',
                              child: Material(
                                child: ListTile(
                                  title: const Text(
                                    'Close request',
                                    style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),),
                                  tileColor: const Color.fromRGBO(255, 255, 255, 0.853),
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
          SizedBox(height: 5,),
          Hero(
            tag: 'ListTile-Hero',
            child: Material(
              child: ListTile(
                  leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/barenosedWombat.jpg'),
                  radius: 20,
                ),
                title: const Text('Bare-Nosed Wombat'),
                subtitle: const Text('4 years\nGrass\nInvermay Park\t45m ago'),
                tileColor: Color.fromARGB(235, 245, 246, 246),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(title: const Text('Bare-Nosed Wombat')),
                          body: Center(
                            child: Hero(
                              tag: 'ListTile-Hero',
                              child: Material(
                                child: ListTile(
                                  title: const Text(
                                    'Close request',
                                    style: TextStyle(color: Color.fromRGBO(0, 4, 7, 0.881)),),
                                  tileColor: const Color.fromRGBO(255, 255, 255, 0.853),
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
    )));
  }
}
