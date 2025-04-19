import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final TextEditingController numeroController = TextEditingController();
final List<String> etiquetasDuplicadasList = [];

class etiquetaDuplicadoPage extends StatefulWidget {
  @override
  _etiquetaDuplicadoPageState createState() => _etiquetaDuplicadoPageState();
}

class _etiquetaDuplicadoPageState extends State<etiquetaDuplicadoPage> {
  final TextEditingController codigoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preenche o TextField apenas com os códigos formatados
    if (etiquetasDuplicadasList.isNotEmpty) {
      final textoInicial = etiquetasDuplicadasList
          .map((codigo) => codigo.trim())
          .where((c) => c.isNotEmpty)
          .join(',\n');

      codigoController.text = textoInicial;
      codigoController.selection = TextSelection.fromPosition(
        TextPosition(offset: codigoController.text.length),
      );
    }

    // Só agora adiciona o listener
    codigoController.addListener(() {
      final texto = codigoController.text;

      // Evita múltiplas vírgulas ou quebras de linha desnecessárias
      if (texto.isNotEmpty && !texto.endsWith(',\n')) {
        final novoTexto = '${texto.trimRight()},\n';

        // Evita atualizar se já estiver igual
        if (texto != novoTexto) {
          codigoController.text = novoTexto;
          codigoController.selection = TextSelection.fromPosition(
            TextPosition(offset: codigoController.text.length),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    codigoController.dispose();
    numeroController.dispose();
    super.dispose();
  }

  void salvarCodigo() {
    final textoCompleto = codigoController.text.trim();

    // Remove quebras de linha duplas ou finais
    final textoLimpo = textoCompleto.replaceAll(RegExp(r',\s*\n'), ',\n');

    List<String> codigos =
        textoLimpo
            .split(',')
            .map((c) => c.trim())
            .where((c) => c.isNotEmpty)
            .toList();

    setState(() {
      etiquetasDuplicadasList.addAll(
        codigos.where((c) => !etiquetasDuplicadasList.contains(c)),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${codigos.length} código(s) salvo(s)!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Etiquetas Duplicados',
          style: TextStyle(color: Colors.white),
        ),
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

          // Onda na parte de baixo
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

          // Conteúdo principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Escaneie ou digite o código de barras:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: numeroController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: 'Quantidade para duplicar',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Campo de texto grande
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: codigoController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Código de barras...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // |Botoes de salvar e limpa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 165,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            codigoController.clear();
                            etiquetasDuplicadasList.clear();
                          },
                          icon: Icon(Icons.clear, color: Colors.white),
                          label: Text(
                            'Limpar',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              247,
                              65,
                              65,
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        width: 165,
                        child: ElevatedButton.icon(
                          onPressed: salvarCodigo,
                          icon: Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              20,
                              121,
                              189,
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                        ),
                      ),
                    ],
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
