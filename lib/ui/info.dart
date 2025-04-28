import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SobreScreenState createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  String _appVersion = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      // Tentando abrir a URL diretamente
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Caso ocorra erro, exibe uma mensagem
      if (!mounted) return;
      _showErrorSnackBar('Não foi possível abrir o link: $url');
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final double verticalPadding = MediaQuery.of(context).size.height * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre o Aplicativo',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 100,
              width: double.infinity,
              child: Image.asset(
                'assets/image/ondaDeCima.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      image: const DecorationImage(
                        image: AssetImage('assets/image/globonitroicon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 24.0),
                  ),
                  const Text(
                    'Sobre o Aplicativo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 20, 121, 189),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'App ideal para escanear códigos de produtos e enviá-los rapidamente para o computador via WhatsApp, agilizando processos e auxiliando na contagem de estoque.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Criado por:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thiago Araujo\nMatrícula: 6099',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Versão: $_appVersion',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap:
                        () => _launchURL(
                          'https://github.com/lThiag0/globo_nitro/',
                        ),
                    child: const Text(
                      'Visite nosso GitHub',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap:
                        () => _launchURL(
                          'mailto:thiaguinhofurtado07@hotmail.com',
                        ),
                    child: const Text(
                      'Entre em contato por e-mail',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
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
