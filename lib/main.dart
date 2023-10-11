import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';
import 'manager/auth_manager.dart';
import 'network calls/base_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  bool _loading = false;

  Future<void> _performLogin() async {
    String number = _usernamecontroller.text.trim();
    String password = _passwordcontroller.text.trim();

    if (number.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter Your Number");
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter valid Password");
      return;
    }

    setState(() {
      _loading = true;
    });

    final response = await authManager.performlogin(number, password);

    setState(() {
      _loading = false;
    });

    if (response.status == ResponseStatus.SUCCESS) {
      print("data of response is --${response.data}");
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
        // NavigationService().navigatePage(OTPPage(phoneNumber: number,));
      });
      // Fluttertoast.showToast(msg: response.message!);
    } else {
      Fluttertoast.showToast(msg: response.message!);
    }

    setState(() {
      _loading = false;
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _usernamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter Username"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: _passwordcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Enter Password"),
              ),
              TextButton(
                  onPressed: () {
                    _performLogin();
                  },
                  child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
