class VehicleListing {
  final String id;
  final String title;
  final String description;
  final double currentPrice;
  final double? basePrice;
  final String coverImage;
  final List<String> images;
  final String city;
  final String sellerId;
  final String sellerName;
  final bool isVerified;
  final bool isAuction;
  final int? year;
  final String? brand;
  final String? model;
  final String? bodyType;
  final int? mileage;
  final String? transmission;
  final String? fuelType;
  final DateTime createdAt;
  final DateTime? auctionEndTime;
  final int? bidCount;
  final ListingStatus status;

  VehicleListing({
    required this.id,
    required this.title,
    required this.description,
    required this.currentPrice,
    this.basePrice,
    required this.coverImage,
    required this.images,
    required this.city,
    required this.sellerId,
    required this.sellerName,
    required this.isVerified,
    required this.isAuction,
    this.year,
    this.brand,
    this.model,
    this.bodyType,
    this.mileage,
    this.transmission,
    this.fuelType,
    required this.createdAt,
    this.auctionEndTime,
    this.bidCount,
    this.status = ListingStatus.active,
  });

  factory VehicleListing.fromJson(Map<String, dynamic> json) {
    return VehicleListing(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      basePrice: json['basePrice'] != null ? (json['basePrice'] as num).toDouble() : null,
      coverImage: json['coverImage'] as String,
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      city: json['city'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      isVerified: json['isVerified'] as bool,
      isAuction: json['isAuction'] as bool,
      year: json['year'] as int?,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      bodyType: json['bodyType'] as String?,
      mileage: json['mileage'] as int?,
      transmission: json['transmission'] as String?,
      fuelType: json['fuelType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      auctionEndTime: json['auctionEndTime'] != null
          ? DateTime.parse(json['auctionEndTime'] as String)
          : null,
      bidCount: json['bidCount'] as int?,
      status: ListingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ListingStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'currentPrice': currentPrice,
      'basePrice': basePrice,
      'coverImage': coverImage,
      'images': images,
      'city': city,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'isVerified': isVerified,
      'isAuction': isAuction,
      'year': year,
      'brand': brand,
      'model': model,
      'bodyType': bodyType,
      'mileage': mileage,
      'transmission': transmission,
      'fuelType': fuelType,
      'createdAt': createdAt.toIso8601String(),
      'auctionEndTime': auctionEndTime?.toIso8601String(),
      'bidCount': bidCount,
      'status': status.name,
    };
  }

  VehicleListing copyWith({
    String? id,
    String? title,
    String? description,
    double? currentPrice,
    double? basePrice,
    String? coverImage,
    List<String>? images,
    String? city,
    String? sellerId,
    String? sellerName,
    bool? isVerified,
    bool? isAuction,
    int? year,
    String? brand,
    String? model,
    String? bodyType,
    int? mileage,
    String? transmission,
    String? fuelType,
    DateTime? createdAt,
    DateTime? auctionEndTime,
    int? bidCount,
    ListingStatus? status,
  }) {
    return VehicleListing(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      currentPrice: currentPrice ?? this.currentPrice,
      basePrice: basePrice ?? this.basePrice,
      coverImage: coverImage ?? this.coverImage,
      images: images ?? this.images,
      city: city ?? this.city,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      isVerified: isVerified ?? this.isVerified,
      isAuction: isAuction ?? this.isAuction,
      year: year ?? this.year,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      bodyType: bodyType ?? this.bodyType,
      mileage: mileage ?? this.mileage,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      createdAt: createdAt ?? this.createdAt,
      auctionEndTime: auctionEndTime ?? this.auctionEndTime,
      bidCount: bidCount ?? this.bidCount,
      status: status ?? this.status,
    );
  }
}

enum ListingStatus {
  active,
  pending,
  sold,
  expired,
  blocked,
}

