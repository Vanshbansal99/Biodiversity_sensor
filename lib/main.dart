import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syngenta/homepage.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
  Widget build(BuildContext context){
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        email: 'milanpreetkaur502@gmail.com',
        
      )

      );

  }
}