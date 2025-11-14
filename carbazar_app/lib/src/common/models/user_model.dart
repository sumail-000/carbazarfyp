class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final String? city;
  final String? cnicNumber;
  final String? dealershipName;
  final String? dealershipAddress;
  final String? dealershipPhone;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    required this.role,
    this.verificationStatus = VerificationStatus.unverified,
    this.city,
    this.cnicNumber,
    this.dealershipName,
    this.dealershipAddress,
    this.dealershipPhone,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.buyer,
      ),
      verificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name == json['verificationStatus'],
        orElse: () => VerificationStatus.unverified,
      ),
      city: json['city'] as String?,
      cnicNumber: json['cnicNumber'] as String?,
      dealershipName: json['dealershipName'] as String?,
      dealershipAddress: json['dealershipAddress'] as String?,
      dealershipPhone: json['dealershipPhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role.name,
      'verificationStatus': verificationStatus.name,
      'city': city,
      'cnicNumber': cnicNumber,
      'dealershipName': dealershipName,
      'dealershipAddress': dealershipAddress,
      'dealershipPhone': dealershipPhone,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    UserRole? role,
    VerificationStatus? verificationStatus,
    String? city,
    String? cnicNumber,
    String? dealershipName,
    String? dealershipAddress,
    String? dealershipPhone,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      city: city ?? this.city,
      cnicNumber: cnicNumber ?? this.cnicNumber,
      dealershipName: dealershipName ?? this.dealershipName,
      dealershipAddress: dealershipAddress ?? this.dealershipAddress,
      dealershipPhone: dealershipPhone ?? this.dealershipPhone,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isSeller => role == UserRole.seller;
  bool get isBuyer => role == UserRole.buyer;
  bool get isVerified => verificationStatus == VerificationStatus.verified;
  bool get isPending => verificationStatus == VerificationStatus.pending;
  bool get isBlocked => verificationStatus == VerificationStatus.blocked;
}

enum UserRole {
  buyer,
  seller,
}

enum VerificationStatus {
  unverified,
  pending,
  verified,
  blocked,
}

