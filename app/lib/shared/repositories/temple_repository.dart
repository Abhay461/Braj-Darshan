import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/models.dart';

class TempleRepository {
  final DioClient dioClient;

  TempleRepository({required this.dioClient});

  Future<List<Temple>> getTemples({
    int page = 1,
    int limit = 10,
    String? search,
    String? categoryId,
    String? locationId,
    String? status = 'active',
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
        'status': status,
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (categoryId != null && categoryId.isNotEmpty) queryParams['categoryId'] = categoryId;
      if (locationId != null && locationId.isNotEmpty) queryParams['locationId'] = locationId;

      final response = await dioClient.dio.get('/temples', queryParameters: queryParams);
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Temple?> getTempleByIdOrSlug(String idOrSlug) async {
    try {
      final response = await dioClient.dio.get('/temples/$idOrSlug');
      if (response.data['success'] == true && response.data['data'] != null) {
        return Temple.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Temple>> getFeaturedTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/featured', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Temple>> getPopularTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/popular', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Temple>> getRecentTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/recent', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Temple>> getNearbyTemples({
    required double lat,
    required double lng,
    double radius = 0.05,
    int limit = 10,
  }) async {
    try {
      final response = await dioClient.dio.get('/temples/nearby', queryParameters: {
        'lat': lat,
        'lng': lng,
        'radius': radius,
        'limit': limit,
      });
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await dioClient.dio.get('/categories');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Category.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Location>> getLocations() async {
    try {
      final response = await dioClient.dio.get('/locations');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Location.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Festival>> getFestivals() async {
    try {
      final response = await dioClient.dio.get('/festivals');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Festival.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
