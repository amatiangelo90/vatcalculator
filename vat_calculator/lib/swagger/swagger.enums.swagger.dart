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

enum ProductUnitMeasure {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('KG')
  kg,
  @JsonValue('PEZZI')
  pezzi,
  @JsonValue('CARTONI')
  cartoni,
  @JsonValue('BOTTIGLIA')
  bottiglia,
  @JsonValue('UNITA')
  unita,
  @JsonValue('ALTRO')
  altro
}

const $ProductUnitMeasureMap = {
  ProductUnitMeasure.kg: 'KG',
  ProductUnitMeasure.pezzi: 'PEZZI',
  ProductUnitMeasure.cartoni: 'CARTONI',
  ProductUnitMeasure.bottiglia: 'BOTTIGLIA',
  ProductUnitMeasure.unita: 'UNITA',
  ProductUnitMeasure.altro: 'ALTRO'
};

enum UserEntityUserType {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('entrepreneur')
  entrepreneur,
  @JsonValue('supplier')
  supplier
}

const $UserEntityUserTypeMap = {
  UserEntityUserType.entrepreneur: 'entrepreneur',
  UserEntityUserType.supplier: 'supplier'
};

enum WorkstationWorkstationType {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('BAR')
  bar,
  @JsonValue('CHAMPAGNERIE')
  champagnerie
}

const $WorkstationWorkstationTypeMap = {
  WorkstationWorkstationType.bar: 'BAR',
  WorkstationWorkstationType.champagnerie: 'CHAMPAGNERIE'
};

enum OrderEntityOrderStatus {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('INVIATO')
  inviato,
  @JsonValue('INVIATO_TRAMITE_WHATS_APP')
  inviatoTramiteWhatsApp,
  @JsonValue('INVIATO_TRAMITE_SMS')
  inviatoTramiteSms,
  @JsonValue('NON_INVIATO')
  nonInviato,
  @JsonValue('RICEVUTO')
  ricevuto,
  @JsonValue('NON_RICEVUTO')
  nonRicevuto
}

const $OrderEntityOrderStatusMap = {
  OrderEntityOrderStatus.inviato: 'INVIATO',
  OrderEntityOrderStatus.inviatoTramiteWhatsApp: 'INVIATO_TRAMITE_WHATS_APP',
  OrderEntityOrderStatus.inviatoTramiteSms: 'INVIATO_TRAMITE_SMS',
  OrderEntityOrderStatus.nonInviato: 'NON_INVIATO',
  OrderEntityOrderStatus.ricevuto: 'RICEVUTO',
  OrderEntityOrderStatus.nonRicevuto: 'NON_RICEVUTO'
};

enum BranchUserPriviledge {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('SUPER_ADMIN')
  superAdmin,
  @JsonValue('ADMIN')
  admin,
  @JsonValue('EMPLOYEE')
  employee,
  @JsonValue('BARMAN')
  barman
}

const $BranchUserPriviledgeMap = {
  BranchUserPriviledge.superAdmin: 'SUPER_ADMIN',
  BranchUserPriviledge.admin: 'ADMIN',
  BranchUserPriviledge.employee: 'EMPLOYEE',
  BranchUserPriviledge.barman: 'BARMAN'
};

enum EventEventStatus {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('APERTO')
  aperto,
  @JsonValue('CHIUSO')
  chiuso
}

const $EventEventStatusMap = {
  EventEventStatus.aperto: 'APERTO',
  EventEventStatus.chiuso: 'CHIUSO'
};
