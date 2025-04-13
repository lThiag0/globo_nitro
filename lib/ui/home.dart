import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Onda no topo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Image.asset(
              'assets/image/ondaDebaixo.png',
              fit: BoxFit.cover,
            ),
          ),

          // Conteúdo principal
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logotipo
                        Image.asset('assets/image/globoNitro.png', height: 120),

                        SizedBox(height: 50),

                        // Botão 1
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação do botão
                              Navigator.pushNamed(context, '/produtos');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                20,
                                121,
                                189,
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              'Scannear produto',
                              style: TextStyle(
                                //fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Botão 2
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação do segundo botão
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                20,
                                121,
                                189,
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              'Fazer Relatório',
                              style: TextStyle(
                                //fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: Text(
                  'Criado por Thiago Araujo - Matricula 6099',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),

          // Onda no rodapé
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
        ],
      ),
    );
  }
}
