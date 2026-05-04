class StateModel {
  final int id;
  final String name;
  final String? code; // ✅ nullable

  StateModel({
    required this.id,
    required this.name,
    this.code,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      code: json['code'], // now safe
    );
  }
}
class CityModel {
  final int id;
  final String name;
  final String? stateName;

  CityModel({
    required this.id,
    required this.name,
    this.stateName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      stateName: json['state_name'], // Optional
    );
  }
}