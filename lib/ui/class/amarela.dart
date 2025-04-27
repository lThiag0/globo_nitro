import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/class/scancamera.dart';
import 'package:globo_nitro/ui/produtos.dart';

final List<String> etiquetasAmarelasList = [];

class EtiquetaAmarelaPage extends StatefulWidget {
  const EtiquetaAmarelaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EtiquetaAmarelaPageState createState() => _EtiquetaAmarelaPageState();
}

// ignore: camel_case_types
class _EtiquetaAmarelaPageState extends State<EtiquetaAmarelaPage> {
  final TextEditingController codigoController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (etiquetasAmarelasList.isNotEmpty) {
      final textoInicial = etiquetasAmarelasList
          .map((codigo) => codigo.trim())
          .where((c) => c.isNotEmpty)
          .join('\n');

      codigoController.text = textoInicial;
      codigoController.selection = TextSelection.fromPosition(
        TextPosition(offset: codigoController.text.length),
      );
    }

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // Quando o campo é clicado, mover o cursor para a última linha
        _moverCursorParaUltimaLinha();
      }
    });
  }

  // Função para mover o cursor para a última linha
  void _moverCursorParaUltimaLinha() {
    final textoAtual = codigoController.text;
    if (textoAtual.isNotEmpty && !textoAtual.endsWith('\n')) {
      // Se o texto não terminar com uma linha em branco, adicionar uma
      codigoController.text = '$textoAtual\n';
    }
    // Mover o cursor para o final do texto
    codigoController.selection = TextSelection.fromPosition(
      TextPosition(offset: codigoController.text.length),
    );
  }

  void salvarCodigo() {
    if (codigoController.text.isNotEmpty) {
      // Limpar a lista de códigos após salvar (com ou sem duplicados)
      etiquetasAmarelasList.clear();
      // Adiciona os códigos à lista
      final novosCodigos = codigoController.text.split('\n');

      // Adiciona a vírgula ao final de cada código, se ainda não tiver
      for (var codigo in novosCodigos) {
        String codigoFormatado = codigo.trim();
        if (codigoFormatado.isNotEmpty &&
            !etiquetasAmarelasList.contains('$codigoFormatado,')) {
          if (!codigoFormatado.endsWith(',')) {
            codigoFormatado += ',';
          }
          etiquetasAmarelasList.add(codigoFormatado);
        }
      }

      // Atualiza a UI
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${etiquetasAmarelasList.length} código(s) salvo(s)!'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProdutosPage()),
      ).then((_) => setState(() {}));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi encontrado nem um codigo escaneado!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
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

                  SizedBox(height: 20),
                  // Escanear pela camera do celular
                  SizedBox(
                    width: 350,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final codigosEscaneados =
                            await Navigator.push<List<String>>(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ScannerPage(), // sem callback
                              ),
                            );

                        if (codigosEscaneados != null &&
                            codigosEscaneados.isNotEmpty) {
                          setState(() {
                            for (var codigo in codigosEscaneados) {
                              if (!etiquetasAmarelasList.contains(codigo)) {
                                //etiquetasAmarelasList.add(codigo);
                                final textoAtual =
                                    codigoController.text.trimRight();
                                final novoTexto =
                                    textoAtual.isEmpty
                                        ? '$codigo,\n'
                                        : '$textoAtual\n$codigo,\n';
                                codigoController.text = novoTexto;
                                codigoController
                                    .selection = TextSelection.fromPosition(
                                  TextPosition(
                                    offset: codigoController.text.length,
                                  ),
                                );
                              }
                            }
                          });
                        }
                      },
                      icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                      label: Text(
                        'Escanear pela câmera',
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

                  SizedBox(height: 15),

                  // Campo de texto grande
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: codigoController,
                      focusNode: focusNode,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Código de barras...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  // |Botoes de salvar e limpa
                  SizedBox(
                    width: 350,
                    child: Row(
                      children: [
                        Expanded(
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
                              backgroundColor: Color.fromARGB(255, 247, 65, 65),
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: salvarCodigo,
                            icon: Icon(Icons.save, color: Colors.white),
                            label: Text(
                              'Salvar',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
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
