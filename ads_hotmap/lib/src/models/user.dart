class User {
  final int? id;
  late final String? email;
  final int? cityId;
  late final String? firstName;
  late final String? middleName;
  late final String? lastName;
  late final String? phone;
  final String? avatar;
  late final String? passportNumber;
  final String? passportPhoto;
  late final String? birthday;
  late final String? homeAddress;
  final String? homeCords;
  final String? oneSignalToken;
  final int? status;
  final DateTime? createdAt;

  User({
    this.id,
    this.email,
    this.cityId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.phone,
    this.avatar,
    this.passportNumber,
    this.passportPhoto,
    this.birthday,
    this.homeAddress,
    this.homeCords,
    this.oneSignalToken,
    this.status,
    this.createdAt,
  });
  Map fromJsonData(Map<String, dynamic> json) {
    return {
      'data': json['data'],
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['data']['id'],
      email: json['data']['email'],
      cityId: json['data']['city_id'],
      firstName: json['data']['first_name'],
      middleName: json['data']['middle_name'],
      lastName: json['data']['last_name'],
      phone: json['data']['phone'],
      avatar: json['data']['avatar'],
      passportNumber: json['data']['passport_number'],
      passportPhoto: json['data']['passport_photo'],
      birthday: json['data']['birthday'],
      homeAddress: json['data']['home_address'],
      homeCords: json['data']['home_cords'],
      oneSignalToken: json['data']['onesignal_token'],
      status: json['data']['status'],
      createdAt: json['data']['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'city_id': cityId,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone': phone,
      'avatar': avatar,
      'passport_number': passportNumber,
      'passport_photo': passportPhoto,
      'birthday': birthday,
      'home_address': homeAddress,
      'home_cords': homeCords,
      'onesignal_token': oneSignalToken,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
