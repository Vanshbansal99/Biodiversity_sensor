import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syngenta/homepage.dart';
import 'login.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sygenta Overview',
      theme: ThemeData.light(),
      // home: const HomeScreen(
      //   email: 'milanpreetkaur502@gmail.com',
      //   // email: 'DEsensor@gmail.com',
      // ),
        initialRoute: '/login', // Set initial route to login screen
      routes: {
        '/login': (context) => Login(),
         '/home': (context) => const HomePage(email: 'milanpreetkaur502@gmail.com'),
        // '/config': (context) => const ConfigScreen(deviceId: 'D0315', userName: 'milanpreetkaur502@gmail.com'),
      },
    );
  }
}