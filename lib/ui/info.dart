import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  // Função para abrir o URL no navegador ou aplicativo de e-mail
  _launchURL(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sobre o Aplicativo', style: TextStyle(color: Colors.white)),
          ],
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

          // Onda na parte de baixo, fixada no final da tela
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/image/ondaDeCima.png',
              fit: BoxFit.cover,
              height: 100, // Tamanho fixo da onda de baixo
            ),
          ),
          // Conteúdo central
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo centralizado
                  Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: AssetImage('assets/image/globonitroicon.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 24.0),
                  ),
                  // Título da seção
                  Text(
                    'Sobre o Aplicativo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 20, 121, 189),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Este é um aplicativo desenvolvido para facilitar a vida dos usuários, oferecendo uma série de funcionalidades que permitem realizar tarefas de forma mais rápida e prática.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 24),
                  // Informações do criador
                  Text(
                    'Criado por:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Thiago Araujo',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Matrícula: 6099',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  // Versão do aplicativo
                  Text(
                    'Versão: 1.0.0',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  // Links interativos
                  GestureDetector(
                    onTap:
                        () => _launchURL(
                          'https://github.com/lThiag0/globo_nitro/',
                        ),
                    child: Text(
                      'Visite nosso GitHub',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap:
                        () => _launchURL(
                          'mailto:thiaguinhofurtado07@hotmail.com',
                        ),
                    child: Text(
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
