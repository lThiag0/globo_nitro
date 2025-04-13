import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/class/amarela.dart';
import 'package:globo_nitro/ui/class/branca.dart';
import 'package:globo_nitro/ui/class/duplicado.dart';
import 'package:share_plus/share_plus.dart';

class ProdutosPage extends StatefulWidget {
  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  void gerarEtiquetas() {
    final numero = numeroController.text.trim();

    if (etiquetasBrancasList.isEmpty ||
        etiquetasAmarelasList.isEmpty ||
        etiquetasDuplicadasList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Escaneie ao menos 1 código de produto!')),
      );
      return;
    }

    final conteudo = StringBuffer();
    conteudo.writeln('Relatório de Etiquetas Nitro:');

    // If de etiquetas Brancas
    if (etiquetasBrancasList.isNotEmpty) {
      conteudo.writeln('Códigos escaneados de etiquetas Brancas:');
      for (var codigo in etiquetasBrancasList) {
        conteudo.writeln(codigo);
      }
      conteudo.writeln('\n');
      conteudo.writeln('\n');
    }
    // If de etiquetas Brancas
    if (etiquetasAmarelasList.isNotEmpty) {
      conteudo.writeln('Códigos escaneados de etiquetas Amarelas:');
      for (var codigo in etiquetasAmarelasList) {
        conteudo.writeln(codigo);
      }
      conteudo.writeln('\n');
      conteudo.writeln('\n');
    }
    // If de etiquetas Brancas
    if (etiquetasDuplicadasList.isNotEmpty) {
      conteudo.writeln('Códigos escaneados de etiquetas Duplicadas:');
      for (var codigo in etiquetasDuplicadasList) {
        conteudo.writeln('Número para duplica: $numero');
        conteudo.writeln('----------------------------');
        conteudo.writeln(codigo);
      }
    }

    Share.share(conteudo.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Produtos', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 121, 189),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Onda no topo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Image.asset(
              'assets/image/ondaDebaixo.png',
              fit: BoxFit.cover,
            ),
          ),

          // Onda no rodapé
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Image.asset(
              'assets/image/ondaDeCima.png',
              fit: BoxFit.cover,
            ),
          ),

          // Conteúdo centralizado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Escolha uma opção de etiqueta:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 40),

                  // Botão 1
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação do botão
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => etiquetaBrancaPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          20,
                          121,
                          189,
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Etiquetas brancas',
                        style: TextStyle(
                          //fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Botão 2
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação do botão
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => etiquetaAmarelaPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          20,
                          121,
                          189,
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Etiquetas Amarelas',
                        style: TextStyle(
                          //fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Botão 3
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        // Ação do botão
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => etiquetaDuplicadoPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          20,
                          121,
                          189,
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Etiquetas Duplicadas',
                        style: TextStyle(
                          //fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Botão 4
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: gerarEtiquetas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 247, 65, 65),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Gerar Etiquetas',
                        style: TextStyle(
                          //fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
