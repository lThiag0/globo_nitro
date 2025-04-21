import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ConferenciaItem {
  final String item;
  final int quantity;

  ConferenciaItem({required this.item, required this.quantity});
}

class StockCheckScreen extends StatefulWidget {
  const StockCheckScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StockCheckScreenState createState() => _StockCheckScreenState();
}

class _StockCheckScreenState extends State<StockCheckScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<ConferenciaItem> _conferencias = [];
  int? _editingIndex;

  // Função para adicionar ou editar item
  void _addOrEditItem() {
    final String item = _itemController.text.trim();
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
        _conferencias[_editingIndex!] = ConferenciaItem(
          item: item,
          quantity: quantity,
        );
        _editingIndex = null;
      } else {
        _conferencias.add(ConferenciaItem(item: item, quantity: quantity));
      }
    });

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
      _itemController.text = _conferencias[index].item;
      _quantityController.text = _conferencias[index].quantity.toString();
    });
  }

  // Função de confirmação para excluir
  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Excluir item'),
            content: Text(
              'Tem certeza que deseja excluir o item "${_conferencias[index].item}"?',
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Excluir'),
                onPressed: () {
                  _deleteItem(index);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  // Função para compartilhar o relatório
  void _shareReport() {
    if (_conferencias.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Nenhum item para compartilhar.')));
      return;
    }

    String report = '** Relatório de Itens Conferidos: **\n\n';
    for (var item in _conferencias) {
      report += '# Item: ${item.item} \n - Quantidade: ${item.quantity}\n\n';
    }

    Share.share(report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conferência de Estoque',
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
          // Imagem do topo
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

          // Imagem da base
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/image/ondaDeCima.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),

          // Conteúdo principal
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 52.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_editingIndex != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Editando o item: ${_conferencias[_editingIndex!].item}',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addOrEditItem,
                      icon: Icon(Icons.add_box, color: Colors.white),
                      label: AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        transitionBuilder:
                            (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                        child: Text(
                          _editingIndex != null
                              ? 'Salvar Edição'
                              : 'Adicionar Item',
                          key: ValueKey(_editingIndex != null),
                          style: TextStyle(color: Colors.white),
                        ),
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
                  SizedBox(height: 8),

                  // ListView com tamanho fixo
                  SizedBox(
                    height: 220, // Altura fixa para o ListView
                    child: ListView.builder(
                      shrinkWrap:
                          true, // Faz o ListView ocupar apenas o espaço necessário
                      physics: BouncingScrollPhysics(),
                      itemCount: _conferencias.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color:
                                _editingIndex == index
                                    // ignore: deprecated_member_use
                                    ? Colors.orange.withOpacity(0.1)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: ListTile(
                              key: ValueKey(_conferencias[index]),
                              title: Text(_conferencias[index].item),
                              subtitle: Text(
                                'Quantidade: ${_conferencias[index].quantity}',
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
                                    onPressed: () => _confirmDelete(index),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
                      child: SizedBox(
                        width: double.infinity,
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
