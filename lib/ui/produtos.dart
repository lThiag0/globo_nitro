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
    try {
      if (etiquetasBrancasList.isEmpty &&
          etiquetasAmarelasList.isEmpty &&
          etiquetasDuplicadasList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhuma etiqueta escaneada para gerar.')),
        );
        return;
      }

      final numero = numeroController.text.trim();
      final buffer = StringBuffer();

      buffer.writeln('Relatório de Etiquetas Nitro:');
      buffer.writeln('\n');
      // If de etiquetas Brancas
      if (etiquetasBrancasList.isNotEmpty) {
        buffer.writeln('Códigos de etiquetas Brancas:');
        for (var codigo in etiquetasBrancasList) {
          buffer.writeln('$codigo,');
        }
        //conteudo.writeln('\n');
        buffer.writeln('\n');
      }
      // If de etiquetas Amarelas
      if (etiquetasAmarelasList.isNotEmpty) {
        buffer.writeln('Códigos de etiquetas Amarelas:');
        for (var codigo in etiquetasAmarelasList) {
          buffer.writeln('$codigo,');
        }
        //conteudo.writeln('\n');
        buffer.writeln('\n');
      }
      // If de etiquetas Duplicadas
      if (etiquetasDuplicadasList.isNotEmpty) {
        buffer.writeln('Códigos de etiquetas Duplicadas:');
        buffer.writeln('Número para duplica: $numero');
        buffer.writeln('\n');
        for (var codigo in etiquetasDuplicadasList) {
          buffer.writeln('$codigo,');
        }
      }

      final textoFinal = buffer.toString();

      // Compartilhar usando o share_plus
      Share.share(textoFinal);
    } catch (e, stackTrace) {
      debugPrint('Erro ao gerar etiquetas: $e');
      debugPrint(stackTrace.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar as etiquetas. Tente novamente.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Aguarda o frame inicial renderizar antes de mostrar o diálogo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verificarEtiquetasSalvas();
    });
  }

  void _verificarEtiquetasSalvas() {
    // Verifica se há códigos nas listas de etiquetas
    if (etiquetasBrancasList.isNotEmpty ||
        etiquetasAmarelasList.isNotEmpty ||
        etiquetasDuplicadasList.isNotEmpty) {
      // Exibe um diálogo perguntando ao usuário o que deseja fazer
      _mostrarDialogo();
    }
  }

  void _mostrarDialogo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Códigos Escaneados salvos'),
          content: Text(
            'Há códigos escaneados salvos. Deseja continuar com esses códigos ou limpar?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Limpar as listas de etiquetas
                setState(() {
                  etiquetasBrancasList.clear();
                  etiquetasAmarelasList.clear();
                  etiquetasDuplicadasList.clear();
                });
                Navigator.of(context).pop();
              },
              child: Text('Limpar Códigos'),
            ),
            TextButton(
              onPressed: () {
                // Apenas fecha o diálogo e mantém os códigos salvos
                Navigator.of(context).pop();
              },
              child: Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Etiquetas', style: TextStyle(color: Colors.white)),
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
              'assets/image/ondaDeBaixo.png',
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
