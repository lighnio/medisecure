import 'package:flutter/material.dart';
import 'package:medisecure/services/tests_service.dart';
import 'package:medisecure/views/dashboard/dashboard.dart';
import 'package:medisecure/views/login/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getBool('isLoggedIn') ?? false;
  print(status);
  runApp(ChangeNotifierProvider(create: (context) => TestServices(), child: MaterialApp(home: status != true ? Login() : Dashboard())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}