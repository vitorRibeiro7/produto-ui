import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ProductService {
  final String apiUrl = "http://localhost:3000";

  Future<bool> createProduct(Produto product) async {
    final response = await http.post(
      Uri.parse('$apiUrl/produto'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> updateProduct(int id, Produto product) async {
    final response = await http.put(
      Uri.parse('$apiUrl/produto/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<List<Produto>> fetchProducts() async {
    final response = await http.get(Uri.parse('$apiUrl/produtos'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Produto.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/produto/$id'));
    if (response.statusCode != 204) {
      throw Exception('Falha ao deletar produto');
    }
  }
}
