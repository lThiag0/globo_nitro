import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key); // 🔄 Removido onFinishScan

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.ean13, BarcodeFormat.ean8],
  );

  final Set<String> codigosLidos = {};

  Future<void> _playBeep() async {
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('sound/beepscan.mp3'));
      await player.dispose();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao tocar bip: $e'),
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _finalizar() {
    if (codigosLidos.isEmpty) {
      Navigator.pop(context); // Volta sem enviar dados
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text('Finalizar escaneamento?'),
              content: Text(
                'Você leu ${codigosLidos.length} código(s). Deseja confirmar?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Fecha o dialog
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha o dialog
                    Navigator.pop(
                      context,
                      codigosLidos.toList(),
                    ); // Retorna dados
                  },
                  child: Text('Confirmar'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneando Vários Códigos'),
        backgroundColor: const Color.fromARGB(255, 20, 121, 189),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              cameraController.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Finalizar escaneamento',
            onPressed: _finalizar,
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (barcodeCapture) {
          for (final barcode in barcodeCapture.barcodes) {
            final code = barcode.rawValue;
            if (code != null &&
                code.isNotEmpty &&
                !codigosLidos.contains(code)) {
              codigosLidos.add(code);
              _playBeep();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Código adicionado: $code'),
                  duration: Duration(milliseconds: 700),
                ),
              );
              setState(() {});
            }
          }
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey[200],
        child: Text(
          'Total de códigos lidos: ${codigosLidos.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
