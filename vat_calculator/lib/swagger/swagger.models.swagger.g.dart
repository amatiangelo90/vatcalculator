// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ROrderProduct _$ROrderProductFromJson(Map<String, dynamic> json) =>
    ROrderProduct(
      amount: (json['amount'] as num?)?.toDouble(),
      orderProductId: json['orderProductId'] as num?,
      price: (json['price'] as num?)?.toDouble(),
      productId: json['productId'] as num?,
      productName: json['productName'] as String?,
      unitMeasure: json['unitMeasure'] as String?,
    );

Map<String, dynamic> _$ROrderProductToJson(ROrderProduct instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'orderProductId': instance.orderProductId,
      'price': instance.price,
      'productId': instance.productId,
      'productName': instance.productName,
      'unitMeasure': instance.unitMeasure,
    };

RWorkstationProduct _$RWorkstationProductFromJson(Map<String, dynamic> json) =>
    RWorkstationProduct(
      amountHundred: (json['amountHundred'] as num?)?.toDouble(),
      consumed: (json['consumed'] as num?)?.toDouble(),
      productId: json['productId'] as num?,
      productName: json['productName'] as String?,
      stockFromStorage: (json['stockFromStorage'] as num?)?.toDouble(),
      storageId: json['storageId'] as num?,
      unitMeasure: json['unitMeasure'] as String?,
      workstationProductId: json['workstationProductId'] as num?,
    );

Map<String, dynamic> _$RWorkstationProductToJson(
        RWorkstationProduct instance) =>
    <String, dynamic>{
      'amountHundred': instance.amountHundred,
      'consumed': instance.consumed,
      'productId': instance.productId,
      'productName': instance.productName,
      'stockFromStorage': instance.stockFromStorage,
      'storageId': instance.storageId,
      'unitMeasure': instance.unitMeasure,
      'workstationProductId': instance.workstationProductId,
    };

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

RStorageProduct _$RStorageProductFromJson(Map<String, dynamic> json) =>
    RStorageProduct(
      amountHundred: (json['amountHundred'] as num?)?.toDouble(),
      available: json['available'] as bool?,
      orderAmount: (json['orderAmount'] as num?)?.toDouble(),
      productId: json['productId'] as num?,
      productName: json['productName'] as String?,
      stock: (json['stock'] as num?)?.toDouble(),
      storageProductId: json['storageProductId'] as num?,
      supplierId: json['supplierId'] as num?,
      unitMeasure: json['unitMeasure'] as String?,
    );

Map<String, dynamic> _$RStorageProductToJson(RStorageProduct instance) =>
    <String, dynamic>{
      'amountHundred': instance.amountHundred,
      'available': instance.available,
      'orderAmount': instance.orderAmount,
      'productId': instance.productId,
      'productName': instance.productName,
      'stock': instance.stock,
      'storageProductId': instance.storageProductId,
      'supplierId': instance.supplierId,
      'unitMeasure': instance.unitMeasure,
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

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      category: json['category'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      productId: json['productId'] as num?,
      supplierId: json['supplierId'] as num?,
      unitMeasure: productUnitMeasureFromJson(json['unitMeasure']),
      unitMeasureOTH: json['unitMeasureOTH'] as String?,
      vatApplied: json['vatApplied'] as int?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'category': instance.category,
      'code': instance.code,
      'description': instance.description,
      'name': instance.name,
      'price': instance.price,
      'productId': instance.productId,
      'supplierId': instance.supplierId,
      'unitMeasure': productUnitMeasureToJson(instance.unitMeasure),
      'unitMeasureOTH': instance.unitMeasureOTH,
      'vatApplied': instance.vatApplied,
    };

LoadUnloadModel _$LoadUnloadModelFromJson(Map<String, dynamic> json) =>
    LoadUnloadModel(
      amount: (json['amount'] as num?)?.toDouble(),
      productId: json['productId'] as num?,
      storageId: json['storageId'] as num?,
    );

Map<String, dynamic> _$LoadUnloadModelToJson(LoadUnloadModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'productId': instance.productId,
      'storageId': instance.storageId,
    };

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      branchList: (json['branchList'] as List<dynamic>?)
              ?.map((e) => Branch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      email: json['email'] as String?,
      lastname: json['lastname'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      photo: json['photo'] as String?,
      userId: json['userId'] as num?,
      userType: userEntityUserTypeFromJson(json['userType']),
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'branchList': instance.branchList?.map((e) => e.toJson()).toList(),
      'email': instance.email,
      'lastname': instance.lastname,
      'name': instance.name,
      'phone': instance.phone,
      'photo': instance.photo,
      'userId': instance.userId,
      'userType': userEntityUserTypeToJson(instance.userType),
    };

ExpenceEvent _$ExpenceEventFromJson(Map<String, dynamic> json) => ExpenceEvent(
      amount: (json['amount'] as num?)?.toDouble(),
      dateIntert: json['dateIntert'] as String?,
      description: json['description'] as String?,
      expenceId: json['expenceId'] as num?,
    );

Map<String, dynamic> _$ExpenceEventToJson(ExpenceEvent instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'dateIntert': instance.dateIntert,
      'description': instance.description,
      'expenceId': instance.expenceId,
    };

Workstation _$WorkstationFromJson(Map<String, dynamic> json) => Workstation(
      eventId: json['eventId'] as num?,
      extra: json['extra'] as String?,
      name: json['name'] as String?,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) =>
                  RWorkstationProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      responsable: json['responsable'] as String?,
      workstationId: json['workstationId'] as num?,
      workstationType:
          workstationWorkstationTypeFromJson(json['workstationType']),
    );

Map<String, dynamic> _$WorkstationToJson(Workstation instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'extra': instance.extra,
      'name': instance.name,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'responsable': instance.responsable,
      'workstationId': instance.workstationId,
      'workstationType':
          workstationWorkstationTypeToJson(instance.workstationType),
    };

OrderEntity _$OrderEntityFromJson(Map<String, dynamic> json) => OrderEntity(
      branchId: json['branchId'] as num?,
      closedBy: json['closedBy'] as String?,
      code: json['code'] as String?,
      creationDate: json['creationDate'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      details: json['details'] as String?,
      errorMessage: json['errorMessage'] as String?,
      orderId: json['orderId'] as num?,
      orderStatus: orderEntityOrderStatusFromJson(json['orderStatus']),
      paid: json['paid'] as bool?,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ROrderProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      senderUser: json['senderUser'] as String?,
      storageId: json['storageId'] as num?,
      supplierId: json['supplierId'] as num?,
      total: (json['total'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderEntityToJson(OrderEntity instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'closedBy': instance.closedBy,
      'code': instance.code,
      'creationDate': instance.creationDate,
      'deliveryDate': instance.deliveryDate,
      'details': instance.details,
      'errorMessage': instance.errorMessage,
      'orderId': instance.orderId,
      'orderStatus': orderEntityOrderStatusToJson(instance.orderStatus),
      'paid': instance.paid,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'senderUser': instance.senderUser,
      'storageId': instance.storageId,
      'supplierId': instance.supplierId,
      'total': instance.total,
    };

Storage _$StorageFromJson(Map<String, dynamic> json) => Storage(
      address: json['address'] as String?,
      branchId: json['branchId'] as num?,
      cap: json['cap'] as String?,
      city: json['city'] as String?,
      creationDate: json['creationDate'] as String?,
      name: json['name'] as String?,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => RStorageProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      storageId: json['storageId'] as num?,
    );

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
      'address': instance.address,
      'branchId': instance.branchId,
      'cap': instance.cap,
      'city': instance.city,
      'creationDate': instance.creationDate,
      'name': instance.name,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'storageId': instance.storageId,
    };

Branch _$BranchFromJson(Map<String, dynamic> json) => Branch(
      address: json['address'] as String?,
      branchCode: json['branchCode'] as String?,
      branchId: json['branchId'] as num?,
      cap: json['cap'] as String?,
      city: json['city'] as String?,
      email: json['email'] as String?,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      name: json['name'] as String?,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      phoneNumber: json['phoneNumber'] as String?,
      storages: (json['storages'] as List<dynamic>?)
              ?.map((e) => Storage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      suppliers: (json['suppliers'] as List<dynamic>?)
              ?.map((e) => Supplier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      token: json['token'] as String?,
      userId: json['userId'] as num?,
      userPriviledge: branchUserPriviledgeFromJson(json['userPriviledge']),
      vatNumber: json['vatNumber'] as String?,
    );

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'address': instance.address,
      'branchCode': instance.branchCode,
      'branchId': instance.branchId,
      'cap': instance.cap,
      'city': instance.city,
      'email': instance.email,
      'events': instance.events?.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'orders': instance.orders?.map((e) => e.toJson()).toList(),
      'phoneNumber': instance.phoneNumber,
      'storages': instance.storages?.map((e) => e.toJson()).toList(),
      'suppliers': instance.suppliers?.map((e) => e.toJson()).toList(),
      'token': instance.token,
      'userId': instance.userId,
      'userPriviledge': branchUserPriviledgeToJson(instance.userPriviledge),
      'vatNumber': instance.vatNumber,
    };

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      branchId: json['branchId'] as num?,
      cardColor: json['cardColor'] as String?,
      createdBy: json['createdBy'] as String?,
      dateCreation: json['dateCreation'] as String?,
      dateEvent: json['dateEvent'] as String?,
      eventId: json['eventId'] as num?,
      eventStatus: eventEventStatusFromJson(json['eventStatus']),
      expenceEvents: (json['expenceEvents'] as List<dynamic>?)
              ?.map((e) => ExpenceEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      location: json['location'] as String?,
      name: json['name'] as String?,
      storageId: json['storageId'] as num?,
      workstations: (json['workstations'] as List<dynamic>?)
              ?.map((e) => Workstation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'branchId': instance.branchId,
      'cardColor': instance.cardColor,
      'createdBy': instance.createdBy,
      'dateCreation': instance.dateCreation,
      'dateEvent': instance.dateEvent,
      'eventId': instance.eventId,
      'eventStatus': eventEventStatusToJson(instance.eventStatus),
      'expenceEvents': instance.expenceEvents?.map((e) => e.toJson()).toList(),
      'location': instance.location,
      'name': instance.name,
      'storageId': instance.storageId,
      'workstations': instance.workstations?.map((e) => e.toJson()).toList(),
    };

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
      address: json['address'] as String?,
      branchId: json['branchId'] as num?,
      cap: json['cap'] as String?,
      cf: json['cf'] as String?,
      city: json['city'] as String?,
      code: json['code'] as String?,
      country: json['country'] as String?,
      createdByUserId: json['createdByUserId'] as num?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      pec: json['pec'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      productList: (json['productList'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      supplierId: json['supplierId'] as num?,
      vatNumber: json['vatNumber'] as String?,
    );

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
      'address': instance.address,
      'branchId': instance.branchId,
      'cap': instance.cap,
      'cf': instance.cf,
      'city': instance.city,
      'code': instance.code,
      'country': instance.country,
      'createdByUserId': instance.createdByUserId,
      'email': instance.email,
      'name': instance.name,
      'pec': instance.pec,
      'phoneNumber': instance.phoneNumber,
      'productList': instance.productList?.map((e) => e.toJson()).toList(),
      'supplierId': instance.supplierId,
      'vatNumber': instance.vatNumber,
    };
