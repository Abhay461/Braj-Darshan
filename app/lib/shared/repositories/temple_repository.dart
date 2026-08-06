import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/models.dart';

class TempleRepository {
  final DioClient dioClient;

  TempleRepository({required this.dioClient});

  static final List<Temple> _fallbackTemples = [
    Temple(
      id: 'banke_bihari',
      name: 'Banke Bihari',
      slug: 'banke-bihari',
      shortDescription: 'One of the most revered temples in Vrindavan dedicated to Lord Krishna as Banke Bihari.',
      history: 'Established by Swami Haridas in 1864. The deity was originally worshipped at Nidhivan.',
      importance: 'Most visited temple in Vrindavan, famous for its unique curtain darshan style.',
      coverImage: 'https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5692,
      longitude: 77.6639,
      darshanTiming: 'Morning: 7:45 AM - 12:00 PM | Evening: 5:30 PM - 9:30 PM',
      isFeatured: true,
      isPopular: true,
      status: 'active',
      address: TempleAddress(
        street: 'Godowlia Road, Bihari Pura',
        area: 'Bihari Pura',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Godowlia Road, Bihari Pura, Vrindavan, Uttar Pradesh 281121',
      ),
      tags: ['krishna', 'banke bihari', 'vrindavan', 'swami haridas'],
    ),
    Temple(
      id: 'prem_mandir',
      name: 'Prem Mandir',
      slug: 'prem-mandir',
      shortDescription: 'Stunning white marble temple complex maintained by Jagadguru Kripalu Parishat.',
      history: 'Shila nyas was performed in January 2001 and inauguration took place in February 2012.',
      importance: 'Renowned for intricate Italian marble carvings and captivating evening light displays.',
      coverImage: 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1561361513-2d000a50f0dc?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5724,
      longitude: 77.6738,
      darshanTiming: 'Morning: 5:30 AM - 12:00 PM | Evening: 4:30 PM - 8:30 PM',
      isFeatured: true,
      isPopular: true,
      status: 'active',
      address: TempleAddress(
        street: 'Chhatikara Road',
        area: 'Raman Reti',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Chhatikara Road, Raman Reti, Vrindavan, Uttar Pradesh 281121',
      ),
      tags: ['prem mandir', 'radha krishna', 'vrindavan', 'kripalu parishat'],
    ),
    Temple(
      id: 'iskcon_vrindavan',
      name: 'ISKCON Vrindavan',
      slug: 'iskcon-vrindavan',
      shortDescription: 'Also known as Sri Sri Krishna Balaram Mandir, established by Srila Prabhupada.',
      history: 'Opened in 1975 by A.C. Bhaktivedanta Swami Prabhupada.',
      importance: 'International hub for Gaudiya Vaishnavism, continuous 24-hour kirtan.',
      coverImage: 'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1609766857041-ed402ea8069a?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5732,
      longitude: 77.6754,
      darshanTiming: '4:30 AM - 1:00 PM | 4:30 PM - 8:30 PM',
      isFeatured: true,
      isPopular: true,
      status: 'active',
      address: TempleAddress(
        street: 'Bhakti Vedanta Swami Marg',
        area: 'Raman Reti',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Bhakti Vedanta Swami Marg, Raman Reti, Vrindavan, UP 281121',
      ),
      tags: ['iskcon', 'krishna balaram', 'prabhupada', 'vrindavan'],
    ),
    Temple(
      id: 'radha_raman',
      name: 'Radha Raman',
      slug: 'radha-raman',
      shortDescription: 'Ancient self-manifested deity of Shri Radha Raman Dev Ji established by Gopala Bhatta Goswami.',
      history: 'Self-manifested from a Shaligram Shila in 1542.',
      importance: 'One of the seven ancient temples of Vrindavan; sacred kitchen fire has burned continuously for over 480 years.',
      coverImage: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5852,
      longitude: 77.7011,
      darshanTiming: '8:00 AM - 12:30 PM | 6:00 PM - 9:00 PM',
      isFeatured: true,
      isPopular: true,
      status: 'active',
      address: TempleAddress(
        street: 'Radha Raman Gali',
        area: 'Shri Shahji Temple Area',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Radha Raman Gali, Vrindavan, Uttar Pradesh 281121',
      ),
      tags: ['radha raman', 'gopala bhatta goswami', 'ancient temple', 'vrindavan'],
    ),
    Temple(
      id: 'radha_vallabh',
      name: 'Radha Vallabh',
      slug: 'radha-vallabh',
      shortDescription: 'Historical temple of the Radha Vallabh sampradaya established by Hith Harivansh Mahaprabhu.',
      history: 'Established in 1535 by Shri Hith Harivansh Mahaprabhu.',
      importance: 'Emphasizes devotion to Shri Radha Rani as the supreme sovereign deity.',
      coverImage: 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5841,
      longitude: 77.7025,
      darshanTiming: '5:00 AM - 12:00 PM | 5:00 PM - 9:00 PM',
      isFeatured: false,
      isPopular: true,
      status: 'active',
      address: TempleAddress(
        street: 'Gothra Gali',
        area: 'Radha Vallabh Ghera',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Gothra Gali, Radha Vallabh Ghera, Vrindavan, UP 281121',
      ),
      tags: ['radha vallabh', 'hit harivansh', 'vrindavan'],
    ),
    Temple(
      id: 'madan_mohan',
      name: 'Madan Mohan',
      slug: 'madan-mohan',
      shortDescription: 'One of the oldest temples in Vrindavan located on Dwaita Hill overlooking the Yamuna.',
      history: 'Established by Sanatana Goswami in the 16th century.',
      importance: 'First temple built by the Six Goswamis of Vrindavan.',
      coverImage: 'https://images.unsplash.com/photo-1627894483216-2138af692e32?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1627894483216-2138af692e32?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5867,
      longitude: 77.6980,
      darshanTiming: '7:00 AM - 12:00 PM | 4:00 PM - 8:00 PM',
      isFeatured: false,
      isPopular: true,
      status: 'active',
      address: TempleAddress(
        street: 'Kali Ghat',
        area: 'Dwaita Hill',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Kali Ghat, Dwaita Hill, Vrindavan, UP 281121',
      ),
      tags: ['madan mohan', 'sanatana goswami', 'ancient temple'],
    ),
    Temple(
      id: 'govind_dev',
      name: 'Govind Dev',
      slug: 'govind-dev',
      shortDescription: 'Historic red sandstone architectural marvel built by Raja Man Singh of Amber in 1590.',
      history: 'Built by Raja Man Singh under the guidance of Rupa Goswami.',
      importance: 'A masterpiece of medieval Indian architecture combining Hindu, Western, and Mughal styles.',
      coverImage: 'https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1545128485-c400e7702796?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5847,
      longitude: 77.7003,
      darshanTiming: '8:00 AM - 12:30 PM | 4:30 PM - 8:30 PM',
      isFeatured: true,
      isPopular: false,
      status: 'active',
      address: TempleAddress(
        street: 'Govind Dev Mandir Marg',
        area: 'Vrindavan',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Govind Dev Mandir Marg, Vrindavan, UP 281121',
      ),
      tags: ['govind dev', 'raja man singh', 'red sandstone temple'],
    ),
    Temple(
      id: 'gopinath',
      name: 'Gopinath',
      slug: 'gopinath',
      shortDescription: 'Historic temple established by Madhu Pandit Goswami housing Shri Gopinath Ji.',
      history: 'Originally established by Madhu Pandit Goswami in the 16th century.',
      importance: 'One of the primary ancient Goswami shrines in Vrindavan.',
      coverImage: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=800&q=80',
      thumbnailImage: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=400&q=80',
      latitude: 27.5815,
      longitude: 77.7032,
      darshanTiming: '7:30 AM - 12:00 PM | 5:00 PM - 8:30 PM',
      isFeatured: false,
      isPopular: false,
      status: 'active',
      address: TempleAddress(
        street: 'Gopinath Bazaar',
        area: 'Gopinath Gali',
        city: 'Vrindavan',
        state: 'Uttar Pradesh',
        pincode: '281121',
        full: 'Gopinath Bazaar, Vrindavan, UP 281121',
      ),
      tags: ['gopinath temple', 'madhu pandit goswami', 'vrindavan ancient'],
    ),
  ];

  static final List<Category> _fallbackCategories = [
    Category(id: 'cat_1', name: 'Krishna Temple', slug: 'krishna-temple', description: 'Temples dedicated to Lord Krishna', icon: 'temple_hindu', status: 'active'),
    Category(id: 'cat_2', name: 'Radha Temple', slug: 'radha-temple', description: 'Temples dedicated to Shri Radha Rani', icon: 'favorite', status: 'active'),
    Category(id: 'cat_3', name: 'Shiva Temple', slug: 'shiva-temple', description: 'Temples dedicated to Lord Shiva in Braj', icon: 'temple_hindu', status: 'active'),
    Category(id: 'cat_4', name: 'Ancient Temple', slug: 'ancient-temple', description: 'Historic temples of Braj Mandal', icon: 'account_balance', status: 'active'),
  ];

  static final List<Location> _fallbackLocations = [
    Location(id: 'loc_1', name: 'Vrindavan', slug: 'vrindavan', district: 'Mathura', state: 'Uttar Pradesh', latitude: 27.5830, longitude: 77.7000, status: 'active'),
    Location(id: 'loc_2', name: 'Mathura', slug: 'mathura', district: 'Mathura', state: 'Uttar Pradesh', latitude: 27.4924, longitude: 77.6737, status: 'active'),
    Location(id: 'loc_3', name: 'Govardhan', slug: 'govardhan', district: 'Mathura', state: 'Uttar Pradesh', latitude: 27.4950, longitude: 77.4614, status: 'active'),
    Location(id: 'loc_4', name: 'Barsana', slug: 'barsana', district: 'Mathura', state: 'Uttar Pradesh', latitude: 27.6483, longitude: 77.3786, status: 'active'),
    Location(id: 'loc_5', name: 'Nandgaon', slug: 'nandgaon', district: 'Mathura', state: 'Uttar Pradesh', latitude: 27.6714, longitude: 77.3667, status: 'active'),
  ];

  static final List<Festival> _fallbackFestivals = [
    Festival(id: 'fest_1', name: 'Janmashtami', slug: 'janmashtami', description: 'Grand celebration of Lord Krishna Birth', startDate: '2026-08-25'),
    Festival(id: 'fest_2', name: 'Radhashtami', slug: 'radhashtami', description: 'Divine appearance day of Shri Radha Rani', startDate: '2026-09-08'),
    Festival(id: 'fest_3', name: 'Holi in Braj', slug: 'holi', description: 'World-famous Lathmar and Flower Holi of Barsana & Vrindavan', startDate: '2026-03-15'),
  ];

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
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    
    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      return _fallbackTemples.where((t) =>
        t.name.toLowerCase().contains(query) ||
        t.shortDescription.toLowerCase().contains(query) ||
        (t.address?.full?.toLowerCase().contains(query) ?? false)
      ).toList();
    }
    return _fallbackTemples;
  }

  Future<Temple?> getTempleByIdOrSlug(String idOrSlug) async {
    try {
      final response = await dioClient.dio.get('/temples/$idOrSlug');
      if (response.data['success'] == true && response.data['data'] != null) {
        return Temple.fromJson(response.data['data']);
      }
    } catch (_) {}
    try {
      return _fallbackTemples.firstWhere((t) => t.id == idOrSlug || t.slug == idOrSlug);
    } catch (_) {
      return _fallbackTemples.first;
    }
  }

  Future<List<Temple>> getFeaturedTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/featured', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Temple.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackTemples.where((t) => t.isFeatured).toList();
  }

  Future<List<Temple>> getPopularTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/popular', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Temple.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackTemples.where((t) => t.isPopular).toList();
  }

  Future<List<Temple>> getRecentTemples({int limit = 10}) async {
    try {
      final response = await dioClient.dio.get('/temples/recent', queryParameters: {'limit': limit});
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Temple.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackTemples;
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
        final list = rawList.map((item) => Temple.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackTemples;
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await dioClient.dio.get('/categories');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Category.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackCategories;
  }

  Future<List<Location>> getLocations() async {
    try {
      final response = await dioClient.dio.get('/locations');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Location.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackLocations;
  }

  Future<List<Festival>> getFestivals() async {
    try {
      final response = await dioClient.dio.get('/festivals');
      if (response.data['success'] == true && response.data['data'] != null) {
        final List rawList = response.data['data'];
        final list = rawList.map((item) => Festival.fromJson(item)).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (_) {}
    return _fallbackFestivals;
  }
}


