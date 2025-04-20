import 'package:flutter/material.dart';
import 'package:globo_nitro/ui/class/scancamera.dart';

final List<String> etiquetasBrancasList = [];

class EtiquetaBrancaPage extends StatefulWidget {
  const EtiquetaBrancaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EtiquetaBrancaPageState createState() => _EtiquetaBrancaPageState();
}

class _EtiquetaBrancaPageState extends State<EtiquetaBrancaPage> {
  final TextEditingController codigoController = TextEditingController();

  bool _isAtualizandoTexto = false;

  @override
  void initState() {
    super.initState();

    if (etiquetasBrancasList.isNotEmpty) {
      final textoInicial = etiquetasBrancasList
          .map((codigo) => codigo.trim())
          .where((c) => c.isNotEmpty)
          .join(',\n');

      codigoController.text = textoInicial;
      codigoController.selection = TextSelection.fromPosition(
        TextPosition(offset: codigoController.text.length),
      );
    }

    codigoController.addListener(() {
      if (_isAtualizandoTexto) return;

      String texto = codigoController.text;

      // Se o usuário apagou, não força vírgula
      if (texto.isEmpty) return;

      // Verifica se ele está digitando e não usando backspace
      if (!texto.endsWith(',\n')) {
        _isAtualizandoTexto = true;

        // Verifica se a última letra é um número ou letra antes de aplicar o ",\n"
        if (RegExp(r'[a-zA-Z0-9]$').hasMatch(texto)) {
          codigoController.text = '$texto,\n';
          codigoController.selection = TextSelection.fromPosition(
            TextPosition(offset: codigoController.text.length),
          );
        }

        _isAtualizandoTexto = false;
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
      etiquetasBrancasList.addAll(
        codigos.where((c) => !etiquetasBrancasList.contains(c)),
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
        title: Text('Etiquetas Brancas', style: TextStyle(color: Colors.white)),
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
                              if (!etiquetasBrancasList.contains(codigo)) {
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

                  SizedBox(height: 10),

                  // |Botoes de salvar e limpa
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            codigoController.clear();
                            etiquetasBrancasList.clear();
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
                            backgroundColor: Color.fromARGB(255, 20, 121, 189),
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
