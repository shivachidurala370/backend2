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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
              SizedBox(
                height: 20,
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
