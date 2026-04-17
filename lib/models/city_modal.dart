class CityModel {
  final int id;
  final String name;
  final String stateName;

  CityModel({
    required this.id,
    required this.name,
    required this.stateName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'],
      name: json['name'],
      stateName: json['state_name'],
    );
  }

  String get displayName => "$name, $stateName";
}