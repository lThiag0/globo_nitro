import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class StockCheckScreen extends StatefulWidget {
  const StockCheckScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StockCheckScreenState createState() => _StockCheckScreenState();
}

class _StockCheckScreenState extends State<StockCheckScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, dynamic>> _conferencias = [];
  int? _editingIndex; // Para armazenar o índice do item que está sendo editado

  // Função para adicionar ou editar item
  void _addOrEditItem() {
    final String item = _itemController.text;
    final String quantityText = _quantityController.text;

    if (item.isEmpty || quantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    final int quantity = int.tryParse(quantityText) ?? 0;
    if (quantity <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Quantidade inválida')));
      return;
    }

    setState(() {
      if (_editingIndex != null) {
        // Se estamos editando, atualizamos o item existente
        _conferencias[_editingIndex!] = {'item': item, 'quantity': quantity};
        _editingIndex = null; // Limpa o índice de edição
      } else {
        // Se estamos adicionando um novo item
        _conferencias.add({'item': item, 'quantity': quantity});
      }
    });

    // Limpa os campos após adicionar ou editar
    _itemController.clear();
    _quantityController.clear();
  }

  // Função para excluir item
  void _deleteItem(int index) {
    setState(() {
      _conferencias.removeAt(index);
    });
  }

  // Função para editar item
  void _editItem(int index) {
    setState(() {
      _editingIndex = index;
      _itemController.text = _conferencias[index]['item'];
      _quantityController.text = _conferencias[index]['quantity'].toString();
    });
  }

  // Função para compartilhar o relatório
  void _shareReport() {
    if (_conferencias.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Nenhum item para compartilhar.')));
      return;
    }

    // Gera o texto do relatório
    String report = '** Relatório de Itens Conferidos: **\n\n';
    for (var item in _conferencias) {
      report +=
          '# Item: ${item['item']} \n - Quantidade: ${item['quantity']}\n\n';
    }

    // Compartilha o relatório com outros aplicativos
    Share.share(report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Conferência de Estoque',
              style: TextStyle(color: Colors.white),
            ),
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

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 52.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantidade Conferida',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 350,
                    child: ElevatedButton.icon(
                      onPressed: _addOrEditItem,
                      icon: Icon(Icons.add_box, color: Colors.white),
                      label: Text(
                        _editingIndex != null
                            ? 'Salvar Edição'
                            : 'Adicionar Item',
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
                  SizedBox(height: 16),
                  Text(
                    'Itens Conferidos: ${_conferencias.length} Itens',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // Container para criar o formato quadrado com rolagem
                  SizedBox(
                    height: 220, // Defina uma altura fixa para o quadrado
                    width: 350, // Defina uma largura fixa para o quadrado
                    child: ListView.builder(
                      shrinkWrap:
                          true, // Faz o ListView ocupar apenas o espaço necessário
                      physics:
                          BouncingScrollPhysics(), // Permite a rolagem com efeito
                      itemCount: _conferencias.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_conferencias[index]['item']),
                          subtitle: Text(
                            'Quantidade: ${_conferencias[index]['quantity']}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editItem(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteItem(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10),
                  // Botão de compartilhar
                  SizedBox(
                    width: 350,
                    child: ElevatedButton.icon(
                      onPressed: _shareReport,
                      icon: Icon(Icons.share, color: Colors.white),
                      label: Text(
                        'Compartilhar Relatório',
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
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
