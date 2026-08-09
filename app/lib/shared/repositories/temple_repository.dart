import 'package:flutter/foundation.dart' hide Category;
import '../../core/network/dio_client.dart';
import '../models/models.dart';

class TempleRepository {
  final DioClient dioClient;

  TempleRepository({required this.dioClient});

  List<Temple> _cachedTemples = [];
  List<Temple> _cachedFeatured = [];
  List<Category> _cachedCategories = [];
  List<Location> _cachedLocations = [];
  List<Festival> _cachedFestivals = [];

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
        final list = rawList.map((item) => Temple.fromJson(item)).toList();
        if (list.isNotEmpty && (search == null || search.isEmpty) && categoryId == null && locationId == null) {
          _cachedTemples = list;
        }
        return list;
      }
    } catch (e) {
      debugPrint('TempleRepository.getTemples error: $e');
    }

    var result = _cachedTemples;
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      result = result.where((t) => t.name.toLowerCase().contains(q) || t.shortDescription.toLowerCase().contains(q)).toList();
    }
    if (categoryId != null && categoryId.isNotEmpty) {
      result = result.where((t) {
        final catId = t.category is Category ? (t.category as Category).id : t.category?.toString();
        return catId == categoryId;
      }).toList();
    }
    return result;
  }

  Future<Temple?> getTempleByIdOrSlug(String idOrSlug) async {
    try {
      final response = await dioClient.dio.get('/temples/$idOrSlug');
      if (response.data['success'] == true && response.data['data'] != null) {
        return Temple.fromJson(response.data['data']);
      }
    } catch (e) {
      debugPrint('TempleRepository.getTempleByIdOrSlug Network error: $e');
    }
    try {
      return _cachedTemples.firstWhere((t) => t.id == idOrSlug || t.slug == idOrSlug);
    } catch (e) {
      debugPrint('TempleRepository.getTempleByIdOrSlug Cache fallback notice: $e');
      return null;
    }
  }

  Future<List<Temple>> getFeaturedTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/featured', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Temple.fromJson(item)).toList();
        if (list.isNotEmpty) _cachedFeatured = list;
        return list;
      }
    } catch (e) {
      debugPrint('TempleRepository.getFeaturedTemples error: $e');
    }
    return _cachedFeatured.isNotEmpty ? _cachedFeatured : _cachedTemples;
  }

  Future<List<Temple>> getPopularTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/popular', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('TempleRepository.getPopularTemples error: $e');
    }
    return _cachedTemples;
  }

  Future<List<Temple>> getRecentTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/recent', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        return rawList.map((item) => Temple.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('TempleRepository.getRecentTemples error: $e');
    }
    return _cachedTemples;
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
    } catch (e) {
      debugPrint('TempleRepository.getNearbyTemples error: $e');
    }
    return _cachedTemples;
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await dioClient.dio.get('/categories');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Category.fromJson(item)).toList();
        if (list.isNotEmpty) _cachedCategories = list;
        return list;
      }
    } catch (e) {
      debugPrint('TempleRepository.getCategories error: $e');
    }
    return _cachedCategories;
  }

  Future<List<Location>> getLocations() async {
    try {
      final response = await dioClient.dio.get('/locations');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Location.fromJson(item)).toList();
        if (list.isNotEmpty) _cachedLocations = list;
        return list;
      }
    } catch (e) {
      debugPrint('TempleRepository.getLocations error: $e');
    }
    return _cachedLocations;
  }

  Future<List<Festival>> getFestivals() async {
    try {
      final response = await dioClient.dio.get('/festivals');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Festival.fromJson(item)).toList();
        if (list.isNotEmpty) _cachedFestivals = list;
        return list;
      }
    } catch (e) {
      debugPrint('TempleRepository.getFestivals error: $e');
    }
    return _cachedFestivals;
  }
}

