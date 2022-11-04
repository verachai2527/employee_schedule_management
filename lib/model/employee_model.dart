import 'dart:convert';

class EmployeeModel {
  String id;
  String firstName;
  String lastName;
  String birthDate;
  String position;
  String address;
  String profilePicLink;
  double lat;
  double long;
  bool canEdit = true;
  String uid = "";
  EmployeeModel({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.birthDate = "",
    this.position = "",
    this.address = "",
    this.profilePicLink = "",
    this.lat = 0.0,
    this.long = 0.0,
    this.canEdit = true,
  });
  void setEmployeeToUserModel(EmployeeModel employeeModel) {
    this.id = employeeModel.id;
    this.address = employeeModel.address;
    this.birthDate = employeeModel.birthDate;
    this.canEdit = employeeModel.canEdit;
    this.firstName = employeeModel.firstName;
    this.lastName = employeeModel.lastName;
    this.profilePicLink = employeeModel.profilePicLink;
    this.position = employeeModel.position;
    this.uid = employeeModel.uid;
  }

  @override
  String toString() {
    return 'EmployeeModel(id: $id, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, position: $position, address: $address, profilePicLink: $profilePicLink, lat: $lat, long: $long, canEdit: $canEdit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmployeeModel &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthDate == birthDate &&
        other.position == position &&
        other.address == address &&
        other.profilePicLink == profilePicLink &&
        other.lat == lat &&
        other.long == long &&
        other.canEdit == canEdit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthDate.hashCode ^
        position.hashCode ^
        address.hashCode ^
        profilePicLink.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        canEdit.hashCode;
  }

  EmployeeModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? position,
    String? address,
    String? profilePicLink,
    double? lat,
    double? long,
    bool? canEdit,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      position: position ?? this.position,
      address: address ?? this.address,
      profilePicLink: profilePicLink ?? this.profilePicLink,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      canEdit: canEdit ?? this.canEdit,
    );
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      birthDate: map['birthDate'] ?? '',
      position: map['position'] ?? '',
      address: map['address'] ?? '',
      profilePicLink: map['profilePicLink'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
      canEdit: map['canEdit'] ?? false,
    );
  }

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'position': position,
      'address': address,
      'profilePicLink': profilePicLink,
      'lat': lat,
      'long': long,
      'canEdit': canEdit,
    };
  }

  String toJson() => json.encode(toMap());
}
