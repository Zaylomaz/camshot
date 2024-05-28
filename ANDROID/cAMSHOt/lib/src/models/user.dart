class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  // final String avatar;
  final String passportNumber;
  final String passportPhoto;
  final String birthday;
  final String homeAddress;
  final String homeCords;
  final int cityId;
  final int active;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    // required this.avatar,
    required this.passportNumber,
    required this.passportPhoto,
    required this.birthday,
    required this.homeAddress,
    required this.homeCords,
    required this.cityId,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      // avatar: json['avatar'],
      passportNumber: json['passport_number'],
      passportPhoto: json['passport_photo'],
      birthday: json['birthday'],
      homeAddress: json['home_address'],
      homeCords: json['home_cords'],
      cityId: json['city_id'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone': phone,
      // 'avatar': avatar,
      'passport_number': passportNumber,
      'passport_photo': passportPhoto,
      'birthday': birthday,
      'home_address': homeAddress,
      'home_cords': homeCords,
      'city_id': cityId,
      'active': active,
    };
  }

  UserModel copyWith({
    int? id,
    String? email,
    String? firstName,
    String? middleName,
    String? lastName,
    String? phone,
    // String? avatar,
    String? passportNumber,
    String? passportPhoto,
    String? birthday,
    String? homeAddress,
    String? homeCords,
    int? cityId,
    int? active,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      // avatar: avatar ?? this.avatar,
      passportNumber: passportNumber ?? this.passportNumber,
      passportPhoto: passportPhoto ?? this.passportPhoto,
      birthday: birthday ?? this.birthday,
      homeAddress: homeAddress ?? this.homeAddress,
      homeCords: homeCords ?? this.homeCords,
      cityId: cityId ?? this.cityId,
      active: active ?? this.active,
    );
  }
}
