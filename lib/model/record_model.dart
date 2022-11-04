import 'dart:convert';

import 'package:employee_schedule_management/model/employee_model.dart';

class RecordModel {
  String id = "";
  String checkIn = "";
  String checkOut = "";
  String checkOutLocation = "";
  DateTime date = DateTime.now();

  String employeeId = "";
  String firstName;
  String lastName;
  String birthDate;
  String position;
  String address;
  RecordModel({
    this.id = "",
    this.checkIn = "",
    this.checkOut = "",
    this.checkOutLocation = "",
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.position,
    required this.address,
  });
  void setEmployeeToUserModel(EmployeeModel employeeModel) {
    this.employeeId = employeeModel.id;
    this.address = employeeModel.address;
    this.birthDate = employeeModel.birthDate;
    this.firstName = employeeModel.firstName;
    this.lastName = employeeModel.lastName;
    this.position = employeeModel.position;
  }

  RecordModel copyWith({
    String? id,
    String? checkIn,
    String? checkOut,
    String? checkOutLocation,
    String? employeeId,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? position,
    String? address,
  }) {
    return RecordModel(
      id: id ?? this.id,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      checkOutLocation: checkOutLocation ?? this.checkOutLocation,
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      position: position ?? this.position,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'checkOutLocation': checkOutLocation,
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'position': position,
      'address': address,
    };
  }

  factory RecordModel.fromMap(Map<String, dynamic> map) {
    return RecordModel(
      id: map['id'] ?? '',
      checkIn: map['checkIn'] ?? '',
      checkOut: map['checkOut'] ?? '',
      checkOutLocation: map['checkOutLocation'] ?? '',
      employeeId: map['employeeId'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      birthDate: map['birthDate'] ?? '',
      position: map['position'] ?? '',
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordModel.fromJson(String source) =>
      RecordModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RecordModel(id: $id, checkIn: $checkIn, checkOut: $checkOut, checkOutLocation: $checkOutLocation, employeeId: $employeeId, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, position: $position, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecordModel &&
        other.id == id &&
        other.checkIn == checkIn &&
        other.checkOut == checkOut &&
        other.checkOutLocation == checkOutLocation &&
        other.employeeId == employeeId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthDate == birthDate &&
        other.position == position &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        checkIn.hashCode ^
        checkOut.hashCode ^
        checkOutLocation.hashCode ^
        employeeId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthDate.hashCode ^
        position.hashCode ^
        address.hashCode;
  }
}
