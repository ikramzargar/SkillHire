class UserData {
  String name;
  String email;
  String phone;
  String address;
  String userId; // This can be the Firebase user ID
  double latitude;
  double longitude;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}