class AuctionModel {
  final String id;
  final String listingId;
  final String vehicleTitle;
  final String coverImage;
  final double basePrice;
  final double currentBid;
  final double minIncrement;
  final DateTime startTime;
  final DateTime endTime;
  final String sellerId;
  final String sellerName;
  final List<BidModel> bids;
  final int participantsCount;
  final AuctionStatus status;
  final String? winnerId;

  AuctionModel({
    required this.id,
    required this.listingId,
    required this.vehicleTitle,
    required this.coverImage,
    required this.basePrice,
    required this.currentBid,
    required this.minIncrement,
    required this.startTime,
    required this.endTime,
    required this.sellerId,
    required this.sellerName,
    this.bids = const [],
    this.participantsCount = 0,
    required this.status,
    this.winnerId,
  });

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      vehicleTitle: json['vehicleTitle'] as String,
      coverImage: json['coverImage'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      currentBid: (json['currentBid'] as num).toDouble(),
      minIncrement: (json['minIncrement'] as num).toDouble(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      bids: json['bids'] != null
          ? (json['bids'] as List<dynamic>)
              .map((e) => BidModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      participantsCount: json['participantsCount'] as int? ?? 0,
      status: AuctionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AuctionStatus.scheduled,
      ),
      winnerId: json['winnerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'vehicleTitle': vehicleTitle,
      'coverImage': coverImage,
      'basePrice': basePrice,
      'currentBid': currentBid,
      'minIncrement': minIncrement,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'sellerId': sellerId,
      'sellerName': sellerName,
      'bids': bids.map((e) => e.toJson()).toList(),
      'participantsCount': participantsCount,
      'status': status.name,
      'winnerId': winnerId,
    };
  }

  bool get isLive => status == AuctionStatus.live;
  bool get isEnded => status == AuctionStatus.ended;
  bool get isScheduled => status == AuctionStatus.scheduled;
  
  Duration get timeRemaining => endTime.difference(DateTime.now());
  bool get isEndingSoon => timeRemaining.inMinutes < 5 && timeRemaining.inMinutes > 0;
}

class BidModel {
  final String id;
  final String auctionId;
  final String bidderId;
  final String bidderName;
  final double amount;
  final DateTime timestamp;

  BidModel({
    required this.id,
    required this.auctionId,
    required this.bidderId,
    required this.bidderName,
    required this.amount,
    required this.timestamp,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] as String,
      auctionId: json['auctionId'] as String,
      bidderId: json['bidderId'] as String,
      bidderName: json['bidderName'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auctionId': auctionId,
      'bidderId': bidderId,
      'bidderName': bidderName,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

enum AuctionStatus {
  scheduled,
  live,
  ended,
  cancelled,
}

