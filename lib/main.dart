import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/home.dart';
import 'package:globo_nitro/ui/produtos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Relatórios',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/produtos': (context) => ProdutosPage(),
      },
    );
  }
}

class TelaComBotao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela com Botão')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Texto Centralizado', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20), // Espaço entre o texto e o botão
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Clique aqui'),
            ),
          ],
        ),
      ),
    );
  }
}
