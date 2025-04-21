import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globo_nitro/ui/class/scancamera.dart';

final TextEditingController numeroController = TextEditingController();
final List<String> etiquetasDuplicadasList = [];

class EtiquetaDuplicadoPage extends StatefulWidget {
  const EtiquetaDuplicadoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EtiquetaDuplicadoPageState createState() => _EtiquetaDuplicadoPageState();
}

class _EtiquetaDuplicadoPageState extends State<EtiquetaDuplicadoPage> {
  final TextEditingController codigoController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (etiquetasDuplicadasList.isNotEmpty) {
      final textoInicial = etiquetasDuplicadasList
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
    if (codigoController.text.isNotEmpty && numeroController.text.isNotEmpty) {
      // Limpar a lista de códigos após salvar (com ou sem duplicados)
      etiquetasDuplicadasList.clear();
      // Adiciona os códigos à lista
      final novosCodigos = codigoController.text.split('\n');

      // Adiciona a vírgula ao final de cada código, se ainda não tiver
      for (var codigo in novosCodigos) {
        String codigoFormatado = codigo.trim();
        if (codigoFormatado.isNotEmpty &&
            !etiquetasDuplicadasList.contains('$codigoFormatado,')) {
          if (!codigoFormatado.endsWith(',')) {
            codigoFormatado += ',';
          }
          etiquetasDuplicadasList.add(codigoFormatado);
        }
      }

      // Atualiza a UI
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${etiquetasDuplicadasList.length} código(s) salvo(s)!',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi encontrado nem um codigo escaneado ou quantidade para duplicar!',
          ),
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
                              if (!etiquetasDuplicadasList.contains(codigo)) {
                                //etiquetasBrancasList.add(codigo);
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
                  SizedBox(
                    width: 350,
                    child: TextField(
                      controller: codigoController,
                      focusNode: focusNode,
                      maxLines: 7,
                      decoration: InputDecoration(
                        hintText: 'Código de barras...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 350,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              codigoController.clear();
                              etiquetasDuplicadasList.clear();
                              numeroController.clear();
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
