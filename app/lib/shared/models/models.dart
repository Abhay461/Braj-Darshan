import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int limit;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginationMeta({
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.limit,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      limit: json['limit'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }
}

class GalleryImage {
  final String imageUrl;
  final String thumbnailUrl;
  final String publicId;
  final String? caption;
  final int? order;

  GalleryImage({
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.publicId,
    this.caption,
    this.order,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      imageUrl: json['imageUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['imageUrl'] ?? '',
      publicId: json['publicId'] ?? '',
      caption: json['caption'],
      order: json['order'],
    );
  }
}

class TempleAddress {
  final String? street;
  final String? area;
  final String? city;
  final String? state;
  final String? pincode;
  final String? full;

  TempleAddress({
    this.street,
    this.area,
    this.city,
    this.state,
    this.pincode,
    this.full,
  });

  factory TempleAddress.fromJson(Map<String, dynamic> json) {
    return TempleAddress(
      street: json['street'],
      area: json['area'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      full: json['full'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? icon;
  final int? sortOrder;
  final String status;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.icon,
    this.sortOrder,
    required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      icon: json['icon'],
      sortOrder: json['sortOrder'],
      status: json['status'] ?? 'active',
    );
  }
}

class Location {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? coverImage;
  final String? district;
  final String? state;
  final String? country;
  final double latitude;
  final double longitude;
  final int? sortOrder;
  final String status;

  Location({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.coverImage,
    this.district,
    this.state,
    this.country,
    required this.latitude,
    required this.longitude,
    this.sortOrder,
    required this.status,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      coverImage: json['coverImage'],
      district: json['district'],
      state: json['state'],
      country: json['country'],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 27.5830,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.7000,
      sortOrder: json['sortOrder'],
      status: json['status'] ?? 'active',
    );
  }
}

class Facility {
  final String id;
  final String name;
  final String slug;
  final String? icon;

  Facility({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      icon: json['icon'],
    );
  }
}

class AartiTiming {
  final String name;
  final String time; // HH:mm 24-hour format
  final String description;

  AartiTiming({
    required this.name,
    required this.time,
    required this.description,
  });

  factory AartiTiming.fromJson(Map<String, dynamic> json) {
    return AartiTiming(
      name: json['name'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'time': time,
      'description': description,
    };
  }
}

class WeatherData {
  final int temperature;
  final String condition;
  final String description;
  final int humidity;
  final int windSpeed;
  final String icon;
  final String yatraSuggestion;
  final String suggestionType; // 'rain', 'heat', 'warm', 'fog', 'cool', 'pleasant'
  final String locationName;
  final String country;
  final int timestamp;
  final bool fromCache;
  final bool cacheExpired;

  WeatherData({
    required this.temperature,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.yatraSuggestion,
    required this.suggestionType,
    required this.locationName,
    required this.country,
    required this.timestamp,
    this.fromCache = false,
    this.cacheExpired = false,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature'] as num?)?.toInt() ?? 0,
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      humidity: (json['humidity'] as num?)?.toInt() ?? 0,
      windSpeed: (json['windSpeed'] as num?)?.toInt() ?? 0,
      icon: json['icon'] ?? '01d',
      yatraSuggestion: json['yatraSuggestion'] ?? '',
      suggestionType: json['suggestionType'] ?? 'pleasant',
      locationName: json['locationName'] ?? 'Vrindavan',
      country: json['country'] ?? 'IN',
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
      fromCache: json['fromCache'] ?? false,
      cacheExpired: json['cacheExpired'] ?? false,
    );
  }

  String get weatherIconUrl => 'https://openweathermap.org/img/wn/@2x.png';
  
  bool get isDay => icon.endsWith('d');
}

class EmergencyContactLocation {
  final double? lat;
  final double? lng;
  final String? address;
  final String? name;

  EmergencyContactLocation({
    this.lat,
    this.lng,
    this.address,
    this.name,
  });

  factory EmergencyContactLocation.fromJson(Map<String, dynamic> json) {
    return EmergencyContactLocation(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'],
      name: json['name'],
    );
  }
}

class EmergencyContact {
  final String id;
  final String name;
  final String category; // 'police', 'medical', 'fire', 'helpline', 'hospital', 'ambulance', 'tourist_police', 'other'
  final String phone;
  final String? description;
  final EmergencyContactLocation? location;
  final bool isActive;
  final int sortOrder;
  final String area;
  final bool isVerified;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    this.description,
    this.location,
    required this.isActive,
    required this.sortOrder,
    required this.area,
    required this.isVerified,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'helpline',
      phone: json['phone'] ?? '',
      description: json['description'],
      location: json['location'] != null 
          ? EmergencyContactLocation.fromJson(json['location']) 
          : null,
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
      area: json['area'] ?? 'Braj',
      isVerified: json['isVerified'] ?? false,
    );
  }

  IconData get categoryIcon {
    switch (category) {
      case 'police':
      case 'tourist_police':
        return Icons.local_police_outlined;
      case 'hospital':
      case 'medical':
        return Icons.local_hospital_outlined;
      case 'ambulance':
        return Icons.emergency_outlined;
      case 'fire':
        return Icons.local_fire_department_outlined;
      case 'helpline':
        return Icons.phone_in_talk_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String get categoryLabel {
    switch (category) {
      case 'tourist_police':
        return 'Tourist Police';
      case 'hospital':
        return 'Hospital';
      case 'medical':
        return 'Medical';
      case 'ambulance':
        return 'Ambulance';
      case 'fire':
        return 'Fire';
      case 'helpline':
        return 'Helpline';
      default:
        return category[0].toUpperCase() + category.substring(1);
    }
  }
}

class FestivalThemeConfig {
  final String? bannerImage;
  final String? accentColor;
  final bool showPetals;
  final String petalType; // 'gulal', 'flower', 'diya', 'none'

  FestivalThemeConfig({
    this.bannerImage,
    this.accentColor,
    this.showPetals = false,
    this.petalType = 'none',
  });

  factory FestivalThemeConfig.fromJson(Map<String, dynamic> json) {
    return FestivalThemeConfig(
      bannerImage: json['bannerImage'],
      accentColor: json['accentColor'],
      showPetals: json['showPetals'] ?? false,
      petalType: json['petalType'] ?? 'none',
    );
  }
}

class Festival {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? bannerImage;
  final String? startDate;
  final String? endDate;
  final List<dynamic>? templeIds;
  final FestivalThemeConfig? themeConfig;
  final String? status;

  Festival({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.bannerImage,
    this.startDate,
    this.endDate,
    this.templeIds,
    this.themeConfig,
    this.status,
  });

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      bannerImage: json['bannerImage'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      templeIds: json['templeIds'],
      themeConfig: json['themeConfig'] != null 
          ? FestivalThemeConfig.fromJson(json['themeConfig']) 
          : null,
      status: json['status'],
    );
  }

  bool get isCurrentlyActive {
    if (startDate == null || endDate == null) return false;
    try {
      final now = DateTime.now();
      final start = DateTime.parse(startDate!);
      final end = DateTime.parse(endDate!);
      return now.isAfter(start.subtract(const Duration(days: 1))) && 
             now.isBefore(end.add(const Duration(days: 1)));
    } catch (_) {
      return false;
    }
  }
}

class Temple {
  final String id;
  final String name;
  final String? nameHindi;
  final String slug;
  final String shortDescription;
  final String? history;
  final String? historyHindi;
  final String? importance;
  final dynamic category;
  final dynamic location;
  final String coverImage;
  final String? thumbnailImage;
  final String? featuredImage;
  final List<GalleryImage> galleryImages;
  final TempleAddress? address;
  final double latitude;
  final double longitude;
  final String? darshanTiming;
  final List<AartiTiming> aartiTimings;
  final String? phone;
  final String? website;
  final String? donationUrl;
  final String? guestHouseBookingUrl;
  final String? liveDarshanUrl;
  final String? directionsUrl;
  final String? visitDuration;
  final bool parkingAvailable;
  final bool wheelchairAccessible;
  final List<dynamic> facilities;
  final List<String> tags;
  final List<String> keywords;
  final bool isFeatured;
  final bool isPopular;
  final String status;
  final String? seoTitle;
  final String? seoDescription;
  final double? mapZoom;
  final String? mapPinIconStyle;
  final String? mapPinColor;
  final double? mapPinSize;

  Temple({
    required this.id,
    required this.name,
    this.nameHindi,
    required this.slug,
    required this.shortDescription,
    this.history,
    this.historyHindi,
    this.importance,
    this.category,
    this.location,
    required this.coverImage,
    this.thumbnailImage,
    this.featuredImage,
    this.galleryImages = const [],
    this.address,
    required this.latitude,
    required this.longitude,
    this.darshanTiming,
    this.aartiTimings = const [],
    this.phone,
    this.website,
    this.donationUrl,
    this.guestHouseBookingUrl,
    this.liveDarshanUrl,
    this.directionsUrl,
    this.visitDuration,
    this.parkingAvailable = false,
    this.wheelchairAccessible = false,
    this.facilities = const [],
    this.tags = const [],
    this.keywords = const [],
    this.isFeatured = false,
    this.isPopular = false,
    required this.status,
    this.seoTitle,
    this.seoDescription,
    this.mapZoom,
    this.mapPinIconStyle,
    this.mapPinColor,
    this.mapPinSize,
  });

  factory Temple.fromJson(Map<String, dynamic> json) {
    var rawGallery = json['galleryImages'] as List? ?? [];
    List<GalleryImage> galleryList = rawGallery.map((g) => GalleryImage.fromJson(g)).toList();

    // Parse aartiTimings
    List<AartiTiming> aartiList = [];
    if (json['aartiTimings'] != null && json['aartiTimings'] is List) {
      aartiList = (json['aartiTimings'] as List)
          .map((e) => AartiTiming.fromJson(e))
          .toList();
    }

    // DEBUG: Log raw API latitude/longitude values
    final rawLat = json['latitude'];
    final rawLng = json['longitude'];
    final parsedLat = (rawLat as num?)?.toDouble();
    final parsedLng = (rawLng as num?)?.toDouble();
    if (kDebugMode) {
      debugPrint('Temple.fromJson: ');
      debugPrint('   Raw API: latitude= (type: ), longitude= (type: )');
      debugPrint('   Parsed: latitude=, longitude=');
      debugPrint('   Final: latitude=, longitude=');
      debugPrint('   Aarti Timings: ');
    }

    return Temple(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      nameHindi: json['nameHindi'],
      slug: json['slug'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      history: json['history'],
      historyHindi: json['historyHindi'],
      importance: json['importance'],
      category: json['categoryId'] is Map ? Category.fromJson(json['categoryId']) : json['categoryId'],
      location: json['locationId'] is Map ? Location.fromJson(json['locationId']) : json['locationId'],
      coverImage: json['coverImage'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? json['coverImage'] ?? '',
      featuredImage: json['featuredImage'] ?? json['thumbnailImage'] ?? json['coverImage'] ?? '',
      galleryImages: galleryList,
      address: json['address'] is Map ? TempleAddress.fromJson(json['address']) : null,
      latitude: parsedLat ?? 27.5830,
      longitude: parsedLng ?? 77.7000,
      darshanTiming: json['darshanTiming'],
      aartiTimings: aartiList,
      phone: json['phone'],
      website: json['website'],
      donationUrl: json['donationUrl'],
      guestHouseBookingUrl: json['guestHouseBookingUrl'],
      liveDarshanUrl: json['liveDarshanUrl'],
      directionsUrl: json['directionsUrl'],
      visitDuration: json['visitDuration'],
      parkingAvailable: json['parkingAvailable'] ?? false,
      wheelchairAccessible: json['wheelchairAccessible'] ?? false,
      facilities: json['facilities'] as List? ?? [],
      tags: (json['tags'] as List? ?? []).map((e) => e.toString()).toList(),
      keywords: (json['keywords'] as List? ?? []).map((e) => e.toString()).toList(),
      isFeatured: json['isFeatured'] ?? false,
      isPopular: json['isPopular'] ?? false,
      status: json['status'] ?? 'active',
      seoTitle: json['seoTitle'],
      seoDescription: json['seoDescription'],
      mapZoom: (json['mapZoom'] as num?)?.toDouble(),
      mapPinIconStyle: json['mapPinIconStyle'],
      mapPinColor: json['mapPinColor'],
      mapPinSize: (json['mapPinSize'] as num?)?.toDouble(),
    );
  }
}

class PinIconOption {
  final String name;
  final String iconClass;
  final bool isDefault;

  PinIconOption({
    required this.name,
    required this.iconClass,
    required this.isDefault,
  });

  factory PinIconOption.fromJson(Map<String, dynamic> json) {
    return PinIconOption(
      name: json['name'] ?? '',
      iconClass: json['iconClass'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconClass': iconClass,
      'isDefault': isDefault,
    };
  }
}

class MapSettings {
  final double defaultZoom;
  final double minZoom;
  final double maxZoom;
  final double defaultCenterLat;
  final double defaultCenterLng;
  final String defaultPinIconStyle;
  final String defaultPinColor;
  final double defaultPinSize;
  final String mapStyle;
  final List<PinIconOption> availablePinIcons;

  MapSettings({
    required this.defaultZoom,
    required this.minZoom,
    required this.maxZoom,
    required this.defaultCenterLat,
    required this.defaultCenterLng,
    required this.defaultPinIconStyle,
    required this.defaultPinColor,
    required this.defaultPinSize,
    required this.mapStyle,
    required this.availablePinIcons,
  });

  factory MapSettings.fromJson(Map<String, dynamic> json) {
    return MapSettings(
      defaultZoom: (json['defaultZoom'] as num?)?.toDouble() ?? 14.0,
      minZoom: (json['minZoom'] as num?)?.toDouble() ?? 5.0,
      maxZoom: (json['maxZoom'] as num?)?.toDouble() ?? 18.0,
      defaultCenterLat: (json['defaultCenterLat'] as num?)?.toDouble() ?? 27.5830,
      defaultCenterLng: (json['defaultCenterLng'] as num?)?.toDouble() ?? 77.7000,
      defaultPinIconStyle: json['defaultPinIconStyle'] ?? 'location_on',
      defaultPinColor: json['defaultPinColor'] ?? '#C5221F',
      defaultPinSize: (json['defaultPinSize'] as num?)?.toDouble() ?? 42.0,
      mapStyle: json['mapStyle'] ?? 'standard',
      availablePinIcons: (json['availablePinIcons'] as List?)
              ?.map((e) => PinIconOption.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultZoom': defaultZoom,
      'minZoom': minZoom,
      'maxZoom': maxZoom,
      'defaultCenterLat': defaultCenterLat,
      'defaultCenterLng': defaultCenterLng,
      'defaultPinIconStyle': defaultPinIconStyle,
      'defaultPinColor': defaultPinColor,
      'defaultPinSize': defaultPinSize,
      'mapStyle': mapStyle,
      'availablePinIcons': availablePinIcons.map((e) => e.toJson()).toList(),
    };
  }
}



