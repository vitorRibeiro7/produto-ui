import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto.dart';
import 'form_produto.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProdutoListScreenState createState() => _ProdutoListScreenState();
}

class _ProdutoListScreenState extends State<ProductListScreen> {
  final ProductService _service = ProductService();
  late Future<List<Produto>> _produtoList;

  @override
  void initState() {
    super.initState();
    _produtoList = _service.fetchProducts();
  }

  void _refreshProductList() {
    setState(() {
      _produtoList = _service.fetchProducts();
    });
  }

  void _confirmDeleteProduct(int productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('Tem certeza que deseja excluir este produto?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text('Excluir'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _service.deleteProduct(productId).then((_) {
                  Navigator.of(context).pop();
                  _refreshProductList();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: FutureBuilder<List<Produto>>(
        future: _produtoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: const Icon(Icons.inventory,
                        size: 40, color: Colors.blue),
                    title: Text(
                      products[index].descricao,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preço: R\$ ${products[index].preco.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          'Estoque: ${products[index].estoque}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductForm(produto: products[index]),
                              ),
                            );
                            if (result == true) {
                              _refreshProductList();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDeleteProduct(products[index].id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductForm(),
            ),
          );
          if (result == true) {
            _refreshProductList();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
