import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import '../../shared/models/models.dart';

class WeatherService {
  static const String _baseUrl = 'https://braj-darshan-wdw9.onrender.com/api/v1';
  static const double _defaultLat = 27.5830;
  static const double _defaultLng = 77.7000;
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<WeatherData?> fetchWeather({double? lat, double? lng}) async {
    try {
      final response = await _dio.get('/weather', queryParameters: {
        'lat': lat ?? _defaultLat,
        'lng': lng ?? _defaultLng,
      });
      
      if (response.data['success'] == true && response.data['data'] != null) {
        return WeatherData.fromJson(response.data['data']);
      }
    } on DioException catch (e) {
      developer.log('WeatherService DioException: ${e.message}');
    } catch (e) {
      developer.log('WeatherService error: $e');
    }
    return null;
  }
}
