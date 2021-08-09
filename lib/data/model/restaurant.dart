import 'dart:convert';

class Restaurant {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late String rating;
  late List<String> menus;

  Restaurant(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictureId,
      required this.city,
      required this.rating,
      required this.menus});

  Restaurant.fromJson(Map<String, dynamic> restaurant){
    id = restaurant['id'];
    name = restaurant['name'];
    description = restaurant['description'];
    pictureId = restaurant['pictureId'];
    city = restaurant['city'];
    rating = restaurant['rating'];
    menus = restaurant['menus'];
  }
}

class Food {
  late String name;

  Food({required this.name});

  Food.fromJson(Map<String, dynamic> food){
    name = food['name'];
  }
}

class Drink {
  late String name;

  Drink({required this.name});

  Drink.fromJson(Map<String, dynamic> drink){
    name = drink['name'];
  }
}

List<Restaurant> parseRestaurants(String? json){
  if(json == null){
    return [];
  }

  final List parsed = jsonDecode(json);
  return parsed.map((json) => Restaurant.fromJson(json)).toList();
}

List<Food> parseFoods(String? json){
  if(json == null){
    return [];
  }

  final List parsed = jsonDecode(json);
  return parsed.map((json) => Food.fromJson(json)).toList();
}

List<Drink> parseDrinks(String? json){
  if(json == null){
    return [];
  }

  final List parsed = jsonDecode(json);
  return parsed.map((json) => Drink.fromJson(json)).toList();
}