import 'package:dicoding_restaurant/data/api/api_service.dart';
import 'package:dicoding_restaurant/data/model/detail.dart';
import 'package:dicoding_restaurant/data/model/restaurant.dart';
import 'package:dicoding_restaurant/utils/result_state.dart';
import 'package:flutter/material.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  String? query;
  String? id;

  RestaurantProvider({this.query, this.id, required this.apiService}) {
    if (id != null) {
      _fetchDetail(id!);
    } else if (query != null) {
      _fetchRestaurantByQuery(query!);
    } else {
      _fetchAllRestaurant();
    }
  }

  late RestaurantResult _restaurantResult;
  late SearchResult _searchResult;
  late DetailResult _detailResult;
  String _message = '';
  int _count = 0;
  late ResultState _state;

  String get message => _message;

  int get count => _count;

  RestaurantResult get result => _restaurantResult;

  SearchResult get search => _searchResult;

  DetailResult get detail => _detailResult;

  ResultState get state => _state;

  sendData(ComposeReview review) {
    apiService.postReview(review);
    notifyListeners();
    _fetchDetail(review.id);
    notifyListeners();
  }

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
        _count = restaurant.count;
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

  Future<dynamic> _fetchRestaurantByQuery(String query) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final response = await apiService.search(query);

      if ((response.founded == 0) || (response.restaurants.isEmpty)) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'No Data Available';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchResult = response;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
