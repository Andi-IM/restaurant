// Mocks generated by Mockito 5.0.15 from annotations
// in dicoding_restaurant/test/unit-tests/provider/restaurant_provider_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:dicoding_restaurant/data/api/api_service.dart' as _i5;
import 'package:dicoding_restaurant/data/model/detail.dart' as _i4;
import 'package:dicoding_restaurant/data/model/restaurant.dart' as _i3;
import 'package:http/http.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeClient_0 extends _i1.Fake implements _i2.Client {}

class _FakeRestaurantResult_1 extends _i1.Fake implements _i3.RestaurantResult {
}

class _FakeDetailResult_2 extends _i1.Fake implements _i4.DetailResult {}

class _FakeSearchResult_3 extends _i1.Fake implements _i3.SearchResult {}

/// A class which mocks [ApiService].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiService extends _i1.Mock implements _i5.ApiService {
  MockApiService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Client get client => (super.noSuchMethod(Invocation.getter(#client),
      returnValue: _FakeClient_0()) as _i2.Client);
  @override
  _i6.Future<_i3.RestaurantResult> list() =>
      (super.noSuchMethod(Invocation.method(#list, []),
              returnValue:
                  Future<_i3.RestaurantResult>.value(_FakeRestaurantResult_1()))
          as _i6.Future<_i3.RestaurantResult>);
  @override
  _i6.Future<_i4.DetailResult> get(String? id) => (super.noSuchMethod(
          Invocation.method(#get, [id]),
          returnValue: Future<_i4.DetailResult>.value(_FakeDetailResult_2()))
      as _i6.Future<_i4.DetailResult>);
  @override
  _i6.Future<_i3.SearchResult> search(String? query) => (super.noSuchMethod(
          Invocation.method(#search, [query]),
          returnValue: Future<_i3.SearchResult>.value(_FakeSearchResult_3()))
      as _i6.Future<_i3.SearchResult>);
  @override
  _i6.Future<dynamic> postReview(_i4.ComposeReview? review) =>
      (super.noSuchMethod(Invocation.method(#postReview, [review]),
          returnValue: Future<dynamic>.value()) as _i6.Future<dynamic>);
  @override
  String toString() => super.toString();
}
