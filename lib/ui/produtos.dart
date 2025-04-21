import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/class/amarela.dart';
import 'package:globo_nitro/ui/class/branca.dart';
import 'package:globo_nitro/ui/class/duplicado.dart';
import 'package:share_plus/share_plus.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  // Variável para controlar o estado de carregamento
  bool _isLoading = false;

  void gerarEtiquetas() async {
    try {
      // Se nenhuma etiqueta foi escaneada, mostra SnackBar e retorna
      if (etiquetasBrancasList.isEmpty &&
          etiquetasAmarelasList.isEmpty &&
          etiquetasDuplicadasList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nenhuma etiqueta escaneada para gerar.')),
        );
        return;
      }

      // Inicia o processo de carregamento
      setState(() {
        _isLoading = true;
      });

      // Exibe o diálogo de carregamento
      showDialog(
        context: context,
        barrierDismissible: false, // Impede que o usuário feche o diálogo
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Gerando etiquetas...'),
              ],
            ),
          );
        },
      );

      final numero = numeroController.text.trim();
      final buffer = StringBuffer();

      buffer.writeln('Relatório de Etiquetas Nitro:');
      buffer.writeln('\n');

      // Processa as etiquetas Brancas
      if (etiquetasBrancasList.isNotEmpty) {
        buffer.writeln('Códigos de etiquetas Brancas:');
        for (var codigo in etiquetasBrancasList) {
          buffer.writeln(codigo);
        }
        buffer.writeln('\n');
      }

      // Processa as etiquetas Amarelas
      if (etiquetasAmarelasList.isNotEmpty) {
        buffer.writeln('Códigos de etiquetas Amarelas:');
        for (var codigo in etiquetasAmarelasList) {
          buffer.writeln(codigo);
        }
        buffer.writeln('\n');
      }

      // Processa as etiquetas Duplicadas
      if (etiquetasDuplicadasList.isNotEmpty) {
        buffer.writeln('Códigos de etiquetas Duplicadas:');
        buffer.writeln('Número para duplica: $numero');
        buffer.writeln('\n');
        for (var codigo in etiquetasDuplicadasList) {
          buffer.writeln(codigo);
        }
      }

      final textoFinal = buffer.toString();

      // Compartilha as etiquetas geradas
      Share.share(textoFinal);

      // Fecha o diálogo de carregamento
      Navigator.of(context).pop();
    } catch (e, stackTrace) {
      // Caso ocorra um erro
      debugPrint('Erro ao gerar etiquetas: $e');
      debugPrint(stackTrace.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar as etiquetas. Tente novamente.')),
      );

      // Fecha o diálogo de carregamento em caso de erro
      Navigator.of(context).pop();
    } finally {
      // Desativa o carregamento independentemente do sucesso ou falha
      setState(() {
        _isLoading = false;
      });
    }
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
                  // Botões de opções de etiquetas
                  _buildEtiquetaButton(
                    'Etiquetas brancas',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtiquetaBrancaPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildEtiquetaButton(
                    'Etiquetas Amarelas',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtiquetaAmarelaPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildEtiquetaButton(
                    'Etiquetas Duplicadas',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtiquetaDuplicadoPage(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Botão para gerar as etiquetas
                  _buildEtiquetaButton(
                    'Gerar Etiquetas',
                    gerarEtiquetas,
                    backgroundColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Função auxiliar para criar botões
  Widget _buildEtiquetaButton(
    String label,
    VoidCallback onPressed, {
    Color backgroundColor = const Color.fromARGB(255, 20, 121, 189),
  }) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed:
            _isLoading
                ? null
                : onPressed, // Desabilita o botão durante o carregamento
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size(double.infinity, 50),
        ),
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
