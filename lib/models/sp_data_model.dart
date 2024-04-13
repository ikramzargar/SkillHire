class ServiceProviderData {
  String name;
  String email;
  String phone;
  String address;
  String profession;
  String experience;
  String rate;
  String userId; // This can be the Firebase user ID
  double latitude;
  double longitude;


  ServiceProviderData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.profession,
    required this.experience,
    required this.rate,
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
      'profession': profession,
      'experience' : experience,
      'rate' : rate,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ServiceProviderData.fromMap(Map<String, dynamic> map) {
    return ServiceProviderData(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      profession: map['profession'],
      experience: map['experience'],
      rate:  map['rate'],
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}