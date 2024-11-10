import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto.dart';

class ProductForm extends StatefulWidget {
  final Produto? produto;

  ProductForm({this.produto});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _service = ProductService();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      _descriptionController.text = widget.produto!.descricao;
      _priceController.text = widget.produto!.preco.toString();
      _stockController.text = widget.produto!.estoque.toString();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final produto = Produto(
        id: widget.produto?.id ?? 0,
        descricao: _descriptionController.text,
        preco: double.parse(_priceController.text),
        estoque: int.parse(_stockController.text),
        data: DateTime.now().toString(),
      );

      try {
        bool isSuccess = widget.produto == null
            ? await _service.createProduct(produto)
            : await _service.updateProduct(produto.id, produto);

        if (isSuccess) {
          Navigator.pop(context, true);
        } else {
          _showErrorMessage('Erro ao salvar o produto');
        }
      } catch (error) {
        _showErrorMessage('Erro ao salvar o produto');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.produto == null ? 'Novo Produto' : 'Editar Produto'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              _buildTextField(
                controller: _descriptionController,
                label: 'Descrição',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a descrição do produto';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: _priceController,
                label: 'Preço',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o preço do produto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Insira um preço válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              _buildTextField(
                controller: _stockController,
                label: 'Estoque',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira a quantidade em estoque';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Insira uma quantidade válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProduct,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        widget.produto == null ? 'Adicionar Produto' : 'Salvar Alterações',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
