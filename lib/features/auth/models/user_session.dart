class UserSession {
  const UserSession({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.profileImage,
    required this.accessToken,
    required this.refreshToken,
  });

  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String profileImage;
  final String accessToken;
  final String refreshToken;

  String get fullName => '$firstName $lastName'.trim();

  factory UserSession.fromApiJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;

    return UserSession(
      userId: (json['userId'] ?? user['userId'] ?? user['_id'] ?? '').toString(),
      email: (json['email'] ?? user['email'] ?? '').toString(),
      firstName: (json['firstName'] ?? user['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? user['lastName'] ?? '').toString(),
      phone: (json['phone'] ?? user['phone'] ?? user['phoneNumber'] ?? '').toString(),
      profileImage: (json['profileImage'] ??
              user['profileImage'] ??
              user['avatar'] ??
              user['image'] ??
              '')
          .toString(),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
    );
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      userId: (json['userId'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      profileImage: (json['profileImage'] ?? '').toString(),
      accessToken: (json['accessToken'] ?? '').toString(),
      refreshToken: (json['refreshToken'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profileImage': profileImage,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  UserSession copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserSession(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
