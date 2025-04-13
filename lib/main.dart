import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Relatórios',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
