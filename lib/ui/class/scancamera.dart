import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.ean13, BarcodeFormat.ean8],
  );

  final Set<String> codigosLidos = {};
  late final AudioPlayer _player;
  bool _canScan = true;
  bool isTorchOn = false;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    cameraController.dispose();
    super.dispose();
  }

  Future<void> _playBeep() async {
    try {
      await _player.play(AssetSource('sound/beepscan.mp3'));
    } catch (e) {
      // Se ocorrer um erro, exibe um log detalhado
      debugPrint('Erro ao tocar o beep: ${e.toString()}');

      // Opcional: exibir uma mensagem na interface do usuário, caso o erro aconteça
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao reproduzir o som de beep.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleTorch() {
    setState(() {
      isTorchOn = !isTorchOn;
    });
    cameraController.toggleTorch();
  }

  void _removerCodigo(String codigo) {
    setState(() {
      codigosLidos.remove(codigo); // Remove o código da lista
    });

    // Exibe uma mensagem de confirmação (opcional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código removido: $codigo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _finalizar() {
    if (codigosLidos.isEmpty) {
      Navigator.pop(context);
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
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, codigosLidos.toList());
                  },
                  child: Text('Confirmar'),
                ),
              ],
            ),
      );
    }
  }

  void _onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    if (!_canScan) return;

    setState(() {
      isScanning = true;
    });

    for (final barcode in barcodeCapture.barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty && !codigosLidos.contains(code)) {
        codigosLidos.add(code);
        setState(() {});
        await _playBeep();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código adicionado: $code'),
            duration: Duration(milliseconds: 700),
          ),
        );
        _canScan = false;
        await Future.delayed(Duration(milliseconds: 800));
        _canScan = true;
      }
    }

    setState(() {
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Escaneando Vários Códigos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 121, 189),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _toggleTorch,
            icon: Icon(
              isTorchOn ? Icons.flash_on : Icons.flash_off,
              color: isTorchOn ? Colors.yellow : Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            tooltip: 'Finalizar escaneamento',
            onPressed: _finalizar,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: _onBarcodeDetected,
                ),
                if (isScanning)
                  Container(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Escaneando...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (codigosLidos.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total de códigos lidos: ${codigosLidos.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: codigosLidos.length,
                      itemBuilder: (context, index) {
                        final codigo = codigosLidos.elementAt(index);
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16.0,
                                  ), // Adiciona o espaçamento à esquerda
                                  child: Text(
                                    codigo,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _removerCodigo(codigo);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
