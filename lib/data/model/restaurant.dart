// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/services.dart';

class DataApi {
  static Future<List<Restaurant>> getRestaurants(String query) async {
    var jsonText = await rootBundle.loadString('assets/local_restaurant.json');
    final Data data = dataFromJson(jsonText);
    final List<Restaurant> restaurants = data.restaurants;

    return restaurants.where((restaurant) {
      final nameLower = restaurant.name.toLowerCase();
      final cityLower = restaurant.city.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) || cityLower.contains(searchLower);
    }).toList();
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.restaurants,
  });

  List<Restaurant> restaurants;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menus menus;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        pictureId: json["pictureId"],
        city: json["city"],
        rating: json["rating"].toDouble(),
        menus: Menus.fromJson(json["menus"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
        "menus": menus.toJson(),
      };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  List<Item> foods;
  List<Item> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
        foods: List<Item>.from(json["foods"].map((x) => Item.fromJson(x))),
        drinks: List<Item>.from(json["drinks"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.name,
  });

  String name;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
