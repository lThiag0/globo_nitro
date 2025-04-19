import 'package:flutter/material.dart';

final List<String> etiquetasAmarelasList = [];

class etiquetaAmarelaPage extends StatefulWidget {
  @override
  _etiquetaAmarelaPageState createState() => _etiquetaAmarelaPageState();
}

class _etiquetaAmarelaPageState extends State<etiquetaAmarelaPage> {
  final TextEditingController codigoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preenche o TextField apenas com os códigos formatados
    if (etiquetasAmarelasList.isNotEmpty) {
      final textoInicial = etiquetasAmarelasList
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
      etiquetasAmarelasList.addAll(
        codigos.where((c) => !etiquetasAmarelasList.contains(c)),
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
          'Etiquetas Amarelas',
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

                  SizedBox(height: 30),

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

                  SizedBox(height: 30),
                  // |Botoes de salvar e limpa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 165,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            codigoController.clear();
                            etiquetasAmarelasList.clear();
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
