import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class Services {
  static const ROOT = "http://192.168.1.197/ProductsDB/product_actions.php";
  static const _CREATE_TABLE_ACTION = "CREATE_ACTION";
  static const _GET_ALL_ACTION = "GET_ALL";
  static const _GET_ALL_FROM_USER_ACTION = "GET_ALL_FROM_USER";
  static const _ADD_PROD_ACTION = "ADD_PROD";
  static const _UPDATE_PROD_ACTION = "UPDATE_PROD";

  static Future<String> createTable() async {
    var map = Map<String, dynamic>();
    map['action'] = _CREATE_TABLE_ACTION;
    final reponse = await http.post(Uri.parse(ROOT), body: map);
    return reponse.body;
  }

  static Future<List<Product>> getProducts() async {
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_ACTION;
    final reponse = await http.post(Uri.parse(ROOT), body: map);
    List<Product> list = parseResponse(reponse.body);
    return list;
  }

  static Future<List<Product>> getProductsFromUser(String uid) async {
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_FROM_USER_ACTION;
    map['uid'] = uid;
    final reponse = await http.post(Uri.parse(ROOT), body: map);
    List<Product> list = parseResponse(reponse.body);
    return list;
  }

  static List<Product> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Product>((json) => Product.fromJson(json)).toList();
  }

  static Future<String> addProduct(String title, String description,
      String price, String stock, String uid) async {
    var map = Map<String, dynamic>();
    map['action'] = _ADD_PROD_ACTION;
    map['title'] = title;
    map['description'] = description;
    map['price'] = price;
    map['stock'] = stock;
    map['uid'] = uid;
    print("hereeee");
    final reponse = await http.post(Uri.parse(ROOT), body: map);
    print(reponse.body);
    if (200 == reponse.statusCode) {
      print("okkk");
      return reponse.body;
    }
    return "eror";
  }

  static Future<String> updateProduct(int prodID, String? title, int price,
      String description, int stock, String uid) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_PROD_ACTION;
      map['id_prod'] = prodID;
      map['title'] = title;
      map['price'] = price;
      map['description'] = description;
      //map['image'] = image;
      map['stock'] = stock;
      map['uid'] = uid;

      final reponse = await http.post(Uri.parse(ROOT), body: map);
      if (200 == reponse.statusCode) {
        return reponse.body;
      }
      return "eror";
    } catch (e) {
      return "error";
    }
  }
}
