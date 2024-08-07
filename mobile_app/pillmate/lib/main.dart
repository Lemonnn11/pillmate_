import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pillmate/pages/appearance.dart';
import 'package:pillmate/pages/drug_notification.dart';
import 'package:pillmate/pages/font_size.dart';
import 'package:pillmate/pages/homepage.dart';
import 'package:pillmate/pages/on_boarding_1.dart';
import 'package:pillmate/pages/search_pharmacy.dart';
import 'package:pillmate/pages/sign_in/login.dart';
import 'package:pillmate/pages/my_drug_list.dart';
import 'package:pillmate/pages/personal_information.dart';
import 'package:pillmate/pages/profile.dart';
import 'package:pillmate/pages/welcome_page.dart';
import 'package:pillmate/services/local_notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';

// final navigatorKey = GlobalKey<NavigatorState>();



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.3);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
          child: child!,
        );
      },
      theme: ThemeData(

      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/homepage',
      routes: {
        '/log-in': (context) => LoginPage(),
        '/homepage': (context) => Homepage(),
        '/my-drug-list': (context) => MyDrugList(),
        '/profile': (context) => ProfilePage(),
        '/personal-info': (context) => PersonalInformation(),
        '/drug-notification': (context) => DrugNotification(),
        '/welcome': (context) => WelcomePage(),
        '/search-pharmacy': (context) => SearchPharmacy(),
        '/appearance': (context) => Appearance(),
        '/font-size': (context) => FontSize(),
        '/on-boarding-1': (context) => OnBoarding1(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
