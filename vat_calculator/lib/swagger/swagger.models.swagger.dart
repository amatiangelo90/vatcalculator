// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'swagger.enums.swagger.dart' as enums;

part 'swagger.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomerAccess {
  CustomerAccess({
    this.accessDate,
    this.branchLocation,
  });

  factory CustomerAccess.fromJson(Map<String, dynamic> json) =>
      _$CustomerAccessFromJson(json);

  @JsonKey(name: 'accessDate')
  final String? accessDate;
  @JsonKey(
    name: 'branchLocation',
    toJson: customerAccessBranchLocationToJson,
    fromJson: customerAccessBranchLocationFromJson,
  )
  final enums.CustomerAccessBranchLocation? branchLocation;
  static const fromJsonFactory = _$CustomerAccessFromJson;
  static const toJsonFactory = _$CustomerAccessToJson;
  Map<String, dynamic> toJson() => _$CustomerAccessToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is CustomerAccess &&
            (identical(other.accessDate, accessDate) ||
                const DeepCollectionEquality()
                    .equals(other.accessDate, accessDate)) &&
            (identical(other.branchLocation, branchLocation) ||
                const DeepCollectionEquality()
                    .equals(other.branchLocation, branchLocation)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessDate) ^
      const DeepCollectionEquality().hash(branchLocation) ^
      runtimeType.hashCode;
}

extension $CustomerAccessExtension on CustomerAccess {
  CustomerAccess copyWith(
      {String? accessDate,
      enums.CustomerAccessBranchLocation? branchLocation}) {
    return CustomerAccess(
        accessDate: accessDate ?? this.accessDate,
        branchLocation: branchLocation ?? this.branchLocation);
  }

  CustomerAccess copyWithWrapped(
      {Wrapped<String?>? accessDate,
      Wrapped<enums.CustomerAccessBranchLocation?>? branchLocation}) {
    return CustomerAccess(
        accessDate: (accessDate != null ? accessDate.value : this.accessDate),
        branchLocation: (branchLocation != null
            ? branchLocation.value
            : this.branchLocation));
  }
}

@JsonSerializable(explicitToJson: true)
class Customer {
  Customer({
    this.accessesList,
    this.customerId,
    this.dob,
    this.email,
    this.lastname,
    this.name,
    this.phone,
    this.treatmentPersonalData,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  @JsonKey(name: 'accessesList', defaultValue: <CustomerAccess>[])
  final List<CustomerAccess>? accessesList;
  @JsonKey(name: 'customerId')
  final num? customerId;
  @JsonKey(name: 'dob')
  final String? dob;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'lastname')
  final String? lastname;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'treatmentPersonalData')
  final bool? treatmentPersonalData;
  static const fromJsonFactory = _$CustomerFromJson;
  static const toJsonFactory = _$CustomerToJson;
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Customer &&
            (identical(other.accessesList, accessesList) ||
                const DeepCollectionEquality()
                    .equals(other.accessesList, accessesList)) &&
            (identical(other.customerId, customerId) ||
                const DeepCollectionEquality()
                    .equals(other.customerId, customerId)) &&
            (identical(other.dob, dob) ||
                const DeepCollectionEquality().equals(other.dob, dob)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.lastname, lastname) ||
                const DeepCollectionEquality()
                    .equals(other.lastname, lastname)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.phone, phone) ||
                const DeepCollectionEquality().equals(other.phone, phone)) &&
            (identical(other.treatmentPersonalData, treatmentPersonalData) ||
                const DeepCollectionEquality().equals(
                    other.treatmentPersonalData, treatmentPersonalData)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessesList) ^
      const DeepCollectionEquality().hash(customerId) ^
      const DeepCollectionEquality().hash(dob) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(lastname) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(phone) ^
      const DeepCollectionEquality().hash(treatmentPersonalData) ^
      runtimeType.hashCode;
}

extension $CustomerExtension on Customer {
  Customer copyWith(
      {List<CustomerAccess>? accessesList,
      num? customerId,
      String? dob,
      String? email,
      String? lastname,
      String? name,
      String? phone,
      bool? treatmentPersonalData}) {
    return Customer(
        accessesList: accessesList ?? this.accessesList,
        customerId: customerId ?? this.customerId,
        dob: dob ?? this.dob,
        email: email ?? this.email,
        lastname: lastname ?? this.lastname,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        treatmentPersonalData:
            treatmentPersonalData ?? this.treatmentPersonalData);
  }

  Customer copyWithWrapped(
      {Wrapped<List<CustomerAccess>?>? accessesList,
      Wrapped<num?>? customerId,
      Wrapped<String?>? dob,
      Wrapped<String?>? email,
      Wrapped<String?>? lastname,
      Wrapped<String?>? name,
      Wrapped<String?>? phone,
      Wrapped<bool?>? treatmentPersonalData}) {
    return Customer(
        accessesList:
            (accessesList != null ? accessesList.value : this.accessesList),
        customerId: (customerId != null ? customerId.value : this.customerId),
        dob: (dob != null ? dob.value : this.dob),
        email: (email != null ? email.value : this.email),
        lastname: (lastname != null ? lastname.value : this.lastname),
        name: (name != null ? name.value : this.name),
        phone: (phone != null ? phone.value : this.phone),
        treatmentPersonalData: (treatmentPersonalData != null
            ? treatmentPersonalData.value
            : this.treatmentPersonalData));
  }
}

String? customerAccessBranchLocationToJson(
    enums.CustomerAccessBranchLocation? customerAccessBranchLocation) {
  return enums.$CustomerAccessBranchLocationMap[customerAccessBranchLocation];
}

enums.CustomerAccessBranchLocation customerAccessBranchLocationFromJson(
  Object? customerAccessBranchLocation, [
  enums.CustomerAccessBranchLocation? defaultValue,
]) {
  if (customerAccessBranchLocation is String) {
    return enums.$CustomerAccessBranchLocationMap.entries
        .firstWhere(
            (element) =>
                element.value.toLowerCase() ==
                customerAccessBranchLocation.toLowerCase(),
            orElse: () => const MapEntry(
                enums.CustomerAccessBranchLocation.swaggerGeneratedUnknown, ''))
        .key;
  }

  final parsedResult = defaultValue == null
      ? null
      : enums.$CustomerAccessBranchLocationMap.entries
          .firstWhereOrNull((element) => element.value == defaultValue)
          ?.key;

  return parsedResult ??
      defaultValue ??
      enums.CustomerAccessBranchLocation.swaggerGeneratedUnknown;
}

List<String> customerAccessBranchLocationListToJson(
    List<enums.CustomerAccessBranchLocation>? customerAccessBranchLocation) {
  if (customerAccessBranchLocation == null) {
    return [];
  }

  return customerAccessBranchLocation
      .map((e) => enums.$CustomerAccessBranchLocationMap[e]!)
      .toList();
}

List<enums.CustomerAccessBranchLocation>
    customerAccessBranchLocationListFromJson(
  List? customerAccessBranchLocation, [
  List<enums.CustomerAccessBranchLocation>? defaultValue,
]) {
  if (customerAccessBranchLocation == null) {
    return defaultValue ?? [];
  }

  return customerAccessBranchLocation
      .map((e) => customerAccessBranchLocationFromJson(e.toString()))
      .toList();
}

List<enums.CustomerAccessBranchLocation>?
    customerAccessBranchLocationNullableListFromJson(
  List? customerAccessBranchLocation, [
  List<enums.CustomerAccessBranchLocation>? defaultValue,
]) {
  if (customerAccessBranchLocation == null) {
    return defaultValue;
  }

  return customerAccessBranchLocation
      .map((e) => customerAccessBranchLocationFromJson(e.toString()))
      .toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
