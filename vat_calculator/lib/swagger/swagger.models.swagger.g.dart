// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAccess _$CustomerAccessFromJson(Map<String, dynamic> json) =>
    CustomerAccess(
      accessDate: json['accessDate'] as String?,
      branchLocation:
          customerAccessBranchLocationFromJson(json['branchLocation']),
    );

Map<String, dynamic> _$CustomerAccessToJson(CustomerAccess instance) =>
    <String, dynamic>{
      'accessDate': instance.accessDate,
      'branchLocation':
          customerAccessBranchLocationToJson(instance.branchLocation),
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      accessesList: (json['accessesList'] as List<dynamic>?)
              ?.map((e) => CustomerAccess.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      customerId: json['customerId'] as num?,
      dob: json['dob'] as String?,
      email: json['email'] as String?,
      lastname: json['lastname'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      treatmentPersonalData: json['treatmentPersonalData'] as bool?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'accessesList': instance.accessesList?.map((e) => e.toJson()).toList(),
      'customerId': instance.customerId,
      'dob': instance.dob,
      'email': instance.email,
      'lastname': instance.lastname,
      'name': instance.name,
      'phone': instance.phone,
      'treatmentPersonalData': instance.treatmentPersonalData,
    };
