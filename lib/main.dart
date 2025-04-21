import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/estoque.dart';
import 'package:globo_nitro/ui/home.dart';
import 'package:globo_nitro/ui/info.dart';
import 'package:globo_nitro/ui/produtos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nitro',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/produtos': (context) => ProdutosPage(),
        '/estoque': (context) => StockCheckScreen(),
        '/info': (context) => SobreScreen(),
      },
    );
  }
}
