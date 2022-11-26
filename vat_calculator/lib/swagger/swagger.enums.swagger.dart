import 'package:json_annotation/json_annotation.dart';

enum CustomerAccessBranchLocation {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('CISTERNINO')
  cisternino,
  @JsonValue('LOCOROTONDO')
  locorotondo,
  @JsonValue('MONOPOLI')
  monopoli
}

const $CustomerAccessBranchLocationMap = {
  CustomerAccessBranchLocation.cisternino: 'CISTERNINO',
  CustomerAccessBranchLocation.locorotondo: 'LOCOROTONDO',
  CustomerAccessBranchLocation.monopoli: 'MONOPOLI'
};
