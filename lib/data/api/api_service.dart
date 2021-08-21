import 'dart:convert';
import 'dart:io';

import 'package:dicoding_restaurant/data/model/detail.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantResult> list() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));

    try {
      if (response.statusCode == 200) {
        return RestaurantResult.fromJson(json.decode(response.body));
      }
    } on SocketException {
      print('No Internet Access');
    } on HttpException {
      print('Not Found');
    } on FormatException {
      print('Bad Response');
    }

    throw Exception('Failed to load lists');
  }

  Future<DetailResult> get(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      return DetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load detail');
    }
  }
}
