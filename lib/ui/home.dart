import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obter o tamanho da tela
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 20, 121, 189),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Onda no topo (ajustando a posição com base no tamanho da tela)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height:
                screenHeight * 0.15, // Ajuste de acordo com a altura da tela
            child: Image.asset(
              'assets/image/ondaDeBaixo.png',
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
                              'Escanear produto',
                              style: TextStyle(color: Colors.white),
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
                              Navigator.pushNamed(context, '/estoque');
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
                              'Conferir Estoque',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Botão 3
                        SizedBox(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ação do terceiro botão
                              Navigator.pushNamed(context, '/info');
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
                              'Informações do Aplicativo',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer ajustado
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.2,
                ), // Espaço para evitar sobreposição
                child: Text(
                  'Criado por Thiago Araujo - Matrícula 6099',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),

          // Onda no rodapé (ajustando a posição com base no tamanho da tela)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height:
                screenHeight * 0.15, // Ajuste de acordo com a altura da tela
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
