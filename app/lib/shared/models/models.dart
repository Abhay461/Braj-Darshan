import 'package:flutter/foundation.dart';

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

class Festival {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? bannerImage;
  final String? startDate;
  final String? endDate;
  final List<dynamic>? templeIds;

  Festival({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.bannerImage,
    this.startDate,
    this.endDate,
    this.templeIds,
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
    );
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
  });

  factory Temple.fromJson(Map<String, dynamic> json) {
    var rawGallery = json['galleryImages'] as List? ?? [];
    List<GalleryImage> galleryList = rawGallery.map((g) => GalleryImage.fromJson(g)).toList();

    // DEBUG: Log raw API latitude/longitude values
    final rawLat = json['latitude'];
    final rawLng = json['longitude'];
    final parsedLat = (rawLat as num?)?.toDouble();
    final parsedLng = (rawLng as num?)?.toDouble();
    if (kDebugMode) {
      debugPrint('🔍 Temple.fromJson: ${json['name'] ?? json['slug'] ?? "unknown"}');
      debugPrint('   Raw API: latitude=$rawLat (type: ${rawLat.runtimeType}), longitude=$rawLng (type: ${rawLng.runtimeType})');
      debugPrint('   Parsed: latitude=$parsedLat, longitude=$parsedLng');
      debugPrint('   Final: latitude=${parsedLat ?? 27.5830}, longitude=${parsedLng ?? 77.7000}');
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
    );
  }
}
