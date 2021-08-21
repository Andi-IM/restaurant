import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/detail.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:flutter/material.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final List<Restaurant> _restaurants = [];
  String? id;

  RestaurantProvider(this.id, {required this.apiService}) {
    if (id != null) {
      _fetchDetail(id!);
    } else {
      _fetchAllRestaurant();
    }
  }

  late RestaurantResult _restaurantResult;
  late DetailResult _detailResult;
  late String _message = '';
  late int _count = 0;
  late ResultState _state;

  List<Restaurant> get restaurants => _restaurants;

  String get message => _message;

  int get count => _count;

  RestaurantResult get result => _restaurantResult;

  DetailResult get detail => _detailResult;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.list();

      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  Future<dynamic> _fetchDetail(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final detail = await apiService.get(id);

      if (detail.error == false) {
        _state = ResultState.HasData;
        notifyListeners();
        return _detailResult = detail;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
