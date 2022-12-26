import 'swagger.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:chopper/chopper.dart' as chopper;
import 'swagger.enums.swagger.dart' as enums;
export 'swagger.enums.swagger.dart';
export 'swagger.models.swagger.dart';

part 'swagger.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Swagger extends ChopperService {
  static Swagger create({
    ChopperClient? client,
    Authenticator? authenticator,
    String? baseUrl,
    Iterable<dynamic>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
        services: [_$Swagger()],
        converter: $JsonSerializableConverter(),
        interceptors: interceptors ?? [],
        authenticator: authenticator,
        baseUrl: baseUrl ?? 'http://localhost:16172/ventimetriquadriservice');
    return _$Swagger(newClient);
  }

  ///createBranchSupplierRelation
  ///@param branchId branchId
  ///@param supplierId supplierId
  Future<chopper.Response> apiV1AppBranchesCreatebranchsupplierrelationPut({
    required int? branchId,
    required int? supplierId,
  }) {
    return _apiV1AppBranchesCreatebranchsupplierrelationPut(
        branchId: branchId, supplierId: supplierId);
  }

  ///createBranchSupplierRelation
  ///@param branchId branchId
  ///@param supplierId supplierId
  @Put(
    path: '/api/v1/app/branches/createbranchsupplierrelation',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppBranchesCreatebranchsupplierrelationPut({
    @Query('branchId') required int? branchId,
    @Query('supplierId') required int? supplierId,
  });

  ///delete
  ///@param storages[0].products[0].storageProductId
  ///@param storages[0].products[0].productName
  ///@param storages[0].products[0].unitMeasure
  ///@param storages[0].products[0].stock
  ///@param storages[0].products[0].amountHundred
  ///@param storages[0].products[0].productId
  ///@param storages[0].storageId
  ///@param storages[0].name
  ///@param storages[0].creationDate
  ///@param storages[0].address
  ///@param storages[0].city
  ///@param storages[0].cap
  ///@param storages[0].branchId
  ///@param suppliers[0].productList[0].productId
  ///@param suppliers[0].productList[0].name
  ///@param suppliers[0].productList[0].code
  ///@param suppliers[0].productList[0].unitMeasure
  ///@param suppliers[0].productList[0].unitMeasureOTH
  ///@param suppliers[0].productList[0].vatApplied
  ///@param suppliers[0].productList[0].price
  ///@param suppliers[0].productList[0].description
  ///@param suppliers[0].productList[0].category
  ///@param suppliers[0].productList[0].supplierId
  ///@param suppliers[0].supplierId
  ///@param suppliers[0].name
  ///@param suppliers[0].vatNumber
  ///@param suppliers[0].address
  ///@param suppliers[0].city
  ///@param suppliers[0].cap
  ///@param suppliers[0].code
  ///@param suppliers[0].phoneNumber
  ///@param suppliers[0].email
  ///@param suppliers[0].pec
  ///@param suppliers[0].cf
  ///@param suppliers[0].country
  ///@param suppliers[0].createdByUserId
  ///@param suppliers[0].branchId
  ///@param events[0].expenceEvents[0].expenceId
  ///@param events[0].expenceEvents[0].description
  ///@param events[0].expenceEvents[0].amount
  ///@param events[0].expenceEvents[0].dateIntert
  ///@param events[0].expenceEvents[0].eventId
  ///@param events[0].workstations[0].products[0].workstationProductId
  ///@param events[0].workstations[0].products[0].productName
  ///@param events[0].workstations[0].products[0].unitMeasure
  ///@param events[0].workstations[0].products[0].stockFromStorage
  ///@param events[0].workstations[0].products[0].consumed
  ///@param events[0].workstations[0].products[0].amountHundred
  ///@param events[0].workstations[0].products[0].productId
  ///@param events[0].workstations[0].products[0].storageId
  ///@param events[0].workstations[0].workstationId
  ///@param events[0].workstations[0].name
  ///@param events[0].workstations[0].responsable
  ///@param events[0].workstations[0].extra
  ///@param events[0].workstations[0].workstationType
  ///@param events[0].workstations[0].eventId
  ///@param events[0].eventId
  ///@param events[0].name
  ///@param events[0].dateEvent
  ///@param events[0].dateCreation
  ///@param events[0].eventStatus
  ///@param events[0].location
  ///@param events[0].branchId
  ///@param events[0].storageId
  ///@param orders[0].products[0].orderProductId
  ///@param orders[0].products[0].productName
  ///@param orders[0].products[0].unitMeasure
  ///@param orders[0].products[0].productId
  ///@param orders[0].products[0].price
  ///@param orders[0].products[0].amount
  ///@param orders[0].orderId
  ///@param orders[0].code
  ///@param orders[0].total
  ///@param orders[0].orderStatus
  ///@param orders[0].errorStatus
  ///@param orders[0].creationDate
  ///@param orders[0].senderUser
  ///@param orders[0].details
  ///@param orders[0].deliveryDate
  ///@param orders[0].closedBy
  ///@param orders[0].supplierId
  ///@param orders[0].branchId
  ///@param orders[0].storageId
  ///@param branchId
  ///@param branchCode
  ///@param name
  ///@param email
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param phoneNumber
  ///@param userId
  ///@param token
  ///@param userPriviledge
  Future<chopper.Response> apiV1AppBranchesDeleteDelete({
    int? storages0Products0StorageProductId,
    String? storages0Products0ProductName,
    String? storages0Products0UnitMeasure,
    num? storages0Products0Stock,
    num? storages0Products0AmountHundred,
    int? storages0Products0ProductId,
    int? storages0StorageId,
    String? storages0Name,
    String? storages0CreationDate,
    String? storages0Address,
    String? storages0City,
    String? storages0Cap,
    int? storages0BranchId,
    int? suppliers0ProductList0ProductId,
    String? suppliers0ProductList0Name,
    String? suppliers0ProductList0Code,
    String? suppliers0ProductList0UnitMeasure,
    String? suppliers0ProductList0UnitMeasureOTH,
    int? suppliers0ProductList0VatApplied,
    num? suppliers0ProductList0Price,
    String? suppliers0ProductList0Description,
    String? suppliers0ProductList0Category,
    int? suppliers0ProductList0SupplierId,
    int? suppliers0SupplierId,
    String? suppliers0Name,
    String? suppliers0VatNumber,
    String? suppliers0Address,
    String? suppliers0City,
    String? suppliers0Cap,
    String? suppliers0Code,
    String? suppliers0PhoneNumber,
    String? suppliers0Email,
    String? suppliers0Pec,
    String? suppliers0Cf,
    String? suppliers0Country,
    int? suppliers0CreatedByUserId,
    int? suppliers0BranchId,
    int? events0ExpenceEvents0ExpenceId,
    String? events0ExpenceEvents0Description,
    num? events0ExpenceEvents0Amount,
    String? events0ExpenceEvents0DateIntert,
    int? events0ExpenceEvents0EventId,
    int? events0Workstations0Products0WorkstationProductId,
    String? events0Workstations0Products0ProductName,
    String? events0Workstations0Products0UnitMeasure,
    num? events0Workstations0Products0StockFromStorage,
    num? events0Workstations0Products0Consumed,
    num? events0Workstations0Products0AmountHundred,
    int? events0Workstations0Products0ProductId,
    int? events0Workstations0Products0StorageId,
    int? events0Workstations0WorkstationId,
    String? events0Workstations0Name,
    String? events0Workstations0Responsable,
    String? events0Workstations0Extra,
    String? events0Workstations0WorkstationType,
    int? events0Workstations0EventId,
    int? events0EventId,
    String? events0Name,
    String? events0DateEvent,
    String? events0DateCreation,
    String? events0EventStatus,
    String? events0Location,
    int? events0BranchId,
    int? events0StorageId,
    int? orders0Products0OrderProductId,
    String? orders0Products0ProductName,
    String? orders0Products0UnitMeasure,
    int? orders0Products0ProductId,
    num? orders0Products0Price,
    num? orders0Products0Amount,
    int? orders0OrderId,
    String? orders0Code,
    num? orders0Total,
    String? orders0OrderStatus,
    String? orders0ErrorStatus,
    String? orders0CreationDate,
    String? orders0SenderUser,
    String? orders0Details,
    String? orders0DeliveryDate,
    String? orders0ClosedBy,
    int? orders0SupplierId,
    int? orders0BranchId,
    int? orders0StorageId,
    int? branchId,
    String? branchCode,
    String? name,
    String? email,
    String? vatNumber,
    String? address,
    String? city,
    String? cap,
    String? phoneNumber,
    int? userId,
    String? token,
    String? userPriviledge,
  }) {
    return _apiV1AppBranchesDeleteDelete(
        storages0Products0StorageProductId: storages0Products0StorageProductId,
        storages0Products0ProductName: storages0Products0ProductName,
        storages0Products0UnitMeasure: storages0Products0UnitMeasure,
        storages0Products0Stock: storages0Products0Stock,
        storages0Products0AmountHundred: storages0Products0AmountHundred,
        storages0Products0ProductId: storages0Products0ProductId,
        storages0StorageId: storages0StorageId,
        storages0Name: storages0Name,
        storages0CreationDate: storages0CreationDate,
        storages0Address: storages0Address,
        storages0City: storages0City,
        storages0Cap: storages0Cap,
        storages0BranchId: storages0BranchId,
        suppliers0ProductList0ProductId: suppliers0ProductList0ProductId,
        suppliers0ProductList0Name: suppliers0ProductList0Name,
        suppliers0ProductList0Code: suppliers0ProductList0Code,
        suppliers0ProductList0UnitMeasure: suppliers0ProductList0UnitMeasure,
        suppliers0ProductList0UnitMeasureOTH:
            suppliers0ProductList0UnitMeasureOTH,
        suppliers0ProductList0VatApplied: suppliers0ProductList0VatApplied,
        suppliers0ProductList0Price: suppliers0ProductList0Price,
        suppliers0ProductList0Description: suppliers0ProductList0Description,
        suppliers0ProductList0Category: suppliers0ProductList0Category,
        suppliers0ProductList0SupplierId: suppliers0ProductList0SupplierId,
        suppliers0SupplierId: suppliers0SupplierId,
        suppliers0Name: suppliers0Name,
        suppliers0VatNumber: suppliers0VatNumber,
        suppliers0Address: suppliers0Address,
        suppliers0City: suppliers0City,
        suppliers0Cap: suppliers0Cap,
        suppliers0Code: suppliers0Code,
        suppliers0PhoneNumber: suppliers0PhoneNumber,
        suppliers0Email: suppliers0Email,
        suppliers0Pec: suppliers0Pec,
        suppliers0Cf: suppliers0Cf,
        suppliers0Country: suppliers0Country,
        suppliers0CreatedByUserId: suppliers0CreatedByUserId,
        suppliers0BranchId: suppliers0BranchId,
        events0ExpenceEvents0ExpenceId: events0ExpenceEvents0ExpenceId,
        events0ExpenceEvents0Description: events0ExpenceEvents0Description,
        events0ExpenceEvents0Amount: events0ExpenceEvents0Amount,
        events0ExpenceEvents0DateIntert: events0ExpenceEvents0DateIntert,
        events0ExpenceEvents0EventId: events0ExpenceEvents0EventId,
        events0Workstations0Products0WorkstationProductId:
            events0Workstations0Products0WorkstationProductId,
        events0Workstations0Products0ProductName:
            events0Workstations0Products0ProductName,
        events0Workstations0Products0UnitMeasure:
            events0Workstations0Products0UnitMeasure,
        events0Workstations0Products0StockFromStorage:
            events0Workstations0Products0StockFromStorage,
        events0Workstations0Products0Consumed:
            events0Workstations0Products0Consumed,
        events0Workstations0Products0AmountHundred:
            events0Workstations0Products0AmountHundred,
        events0Workstations0Products0ProductId:
            events0Workstations0Products0ProductId,
        events0Workstations0Products0StorageId:
            events0Workstations0Products0StorageId,
        events0Workstations0WorkstationId: events0Workstations0WorkstationId,
        events0Workstations0Name: events0Workstations0Name,
        events0Workstations0Responsable: events0Workstations0Responsable,
        events0Workstations0Extra: events0Workstations0Extra,
        events0Workstations0WorkstationType:
            events0Workstations0WorkstationType,
        events0Workstations0EventId: events0Workstations0EventId,
        events0EventId: events0EventId,
        events0Name: events0Name,
        events0DateEvent: events0DateEvent,
        events0DateCreation: events0DateCreation,
        events0EventStatus: events0EventStatus,
        events0Location: events0Location,
        events0BranchId: events0BranchId,
        events0StorageId: events0StorageId,
        orders0Products0OrderProductId: orders0Products0OrderProductId,
        orders0Products0ProductName: orders0Products0ProductName,
        orders0Products0UnitMeasure: orders0Products0UnitMeasure,
        orders0Products0ProductId: orders0Products0ProductId,
        orders0Products0Price: orders0Products0Price,
        orders0Products0Amount: orders0Products0Amount,
        orders0OrderId: orders0OrderId,
        orders0Code: orders0Code,
        orders0Total: orders0Total,
        orders0OrderStatus: orders0OrderStatus,
        orders0ErrorStatus: orders0ErrorStatus,
        orders0CreationDate: orders0CreationDate,
        orders0SenderUser: orders0SenderUser,
        orders0Details: orders0Details,
        orders0DeliveryDate: orders0DeliveryDate,
        orders0ClosedBy: orders0ClosedBy,
        orders0SupplierId: orders0SupplierId,
        orders0BranchId: orders0BranchId,
        orders0StorageId: orders0StorageId,
        branchId: branchId,
        branchCode: branchCode,
        name: name,
        email: email,
        vatNumber: vatNumber,
        address: address,
        city: city,
        cap: cap,
        phoneNumber: phoneNumber,
        userId: userId,
        token: token,
        userPriviledge: userPriviledge);
  }

  ///delete
  ///@param storages[0].products[0].storageProductId
  ///@param storages[0].products[0].productName
  ///@param storages[0].products[0].unitMeasure
  ///@param storages[0].products[0].stock
  ///@param storages[0].products[0].amountHundred
  ///@param storages[0].products[0].productId
  ///@param storages[0].storageId
  ///@param storages[0].name
  ///@param storages[0].creationDate
  ///@param storages[0].address
  ///@param storages[0].city
  ///@param storages[0].cap
  ///@param storages[0].branchId
  ///@param suppliers[0].productList[0].productId
  ///@param suppliers[0].productList[0].name
  ///@param suppliers[0].productList[0].code
  ///@param suppliers[0].productList[0].unitMeasure
  ///@param suppliers[0].productList[0].unitMeasureOTH
  ///@param suppliers[0].productList[0].vatApplied
  ///@param suppliers[0].productList[0].price
  ///@param suppliers[0].productList[0].description
  ///@param suppliers[0].productList[0].category
  ///@param suppliers[0].productList[0].supplierId
  ///@param suppliers[0].supplierId
  ///@param suppliers[0].name
  ///@param suppliers[0].vatNumber
  ///@param suppliers[0].address
  ///@param suppliers[0].city
  ///@param suppliers[0].cap
  ///@param suppliers[0].code
  ///@param suppliers[0].phoneNumber
  ///@param suppliers[0].email
  ///@param suppliers[0].pec
  ///@param suppliers[0].cf
  ///@param suppliers[0].country
  ///@param suppliers[0].createdByUserId
  ///@param suppliers[0].branchId
  ///@param events[0].expenceEvents[0].expenceId
  ///@param events[0].expenceEvents[0].description
  ///@param events[0].expenceEvents[0].amount
  ///@param events[0].expenceEvents[0].dateIntert
  ///@param events[0].expenceEvents[0].eventId
  ///@param events[0].workstations[0].products[0].workstationProductId
  ///@param events[0].workstations[0].products[0].productName
  ///@param events[0].workstations[0].products[0].unitMeasure
  ///@param events[0].workstations[0].products[0].stockFromStorage
  ///@param events[0].workstations[0].products[0].consumed
  ///@param events[0].workstations[0].products[0].amountHundred
  ///@param events[0].workstations[0].products[0].productId
  ///@param events[0].workstations[0].products[0].storageId
  ///@param events[0].workstations[0].workstationId
  ///@param events[0].workstations[0].name
  ///@param events[0].workstations[0].responsable
  ///@param events[0].workstations[0].extra
  ///@param events[0].workstations[0].workstationType
  ///@param events[0].workstations[0].eventId
  ///@param events[0].eventId
  ///@param events[0].name
  ///@param events[0].dateEvent
  ///@param events[0].dateCreation
  ///@param events[0].eventStatus
  ///@param events[0].location
  ///@param events[0].branchId
  ///@param events[0].storageId
  ///@param orders[0].products[0].orderProductId
  ///@param orders[0].products[0].productName
  ///@param orders[0].products[0].unitMeasure
  ///@param orders[0].products[0].productId
  ///@param orders[0].products[0].price
  ///@param orders[0].products[0].amount
  ///@param orders[0].orderId
  ///@param orders[0].code
  ///@param orders[0].total
  ///@param orders[0].orderStatus
  ///@param orders[0].errorStatus
  ///@param orders[0].creationDate
  ///@param orders[0].senderUser
  ///@param orders[0].details
  ///@param orders[0].deliveryDate
  ///@param orders[0].closedBy
  ///@param orders[0].supplierId
  ///@param orders[0].branchId
  ///@param orders[0].storageId
  ///@param branchId
  ///@param branchCode
  ///@param name
  ///@param email
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param phoneNumber
  ///@param userId
  ///@param token
  ///@param userPriviledge
  @Delete(path: '/api/v1/app/branches/delete')
  Future<chopper.Response> _apiV1AppBranchesDeleteDelete({
    @Query('storages[0].products[0].storageProductId')
        int? storages0Products0StorageProductId,
    @Query('storages[0].products[0].productName')
        String? storages0Products0ProductName,
    @Query('storages[0].products[0].unitMeasure')
        String? storages0Products0UnitMeasure,
    @Query('storages[0].products[0].stock') num? storages0Products0Stock,
    @Query('storages[0].products[0].amountHundred')
        num? storages0Products0AmountHundred,
    @Query('storages[0].products[0].productId')
        int? storages0Products0ProductId,
    @Query('storages[0].storageId') int? storages0StorageId,
    @Query('storages[0].name') String? storages0Name,
    @Query('storages[0].creationDate') String? storages0CreationDate,
    @Query('storages[0].address') String? storages0Address,
    @Query('storages[0].city') String? storages0City,
    @Query('storages[0].cap') String? storages0Cap,
    @Query('storages[0].branchId') int? storages0BranchId,
    @Query('suppliers[0].productList[0].productId')
        int? suppliers0ProductList0ProductId,
    @Query('suppliers[0].productList[0].name')
        String? suppliers0ProductList0Name,
    @Query('suppliers[0].productList[0].code')
        String? suppliers0ProductList0Code,
    @Query('suppliers[0].productList[0].unitMeasure')
        String? suppliers0ProductList0UnitMeasure,
    @Query('suppliers[0].productList[0].unitMeasureOTH')
        String? suppliers0ProductList0UnitMeasureOTH,
    @Query('suppliers[0].productList[0].vatApplied')
        int? suppliers0ProductList0VatApplied,
    @Query('suppliers[0].productList[0].price')
        num? suppliers0ProductList0Price,
    @Query('suppliers[0].productList[0].description')
        String? suppliers0ProductList0Description,
    @Query('suppliers[0].productList[0].category')
        String? suppliers0ProductList0Category,
    @Query('suppliers[0].productList[0].supplierId')
        int? suppliers0ProductList0SupplierId,
    @Query('suppliers[0].supplierId') int? suppliers0SupplierId,
    @Query('suppliers[0].name') String? suppliers0Name,
    @Query('suppliers[0].vatNumber') String? suppliers0VatNumber,
    @Query('suppliers[0].address') String? suppliers0Address,
    @Query('suppliers[0].city') String? suppliers0City,
    @Query('suppliers[0].cap') String? suppliers0Cap,
    @Query('suppliers[0].code') String? suppliers0Code,
    @Query('suppliers[0].phoneNumber') String? suppliers0PhoneNumber,
    @Query('suppliers[0].email') String? suppliers0Email,
    @Query('suppliers[0].pec') String? suppliers0Pec,
    @Query('suppliers[0].cf') String? suppliers0Cf,
    @Query('suppliers[0].country') String? suppliers0Country,
    @Query('suppliers[0].createdByUserId') int? suppliers0CreatedByUserId,
    @Query('suppliers[0].branchId') int? suppliers0BranchId,
    @Query('events[0].expenceEvents[0].expenceId')
        int? events0ExpenceEvents0ExpenceId,
    @Query('events[0].expenceEvents[0].description')
        String? events0ExpenceEvents0Description,
    @Query('events[0].expenceEvents[0].amount')
        num? events0ExpenceEvents0Amount,
    @Query('events[0].expenceEvents[0].dateIntert')
        String? events0ExpenceEvents0DateIntert,
    @Query('events[0].expenceEvents[0].eventId')
        int? events0ExpenceEvents0EventId,
    @Query('events[0].workstations[0].products[0].workstationProductId')
        int? events0Workstations0Products0WorkstationProductId,
    @Query('events[0].workstations[0].products[0].productName')
        String? events0Workstations0Products0ProductName,
    @Query('events[0].workstations[0].products[0].unitMeasure')
        String? events0Workstations0Products0UnitMeasure,
    @Query('events[0].workstations[0].products[0].stockFromStorage')
        num? events0Workstations0Products0StockFromStorage,
    @Query('events[0].workstations[0].products[0].consumed')
        num? events0Workstations0Products0Consumed,
    @Query('events[0].workstations[0].products[0].amountHundred')
        num? events0Workstations0Products0AmountHundred,
    @Query('events[0].workstations[0].products[0].productId')
        int? events0Workstations0Products0ProductId,
    @Query('events[0].workstations[0].products[0].storageId')
        int? events0Workstations0Products0StorageId,
    @Query('events[0].workstations[0].workstationId')
        int? events0Workstations0WorkstationId,
    @Query('events[0].workstations[0].name') String? events0Workstations0Name,
    @Query('events[0].workstations[0].responsable')
        String? events0Workstations0Responsable,
    @Query('events[0].workstations[0].extra') String? events0Workstations0Extra,
    @Query('events[0].workstations[0].workstationType')
        String? events0Workstations0WorkstationType,
    @Query('events[0].workstations[0].eventId')
        int? events0Workstations0EventId,
    @Query('events[0].eventId') int? events0EventId,
    @Query('events[0].name') String? events0Name,
    @Query('events[0].dateEvent') String? events0DateEvent,
    @Query('events[0].dateCreation') String? events0DateCreation,
    @Query('events[0].eventStatus') String? events0EventStatus,
    @Query('events[0].location') String? events0Location,
    @Query('events[0].branchId') int? events0BranchId,
    @Query('events[0].storageId') int? events0StorageId,
    @Query('orders[0].products[0].orderProductId')
        int? orders0Products0OrderProductId,
    @Query('orders[0].products[0].productName')
        String? orders0Products0ProductName,
    @Query('orders[0].products[0].unitMeasure')
        String? orders0Products0UnitMeasure,
    @Query('orders[0].products[0].productId') int? orders0Products0ProductId,
    @Query('orders[0].products[0].price') num? orders0Products0Price,
    @Query('orders[0].products[0].amount') num? orders0Products0Amount,
    @Query('orders[0].orderId') int? orders0OrderId,
    @Query('orders[0].code') String? orders0Code,
    @Query('orders[0].total') num? orders0Total,
    @Query('orders[0].orderStatus') String? orders0OrderStatus,
    @Query('orders[0].errorStatus') String? orders0ErrorStatus,
    @Query('orders[0].creationDate') String? orders0CreationDate,
    @Query('orders[0].senderUser') String? orders0SenderUser,
    @Query('orders[0].details') String? orders0Details,
    @Query('orders[0].deliveryDate') String? orders0DeliveryDate,
    @Query('orders[0].closedBy') String? orders0ClosedBy,
    @Query('orders[0].supplierId') int? orders0SupplierId,
    @Query('orders[0].branchId') int? orders0BranchId,
    @Query('orders[0].storageId') int? orders0StorageId,
    @Query('branchId') int? branchId,
    @Query('branchCode') String? branchCode,
    @Query('name') String? name,
    @Query('email') String? email,
    @Query('vatNumber') String? vatNumber,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('phoneNumber') String? phoneNumber,
    @Query('userId') int? userId,
    @Query('token') String? token,
    @Query('userPriviledge') String? userPriviledge,
  });

  ///retrieveAll
  Future<chopper.Response<List<Branch>>> apiV1AppBranchesFindallGet() {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppBranchesFindallGet();
  }

  ///retrieveAll
  @Get(path: '/api/v1/app/branches/findall')
  Future<chopper.Response<List<Branch>>> _apiV1AppBranchesFindallGet();

  ///linkBranchAndUser
  ///@param branchId branchId
  ///@param userId userId
  ///@param userPriviledge userPriviledge
  Future<chopper.Response> apiV1AppBranchesLinkbranchanduserGet({
    int? branchId,
    int? userId,
    String? userPriviledge,
  }) {
    return _apiV1AppBranchesLinkbranchanduserGet(
        branchId: branchId, userId: userId, userPriviledge: userPriviledge);
  }

  ///linkBranchAndUser
  ///@param branchId branchId
  ///@param userId userId
  ///@param userPriviledge userPriviledge
  @Get(path: '/api/v1/app/branches/linkbranchanduser')
  Future<chopper.Response> _apiV1AppBranchesLinkbranchanduserGet({
    @Query('branchId') int? branchId,
    @Query('userId') int? userId,
    @Query('userPriviledge') String? userPriviledge,
  });

  ///retrieveByBranchCode
  ///@param branchcode branchcode
  Future<chopper.Response<Branch>> apiV1AppBranchesRetrievebranchbycodeGet(
      {required String? branchcode}) {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppBranchesRetrievebranchbycodeGet(branchcode: branchcode);
  }

  ///retrieveByBranchCode
  ///@param branchcode branchcode
  @Get(path: '/api/v1/app/branches/retrievebranchbycode')
  Future<chopper.Response<Branch>> _apiV1AppBranchesRetrievebranchbycodeGet(
      {@Query('branchcode') required String? branchcode});

  ///retrieveByBranchId
  ///@param branchid branchid
  Future<chopper.Response<Branch>> apiV1AppBranchesRetrievebranchbyidGet(
      {required int? branchid}) {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppBranchesRetrievebranchbyidGet(branchid: branchid);
  }

  ///retrieveByBranchId
  ///@param branchid branchid
  @Get(path: '/api/v1/app/branches/retrievebranchbyid')
  Future<chopper.Response<Branch>> _apiV1AppBranchesRetrievebranchbyidGet(
      {@Query('branchid') required int? branchid});

  ///retrieveAllSuppliersByBranchId
  ///@param branchid branchid
  Future<chopper.Response<List<Supplier>>>
      apiV1AppBranchesRetrievesuppliersbybranchidGet({required int? branchid}) {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppBranchesRetrievesuppliersbybranchidGet(branchid: branchid);
  }

  ///retrieveAllSuppliersByBranchId
  ///@param branchid branchid
  @Get(path: '/api/v1/app/branches/retrievesuppliersbybranchid')
  Future<chopper.Response<List<Supplier>>>
      _apiV1AppBranchesRetrievesuppliersbybranchidGet(
          {@Query('branchid') required int? branchid});

  ///save
  ///@param branch branch
  Future<chopper.Response> apiV1AppBranchesSavePost({required Branch? branch}) {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppBranchesSavePost(branch: branch);
  }

  ///save
  ///@param branch branch
  @Post(path: '/api/v1/app/branches/save')
  Future<chopper.Response> _apiV1AppBranchesSavePost(
      {@Body() required Branch? branch});

  ///update
  ///@param storages[0].products[0].storageProductId
  ///@param storages[0].products[0].productName
  ///@param storages[0].products[0].unitMeasure
  ///@param storages[0].products[0].stock
  ///@param storages[0].products[0].amountHundred
  ///@param storages[0].products[0].productId
  ///@param storages[0].storageId
  ///@param storages[0].name
  ///@param storages[0].creationDate
  ///@param storages[0].address
  ///@param storages[0].city
  ///@param storages[0].cap
  ///@param storages[0].branchId
  ///@param suppliers[0].productList[0].productId
  ///@param suppliers[0].productList[0].name
  ///@param suppliers[0].productList[0].code
  ///@param suppliers[0].productList[0].unitMeasure
  ///@param suppliers[0].productList[0].unitMeasureOTH
  ///@param suppliers[0].productList[0].vatApplied
  ///@param suppliers[0].productList[0].price
  ///@param suppliers[0].productList[0].description
  ///@param suppliers[0].productList[0].category
  ///@param suppliers[0].productList[0].supplierId
  ///@param suppliers[0].supplierId
  ///@param suppliers[0].name
  ///@param suppliers[0].vatNumber
  ///@param suppliers[0].address
  ///@param suppliers[0].city
  ///@param suppliers[0].cap
  ///@param suppliers[0].code
  ///@param suppliers[0].phoneNumber
  ///@param suppliers[0].email
  ///@param suppliers[0].pec
  ///@param suppliers[0].cf
  ///@param suppliers[0].country
  ///@param suppliers[0].createdByUserId
  ///@param suppliers[0].branchId
  ///@param events[0].expenceEvents[0].expenceId
  ///@param events[0].expenceEvents[0].description
  ///@param events[0].expenceEvents[0].amount
  ///@param events[0].expenceEvents[0].dateIntert
  ///@param events[0].expenceEvents[0].eventId
  ///@param events[0].workstations[0].products[0].workstationProductId
  ///@param events[0].workstations[0].products[0].productName
  ///@param events[0].workstations[0].products[0].unitMeasure
  ///@param events[0].workstations[0].products[0].stockFromStorage
  ///@param events[0].workstations[0].products[0].consumed
  ///@param events[0].workstations[0].products[0].amountHundred
  ///@param events[0].workstations[0].products[0].productId
  ///@param events[0].workstations[0].products[0].storageId
  ///@param events[0].workstations[0].workstationId
  ///@param events[0].workstations[0].name
  ///@param events[0].workstations[0].responsable
  ///@param events[0].workstations[0].extra
  ///@param events[0].workstations[0].workstationType
  ///@param events[0].workstations[0].eventId
  ///@param events[0].eventId
  ///@param events[0].name
  ///@param events[0].dateEvent
  ///@param events[0].dateCreation
  ///@param events[0].eventStatus
  ///@param events[0].location
  ///@param events[0].branchId
  ///@param events[0].storageId
  ///@param orders[0].products[0].orderProductId
  ///@param orders[0].products[0].productName
  ///@param orders[0].products[0].unitMeasure
  ///@param orders[0].products[0].productId
  ///@param orders[0].products[0].price
  ///@param orders[0].products[0].amount
  ///@param orders[0].orderId
  ///@param orders[0].code
  ///@param orders[0].total
  ///@param orders[0].orderStatus
  ///@param orders[0].errorStatus
  ///@param orders[0].creationDate
  ///@param orders[0].senderUser
  ///@param orders[0].details
  ///@param orders[0].deliveryDate
  ///@param orders[0].closedBy
  ///@param orders[0].supplierId
  ///@param orders[0].branchId
  ///@param orders[0].storageId
  ///@param branchId
  ///@param branchCode
  ///@param name
  ///@param email
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param phoneNumber
  ///@param userId
  ///@param token
  ///@param userPriviledge
  Future<chopper.Response> apiV1AppBranchesUpdatePut({
    int? storages0Products0StorageProductId,
    String? storages0Products0ProductName,
    String? storages0Products0UnitMeasure,
    num? storages0Products0Stock,
    num? storages0Products0AmountHundred,
    int? storages0Products0ProductId,
    int? storages0StorageId,
    String? storages0Name,
    String? storages0CreationDate,
    String? storages0Address,
    String? storages0City,
    String? storages0Cap,
    int? storages0BranchId,
    int? suppliers0ProductList0ProductId,
    String? suppliers0ProductList0Name,
    String? suppliers0ProductList0Code,
    String? suppliers0ProductList0UnitMeasure,
    String? suppliers0ProductList0UnitMeasureOTH,
    int? suppliers0ProductList0VatApplied,
    num? suppliers0ProductList0Price,
    String? suppliers0ProductList0Description,
    String? suppliers0ProductList0Category,
    int? suppliers0ProductList0SupplierId,
    int? suppliers0SupplierId,
    String? suppliers0Name,
    String? suppliers0VatNumber,
    String? suppliers0Address,
    String? suppliers0City,
    String? suppliers0Cap,
    String? suppliers0Code,
    String? suppliers0PhoneNumber,
    String? suppliers0Email,
    String? suppliers0Pec,
    String? suppliers0Cf,
    String? suppliers0Country,
    int? suppliers0CreatedByUserId,
    int? suppliers0BranchId,
    int? events0ExpenceEvents0ExpenceId,
    String? events0ExpenceEvents0Description,
    num? events0ExpenceEvents0Amount,
    String? events0ExpenceEvents0DateIntert,
    int? events0ExpenceEvents0EventId,
    int? events0Workstations0Products0WorkstationProductId,
    String? events0Workstations0Products0ProductName,
    String? events0Workstations0Products0UnitMeasure,
    num? events0Workstations0Products0StockFromStorage,
    num? events0Workstations0Products0Consumed,
    num? events0Workstations0Products0AmountHundred,
    int? events0Workstations0Products0ProductId,
    int? events0Workstations0Products0StorageId,
    int? events0Workstations0WorkstationId,
    String? events0Workstations0Name,
    String? events0Workstations0Responsable,
    String? events0Workstations0Extra,
    String? events0Workstations0WorkstationType,
    int? events0Workstations0EventId,
    int? events0EventId,
    String? events0Name,
    String? events0DateEvent,
    String? events0DateCreation,
    String? events0EventStatus,
    String? events0Location,
    int? events0BranchId,
    int? events0StorageId,
    int? orders0Products0OrderProductId,
    String? orders0Products0ProductName,
    String? orders0Products0UnitMeasure,
    int? orders0Products0ProductId,
    num? orders0Products0Price,
    num? orders0Products0Amount,
    int? orders0OrderId,
    String? orders0Code,
    num? orders0Total,
    String? orders0OrderStatus,
    String? orders0ErrorStatus,
    String? orders0CreationDate,
    String? orders0SenderUser,
    String? orders0Details,
    String? orders0DeliveryDate,
    String? orders0ClosedBy,
    int? orders0SupplierId,
    int? orders0BranchId,
    int? orders0StorageId,
    int? branchId,
    String? branchCode,
    String? name,
    String? email,
    String? vatNumber,
    String? address,
    String? city,
    String? cap,
    String? phoneNumber,
    int? userId,
    String? token,
    String? userPriviledge,
  }) {
    return _apiV1AppBranchesUpdatePut(
        storages0Products0StorageProductId: storages0Products0StorageProductId,
        storages0Products0ProductName: storages0Products0ProductName,
        storages0Products0UnitMeasure: storages0Products0UnitMeasure,
        storages0Products0Stock: storages0Products0Stock,
        storages0Products0AmountHundred: storages0Products0AmountHundred,
        storages0Products0ProductId: storages0Products0ProductId,
        storages0StorageId: storages0StorageId,
        storages0Name: storages0Name,
        storages0CreationDate: storages0CreationDate,
        storages0Address: storages0Address,
        storages0City: storages0City,
        storages0Cap: storages0Cap,
        storages0BranchId: storages0BranchId,
        suppliers0ProductList0ProductId: suppliers0ProductList0ProductId,
        suppliers0ProductList0Name: suppliers0ProductList0Name,
        suppliers0ProductList0Code: suppliers0ProductList0Code,
        suppliers0ProductList0UnitMeasure: suppliers0ProductList0UnitMeasure,
        suppliers0ProductList0UnitMeasureOTH:
            suppliers0ProductList0UnitMeasureOTH,
        suppliers0ProductList0VatApplied: suppliers0ProductList0VatApplied,
        suppliers0ProductList0Price: suppliers0ProductList0Price,
        suppliers0ProductList0Description: suppliers0ProductList0Description,
        suppliers0ProductList0Category: suppliers0ProductList0Category,
        suppliers0ProductList0SupplierId: suppliers0ProductList0SupplierId,
        suppliers0SupplierId: suppliers0SupplierId,
        suppliers0Name: suppliers0Name,
        suppliers0VatNumber: suppliers0VatNumber,
        suppliers0Address: suppliers0Address,
        suppliers0City: suppliers0City,
        suppliers0Cap: suppliers0Cap,
        suppliers0Code: suppliers0Code,
        suppliers0PhoneNumber: suppliers0PhoneNumber,
        suppliers0Email: suppliers0Email,
        suppliers0Pec: suppliers0Pec,
        suppliers0Cf: suppliers0Cf,
        suppliers0Country: suppliers0Country,
        suppliers0CreatedByUserId: suppliers0CreatedByUserId,
        suppliers0BranchId: suppliers0BranchId,
        events0ExpenceEvents0ExpenceId: events0ExpenceEvents0ExpenceId,
        events0ExpenceEvents0Description: events0ExpenceEvents0Description,
        events0ExpenceEvents0Amount: events0ExpenceEvents0Amount,
        events0ExpenceEvents0DateIntert: events0ExpenceEvents0DateIntert,
        events0ExpenceEvents0EventId: events0ExpenceEvents0EventId,
        events0Workstations0Products0WorkstationProductId:
            events0Workstations0Products0WorkstationProductId,
        events0Workstations0Products0ProductName:
            events0Workstations0Products0ProductName,
        events0Workstations0Products0UnitMeasure:
            events0Workstations0Products0UnitMeasure,
        events0Workstations0Products0StockFromStorage:
            events0Workstations0Products0StockFromStorage,
        events0Workstations0Products0Consumed:
            events0Workstations0Products0Consumed,
        events0Workstations0Products0AmountHundred:
            events0Workstations0Products0AmountHundred,
        events0Workstations0Products0ProductId:
            events0Workstations0Products0ProductId,
        events0Workstations0Products0StorageId:
            events0Workstations0Products0StorageId,
        events0Workstations0WorkstationId: events0Workstations0WorkstationId,
        events0Workstations0Name: events0Workstations0Name,
        events0Workstations0Responsable: events0Workstations0Responsable,
        events0Workstations0Extra: events0Workstations0Extra,
        events0Workstations0WorkstationType:
            events0Workstations0WorkstationType,
        events0Workstations0EventId: events0Workstations0EventId,
        events0EventId: events0EventId,
        events0Name: events0Name,
        events0DateEvent: events0DateEvent,
        events0DateCreation: events0DateCreation,
        events0EventStatus: events0EventStatus,
        events0Location: events0Location,
        events0BranchId: events0BranchId,
        events0StorageId: events0StorageId,
        orders0Products0OrderProductId: orders0Products0OrderProductId,
        orders0Products0ProductName: orders0Products0ProductName,
        orders0Products0UnitMeasure: orders0Products0UnitMeasure,
        orders0Products0ProductId: orders0Products0ProductId,
        orders0Products0Price: orders0Products0Price,
        orders0Products0Amount: orders0Products0Amount,
        orders0OrderId: orders0OrderId,
        orders0Code: orders0Code,
        orders0Total: orders0Total,
        orders0OrderStatus: orders0OrderStatus,
        orders0ErrorStatus: orders0ErrorStatus,
        orders0CreationDate: orders0CreationDate,
        orders0SenderUser: orders0SenderUser,
        orders0Details: orders0Details,
        orders0DeliveryDate: orders0DeliveryDate,
        orders0ClosedBy: orders0ClosedBy,
        orders0SupplierId: orders0SupplierId,
        orders0BranchId: orders0BranchId,
        orders0StorageId: orders0StorageId,
        branchId: branchId,
        branchCode: branchCode,
        name: name,
        email: email,
        vatNumber: vatNumber,
        address: address,
        city: city,
        cap: cap,
        phoneNumber: phoneNumber,
        userId: userId,
        token: token,
        userPriviledge: userPriviledge);
  }

  ///update
  ///@param storages[0].products[0].storageProductId
  ///@param storages[0].products[0].productName
  ///@param storages[0].products[0].unitMeasure
  ///@param storages[0].products[0].stock
  ///@param storages[0].products[0].amountHundred
  ///@param storages[0].products[0].productId
  ///@param storages[0].storageId
  ///@param storages[0].name
  ///@param storages[0].creationDate
  ///@param storages[0].address
  ///@param storages[0].city
  ///@param storages[0].cap
  ///@param storages[0].branchId
  ///@param suppliers[0].productList[0].productId
  ///@param suppliers[0].productList[0].name
  ///@param suppliers[0].productList[0].code
  ///@param suppliers[0].productList[0].unitMeasure
  ///@param suppliers[0].productList[0].unitMeasureOTH
  ///@param suppliers[0].productList[0].vatApplied
  ///@param suppliers[0].productList[0].price
  ///@param suppliers[0].productList[0].description
  ///@param suppliers[0].productList[0].category
  ///@param suppliers[0].productList[0].supplierId
  ///@param suppliers[0].supplierId
  ///@param suppliers[0].name
  ///@param suppliers[0].vatNumber
  ///@param suppliers[0].address
  ///@param suppliers[0].city
  ///@param suppliers[0].cap
  ///@param suppliers[0].code
  ///@param suppliers[0].phoneNumber
  ///@param suppliers[0].email
  ///@param suppliers[0].pec
  ///@param suppliers[0].cf
  ///@param suppliers[0].country
  ///@param suppliers[0].createdByUserId
  ///@param suppliers[0].branchId
  ///@param events[0].expenceEvents[0].expenceId
  ///@param events[0].expenceEvents[0].description
  ///@param events[0].expenceEvents[0].amount
  ///@param events[0].expenceEvents[0].dateIntert
  ///@param events[0].expenceEvents[0].eventId
  ///@param events[0].workstations[0].products[0].workstationProductId
  ///@param events[0].workstations[0].products[0].productName
  ///@param events[0].workstations[0].products[0].unitMeasure
  ///@param events[0].workstations[0].products[0].stockFromStorage
  ///@param events[0].workstations[0].products[0].consumed
  ///@param events[0].workstations[0].products[0].amountHundred
  ///@param events[0].workstations[0].products[0].productId
  ///@param events[0].workstations[0].products[0].storageId
  ///@param events[0].workstations[0].workstationId
  ///@param events[0].workstations[0].name
  ///@param events[0].workstations[0].responsable
  ///@param events[0].workstations[0].extra
  ///@param events[0].workstations[0].workstationType
  ///@param events[0].workstations[0].eventId
  ///@param events[0].eventId
  ///@param events[0].name
  ///@param events[0].dateEvent
  ///@param events[0].dateCreation
  ///@param events[0].eventStatus
  ///@param events[0].location
  ///@param events[0].branchId
  ///@param events[0].storageId
  ///@param orders[0].products[0].orderProductId
  ///@param orders[0].products[0].productName
  ///@param orders[0].products[0].unitMeasure
  ///@param orders[0].products[0].productId
  ///@param orders[0].products[0].price
  ///@param orders[0].products[0].amount
  ///@param orders[0].orderId
  ///@param orders[0].code
  ///@param orders[0].total
  ///@param orders[0].orderStatus
  ///@param orders[0].errorStatus
  ///@param orders[0].creationDate
  ///@param orders[0].senderUser
  ///@param orders[0].details
  ///@param orders[0].deliveryDate
  ///@param orders[0].closedBy
  ///@param orders[0].supplierId
  ///@param orders[0].branchId
  ///@param orders[0].storageId
  ///@param branchId
  ///@param branchCode
  ///@param name
  ///@param email
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param phoneNumber
  ///@param userId
  ///@param token
  ///@param userPriviledge
  @Put(
    path: '/api/v1/app/branches/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppBranchesUpdatePut({
    @Query('storages[0].products[0].storageProductId')
        int? storages0Products0StorageProductId,
    @Query('storages[0].products[0].productName')
        String? storages0Products0ProductName,
    @Query('storages[0].products[0].unitMeasure')
        String? storages0Products0UnitMeasure,
    @Query('storages[0].products[0].stock') num? storages0Products0Stock,
    @Query('storages[0].products[0].amountHundred')
        num? storages0Products0AmountHundred,
    @Query('storages[0].products[0].productId')
        int? storages0Products0ProductId,
    @Query('storages[0].storageId') int? storages0StorageId,
    @Query('storages[0].name') String? storages0Name,
    @Query('storages[0].creationDate') String? storages0CreationDate,
    @Query('storages[0].address') String? storages0Address,
    @Query('storages[0].city') String? storages0City,
    @Query('storages[0].cap') String? storages0Cap,
    @Query('storages[0].branchId') int? storages0BranchId,
    @Query('suppliers[0].productList[0].productId')
        int? suppliers0ProductList0ProductId,
    @Query('suppliers[0].productList[0].name')
        String? suppliers0ProductList0Name,
    @Query('suppliers[0].productList[0].code')
        String? suppliers0ProductList0Code,
    @Query('suppliers[0].productList[0].unitMeasure')
        String? suppliers0ProductList0UnitMeasure,
    @Query('suppliers[0].productList[0].unitMeasureOTH')
        String? suppliers0ProductList0UnitMeasureOTH,
    @Query('suppliers[0].productList[0].vatApplied')
        int? suppliers0ProductList0VatApplied,
    @Query('suppliers[0].productList[0].price')
        num? suppliers0ProductList0Price,
    @Query('suppliers[0].productList[0].description')
        String? suppliers0ProductList0Description,
    @Query('suppliers[0].productList[0].category')
        String? suppliers0ProductList0Category,
    @Query('suppliers[0].productList[0].supplierId')
        int? suppliers0ProductList0SupplierId,
    @Query('suppliers[0].supplierId') int? suppliers0SupplierId,
    @Query('suppliers[0].name') String? suppliers0Name,
    @Query('suppliers[0].vatNumber') String? suppliers0VatNumber,
    @Query('suppliers[0].address') String? suppliers0Address,
    @Query('suppliers[0].city') String? suppliers0City,
    @Query('suppliers[0].cap') String? suppliers0Cap,
    @Query('suppliers[0].code') String? suppliers0Code,
    @Query('suppliers[0].phoneNumber') String? suppliers0PhoneNumber,
    @Query('suppliers[0].email') String? suppliers0Email,
    @Query('suppliers[0].pec') String? suppliers0Pec,
    @Query('suppliers[0].cf') String? suppliers0Cf,
    @Query('suppliers[0].country') String? suppliers0Country,
    @Query('suppliers[0].createdByUserId') int? suppliers0CreatedByUserId,
    @Query('suppliers[0].branchId') int? suppliers0BranchId,
    @Query('events[0].expenceEvents[0].expenceId')
        int? events0ExpenceEvents0ExpenceId,
    @Query('events[0].expenceEvents[0].description')
        String? events0ExpenceEvents0Description,
    @Query('events[0].expenceEvents[0].amount')
        num? events0ExpenceEvents0Amount,
    @Query('events[0].expenceEvents[0].dateIntert')
        String? events0ExpenceEvents0DateIntert,
    @Query('events[0].expenceEvents[0].eventId')
        int? events0ExpenceEvents0EventId,
    @Query('events[0].workstations[0].products[0].workstationProductId')
        int? events0Workstations0Products0WorkstationProductId,
    @Query('events[0].workstations[0].products[0].productName')
        String? events0Workstations0Products0ProductName,
    @Query('events[0].workstations[0].products[0].unitMeasure')
        String? events0Workstations0Products0UnitMeasure,
    @Query('events[0].workstations[0].products[0].stockFromStorage')
        num? events0Workstations0Products0StockFromStorage,
    @Query('events[0].workstations[0].products[0].consumed')
        num? events0Workstations0Products0Consumed,
    @Query('events[0].workstations[0].products[0].amountHundred')
        num? events0Workstations0Products0AmountHundred,
    @Query('events[0].workstations[0].products[0].productId')
        int? events0Workstations0Products0ProductId,
    @Query('events[0].workstations[0].products[0].storageId')
        int? events0Workstations0Products0StorageId,
    @Query('events[0].workstations[0].workstationId')
        int? events0Workstations0WorkstationId,
    @Query('events[0].workstations[0].name') String? events0Workstations0Name,
    @Query('events[0].workstations[0].responsable')
        String? events0Workstations0Responsable,
    @Query('events[0].workstations[0].extra') String? events0Workstations0Extra,
    @Query('events[0].workstations[0].workstationType')
        String? events0Workstations0WorkstationType,
    @Query('events[0].workstations[0].eventId')
        int? events0Workstations0EventId,
    @Query('events[0].eventId') int? events0EventId,
    @Query('events[0].name') String? events0Name,
    @Query('events[0].dateEvent') String? events0DateEvent,
    @Query('events[0].dateCreation') String? events0DateCreation,
    @Query('events[0].eventStatus') String? events0EventStatus,
    @Query('events[0].location') String? events0Location,
    @Query('events[0].branchId') int? events0BranchId,
    @Query('events[0].storageId') int? events0StorageId,
    @Query('orders[0].products[0].orderProductId')
        int? orders0Products0OrderProductId,
    @Query('orders[0].products[0].productName')
        String? orders0Products0ProductName,
    @Query('orders[0].products[0].unitMeasure')
        String? orders0Products0UnitMeasure,
    @Query('orders[0].products[0].productId') int? orders0Products0ProductId,
    @Query('orders[0].products[0].price') num? orders0Products0Price,
    @Query('orders[0].products[0].amount') num? orders0Products0Amount,
    @Query('orders[0].orderId') int? orders0OrderId,
    @Query('orders[0].code') String? orders0Code,
    @Query('orders[0].total') num? orders0Total,
    @Query('orders[0].orderStatus') String? orders0OrderStatus,
    @Query('orders[0].errorStatus') String? orders0ErrorStatus,
    @Query('orders[0].creationDate') String? orders0CreationDate,
    @Query('orders[0].senderUser') String? orders0SenderUser,
    @Query('orders[0].details') String? orders0Details,
    @Query('orders[0].deliveryDate') String? orders0DeliveryDate,
    @Query('orders[0].closedBy') String? orders0ClosedBy,
    @Query('orders[0].supplierId') int? orders0SupplierId,
    @Query('orders[0].branchId') int? orders0BranchId,
    @Query('orders[0].storageId') int? orders0StorageId,
    @Query('branchId') int? branchId,
    @Query('branchCode') String? branchCode,
    @Query('name') String? name,
    @Query('email') String? email,
    @Query('vatNumber') String? vatNumber,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('phoneNumber') String? phoneNumber,
    @Query('userId') int? userId,
    @Query('token') String? token,
    @Query('userPriviledge') String? userPriviledge,
  });

  ///delete
  ///@param eventId eventId
  Future<chopper.Response> apiV1AppEventDeleteDelete({required int? eventId}) {
    return _apiV1AppEventDeleteDelete(eventId: eventId);
  }

  ///delete
  ///@param eventId eventId
  @Delete(path: '/api/v1/app/event/delete')
  Future<chopper.Response> _apiV1AppEventDeleteDelete(
      {@Query('eventId') required int? eventId});

  ///saveExpence
  ///@param expenceId
  ///@param description
  ///@param amount
  ///@param dateIntert
  ///@param eventId
  Future<chopper.Response<ExpenceEvent>> apiV1AppEventExpenceCreatePost({
    int? expenceId,
    String? description,
    num? amount,
    String? dateIntert,
    int? eventId,
  }) {
    generatedMapping.putIfAbsent(
        ExpenceEvent, () => ExpenceEvent.fromJsonFactory);

    return _apiV1AppEventExpenceCreatePost(
        expenceId: expenceId,
        description: description,
        amount: amount,
        dateIntert: dateIntert,
        eventId: eventId);
  }

  ///saveExpence
  ///@param expenceId
  ///@param description
  ///@param amount
  ///@param dateIntert
  ///@param eventId
  @Post(
    path: '/api/v1/app/event/expence/create',
    optionalBody: true,
  )
  Future<chopper.Response<ExpenceEvent>> _apiV1AppEventExpenceCreatePost({
    @Query('expenceId') int? expenceId,
    @Query('description') String? description,
    @Query('amount') num? amount,
    @Query('dateIntert') String? dateIntert,
    @Query('eventId') int? eventId,
  });

  ///deleteExpence
  ///@param expenceId
  ///@param description
  ///@param amount
  ///@param dateIntert
  ///@param eventId
  Future<chopper.Response> apiV1AppEventExpenceDeleteDelete({
    int? expenceId,
    String? description,
    num? amount,
    String? dateIntert,
    int? eventId,
  }) {
    return _apiV1AppEventExpenceDeleteDelete(
        expenceId: expenceId,
        description: description,
        amount: amount,
        dateIntert: dateIntert,
        eventId: eventId);
  }

  ///deleteExpence
  ///@param expenceId
  ///@param description
  ///@param amount
  ///@param dateIntert
  ///@param eventId
  @Delete(path: '/api/v1/app/event/expence/delete')
  Future<chopper.Response> _apiV1AppEventExpenceDeleteDelete({
    @Query('expenceId') int? expenceId,
    @Query('description') String? description,
    @Query('amount') num? amount,
    @Query('dateIntert') String? dateIntert,
    @Query('eventId') int? eventId,
  });

  ///retrieveAllExpenpencesByEventId
  ///@param eventid eventid
  Future<chopper.Response<List<ExpenceEvent>>>
      apiV1AppEventExpenceRetrievebyeventidGet({required int? eventid}) {
    generatedMapping.putIfAbsent(
        ExpenceEvent, () => ExpenceEvent.fromJsonFactory);

    return _apiV1AppEventExpenceRetrievebyeventidGet(eventid: eventid);
  }

  ///retrieveAllExpenpencesByEventId
  ///@param eventid eventid
  @Get(path: '/api/v1/app/event/expence/retrievebyeventid')
  Future<chopper.Response<List<ExpenceEvent>>>
      _apiV1AppEventExpenceRetrievebyeventidGet(
          {@Query('eventid') required int? eventid});

  ///updateExpence
  ///@param expenceId
  ///@param description
  ///@param amount
  ///@param dateIntert
  ///@param eventId
  Future<chopper.Response> apiV1AppEventExpenceUpdatePut({
    int? expenceId,
    String? description,
    num? amount,
    String? dateIntert,
    int? eventId,
  }) {
    return _apiV1AppEventExpenceUpdatePut(
        expenceId: expenceId,
        description: description,
        amount: amount,
        dateIntert: dateIntert,
        eventId: eventId);
  }

  ///updateExpence
  ///@param expenceId
  ///@param description
  ///@param amount
  ///@param dateIntert
  ///@param eventId
  @Put(
    path: '/api/v1/app/event/expence/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppEventExpenceUpdatePut({
    @Query('expenceId') int? expenceId,
    @Query('description') String? description,
    @Query('amount') num? amount,
    @Query('dateIntert') String? dateIntert,
    @Query('eventId') int? eventId,
  });

  ///retrieveEventsClosedByBranchId
  ///@param branchid branchid
  Future<chopper.Response<List<Event>>>
      apiV1AppEventFindeventbybranchidClosedGet({required int? branchid}) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiV1AppEventFindeventbybranchidClosedGet(branchid: branchid);
  }

  ///retrieveEventsClosedByBranchId
  ///@param branchid branchid
  @Get(path: '/api/v1/app/event/findeventbybranchid/closed')
  Future<chopper.Response<List<Event>>>
      _apiV1AppEventFindeventbybranchidClosedGet(
          {@Query('branchid') required int? branchid});

  ///retrieveEventsByBranchId
  ///@param branchid branchid
  Future<chopper.Response<List<Event>>> apiV1AppEventFindeventbybranchidOpenGet(
      {required int? branchid}) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiV1AppEventFindeventbybranchidOpenGet(branchid: branchid);
  }

  ///retrieveEventsByBranchId
  ///@param branchid branchid
  @Get(path: '/api/v1/app/event/findeventbybranchid/open')
  Future<chopper.Response<List<Event>>>
      _apiV1AppEventFindeventbybranchidOpenGet(
          {@Query('branchid') required int? branchid});

  ///save
  ///@param expenceEvents[0].expenceId
  ///@param expenceEvents[0].description
  ///@param expenceEvents[0].amount
  ///@param expenceEvents[0].dateIntert
  ///@param expenceEvents[0].eventId
  ///@param workstations[0].products[0].workstationProductId
  ///@param workstations[0].products[0].productName
  ///@param workstations[0].products[0].unitMeasure
  ///@param workstations[0].products[0].stockFromStorage
  ///@param workstations[0].products[0].consumed
  ///@param workstations[0].products[0].amountHundred
  ///@param workstations[0].products[0].productId
  ///@param workstations[0].products[0].storageId
  ///@param workstations[0].workstationId
  ///@param workstations[0].name
  ///@param workstations[0].responsable
  ///@param workstations[0].extra
  ///@param workstations[0].workstationType
  ///@param workstations[0].eventId
  ///@param eventId
  ///@param name
  ///@param dateEvent
  ///@param dateCreation
  ///@param eventStatus
  ///@param location
  ///@param branchId
  ///@param storageId
  Future<chopper.Response<Event>> apiV1AppEventSavePost({
    int? expenceEvents0ExpenceId,
    String? expenceEvents0Description,
    num? expenceEvents0Amount,
    String? expenceEvents0DateIntert,
    int? expenceEvents0EventId,
    int? workstations0Products0WorkstationProductId,
    String? workstations0Products0ProductName,
    String? workstations0Products0UnitMeasure,
    num? workstations0Products0StockFromStorage,
    num? workstations0Products0Consumed,
    num? workstations0Products0AmountHundred,
    int? workstations0Products0ProductId,
    int? workstations0Products0StorageId,
    int? workstations0WorkstationId,
    String? workstations0Name,
    String? workstations0Responsable,
    String? workstations0Extra,
    String? workstations0WorkstationType,
    int? workstations0EventId,
    int? eventId,
    String? name,
    String? dateEvent,
    String? dateCreation,
    String? eventStatus,
    String? location,
    int? branchId,
    int? storageId,
  }) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiV1AppEventSavePost(
        expenceEvents0ExpenceId: expenceEvents0ExpenceId,
        expenceEvents0Description: expenceEvents0Description,
        expenceEvents0Amount: expenceEvents0Amount,
        expenceEvents0DateIntert: expenceEvents0DateIntert,
        expenceEvents0EventId: expenceEvents0EventId,
        workstations0Products0WorkstationProductId:
            workstations0Products0WorkstationProductId,
        workstations0Products0ProductName: workstations0Products0ProductName,
        workstations0Products0UnitMeasure: workstations0Products0UnitMeasure,
        workstations0Products0StockFromStorage:
            workstations0Products0StockFromStorage,
        workstations0Products0Consumed: workstations0Products0Consumed,
        workstations0Products0AmountHundred:
            workstations0Products0AmountHundred,
        workstations0Products0ProductId: workstations0Products0ProductId,
        workstations0Products0StorageId: workstations0Products0StorageId,
        workstations0WorkstationId: workstations0WorkstationId,
        workstations0Name: workstations0Name,
        workstations0Responsable: workstations0Responsable,
        workstations0Extra: workstations0Extra,
        workstations0WorkstationType: workstations0WorkstationType,
        workstations0EventId: workstations0EventId,
        eventId: eventId,
        name: name,
        dateEvent: dateEvent,
        dateCreation: dateCreation,
        eventStatus: eventStatus,
        location: location,
        branchId: branchId,
        storageId: storageId);
  }

  ///save
  ///@param expenceEvents[0].expenceId
  ///@param expenceEvents[0].description
  ///@param expenceEvents[0].amount
  ///@param expenceEvents[0].dateIntert
  ///@param expenceEvents[0].eventId
  ///@param workstations[0].products[0].workstationProductId
  ///@param workstations[0].products[0].productName
  ///@param workstations[0].products[0].unitMeasure
  ///@param workstations[0].products[0].stockFromStorage
  ///@param workstations[0].products[0].consumed
  ///@param workstations[0].products[0].amountHundred
  ///@param workstations[0].products[0].productId
  ///@param workstations[0].products[0].storageId
  ///@param workstations[0].workstationId
  ///@param workstations[0].name
  ///@param workstations[0].responsable
  ///@param workstations[0].extra
  ///@param workstations[0].workstationType
  ///@param workstations[0].eventId
  ///@param eventId
  ///@param name
  ///@param dateEvent
  ///@param dateCreation
  ///@param eventStatus
  ///@param location
  ///@param branchId
  ///@param storageId
  @Post(
    path: '/api/v1/app/event/save',
    optionalBody: true,
  )
  Future<chopper.Response<Event>> _apiV1AppEventSavePost({
    @Query('expenceEvents[0].expenceId') int? expenceEvents0ExpenceId,
    @Query('expenceEvents[0].description') String? expenceEvents0Description,
    @Query('expenceEvents[0].amount') num? expenceEvents0Amount,
    @Query('expenceEvents[0].dateIntert') String? expenceEvents0DateIntert,
    @Query('expenceEvents[0].eventId') int? expenceEvents0EventId,
    @Query('workstations[0].products[0].workstationProductId')
        int? workstations0Products0WorkstationProductId,
    @Query('workstations[0].products[0].productName')
        String? workstations0Products0ProductName,
    @Query('workstations[0].products[0].unitMeasure')
        String? workstations0Products0UnitMeasure,
    @Query('workstations[0].products[0].stockFromStorage')
        num? workstations0Products0StockFromStorage,
    @Query('workstations[0].products[0].consumed')
        num? workstations0Products0Consumed,
    @Query('workstations[0].products[0].amountHundred')
        num? workstations0Products0AmountHundred,
    @Query('workstations[0].products[0].productId')
        int? workstations0Products0ProductId,
    @Query('workstations[0].products[0].storageId')
        int? workstations0Products0StorageId,
    @Query('workstations[0].workstationId') int? workstations0WorkstationId,
    @Query('workstations[0].name') String? workstations0Name,
    @Query('workstations[0].responsable') String? workstations0Responsable,
    @Query('workstations[0].extra') String? workstations0Extra,
    @Query('workstations[0].workstationType')
        String? workstations0WorkstationType,
    @Query('workstations[0].eventId') int? workstations0EventId,
    @Query('eventId') int? eventId,
    @Query('name') String? name,
    @Query('dateEvent') String? dateEvent,
    @Query('dateCreation') String? dateCreation,
    @Query('eventStatus') String? eventStatus,
    @Query('location') String? location,
    @Query('branchId') int? branchId,
    @Query('storageId') int? storageId,
  });

  ///update
  ///@param expenceEvents[0].expenceId
  ///@param expenceEvents[0].description
  ///@param expenceEvents[0].amount
  ///@param expenceEvents[0].dateIntert
  ///@param expenceEvents[0].eventId
  ///@param workstations[0].products[0].workstationProductId
  ///@param workstations[0].products[0].productName
  ///@param workstations[0].products[0].unitMeasure
  ///@param workstations[0].products[0].stockFromStorage
  ///@param workstations[0].products[0].consumed
  ///@param workstations[0].products[0].amountHundred
  ///@param workstations[0].products[0].productId
  ///@param workstations[0].products[0].storageId
  ///@param workstations[0].workstationId
  ///@param workstations[0].name
  ///@param workstations[0].responsable
  ///@param workstations[0].extra
  ///@param workstations[0].workstationType
  ///@param workstations[0].eventId
  ///@param eventId
  ///@param name
  ///@param dateEvent
  ///@param dateCreation
  ///@param eventStatus
  ///@param location
  ///@param branchId
  ///@param storageId
  Future<chopper.Response> apiV1AppEventUpdatePut({
    int? expenceEvents0ExpenceId,
    String? expenceEvents0Description,
    num? expenceEvents0Amount,
    String? expenceEvents0DateIntert,
    int? expenceEvents0EventId,
    int? workstations0Products0WorkstationProductId,
    String? workstations0Products0ProductName,
    String? workstations0Products0UnitMeasure,
    num? workstations0Products0StockFromStorage,
    num? workstations0Products0Consumed,
    num? workstations0Products0AmountHundred,
    int? workstations0Products0ProductId,
    int? workstations0Products0StorageId,
    int? workstations0WorkstationId,
    String? workstations0Name,
    String? workstations0Responsable,
    String? workstations0Extra,
    String? workstations0WorkstationType,
    int? workstations0EventId,
    int? eventId,
    String? name,
    String? dateEvent,
    String? dateCreation,
    String? eventStatus,
    String? location,
    int? branchId,
    int? storageId,
  }) {
    return _apiV1AppEventUpdatePut(
        expenceEvents0ExpenceId: expenceEvents0ExpenceId,
        expenceEvents0Description: expenceEvents0Description,
        expenceEvents0Amount: expenceEvents0Amount,
        expenceEvents0DateIntert: expenceEvents0DateIntert,
        expenceEvents0EventId: expenceEvents0EventId,
        workstations0Products0WorkstationProductId:
            workstations0Products0WorkstationProductId,
        workstations0Products0ProductName: workstations0Products0ProductName,
        workstations0Products0UnitMeasure: workstations0Products0UnitMeasure,
        workstations0Products0StockFromStorage:
            workstations0Products0StockFromStorage,
        workstations0Products0Consumed: workstations0Products0Consumed,
        workstations0Products0AmountHundred:
            workstations0Products0AmountHundred,
        workstations0Products0ProductId: workstations0Products0ProductId,
        workstations0Products0StorageId: workstations0Products0StorageId,
        workstations0WorkstationId: workstations0WorkstationId,
        workstations0Name: workstations0Name,
        workstations0Responsable: workstations0Responsable,
        workstations0Extra: workstations0Extra,
        workstations0WorkstationType: workstations0WorkstationType,
        workstations0EventId: workstations0EventId,
        eventId: eventId,
        name: name,
        dateEvent: dateEvent,
        dateCreation: dateCreation,
        eventStatus: eventStatus,
        location: location,
        branchId: branchId,
        storageId: storageId);
  }

  ///update
  ///@param expenceEvents[0].expenceId
  ///@param expenceEvents[0].description
  ///@param expenceEvents[0].amount
  ///@param expenceEvents[0].dateIntert
  ///@param expenceEvents[0].eventId
  ///@param workstations[0].products[0].workstationProductId
  ///@param workstations[0].products[0].productName
  ///@param workstations[0].products[0].unitMeasure
  ///@param workstations[0].products[0].stockFromStorage
  ///@param workstations[0].products[0].consumed
  ///@param workstations[0].products[0].amountHundred
  ///@param workstations[0].products[0].productId
  ///@param workstations[0].products[0].storageId
  ///@param workstations[0].workstationId
  ///@param workstations[0].name
  ///@param workstations[0].responsable
  ///@param workstations[0].extra
  ///@param workstations[0].workstationType
  ///@param workstations[0].eventId
  ///@param eventId
  ///@param name
  ///@param dateEvent
  ///@param dateCreation
  ///@param eventStatus
  ///@param location
  ///@param branchId
  ///@param storageId
  @Put(
    path: '/api/v1/app/event/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppEventUpdatePut({
    @Query('expenceEvents[0].expenceId') int? expenceEvents0ExpenceId,
    @Query('expenceEvents[0].description') String? expenceEvents0Description,
    @Query('expenceEvents[0].amount') num? expenceEvents0Amount,
    @Query('expenceEvents[0].dateIntert') String? expenceEvents0DateIntert,
    @Query('expenceEvents[0].eventId') int? expenceEvents0EventId,
    @Query('workstations[0].products[0].workstationProductId')
        int? workstations0Products0WorkstationProductId,
    @Query('workstations[0].products[0].productName')
        String? workstations0Products0ProductName,
    @Query('workstations[0].products[0].unitMeasure')
        String? workstations0Products0UnitMeasure,
    @Query('workstations[0].products[0].stockFromStorage')
        num? workstations0Products0StockFromStorage,
    @Query('workstations[0].products[0].consumed')
        num? workstations0Products0Consumed,
    @Query('workstations[0].products[0].amountHundred')
        num? workstations0Products0AmountHundred,
    @Query('workstations[0].products[0].productId')
        int? workstations0Products0ProductId,
    @Query('workstations[0].products[0].storageId')
        int? workstations0Products0StorageId,
    @Query('workstations[0].workstationId') int? workstations0WorkstationId,
    @Query('workstations[0].name') String? workstations0Name,
    @Query('workstations[0].responsable') String? workstations0Responsable,
    @Query('workstations[0].extra') String? workstations0Extra,
    @Query('workstations[0].workstationType')
        String? workstations0WorkstationType,
    @Query('workstations[0].eventId') int? workstations0EventId,
    @Query('eventId') int? eventId,
    @Query('name') String? name,
    @Query('dateEvent') String? dateEvent,
    @Query('dateCreation') String? dateCreation,
    @Query('eventStatus') String? eventStatus,
    @Query('location') String? location,
    @Query('branchId') int? branchId,
    @Query('storageId') int? storageId,
  });

  ///addProductToWorkstation
  ///@param products[0].workstationProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stockFromStorage
  ///@param products[0].consumed
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param products[0].storageId
  ///@param workstationId
  ///@param name
  ///@param responsable
  ///@param extra
  ///@param workstationType
  ///@param eventId
  Future<chopper.Response<Workstation>> apiV1AppEventWorkstationAddproductPost({
    int? products0WorkstationProductId,
    String? products0ProductName,
    String? products0UnitMeasure,
    num? products0StockFromStorage,
    num? products0Consumed,
    num? products0AmountHundred,
    int? products0ProductId,
    int? products0StorageId,
    int? workstationId,
    String? name,
    String? responsable,
    String? extra,
    String? workstationType,
    int? eventId,
  }) {
    generatedMapping.putIfAbsent(
        Workstation, () => Workstation.fromJsonFactory);

    return _apiV1AppEventWorkstationAddproductPost(
        products0WorkstationProductId: products0WorkstationProductId,
        products0ProductName: products0ProductName,
        products0UnitMeasure: products0UnitMeasure,
        products0StockFromStorage: products0StockFromStorage,
        products0Consumed: products0Consumed,
        products0AmountHundred: products0AmountHundred,
        products0ProductId: products0ProductId,
        products0StorageId: products0StorageId,
        workstationId: workstationId,
        name: name,
        responsable: responsable,
        extra: extra,
        workstationType: workstationType,
        eventId: eventId);
  }

  ///addProductToWorkstation
  ///@param products[0].workstationProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stockFromStorage
  ///@param products[0].consumed
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param products[0].storageId
  ///@param workstationId
  ///@param name
  ///@param responsable
  ///@param extra
  ///@param workstationType
  ///@param eventId
  @Post(
    path: '/api/v1/app/event/workstation/addproduct',
    optionalBody: true,
  )
  Future<chopper.Response<Workstation>>
      _apiV1AppEventWorkstationAddproductPost({
    @Query('products[0].workstationProductId')
        int? products0WorkstationProductId,
    @Query('products[0].productName') String? products0ProductName,
    @Query('products[0].unitMeasure') String? products0UnitMeasure,
    @Query('products[0].stockFromStorage') num? products0StockFromStorage,
    @Query('products[0].consumed') num? products0Consumed,
    @Query('products[0].amountHundred') num? products0AmountHundred,
    @Query('products[0].productId') int? products0ProductId,
    @Query('products[0].storageId') int? products0StorageId,
    @Query('workstationId') int? workstationId,
    @Query('name') String? name,
    @Query('responsable') String? responsable,
    @Query('extra') String? extra,
    @Query('workstationType') String? workstationType,
    @Query('eventId') int? eventId,
  });

  ///createWorkstation
  ///@param products[0].workstationProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stockFromStorage
  ///@param products[0].consumed
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param products[0].storageId
  ///@param workstationId
  ///@param name
  ///@param responsable
  ///@param extra
  ///@param workstationType
  ///@param eventId
  Future<chopper.Response<Workstation>> apiV1AppEventWorkstationCreatePost({
    int? products0WorkstationProductId,
    String? products0ProductName,
    String? products0UnitMeasure,
    num? products0StockFromStorage,
    num? products0Consumed,
    num? products0AmountHundred,
    int? products0ProductId,
    int? products0StorageId,
    int? workstationId,
    String? name,
    String? responsable,
    String? extra,
    String? workstationType,
    int? eventId,
  }) {
    generatedMapping.putIfAbsent(
        Workstation, () => Workstation.fromJsonFactory);

    return _apiV1AppEventWorkstationCreatePost(
        products0WorkstationProductId: products0WorkstationProductId,
        products0ProductName: products0ProductName,
        products0UnitMeasure: products0UnitMeasure,
        products0StockFromStorage: products0StockFromStorage,
        products0Consumed: products0Consumed,
        products0AmountHundred: products0AmountHundred,
        products0ProductId: products0ProductId,
        products0StorageId: products0StorageId,
        workstationId: workstationId,
        name: name,
        responsable: responsable,
        extra: extra,
        workstationType: workstationType,
        eventId: eventId);
  }

  ///createWorkstation
  ///@param products[0].workstationProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stockFromStorage
  ///@param products[0].consumed
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param products[0].storageId
  ///@param workstationId
  ///@param name
  ///@param responsable
  ///@param extra
  ///@param workstationType
  ///@param eventId
  @Post(
    path: '/api/v1/app/event/workstation/create',
    optionalBody: true,
  )
  Future<chopper.Response<Workstation>> _apiV1AppEventWorkstationCreatePost({
    @Query('products[0].workstationProductId')
        int? products0WorkstationProductId,
    @Query('products[0].productName') String? products0ProductName,
    @Query('products[0].unitMeasure') String? products0UnitMeasure,
    @Query('products[0].stockFromStorage') num? products0StockFromStorage,
    @Query('products[0].consumed') num? products0Consumed,
    @Query('products[0].amountHundred') num? products0AmountHundred,
    @Query('products[0].productId') int? products0ProductId,
    @Query('products[0].storageId') int? products0StorageId,
    @Query('workstationId') int? workstationId,
    @Query('name') String? name,
    @Query('responsable') String? responsable,
    @Query('extra') String? extra,
    @Query('workstationType') String? workstationType,
    @Query('eventId') int? eventId,
  });

  ///sendOrder
  ///@param orderEntity orderEntity
  Future<chopper.Response<OrderEntity>> apiV1AppOrderSendPost(
      {required OrderEntity? orderEntity}) {
    generatedMapping.putIfAbsent(
        OrderEntity, () => OrderEntity.fromJsonFactory);

    return _apiV1AppOrderSendPost(orderEntity: orderEntity);
  }

  ///sendOrder
  ///@param orderEntity orderEntity
  @Post(path: '/api/v1/app/order/send')
  Future<chopper.Response<OrderEntity>> _apiV1AppOrderSendPost(
      {@Body() required OrderEntity? orderEntity});

  ///delete
  ///@param productId
  ///@param name
  ///@param code
  ///@param unitMeasure
  ///@param unitMeasureOTH
  ///@param vatApplied
  ///@param price
  ///@param description
  ///@param category
  ///@param supplierId
  Future<chopper.Response> apiV1AppProductsDeleteDelete({
    int? productId,
    String? name,
    String? code,
    String? unitMeasure,
    String? unitMeasureOTH,
    int? vatApplied,
    num? price,
    String? description,
    String? category,
    int? supplierId,
  }) {
    return _apiV1AppProductsDeleteDelete(
        productId: productId,
        name: name,
        code: code,
        unitMeasure: unitMeasure,
        unitMeasureOTH: unitMeasureOTH,
        vatApplied: vatApplied,
        price: price,
        description: description,
        category: category,
        supplierId: supplierId);
  }

  ///delete
  ///@param productId
  ///@param name
  ///@param code
  ///@param unitMeasure
  ///@param unitMeasureOTH
  ///@param vatApplied
  ///@param price
  ///@param description
  ///@param category
  ///@param supplierId
  @Delete(path: '/api/v1/app/products/delete')
  Future<chopper.Response> _apiV1AppProductsDeleteDelete({
    @Query('productId') int? productId,
    @Query('name') String? name,
    @Query('code') String? code,
    @Query('unitMeasure') String? unitMeasure,
    @Query('unitMeasureOTH') String? unitMeasureOTH,
    @Query('vatApplied') int? vatApplied,
    @Query('price') num? price,
    @Query('description') String? description,
    @Query('category') String? category,
    @Query('supplierId') int? supplierId,
  });

  ///retrieveAll
  Future<chopper.Response<List<Product>>> apiV1AppProductsFindallGet() {
    generatedMapping.putIfAbsent(Product, () => Product.fromJsonFactory);

    return _apiV1AppProductsFindallGet();
  }

  ///retrieveAll
  @Get(path: '/api/v1/app/products/findall')
  Future<chopper.Response<List<Product>>> _apiV1AppProductsFindallGet();

  ///retrieveProductsBySupplierId
  ///@param supplierId supplierId
  Future<chopper.Response<List<Product>>> apiV1AppProductsRetrievebysupplierGet(
      {required int? supplierId}) {
    generatedMapping.putIfAbsent(Product, () => Product.fromJsonFactory);

    return _apiV1AppProductsRetrievebysupplierGet(supplierId: supplierId);
  }

  ///retrieveProductsBySupplierId
  ///@param supplierId supplierId
  @Get(path: '/api/v1/app/products/retrievebysupplier')
  Future<chopper.Response<List<Product>>>
      _apiV1AppProductsRetrievebysupplierGet(
          {@Query('supplierId') required int? supplierId});

  ///save
  ///@param productId
  ///@param name
  ///@param code
  ///@param unitMeasure
  ///@param unitMeasureOTH
  ///@param vatApplied
  ///@param price
  ///@param description
  ///@param category
  ///@param supplierId
  Future<chopper.Response<Product>> apiV1AppProductsSavePost({
    int? productId,
    String? name,
    String? code,
    String? unitMeasure,
    String? unitMeasureOTH,
    int? vatApplied,
    num? price,
    String? description,
    String? category,
    int? supplierId,
  }) {
    generatedMapping.putIfAbsent(Product, () => Product.fromJsonFactory);

    return _apiV1AppProductsSavePost(
        productId: productId,
        name: name,
        code: code,
        unitMeasure: unitMeasure,
        unitMeasureOTH: unitMeasureOTH,
        vatApplied: vatApplied,
        price: price,
        description: description,
        category: category,
        supplierId: supplierId);
  }

  ///save
  ///@param productId
  ///@param name
  ///@param code
  ///@param unitMeasure
  ///@param unitMeasureOTH
  ///@param vatApplied
  ///@param price
  ///@param description
  ///@param category
  ///@param supplierId
  @Post(
    path: '/api/v1/app/products/save',
    optionalBody: true,
  )
  Future<chopper.Response<Product>> _apiV1AppProductsSavePost({
    @Query('productId') int? productId,
    @Query('name') String? name,
    @Query('code') String? code,
    @Query('unitMeasure') String? unitMeasure,
    @Query('unitMeasureOTH') String? unitMeasureOTH,
    @Query('vatApplied') int? vatApplied,
    @Query('price') num? price,
    @Query('description') String? description,
    @Query('category') String? category,
    @Query('supplierId') int? supplierId,
  });

  ///update
  ///@param productId
  ///@param name
  ///@param code
  ///@param unitMeasure
  ///@param unitMeasureOTH
  ///@param vatApplied
  ///@param price
  ///@param description
  ///@param category
  ///@param supplierId
  Future<chopper.Response> apiV1AppProductsUpdatePut({
    int? productId,
    String? name,
    String? code,
    String? unitMeasure,
    String? unitMeasureOTH,
    int? vatApplied,
    num? price,
    String? description,
    String? category,
    int? supplierId,
  }) {
    return _apiV1AppProductsUpdatePut(
        productId: productId,
        name: name,
        code: code,
        unitMeasure: unitMeasure,
        unitMeasureOTH: unitMeasureOTH,
        vatApplied: vatApplied,
        price: price,
        description: description,
        category: category,
        supplierId: supplierId);
  }

  ///update
  ///@param productId
  ///@param name
  ///@param code
  ///@param unitMeasure
  ///@param unitMeasureOTH
  ///@param vatApplied
  ///@param price
  ///@param description
  ///@param category
  ///@param supplierId
  @Put(
    path: '/api/v1/app/products/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppProductsUpdatePut({
    @Query('productId') int? productId,
    @Query('name') String? name,
    @Query('code') String? code,
    @Query('unitMeasure') String? unitMeasure,
    @Query('unitMeasureOTH') String? unitMeasureOTH,
    @Query('vatApplied') int? vatApplied,
    @Query('price') num? price,
    @Query('description') String? description,
    @Query('category') String? category,
    @Query('supplierId') int? supplierId,
  });

  ///delete
  ///@param products[0].storageProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stock
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param storageId
  ///@param name
  ///@param creationDate
  ///@param address
  ///@param city
  ///@param cap
  ///@param branchId
  Future<chopper.Response> apiV1AppStorageDeleteDelete({
    int? products0StorageProductId,
    String? products0ProductName,
    String? products0UnitMeasure,
    num? products0Stock,
    num? products0AmountHundred,
    int? products0ProductId,
    int? storageId,
    String? name,
    String? creationDate,
    String? address,
    String? city,
    String? cap,
    int? branchId,
  }) {
    return _apiV1AppStorageDeleteDelete(
        products0StorageProductId: products0StorageProductId,
        products0ProductName: products0ProductName,
        products0UnitMeasure: products0UnitMeasure,
        products0Stock: products0Stock,
        products0AmountHundred: products0AmountHundred,
        products0ProductId: products0ProductId,
        storageId: storageId,
        name: name,
        creationDate: creationDate,
        address: address,
        city: city,
        cap: cap,
        branchId: branchId);
  }

  ///delete
  ///@param products[0].storageProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stock
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param storageId
  ///@param name
  ///@param creationDate
  ///@param address
  ///@param city
  ///@param cap
  ///@param branchId
  @Delete(path: '/api/v1/app/storage/delete')
  Future<chopper.Response> _apiV1AppStorageDeleteDelete({
    @Query('products[0].storageProductId') int? products0StorageProductId,
    @Query('products[0].productName') String? products0ProductName,
    @Query('products[0].unitMeasure') String? products0UnitMeasure,
    @Query('products[0].stock') num? products0Stock,
    @Query('products[0].amountHundred') num? products0AmountHundred,
    @Query('products[0].productId') int? products0ProductId,
    @Query('storageId') int? storageId,
    @Query('name') String? name,
    @Query('creationDate') String? creationDate,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('branchId') int? branchId,
  });

  ///deleteProductFromStorage
  ///@param storageId storageId
  ///@param productId productId
  Future<chopper.Response> apiV1AppStorageDeleteproductfromstorageDelete({
    required int? storageId,
    required int? productId,
  }) {
    return _apiV1AppStorageDeleteproductfromstorageDelete(
        storageId: storageId, productId: productId);
  }

  ///deleteProductFromStorage
  ///@param storageId storageId
  ///@param productId productId
  @Delete(path: '/api/v1/app/storage/deleteproductfromstorage')
  Future<chopper.Response> _apiV1AppStorageDeleteproductfromstorageDelete({
    @Query('storageId') required int? storageId,
    @Query('productId') required int? productId,
  });

  ///findStorageByBranchId
  ///@param branchid branchid
  Future<chopper.Response<List<Storage>>>
      apiV1AppStorageFindstoragebybranchidGet({required int? branchid}) {
    generatedMapping.putIfAbsent(Storage, () => Storage.fromJsonFactory);

    return _apiV1AppStorageFindstoragebybranchidGet(branchid: branchid);
  }

  ///findStorageByBranchId
  ///@param branchid branchid
  @Get(path: '/api/v1/app/storage/findstoragebybranchid')
  Future<chopper.Response<List<Storage>>>
      _apiV1AppStorageFindstoragebybranchidGet(
          {@Query('branchid') required int? branchid});

  ///save
  ///@param storageId storageId
  ///@param productId productId
  Future<chopper.Response<RStorageProduct>> apiV1AppStorageInsertproductGet({
    required int? storageId,
    required int? productId,
  }) {
    generatedMapping.putIfAbsent(
        RStorageProduct, () => RStorageProduct.fromJsonFactory);

    return _apiV1AppStorageInsertproductGet(
        storageId: storageId, productId: productId);
  }

  ///save
  ///@param storageId storageId
  ///@param productId productId
  @Get(path: '/api/v1/app/storage/insertproduct')
  Future<chopper.Response<RStorageProduct>> _apiV1AppStorageInsertproductGet({
    @Query('storageId') required int? storageId,
    @Query('productId') required int? productId,
  });

  ///save
  ///@param products[0].storageProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stock
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param storageId
  ///@param name
  ///@param creationDate
  ///@param address
  ///@param city
  ///@param cap
  ///@param branchId
  Future<chopper.Response<Storage>> apiV1AppStorageSavePost({
    int? products0StorageProductId,
    String? products0ProductName,
    String? products0UnitMeasure,
    num? products0Stock,
    num? products0AmountHundred,
    int? products0ProductId,
    int? storageId,
    String? name,
    String? creationDate,
    String? address,
    String? city,
    String? cap,
    int? branchId,
  }) {
    generatedMapping.putIfAbsent(Storage, () => Storage.fromJsonFactory);

    return _apiV1AppStorageSavePost(
        products0StorageProductId: products0StorageProductId,
        products0ProductName: products0ProductName,
        products0UnitMeasure: products0UnitMeasure,
        products0Stock: products0Stock,
        products0AmountHundred: products0AmountHundred,
        products0ProductId: products0ProductId,
        storageId: storageId,
        name: name,
        creationDate: creationDate,
        address: address,
        city: city,
        cap: cap,
        branchId: branchId);
  }

  ///save
  ///@param products[0].storageProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stock
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param storageId
  ///@param name
  ///@param creationDate
  ///@param address
  ///@param city
  ///@param cap
  ///@param branchId
  @Post(
    path: '/api/v1/app/storage/save',
    optionalBody: true,
  )
  Future<chopper.Response<Storage>> _apiV1AppStorageSavePost({
    @Query('products[0].storageProductId') int? products0StorageProductId,
    @Query('products[0].productName') String? products0ProductName,
    @Query('products[0].unitMeasure') String? products0UnitMeasure,
    @Query('products[0].stock') num? products0Stock,
    @Query('products[0].amountHundred') num? products0AmountHundred,
    @Query('products[0].productId') int? products0ProductId,
    @Query('storageId') int? storageId,
    @Query('name') String? name,
    @Query('creationDate') String? creationDate,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('branchId') int? branchId,
  });

  ///update
  ///@param products[0].storageProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stock
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param storageId
  ///@param name
  ///@param creationDate
  ///@param address
  ///@param city
  ///@param cap
  ///@param branchId
  Future<chopper.Response> apiV1AppStorageUpdatePut({
    int? products0StorageProductId,
    String? products0ProductName,
    String? products0UnitMeasure,
    num? products0Stock,
    num? products0AmountHundred,
    int? products0ProductId,
    int? storageId,
    String? name,
    String? creationDate,
    String? address,
    String? city,
    String? cap,
    int? branchId,
  }) {
    return _apiV1AppStorageUpdatePut(
        products0StorageProductId: products0StorageProductId,
        products0ProductName: products0ProductName,
        products0UnitMeasure: products0UnitMeasure,
        products0Stock: products0Stock,
        products0AmountHundred: products0AmountHundred,
        products0ProductId: products0ProductId,
        storageId: storageId,
        name: name,
        creationDate: creationDate,
        address: address,
        city: city,
        cap: cap,
        branchId: branchId);
  }

  ///update
  ///@param products[0].storageProductId
  ///@param products[0].productName
  ///@param products[0].unitMeasure
  ///@param products[0].stock
  ///@param products[0].amountHundred
  ///@param products[0].productId
  ///@param storageId
  ///@param name
  ///@param creationDate
  ///@param address
  ///@param city
  ///@param cap
  ///@param branchId
  @Put(
    path: '/api/v1/app/storage/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppStorageUpdatePut({
    @Query('products[0].storageProductId') int? products0StorageProductId,
    @Query('products[0].productName') String? products0ProductName,
    @Query('products[0].unitMeasure') String? products0UnitMeasure,
    @Query('products[0].stock') num? products0Stock,
    @Query('products[0].amountHundred') num? products0AmountHundred,
    @Query('products[0].productId') int? products0ProductId,
    @Query('storageId') int? storageId,
    @Query('name') String? name,
    @Query('creationDate') String? creationDate,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('branchId') int? branchId,
  });

  ///delete
  ///@param productList[0].productId
  ///@param productList[0].name
  ///@param productList[0].code
  ///@param productList[0].unitMeasure
  ///@param productList[0].unitMeasureOTH
  ///@param productList[0].vatApplied
  ///@param productList[0].price
  ///@param productList[0].description
  ///@param productList[0].category
  ///@param productList[0].supplierId
  ///@param supplierId
  ///@param name
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param code
  ///@param phoneNumber
  ///@param email
  ///@param pec
  ///@param cf
  ///@param country
  ///@param createdByUserId
  ///@param branchId
  Future<chopper.Response> apiV1AppSuppliersDeleteDelete({
    int? productList0ProductId,
    String? productList0Name,
    String? productList0Code,
    String? productList0UnitMeasure,
    String? productList0UnitMeasureOTH,
    int? productList0VatApplied,
    num? productList0Price,
    String? productList0Description,
    String? productList0Category,
    int? productList0SupplierId,
    int? supplierId,
    String? name,
    String? vatNumber,
    String? address,
    String? city,
    String? cap,
    String? code,
    String? phoneNumber,
    String? email,
    String? pec,
    String? cf,
    String? country,
    int? createdByUserId,
    int? branchId,
  }) {
    return _apiV1AppSuppliersDeleteDelete(
        productList0ProductId: productList0ProductId,
        productList0Name: productList0Name,
        productList0Code: productList0Code,
        productList0UnitMeasure: productList0UnitMeasure,
        productList0UnitMeasureOTH: productList0UnitMeasureOTH,
        productList0VatApplied: productList0VatApplied,
        productList0Price: productList0Price,
        productList0Description: productList0Description,
        productList0Category: productList0Category,
        productList0SupplierId: productList0SupplierId,
        supplierId: supplierId,
        name: name,
        vatNumber: vatNumber,
        address: address,
        city: city,
        cap: cap,
        code: code,
        phoneNumber: phoneNumber,
        email: email,
        pec: pec,
        cf: cf,
        country: country,
        createdByUserId: createdByUserId,
        branchId: branchId);
  }

  ///delete
  ///@param productList[0].productId
  ///@param productList[0].name
  ///@param productList[0].code
  ///@param productList[0].unitMeasure
  ///@param productList[0].unitMeasureOTH
  ///@param productList[0].vatApplied
  ///@param productList[0].price
  ///@param productList[0].description
  ///@param productList[0].category
  ///@param productList[0].supplierId
  ///@param supplierId
  ///@param name
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param code
  ///@param phoneNumber
  ///@param email
  ///@param pec
  ///@param cf
  ///@param country
  ///@param createdByUserId
  ///@param branchId
  @Delete(path: '/api/v1/app/suppliers/delete')
  Future<chopper.Response> _apiV1AppSuppliersDeleteDelete({
    @Query('productList[0].productId') int? productList0ProductId,
    @Query('productList[0].name') String? productList0Name,
    @Query('productList[0].code') String? productList0Code,
    @Query('productList[0].unitMeasure') String? productList0UnitMeasure,
    @Query('productList[0].unitMeasureOTH') String? productList0UnitMeasureOTH,
    @Query('productList[0].vatApplied') int? productList0VatApplied,
    @Query('productList[0].price') num? productList0Price,
    @Query('productList[0].description') String? productList0Description,
    @Query('productList[0].category') String? productList0Category,
    @Query('productList[0].supplierId') int? productList0SupplierId,
    @Query('supplierId') int? supplierId,
    @Query('name') String? name,
    @Query('vatNumber') String? vatNumber,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('code') String? code,
    @Query('phoneNumber') String? phoneNumber,
    @Query('email') String? email,
    @Query('pec') String? pec,
    @Query('cf') String? cf,
    @Query('country') String? country,
    @Query('createdByUserId') int? createdByUserId,
    @Query('branchId') int? branchId,
  });

  ///retrieveAll
  Future<chopper.Response<List<Supplier>>> apiV1AppSuppliersFindallGet() {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppSuppliersFindallGet();
  }

  ///retrieveAll
  @Get(path: '/api/v1/app/suppliers/findall')
  Future<chopper.Response<List<Supplier>>> _apiV1AppSuppliersFindallGet();

  ///retrieveByPhone
  ///@param phone phone
  Future<chopper.Response<Supplier>> apiV1AppSuppliersFindbyphoneGet(
      {required String? phone}) {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppSuppliersFindbyphoneGet(phone: phone);
  }

  ///retrieveByPhone
  ///@param phone phone
  @Get(path: '/api/v1/app/suppliers/findbyphone')
  Future<chopper.Response<Supplier>> _apiV1AppSuppliersFindbyphoneGet(
      {@Query('phone') required String? phone});

  ///save
  ///@param productList[0].productId
  ///@param productList[0].name
  ///@param productList[0].code
  ///@param productList[0].unitMeasure
  ///@param productList[0].unitMeasureOTH
  ///@param productList[0].vatApplied
  ///@param productList[0].price
  ///@param productList[0].description
  ///@param productList[0].category
  ///@param productList[0].supplierId
  ///@param supplierId
  ///@param name
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param code
  ///@param phoneNumber
  ///@param email
  ///@param pec
  ///@param cf
  ///@param country
  ///@param createdByUserId
  ///@param branchId
  Future<chopper.Response<Supplier>> apiV1AppSuppliersSavePost({
    int? productList0ProductId,
    String? productList0Name,
    String? productList0Code,
    String? productList0UnitMeasure,
    String? productList0UnitMeasureOTH,
    int? productList0VatApplied,
    num? productList0Price,
    String? productList0Description,
    String? productList0Category,
    int? productList0SupplierId,
    int? supplierId,
    String? name,
    String? vatNumber,
    String? address,
    String? city,
    String? cap,
    String? code,
    String? phoneNumber,
    String? email,
    String? pec,
    String? cf,
    String? country,
    int? createdByUserId,
    int? branchId,
  }) {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppSuppliersSavePost(
        productList0ProductId: productList0ProductId,
        productList0Name: productList0Name,
        productList0Code: productList0Code,
        productList0UnitMeasure: productList0UnitMeasure,
        productList0UnitMeasureOTH: productList0UnitMeasureOTH,
        productList0VatApplied: productList0VatApplied,
        productList0Price: productList0Price,
        productList0Description: productList0Description,
        productList0Category: productList0Category,
        productList0SupplierId: productList0SupplierId,
        supplierId: supplierId,
        name: name,
        vatNumber: vatNumber,
        address: address,
        city: city,
        cap: cap,
        code: code,
        phoneNumber: phoneNumber,
        email: email,
        pec: pec,
        cf: cf,
        country: country,
        createdByUserId: createdByUserId,
        branchId: branchId);
  }

  ///save
  ///@param productList[0].productId
  ///@param productList[0].name
  ///@param productList[0].code
  ///@param productList[0].unitMeasure
  ///@param productList[0].unitMeasureOTH
  ///@param productList[0].vatApplied
  ///@param productList[0].price
  ///@param productList[0].description
  ///@param productList[0].category
  ///@param productList[0].supplierId
  ///@param supplierId
  ///@param name
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param code
  ///@param phoneNumber
  ///@param email
  ///@param pec
  ///@param cf
  ///@param country
  ///@param createdByUserId
  ///@param branchId
  @Post(
    path: '/api/v1/app/suppliers/save',
    optionalBody: true,
  )
  Future<chopper.Response<Supplier>> _apiV1AppSuppliersSavePost({
    @Query('productList[0].productId') int? productList0ProductId,
    @Query('productList[0].name') String? productList0Name,
    @Query('productList[0].code') String? productList0Code,
    @Query('productList[0].unitMeasure') String? productList0UnitMeasure,
    @Query('productList[0].unitMeasureOTH') String? productList0UnitMeasureOTH,
    @Query('productList[0].vatApplied') int? productList0VatApplied,
    @Query('productList[0].price') num? productList0Price,
    @Query('productList[0].description') String? productList0Description,
    @Query('productList[0].category') String? productList0Category,
    @Query('productList[0].supplierId') int? productList0SupplierId,
    @Query('supplierId') int? supplierId,
    @Query('name') String? name,
    @Query('vatNumber') String? vatNumber,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('code') String? code,
    @Query('phoneNumber') String? phoneNumber,
    @Query('email') String? email,
    @Query('pec') String? pec,
    @Query('cf') String? cf,
    @Query('country') String? country,
    @Query('createdByUserId') int? createdByUserId,
    @Query('branchId') int? branchId,
  });

  ///update
  ///@param productList[0].productId
  ///@param productList[0].name
  ///@param productList[0].code
  ///@param productList[0].unitMeasure
  ///@param productList[0].unitMeasureOTH
  ///@param productList[0].vatApplied
  ///@param productList[0].price
  ///@param productList[0].description
  ///@param productList[0].category
  ///@param productList[0].supplierId
  ///@param supplierId
  ///@param name
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param code
  ///@param phoneNumber
  ///@param email
  ///@param pec
  ///@param cf
  ///@param country
  ///@param createdByUserId
  ///@param branchId
  Future<chopper.Response> apiV1AppSuppliersUpdatePut({
    int? productList0ProductId,
    String? productList0Name,
    String? productList0Code,
    String? productList0UnitMeasure,
    String? productList0UnitMeasureOTH,
    int? productList0VatApplied,
    num? productList0Price,
    String? productList0Description,
    String? productList0Category,
    int? productList0SupplierId,
    int? supplierId,
    String? name,
    String? vatNumber,
    String? address,
    String? city,
    String? cap,
    String? code,
    String? phoneNumber,
    String? email,
    String? pec,
    String? cf,
    String? country,
    int? createdByUserId,
    int? branchId,
  }) {
    return _apiV1AppSuppliersUpdatePut(
        productList0ProductId: productList0ProductId,
        productList0Name: productList0Name,
        productList0Code: productList0Code,
        productList0UnitMeasure: productList0UnitMeasure,
        productList0UnitMeasureOTH: productList0UnitMeasureOTH,
        productList0VatApplied: productList0VatApplied,
        productList0Price: productList0Price,
        productList0Description: productList0Description,
        productList0Category: productList0Category,
        productList0SupplierId: productList0SupplierId,
        supplierId: supplierId,
        name: name,
        vatNumber: vatNumber,
        address: address,
        city: city,
        cap: cap,
        code: code,
        phoneNumber: phoneNumber,
        email: email,
        pec: pec,
        cf: cf,
        country: country,
        createdByUserId: createdByUserId,
        branchId: branchId);
  }

  ///update
  ///@param productList[0].productId
  ///@param productList[0].name
  ///@param productList[0].code
  ///@param productList[0].unitMeasure
  ///@param productList[0].unitMeasureOTH
  ///@param productList[0].vatApplied
  ///@param productList[0].price
  ///@param productList[0].description
  ///@param productList[0].category
  ///@param productList[0].supplierId
  ///@param supplierId
  ///@param name
  ///@param vatNumber
  ///@param address
  ///@param city
  ///@param cap
  ///@param code
  ///@param phoneNumber
  ///@param email
  ///@param pec
  ///@param cf
  ///@param country
  ///@param createdByUserId
  ///@param branchId
  @Put(
    path: '/api/v1/app/suppliers/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppSuppliersUpdatePut({
    @Query('productList[0].productId') int? productList0ProductId,
    @Query('productList[0].name') String? productList0Name,
    @Query('productList[0].code') String? productList0Code,
    @Query('productList[0].unitMeasure') String? productList0UnitMeasure,
    @Query('productList[0].unitMeasureOTH') String? productList0UnitMeasureOTH,
    @Query('productList[0].vatApplied') int? productList0VatApplied,
    @Query('productList[0].price') num? productList0Price,
    @Query('productList[0].description') String? productList0Description,
    @Query('productList[0].category') String? productList0Category,
    @Query('productList[0].supplierId') int? productList0SupplierId,
    @Query('supplierId') int? supplierId,
    @Query('name') String? name,
    @Query('vatNumber') String? vatNumber,
    @Query('address') String? address,
    @Query('city') String? city,
    @Query('cap') String? cap,
    @Query('code') String? code,
    @Query('phoneNumber') String? phoneNumber,
    @Query('email') String? email,
    @Query('pec') String? pec,
    @Query('cf') String? cf,
    @Query('country') String? country,
    @Query('createdByUserId') int? createdByUserId,
    @Query('branchId') int? branchId,
  });

  ///delete
  ///@param branchList[0].storages[0].products[0].storageProductId
  ///@param branchList[0].storages[0].products[0].productName
  ///@param branchList[0].storages[0].products[0].unitMeasure
  ///@param branchList[0].storages[0].products[0].stock
  ///@param branchList[0].storages[0].products[0].amountHundred
  ///@param branchList[0].storages[0].products[0].productId
  ///@param branchList[0].storages[0].storageId
  ///@param branchList[0].storages[0].name
  ///@param branchList[0].storages[0].creationDate
  ///@param branchList[0].storages[0].address
  ///@param branchList[0].storages[0].city
  ///@param branchList[0].storages[0].cap
  ///@param branchList[0].storages[0].branchId
  ///@param branchList[0].suppliers[0].productList[0].productId
  ///@param branchList[0].suppliers[0].productList[0].name
  ///@param branchList[0].suppliers[0].productList[0].code
  ///@param branchList[0].suppliers[0].productList[0].unitMeasure
  ///@param branchList[0].suppliers[0].productList[0].unitMeasureOTH
  ///@param branchList[0].suppliers[0].productList[0].vatApplied
  ///@param branchList[0].suppliers[0].productList[0].price
  ///@param branchList[0].suppliers[0].productList[0].description
  ///@param branchList[0].suppliers[0].productList[0].category
  ///@param branchList[0].suppliers[0].productList[0].supplierId
  ///@param branchList[0].suppliers[0].supplierId
  ///@param branchList[0].suppliers[0].name
  ///@param branchList[0].suppliers[0].vatNumber
  ///@param branchList[0].suppliers[0].address
  ///@param branchList[0].suppliers[0].city
  ///@param branchList[0].suppliers[0].cap
  ///@param branchList[0].suppliers[0].code
  ///@param branchList[0].suppliers[0].phoneNumber
  ///@param branchList[0].suppliers[0].email
  ///@param branchList[0].suppliers[0].pec
  ///@param branchList[0].suppliers[0].cf
  ///@param branchList[0].suppliers[0].country
  ///@param branchList[0].suppliers[0].createdByUserId
  ///@param branchList[0].suppliers[0].branchId
  ///@param branchList[0].events[0].expenceEvents[0].expenceId
  ///@param branchList[0].events[0].expenceEvents[0].description
  ///@param branchList[0].events[0].expenceEvents[0].amount
  ///@param branchList[0].events[0].expenceEvents[0].dateIntert
  ///@param branchList[0].events[0].expenceEvents[0].eventId
  ///@param branchList[0].events[0].workstations[0].products[0].workstationProductId
  ///@param branchList[0].events[0].workstations[0].products[0].productName
  ///@param branchList[0].events[0].workstations[0].products[0].unitMeasure
  ///@param branchList[0].events[0].workstations[0].products[0].stockFromStorage
  ///@param branchList[0].events[0].workstations[0].products[0].consumed
  ///@param branchList[0].events[0].workstations[0].products[0].amountHundred
  ///@param branchList[0].events[0].workstations[0].products[0].productId
  ///@param branchList[0].events[0].workstations[0].products[0].storageId
  ///@param branchList[0].events[0].workstations[0].workstationId
  ///@param branchList[0].events[0].workstations[0].name
  ///@param branchList[0].events[0].workstations[0].responsable
  ///@param branchList[0].events[0].workstations[0].extra
  ///@param branchList[0].events[0].workstations[0].workstationType
  ///@param branchList[0].events[0].workstations[0].eventId
  ///@param branchList[0].events[0].eventId
  ///@param branchList[0].events[0].name
  ///@param branchList[0].events[0].dateEvent
  ///@param branchList[0].events[0].dateCreation
  ///@param branchList[0].events[0].eventStatus
  ///@param branchList[0].events[0].location
  ///@param branchList[0].events[0].branchId
  ///@param branchList[0].events[0].storageId
  ///@param branchList[0].orders[0].products[0].orderProductId
  ///@param branchList[0].orders[0].products[0].productName
  ///@param branchList[0].orders[0].products[0].unitMeasure
  ///@param branchList[0].orders[0].products[0].productId
  ///@param branchList[0].orders[0].products[0].price
  ///@param branchList[0].orders[0].products[0].amount
  ///@param branchList[0].orders[0].orderId
  ///@param branchList[0].orders[0].code
  ///@param branchList[0].orders[0].total
  ///@param branchList[0].orders[0].orderStatus
  ///@param branchList[0].orders[0].errorStatus
  ///@param branchList[0].orders[0].creationDate
  ///@param branchList[0].orders[0].senderUser
  ///@param branchList[0].orders[0].details
  ///@param branchList[0].orders[0].deliveryDate
  ///@param branchList[0].orders[0].closedBy
  ///@param branchList[0].orders[0].supplierId
  ///@param branchList[0].orders[0].branchId
  ///@param branchList[0].orders[0].storageId
  ///@param branchList[0].branchId
  ///@param branchList[0].branchCode
  ///@param branchList[0].name
  ///@param branchList[0].email
  ///@param branchList[0].vatNumber
  ///@param branchList[0].address
  ///@param branchList[0].city
  ///@param branchList[0].cap
  ///@param branchList[0].phoneNumber
  ///@param branchList[0].userId
  ///@param branchList[0].token
  ///@param branchList[0].userPriviledge
  ///@param userId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  Future<chopper.Response> apiV1AppUsersDeleteDelete({
    int? branchList0Storages0Products0StorageProductId,
    String? branchList0Storages0Products0ProductName,
    String? branchList0Storages0Products0UnitMeasure,
    num? branchList0Storages0Products0Stock,
    num? branchList0Storages0Products0AmountHundred,
    int? branchList0Storages0Products0ProductId,
    int? branchList0Storages0StorageId,
    String? branchList0Storages0Name,
    String? branchList0Storages0CreationDate,
    String? branchList0Storages0Address,
    String? branchList0Storages0City,
    String? branchList0Storages0Cap,
    int? branchList0Storages0BranchId,
    int? branchList0Suppliers0ProductList0ProductId,
    String? branchList0Suppliers0ProductList0Name,
    String? branchList0Suppliers0ProductList0Code,
    String? branchList0Suppliers0ProductList0UnitMeasure,
    String? branchList0Suppliers0ProductList0UnitMeasureOTH,
    int? branchList0Suppliers0ProductList0VatApplied,
    num? branchList0Suppliers0ProductList0Price,
    String? branchList0Suppliers0ProductList0Description,
    String? branchList0Suppliers0ProductList0Category,
    int? branchList0Suppliers0ProductList0SupplierId,
    int? branchList0Suppliers0SupplierId,
    String? branchList0Suppliers0Name,
    String? branchList0Suppliers0VatNumber,
    String? branchList0Suppliers0Address,
    String? branchList0Suppliers0City,
    String? branchList0Suppliers0Cap,
    String? branchList0Suppliers0Code,
    String? branchList0Suppliers0PhoneNumber,
    String? branchList0Suppliers0Email,
    String? branchList0Suppliers0Pec,
    String? branchList0Suppliers0Cf,
    String? branchList0Suppliers0Country,
    int? branchList0Suppliers0CreatedByUserId,
    int? branchList0Suppliers0BranchId,
    int? branchList0Events0ExpenceEvents0ExpenceId,
    String? branchList0Events0ExpenceEvents0Description,
    num? branchList0Events0ExpenceEvents0Amount,
    String? branchList0Events0ExpenceEvents0DateIntert,
    int? branchList0Events0ExpenceEvents0EventId,
    int? branchList0Events0Workstations0Products0WorkstationProductId,
    String? branchList0Events0Workstations0Products0ProductName,
    String? branchList0Events0Workstations0Products0UnitMeasure,
    num? branchList0Events0Workstations0Products0StockFromStorage,
    num? branchList0Events0Workstations0Products0Consumed,
    num? branchList0Events0Workstations0Products0AmountHundred,
    int? branchList0Events0Workstations0Products0ProductId,
    int? branchList0Events0Workstations0Products0StorageId,
    int? branchList0Events0Workstations0WorkstationId,
    String? branchList0Events0Workstations0Name,
    String? branchList0Events0Workstations0Responsable,
    String? branchList0Events0Workstations0Extra,
    String? branchList0Events0Workstations0WorkstationType,
    int? branchList0Events0Workstations0EventId,
    int? branchList0Events0EventId,
    String? branchList0Events0Name,
    String? branchList0Events0DateEvent,
    String? branchList0Events0DateCreation,
    String? branchList0Events0EventStatus,
    String? branchList0Events0Location,
    int? branchList0Events0BranchId,
    int? branchList0Events0StorageId,
    int? branchList0Orders0Products0OrderProductId,
    String? branchList0Orders0Products0ProductName,
    String? branchList0Orders0Products0UnitMeasure,
    int? branchList0Orders0Products0ProductId,
    num? branchList0Orders0Products0Price,
    num? branchList0Orders0Products0Amount,
    int? branchList0Orders0OrderId,
    String? branchList0Orders0Code,
    num? branchList0Orders0Total,
    String? branchList0Orders0OrderStatus,
    String? branchList0Orders0ErrorStatus,
    String? branchList0Orders0CreationDate,
    String? branchList0Orders0SenderUser,
    String? branchList0Orders0Details,
    String? branchList0Orders0DeliveryDate,
    String? branchList0Orders0ClosedBy,
    int? branchList0Orders0SupplierId,
    int? branchList0Orders0BranchId,
    int? branchList0Orders0StorageId,
    int? branchList0BranchId,
    String? branchList0BranchCode,
    String? branchList0Name,
    String? branchList0Email,
    String? branchList0VatNumber,
    String? branchList0Address,
    String? branchList0City,
    String? branchList0Cap,
    String? branchList0PhoneNumber,
    int? branchList0UserId,
    String? branchList0Token,
    String? branchList0UserPriviledge,
    int? userId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
  }) {
    return _apiV1AppUsersDeleteDelete(
        branchList0Storages0Products0StorageProductId:
            branchList0Storages0Products0StorageProductId,
        branchList0Storages0Products0ProductName:
            branchList0Storages0Products0ProductName,
        branchList0Storages0Products0UnitMeasure:
            branchList0Storages0Products0UnitMeasure,
        branchList0Storages0Products0Stock: branchList0Storages0Products0Stock,
        branchList0Storages0Products0AmountHundred:
            branchList0Storages0Products0AmountHundred,
        branchList0Storages0Products0ProductId:
            branchList0Storages0Products0ProductId,
        branchList0Storages0StorageId: branchList0Storages0StorageId,
        branchList0Storages0Name: branchList0Storages0Name,
        branchList0Storages0CreationDate: branchList0Storages0CreationDate,
        branchList0Storages0Address: branchList0Storages0Address,
        branchList0Storages0City: branchList0Storages0City,
        branchList0Storages0Cap: branchList0Storages0Cap,
        branchList0Storages0BranchId: branchList0Storages0BranchId,
        branchList0Suppliers0ProductList0ProductId:
            branchList0Suppliers0ProductList0ProductId,
        branchList0Suppliers0ProductList0Name:
            branchList0Suppliers0ProductList0Name,
        branchList0Suppliers0ProductList0Code:
            branchList0Suppliers0ProductList0Code,
        branchList0Suppliers0ProductList0UnitMeasure:
            branchList0Suppliers0ProductList0UnitMeasure,
        branchList0Suppliers0ProductList0UnitMeasureOTH:
            branchList0Suppliers0ProductList0UnitMeasureOTH,
        branchList0Suppliers0ProductList0VatApplied:
            branchList0Suppliers0ProductList0VatApplied,
        branchList0Suppliers0ProductList0Price:
            branchList0Suppliers0ProductList0Price,
        branchList0Suppliers0ProductList0Description:
            branchList0Suppliers0ProductList0Description,
        branchList0Suppliers0ProductList0Category:
            branchList0Suppliers0ProductList0Category,
        branchList0Suppliers0ProductList0SupplierId:
            branchList0Suppliers0ProductList0SupplierId,
        branchList0Suppliers0SupplierId: branchList0Suppliers0SupplierId,
        branchList0Suppliers0Name: branchList0Suppliers0Name,
        branchList0Suppliers0VatNumber: branchList0Suppliers0VatNumber,
        branchList0Suppliers0Address: branchList0Suppliers0Address,
        branchList0Suppliers0City: branchList0Suppliers0City,
        branchList0Suppliers0Cap: branchList0Suppliers0Cap,
        branchList0Suppliers0Code: branchList0Suppliers0Code,
        branchList0Suppliers0PhoneNumber: branchList0Suppliers0PhoneNumber,
        branchList0Suppliers0Email: branchList0Suppliers0Email,
        branchList0Suppliers0Pec: branchList0Suppliers0Pec,
        branchList0Suppliers0Cf: branchList0Suppliers0Cf,
        branchList0Suppliers0Country: branchList0Suppliers0Country,
        branchList0Suppliers0CreatedByUserId:
            branchList0Suppliers0CreatedByUserId,
        branchList0Suppliers0BranchId: branchList0Suppliers0BranchId,
        branchList0Events0ExpenceEvents0ExpenceId:
            branchList0Events0ExpenceEvents0ExpenceId,
        branchList0Events0ExpenceEvents0Description:
            branchList0Events0ExpenceEvents0Description,
        branchList0Events0ExpenceEvents0Amount:
            branchList0Events0ExpenceEvents0Amount,
        branchList0Events0ExpenceEvents0DateIntert:
            branchList0Events0ExpenceEvents0DateIntert,
        branchList0Events0ExpenceEvents0EventId:
            branchList0Events0ExpenceEvents0EventId,
        branchList0Events0Workstations0Products0WorkstationProductId:
            branchList0Events0Workstations0Products0WorkstationProductId,
        branchList0Events0Workstations0Products0ProductName:
            branchList0Events0Workstations0Products0ProductName,
        branchList0Events0Workstations0Products0UnitMeasure:
            branchList0Events0Workstations0Products0UnitMeasure,
        branchList0Events0Workstations0Products0StockFromStorage:
            branchList0Events0Workstations0Products0StockFromStorage,
        branchList0Events0Workstations0Products0Consumed:
            branchList0Events0Workstations0Products0Consumed,
        branchList0Events0Workstations0Products0AmountHundred:
            branchList0Events0Workstations0Products0AmountHundred,
        branchList0Events0Workstations0Products0ProductId:
            branchList0Events0Workstations0Products0ProductId,
        branchList0Events0Workstations0Products0StorageId:
            branchList0Events0Workstations0Products0StorageId,
        branchList0Events0Workstations0WorkstationId:
            branchList0Events0Workstations0WorkstationId,
        branchList0Events0Workstations0Name:
            branchList0Events0Workstations0Name,
        branchList0Events0Workstations0Responsable:
            branchList0Events0Workstations0Responsable,
        branchList0Events0Workstations0Extra:
            branchList0Events0Workstations0Extra,
        branchList0Events0Workstations0WorkstationType:
            branchList0Events0Workstations0WorkstationType,
        branchList0Events0Workstations0EventId:
            branchList0Events0Workstations0EventId,
        branchList0Events0EventId: branchList0Events0EventId,
        branchList0Events0Name: branchList0Events0Name,
        branchList0Events0DateEvent: branchList0Events0DateEvent,
        branchList0Events0DateCreation: branchList0Events0DateCreation,
        branchList0Events0EventStatus: branchList0Events0EventStatus,
        branchList0Events0Location: branchList0Events0Location,
        branchList0Events0BranchId: branchList0Events0BranchId,
        branchList0Events0StorageId: branchList0Events0StorageId,
        branchList0Orders0Products0OrderProductId:
            branchList0Orders0Products0OrderProductId,
        branchList0Orders0Products0ProductName:
            branchList0Orders0Products0ProductName,
        branchList0Orders0Products0UnitMeasure:
            branchList0Orders0Products0UnitMeasure,
        branchList0Orders0Products0ProductId:
            branchList0Orders0Products0ProductId,
        branchList0Orders0Products0Price: branchList0Orders0Products0Price,
        branchList0Orders0Products0Amount: branchList0Orders0Products0Amount,
        branchList0Orders0OrderId: branchList0Orders0OrderId,
        branchList0Orders0Code: branchList0Orders0Code,
        branchList0Orders0Total: branchList0Orders0Total,
        branchList0Orders0OrderStatus: branchList0Orders0OrderStatus,
        branchList0Orders0ErrorStatus: branchList0Orders0ErrorStatus,
        branchList0Orders0CreationDate: branchList0Orders0CreationDate,
        branchList0Orders0SenderUser: branchList0Orders0SenderUser,
        branchList0Orders0Details: branchList0Orders0Details,
        branchList0Orders0DeliveryDate: branchList0Orders0DeliveryDate,
        branchList0Orders0ClosedBy: branchList0Orders0ClosedBy,
        branchList0Orders0SupplierId: branchList0Orders0SupplierId,
        branchList0Orders0BranchId: branchList0Orders0BranchId,
        branchList0Orders0StorageId: branchList0Orders0StorageId,
        branchList0BranchId: branchList0BranchId,
        branchList0BranchCode: branchList0BranchCode,
        branchList0Name: branchList0Name,
        branchList0Email: branchList0Email,
        branchList0VatNumber: branchList0VatNumber,
        branchList0Address: branchList0Address,
        branchList0City: branchList0City,
        branchList0Cap: branchList0Cap,
        branchList0PhoneNumber: branchList0PhoneNumber,
        branchList0UserId: branchList0UserId,
        branchList0Token: branchList0Token,
        branchList0UserPriviledge: branchList0UserPriviledge,
        userId: userId,
        name: name,
        lastname: lastname,
        email: email,
        phone: phone);
  }

  ///delete
  ///@param branchList[0].storages[0].products[0].storageProductId
  ///@param branchList[0].storages[0].products[0].productName
  ///@param branchList[0].storages[0].products[0].unitMeasure
  ///@param branchList[0].storages[0].products[0].stock
  ///@param branchList[0].storages[0].products[0].amountHundred
  ///@param branchList[0].storages[0].products[0].productId
  ///@param branchList[0].storages[0].storageId
  ///@param branchList[0].storages[0].name
  ///@param branchList[0].storages[0].creationDate
  ///@param branchList[0].storages[0].address
  ///@param branchList[0].storages[0].city
  ///@param branchList[0].storages[0].cap
  ///@param branchList[0].storages[0].branchId
  ///@param branchList[0].suppliers[0].productList[0].productId
  ///@param branchList[0].suppliers[0].productList[0].name
  ///@param branchList[0].suppliers[0].productList[0].code
  ///@param branchList[0].suppliers[0].productList[0].unitMeasure
  ///@param branchList[0].suppliers[0].productList[0].unitMeasureOTH
  ///@param branchList[0].suppliers[0].productList[0].vatApplied
  ///@param branchList[0].suppliers[0].productList[0].price
  ///@param branchList[0].suppliers[0].productList[0].description
  ///@param branchList[0].suppliers[0].productList[0].category
  ///@param branchList[0].suppliers[0].productList[0].supplierId
  ///@param branchList[0].suppliers[0].supplierId
  ///@param branchList[0].suppliers[0].name
  ///@param branchList[0].suppliers[0].vatNumber
  ///@param branchList[0].suppliers[0].address
  ///@param branchList[0].suppliers[0].city
  ///@param branchList[0].suppliers[0].cap
  ///@param branchList[0].suppliers[0].code
  ///@param branchList[0].suppliers[0].phoneNumber
  ///@param branchList[0].suppliers[0].email
  ///@param branchList[0].suppliers[0].pec
  ///@param branchList[0].suppliers[0].cf
  ///@param branchList[0].suppliers[0].country
  ///@param branchList[0].suppliers[0].createdByUserId
  ///@param branchList[0].suppliers[0].branchId
  ///@param branchList[0].events[0].expenceEvents[0].expenceId
  ///@param branchList[0].events[0].expenceEvents[0].description
  ///@param branchList[0].events[0].expenceEvents[0].amount
  ///@param branchList[0].events[0].expenceEvents[0].dateIntert
  ///@param branchList[0].events[0].expenceEvents[0].eventId
  ///@param branchList[0].events[0].workstations[0].products[0].workstationProductId
  ///@param branchList[0].events[0].workstations[0].products[0].productName
  ///@param branchList[0].events[0].workstations[0].products[0].unitMeasure
  ///@param branchList[0].events[0].workstations[0].products[0].stockFromStorage
  ///@param branchList[0].events[0].workstations[0].products[0].consumed
  ///@param branchList[0].events[0].workstations[0].products[0].amountHundred
  ///@param branchList[0].events[0].workstations[0].products[0].productId
  ///@param branchList[0].events[0].workstations[0].products[0].storageId
  ///@param branchList[0].events[0].workstations[0].workstationId
  ///@param branchList[0].events[0].workstations[0].name
  ///@param branchList[0].events[0].workstations[0].responsable
  ///@param branchList[0].events[0].workstations[0].extra
  ///@param branchList[0].events[0].workstations[0].workstationType
  ///@param branchList[0].events[0].workstations[0].eventId
  ///@param branchList[0].events[0].eventId
  ///@param branchList[0].events[0].name
  ///@param branchList[0].events[0].dateEvent
  ///@param branchList[0].events[0].dateCreation
  ///@param branchList[0].events[0].eventStatus
  ///@param branchList[0].events[0].location
  ///@param branchList[0].events[0].branchId
  ///@param branchList[0].events[0].storageId
  ///@param branchList[0].orders[0].products[0].orderProductId
  ///@param branchList[0].orders[0].products[0].productName
  ///@param branchList[0].orders[0].products[0].unitMeasure
  ///@param branchList[0].orders[0].products[0].productId
  ///@param branchList[0].orders[0].products[0].price
  ///@param branchList[0].orders[0].products[0].amount
  ///@param branchList[0].orders[0].orderId
  ///@param branchList[0].orders[0].code
  ///@param branchList[0].orders[0].total
  ///@param branchList[0].orders[0].orderStatus
  ///@param branchList[0].orders[0].errorStatus
  ///@param branchList[0].orders[0].creationDate
  ///@param branchList[0].orders[0].senderUser
  ///@param branchList[0].orders[0].details
  ///@param branchList[0].orders[0].deliveryDate
  ///@param branchList[0].orders[0].closedBy
  ///@param branchList[0].orders[0].supplierId
  ///@param branchList[0].orders[0].branchId
  ///@param branchList[0].orders[0].storageId
  ///@param branchList[0].branchId
  ///@param branchList[0].branchCode
  ///@param branchList[0].name
  ///@param branchList[0].email
  ///@param branchList[0].vatNumber
  ///@param branchList[0].address
  ///@param branchList[0].city
  ///@param branchList[0].cap
  ///@param branchList[0].phoneNumber
  ///@param branchList[0].userId
  ///@param branchList[0].token
  ///@param branchList[0].userPriviledge
  ///@param userId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  @Delete(path: '/api/v1/app/users/delete')
  Future<chopper.Response> _apiV1AppUsersDeleteDelete({
    @Query('branchList[0].storages[0].products[0].storageProductId')
        int? branchList0Storages0Products0StorageProductId,
    @Query('branchList[0].storages[0].products[0].productName')
        String? branchList0Storages0Products0ProductName,
    @Query('branchList[0].storages[0].products[0].unitMeasure')
        String? branchList0Storages0Products0UnitMeasure,
    @Query('branchList[0].storages[0].products[0].stock')
        num? branchList0Storages0Products0Stock,
    @Query('branchList[0].storages[0].products[0].amountHundred')
        num? branchList0Storages0Products0AmountHundred,
    @Query('branchList[0].storages[0].products[0].productId')
        int? branchList0Storages0Products0ProductId,
    @Query('branchList[0].storages[0].storageId')
        int? branchList0Storages0StorageId,
    @Query('branchList[0].storages[0].name') String? branchList0Storages0Name,
    @Query('branchList[0].storages[0].creationDate')
        String? branchList0Storages0CreationDate,
    @Query('branchList[0].storages[0].address')
        String? branchList0Storages0Address,
    @Query('branchList[0].storages[0].city') String? branchList0Storages0City,
    @Query('branchList[0].storages[0].cap') String? branchList0Storages0Cap,
    @Query('branchList[0].storages[0].branchId')
        int? branchList0Storages0BranchId,
    @Query('branchList[0].suppliers[0].productList[0].productId')
        int? branchList0Suppliers0ProductList0ProductId,
    @Query('branchList[0].suppliers[0].productList[0].name')
        String? branchList0Suppliers0ProductList0Name,
    @Query('branchList[0].suppliers[0].productList[0].code')
        String? branchList0Suppliers0ProductList0Code,
    @Query('branchList[0].suppliers[0].productList[0].unitMeasure')
        String? branchList0Suppliers0ProductList0UnitMeasure,
    @Query('branchList[0].suppliers[0].productList[0].unitMeasureOTH')
        String? branchList0Suppliers0ProductList0UnitMeasureOTH,
    @Query('branchList[0].suppliers[0].productList[0].vatApplied')
        int? branchList0Suppliers0ProductList0VatApplied,
    @Query('branchList[0].suppliers[0].productList[0].price')
        num? branchList0Suppliers0ProductList0Price,
    @Query('branchList[0].suppliers[0].productList[0].description')
        String? branchList0Suppliers0ProductList0Description,
    @Query('branchList[0].suppliers[0].productList[0].category')
        String? branchList0Suppliers0ProductList0Category,
    @Query('branchList[0].suppliers[0].productList[0].supplierId')
        int? branchList0Suppliers0ProductList0SupplierId,
    @Query('branchList[0].suppliers[0].supplierId')
        int? branchList0Suppliers0SupplierId,
    @Query('branchList[0].suppliers[0].name') String? branchList0Suppliers0Name,
    @Query('branchList[0].suppliers[0].vatNumber')
        String? branchList0Suppliers0VatNumber,
    @Query('branchList[0].suppliers[0].address')
        String? branchList0Suppliers0Address,
    @Query('branchList[0].suppliers[0].city') String? branchList0Suppliers0City,
    @Query('branchList[0].suppliers[0].cap') String? branchList0Suppliers0Cap,
    @Query('branchList[0].suppliers[0].code') String? branchList0Suppliers0Code,
    @Query('branchList[0].suppliers[0].phoneNumber')
        String? branchList0Suppliers0PhoneNumber,
    @Query('branchList[0].suppliers[0].email')
        String? branchList0Suppliers0Email,
    @Query('branchList[0].suppliers[0].pec') String? branchList0Suppliers0Pec,
    @Query('branchList[0].suppliers[0].cf') String? branchList0Suppliers0Cf,
    @Query('branchList[0].suppliers[0].country')
        String? branchList0Suppliers0Country,
    @Query('branchList[0].suppliers[0].createdByUserId')
        int? branchList0Suppliers0CreatedByUserId,
    @Query('branchList[0].suppliers[0].branchId')
        int? branchList0Suppliers0BranchId,
    @Query('branchList[0].events[0].expenceEvents[0].expenceId')
        int? branchList0Events0ExpenceEvents0ExpenceId,
    @Query('branchList[0].events[0].expenceEvents[0].description')
        String? branchList0Events0ExpenceEvents0Description,
    @Query('branchList[0].events[0].expenceEvents[0].amount')
        num? branchList0Events0ExpenceEvents0Amount,
    @Query('branchList[0].events[0].expenceEvents[0].dateIntert')
        String? branchList0Events0ExpenceEvents0DateIntert,
    @Query('branchList[0].events[0].expenceEvents[0].eventId')
        int? branchList0Events0ExpenceEvents0EventId,
    @Query('branchList[0].events[0].workstations[0].products[0].workstationProductId')
        int? branchList0Events0Workstations0Products0WorkstationProductId,
    @Query('branchList[0].events[0].workstations[0].products[0].productName')
        String? branchList0Events0Workstations0Products0ProductName,
    @Query('branchList[0].events[0].workstations[0].products[0].unitMeasure')
        String? branchList0Events0Workstations0Products0UnitMeasure,
    @Query('branchList[0].events[0].workstations[0].products[0].stockFromStorage')
        num? branchList0Events0Workstations0Products0StockFromStorage,
    @Query('branchList[0].events[0].workstations[0].products[0].consumed')
        num? branchList0Events0Workstations0Products0Consumed,
    @Query('branchList[0].events[0].workstations[0].products[0].amountHundred')
        num? branchList0Events0Workstations0Products0AmountHundred,
    @Query('branchList[0].events[0].workstations[0].products[0].productId')
        int? branchList0Events0Workstations0Products0ProductId,
    @Query('branchList[0].events[0].workstations[0].products[0].storageId')
        int? branchList0Events0Workstations0Products0StorageId,
    @Query('branchList[0].events[0].workstations[0].workstationId')
        int? branchList0Events0Workstations0WorkstationId,
    @Query('branchList[0].events[0].workstations[0].name')
        String? branchList0Events0Workstations0Name,
    @Query('branchList[0].events[0].workstations[0].responsable')
        String? branchList0Events0Workstations0Responsable,
    @Query('branchList[0].events[0].workstations[0].extra')
        String? branchList0Events0Workstations0Extra,
    @Query('branchList[0].events[0].workstations[0].workstationType')
        String? branchList0Events0Workstations0WorkstationType,
    @Query('branchList[0].events[0].workstations[0].eventId')
        int? branchList0Events0Workstations0EventId,
    @Query('branchList[0].events[0].eventId') int? branchList0Events0EventId,
    @Query('branchList[0].events[0].name') String? branchList0Events0Name,
    @Query('branchList[0].events[0].dateEvent')
        String? branchList0Events0DateEvent,
    @Query('branchList[0].events[0].dateCreation')
        String? branchList0Events0DateCreation,
    @Query('branchList[0].events[0].eventStatus')
        String? branchList0Events0EventStatus,
    @Query('branchList[0].events[0].location')
        String? branchList0Events0Location,
    @Query('branchList[0].events[0].branchId') int? branchList0Events0BranchId,
    @Query('branchList[0].events[0].storageId')
        int? branchList0Events0StorageId,
    @Query('branchList[0].orders[0].products[0].orderProductId')
        int? branchList0Orders0Products0OrderProductId,
    @Query('branchList[0].orders[0].products[0].productName')
        String? branchList0Orders0Products0ProductName,
    @Query('branchList[0].orders[0].products[0].unitMeasure')
        String? branchList0Orders0Products0UnitMeasure,
    @Query('branchList[0].orders[0].products[0].productId')
        int? branchList0Orders0Products0ProductId,
    @Query('branchList[0].orders[0].products[0].price')
        num? branchList0Orders0Products0Price,
    @Query('branchList[0].orders[0].products[0].amount')
        num? branchList0Orders0Products0Amount,
    @Query('branchList[0].orders[0].orderId') int? branchList0Orders0OrderId,
    @Query('branchList[0].orders[0].code') String? branchList0Orders0Code,
    @Query('branchList[0].orders[0].total') num? branchList0Orders0Total,
    @Query('branchList[0].orders[0].orderStatus')
        String? branchList0Orders0OrderStatus,
    @Query('branchList[0].orders[0].errorStatus')
        String? branchList0Orders0ErrorStatus,
    @Query('branchList[0].orders[0].creationDate')
        String? branchList0Orders0CreationDate,
    @Query('branchList[0].orders[0].senderUser')
        String? branchList0Orders0SenderUser,
    @Query('branchList[0].orders[0].details') String? branchList0Orders0Details,
    @Query('branchList[0].orders[0].deliveryDate')
        String? branchList0Orders0DeliveryDate,
    @Query('branchList[0].orders[0].closedBy')
        String? branchList0Orders0ClosedBy,
    @Query('branchList[0].orders[0].supplierId')
        int? branchList0Orders0SupplierId,
    @Query('branchList[0].orders[0].branchId') int? branchList0Orders0BranchId,
    @Query('branchList[0].orders[0].storageId')
        int? branchList0Orders0StorageId,
    @Query('branchList[0].branchId') int? branchList0BranchId,
    @Query('branchList[0].branchCode') String? branchList0BranchCode,
    @Query('branchList[0].name') String? branchList0Name,
    @Query('branchList[0].email') String? branchList0Email,
    @Query('branchList[0].vatNumber') String? branchList0VatNumber,
    @Query('branchList[0].address') String? branchList0Address,
    @Query('branchList[0].city') String? branchList0City,
    @Query('branchList[0].cap') String? branchList0Cap,
    @Query('branchList[0].phoneNumber') String? branchList0PhoneNumber,
    @Query('branchList[0].userId') int? branchList0UserId,
    @Query('branchList[0].token') String? branchList0Token,
    @Query('branchList[0].userPriviledge') String? branchList0UserPriviledge,
    @Query('userId') int? userId,
    @Query('name') String? name,
    @Query('lastname') String? lastname,
    @Query('email') String? email,
    @Query('phone') String? phone,
  });

  ///retrieveAllBranchesByUserId
  ///@param userId userId
  Future<chopper.Response<List<Branch>>>
      apiV1AppUsersFindAllBranchesByUserIdGet({required int? userId}) {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppUsersFindAllBranchesByUserIdGet(userId: userId);
  }

  ///retrieveAllBranchesByUserId
  ///@param userId userId
  @Get(path: '/api/v1/app/users/findAllBranchesByUserId')
  Future<chopper.Response<List<Branch>>>
      _apiV1AppUsersFindAllBranchesByUserIdGet(
          {@Query('userId') required int? userId});

  ///retrieveAll
  Future<chopper.Response<List<UserEntity>>> apiV1AppUsersFindallGet() {
    generatedMapping.putIfAbsent(UserEntity, () => UserEntity.fromJsonFactory);

    return _apiV1AppUsersFindallGet();
  }

  ///retrieveAll
  @Get(path: '/api/v1/app/users/findall')
  Future<chopper.Response<List<UserEntity>>> _apiV1AppUsersFindallGet();

  ///retrieveAll
  ///@param email email
  Future<chopper.Response<UserEntity>> apiV1AppUsersFindbyemailGet(
      {required String? email}) {
    generatedMapping.putIfAbsent(UserEntity, () => UserEntity.fromJsonFactory);

    return _apiV1AppUsersFindbyemailGet(email: email);
  }

  ///retrieveAll
  ///@param email email
  @Get(path: '/api/v1/app/users/findbyemail')
  Future<chopper.Response<UserEntity>> _apiV1AppUsersFindbyemailGet(
      {@Query('email') required String? email});

  ///save
  ///@param branchList[0].storages[0].products[0].storageProductId
  ///@param branchList[0].storages[0].products[0].productName
  ///@param branchList[0].storages[0].products[0].unitMeasure
  ///@param branchList[0].storages[0].products[0].stock
  ///@param branchList[0].storages[0].products[0].amountHundred
  ///@param branchList[0].storages[0].products[0].productId
  ///@param branchList[0].storages[0].storageId
  ///@param branchList[0].storages[0].name
  ///@param branchList[0].storages[0].creationDate
  ///@param branchList[0].storages[0].address
  ///@param branchList[0].storages[0].city
  ///@param branchList[0].storages[0].cap
  ///@param branchList[0].storages[0].branchId
  ///@param branchList[0].suppliers[0].productList[0].productId
  ///@param branchList[0].suppliers[0].productList[0].name
  ///@param branchList[0].suppliers[0].productList[0].code
  ///@param branchList[0].suppliers[0].productList[0].unitMeasure
  ///@param branchList[0].suppliers[0].productList[0].unitMeasureOTH
  ///@param branchList[0].suppliers[0].productList[0].vatApplied
  ///@param branchList[0].suppliers[0].productList[0].price
  ///@param branchList[0].suppliers[0].productList[0].description
  ///@param branchList[0].suppliers[0].productList[0].category
  ///@param branchList[0].suppliers[0].productList[0].supplierId
  ///@param branchList[0].suppliers[0].supplierId
  ///@param branchList[0].suppliers[0].name
  ///@param branchList[0].suppliers[0].vatNumber
  ///@param branchList[0].suppliers[0].address
  ///@param branchList[0].suppliers[0].city
  ///@param branchList[0].suppliers[0].cap
  ///@param branchList[0].suppliers[0].code
  ///@param branchList[0].suppliers[0].phoneNumber
  ///@param branchList[0].suppliers[0].email
  ///@param branchList[0].suppliers[0].pec
  ///@param branchList[0].suppliers[0].cf
  ///@param branchList[0].suppliers[0].country
  ///@param branchList[0].suppliers[0].createdByUserId
  ///@param branchList[0].suppliers[0].branchId
  ///@param branchList[0].events[0].expenceEvents[0].expenceId
  ///@param branchList[0].events[0].expenceEvents[0].description
  ///@param branchList[0].events[0].expenceEvents[0].amount
  ///@param branchList[0].events[0].expenceEvents[0].dateIntert
  ///@param branchList[0].events[0].expenceEvents[0].eventId
  ///@param branchList[0].events[0].workstations[0].products[0].workstationProductId
  ///@param branchList[0].events[0].workstations[0].products[0].productName
  ///@param branchList[0].events[0].workstations[0].products[0].unitMeasure
  ///@param branchList[0].events[0].workstations[0].products[0].stockFromStorage
  ///@param branchList[0].events[0].workstations[0].products[0].consumed
  ///@param branchList[0].events[0].workstations[0].products[0].amountHundred
  ///@param branchList[0].events[0].workstations[0].products[0].productId
  ///@param branchList[0].events[0].workstations[0].products[0].storageId
  ///@param branchList[0].events[0].workstations[0].workstationId
  ///@param branchList[0].events[0].workstations[0].name
  ///@param branchList[0].events[0].workstations[0].responsable
  ///@param branchList[0].events[0].workstations[0].extra
  ///@param branchList[0].events[0].workstations[0].workstationType
  ///@param branchList[0].events[0].workstations[0].eventId
  ///@param branchList[0].events[0].eventId
  ///@param branchList[0].events[0].name
  ///@param branchList[0].events[0].dateEvent
  ///@param branchList[0].events[0].dateCreation
  ///@param branchList[0].events[0].eventStatus
  ///@param branchList[0].events[0].location
  ///@param branchList[0].events[0].branchId
  ///@param branchList[0].events[0].storageId
  ///@param branchList[0].orders[0].products[0].orderProductId
  ///@param branchList[0].orders[0].products[0].productName
  ///@param branchList[0].orders[0].products[0].unitMeasure
  ///@param branchList[0].orders[0].products[0].productId
  ///@param branchList[0].orders[0].products[0].price
  ///@param branchList[0].orders[0].products[0].amount
  ///@param branchList[0].orders[0].orderId
  ///@param branchList[0].orders[0].code
  ///@param branchList[0].orders[0].total
  ///@param branchList[0].orders[0].orderStatus
  ///@param branchList[0].orders[0].errorStatus
  ///@param branchList[0].orders[0].creationDate
  ///@param branchList[0].orders[0].senderUser
  ///@param branchList[0].orders[0].details
  ///@param branchList[0].orders[0].deliveryDate
  ///@param branchList[0].orders[0].closedBy
  ///@param branchList[0].orders[0].supplierId
  ///@param branchList[0].orders[0].branchId
  ///@param branchList[0].orders[0].storageId
  ///@param branchList[0].branchId
  ///@param branchList[0].branchCode
  ///@param branchList[0].name
  ///@param branchList[0].email
  ///@param branchList[0].vatNumber
  ///@param branchList[0].address
  ///@param branchList[0].city
  ///@param branchList[0].cap
  ///@param branchList[0].phoneNumber
  ///@param branchList[0].userId
  ///@param branchList[0].token
  ///@param branchList[0].userPriviledge
  ///@param userId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  Future<chopper.Response> apiV1AppUsersSavePost({
    int? branchList0Storages0Products0StorageProductId,
    String? branchList0Storages0Products0ProductName,
    String? branchList0Storages0Products0UnitMeasure,
    num? branchList0Storages0Products0Stock,
    num? branchList0Storages0Products0AmountHundred,
    int? branchList0Storages0Products0ProductId,
    int? branchList0Storages0StorageId,
    String? branchList0Storages0Name,
    String? branchList0Storages0CreationDate,
    String? branchList0Storages0Address,
    String? branchList0Storages0City,
    String? branchList0Storages0Cap,
    int? branchList0Storages0BranchId,
    int? branchList0Suppliers0ProductList0ProductId,
    String? branchList0Suppliers0ProductList0Name,
    String? branchList0Suppliers0ProductList0Code,
    String? branchList0Suppliers0ProductList0UnitMeasure,
    String? branchList0Suppliers0ProductList0UnitMeasureOTH,
    int? branchList0Suppliers0ProductList0VatApplied,
    num? branchList0Suppliers0ProductList0Price,
    String? branchList0Suppliers0ProductList0Description,
    String? branchList0Suppliers0ProductList0Category,
    int? branchList0Suppliers0ProductList0SupplierId,
    int? branchList0Suppliers0SupplierId,
    String? branchList0Suppliers0Name,
    String? branchList0Suppliers0VatNumber,
    String? branchList0Suppliers0Address,
    String? branchList0Suppliers0City,
    String? branchList0Suppliers0Cap,
    String? branchList0Suppliers0Code,
    String? branchList0Suppliers0PhoneNumber,
    String? branchList0Suppliers0Email,
    String? branchList0Suppliers0Pec,
    String? branchList0Suppliers0Cf,
    String? branchList0Suppliers0Country,
    int? branchList0Suppliers0CreatedByUserId,
    int? branchList0Suppliers0BranchId,
    int? branchList0Events0ExpenceEvents0ExpenceId,
    String? branchList0Events0ExpenceEvents0Description,
    num? branchList0Events0ExpenceEvents0Amount,
    String? branchList0Events0ExpenceEvents0DateIntert,
    int? branchList0Events0ExpenceEvents0EventId,
    int? branchList0Events0Workstations0Products0WorkstationProductId,
    String? branchList0Events0Workstations0Products0ProductName,
    String? branchList0Events0Workstations0Products0UnitMeasure,
    num? branchList0Events0Workstations0Products0StockFromStorage,
    num? branchList0Events0Workstations0Products0Consumed,
    num? branchList0Events0Workstations0Products0AmountHundred,
    int? branchList0Events0Workstations0Products0ProductId,
    int? branchList0Events0Workstations0Products0StorageId,
    int? branchList0Events0Workstations0WorkstationId,
    String? branchList0Events0Workstations0Name,
    String? branchList0Events0Workstations0Responsable,
    String? branchList0Events0Workstations0Extra,
    String? branchList0Events0Workstations0WorkstationType,
    int? branchList0Events0Workstations0EventId,
    int? branchList0Events0EventId,
    String? branchList0Events0Name,
    String? branchList0Events0DateEvent,
    String? branchList0Events0DateCreation,
    String? branchList0Events0EventStatus,
    String? branchList0Events0Location,
    int? branchList0Events0BranchId,
    int? branchList0Events0StorageId,
    int? branchList0Orders0Products0OrderProductId,
    String? branchList0Orders0Products0ProductName,
    String? branchList0Orders0Products0UnitMeasure,
    int? branchList0Orders0Products0ProductId,
    num? branchList0Orders0Products0Price,
    num? branchList0Orders0Products0Amount,
    int? branchList0Orders0OrderId,
    String? branchList0Orders0Code,
    num? branchList0Orders0Total,
    String? branchList0Orders0OrderStatus,
    String? branchList0Orders0ErrorStatus,
    String? branchList0Orders0CreationDate,
    String? branchList0Orders0SenderUser,
    String? branchList0Orders0Details,
    String? branchList0Orders0DeliveryDate,
    String? branchList0Orders0ClosedBy,
    int? branchList0Orders0SupplierId,
    int? branchList0Orders0BranchId,
    int? branchList0Orders0StorageId,
    int? branchList0BranchId,
    String? branchList0BranchCode,
    String? branchList0Name,
    String? branchList0Email,
    String? branchList0VatNumber,
    String? branchList0Address,
    String? branchList0City,
    String? branchList0Cap,
    String? branchList0PhoneNumber,
    int? branchList0UserId,
    String? branchList0Token,
    String? branchList0UserPriviledge,
    int? userId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
  }) {
    return _apiV1AppUsersSavePost(
        branchList0Storages0Products0StorageProductId:
            branchList0Storages0Products0StorageProductId,
        branchList0Storages0Products0ProductName:
            branchList0Storages0Products0ProductName,
        branchList0Storages0Products0UnitMeasure:
            branchList0Storages0Products0UnitMeasure,
        branchList0Storages0Products0Stock: branchList0Storages0Products0Stock,
        branchList0Storages0Products0AmountHundred:
            branchList0Storages0Products0AmountHundred,
        branchList0Storages0Products0ProductId:
            branchList0Storages0Products0ProductId,
        branchList0Storages0StorageId: branchList0Storages0StorageId,
        branchList0Storages0Name: branchList0Storages0Name,
        branchList0Storages0CreationDate: branchList0Storages0CreationDate,
        branchList0Storages0Address: branchList0Storages0Address,
        branchList0Storages0City: branchList0Storages0City,
        branchList0Storages0Cap: branchList0Storages0Cap,
        branchList0Storages0BranchId: branchList0Storages0BranchId,
        branchList0Suppliers0ProductList0ProductId:
            branchList0Suppliers0ProductList0ProductId,
        branchList0Suppliers0ProductList0Name:
            branchList0Suppliers0ProductList0Name,
        branchList0Suppliers0ProductList0Code:
            branchList0Suppliers0ProductList0Code,
        branchList0Suppliers0ProductList0UnitMeasure:
            branchList0Suppliers0ProductList0UnitMeasure,
        branchList0Suppliers0ProductList0UnitMeasureOTH:
            branchList0Suppliers0ProductList0UnitMeasureOTH,
        branchList0Suppliers0ProductList0VatApplied:
            branchList0Suppliers0ProductList0VatApplied,
        branchList0Suppliers0ProductList0Price:
            branchList0Suppliers0ProductList0Price,
        branchList0Suppliers0ProductList0Description:
            branchList0Suppliers0ProductList0Description,
        branchList0Suppliers0ProductList0Category:
            branchList0Suppliers0ProductList0Category,
        branchList0Suppliers0ProductList0SupplierId:
            branchList0Suppliers0ProductList0SupplierId,
        branchList0Suppliers0SupplierId: branchList0Suppliers0SupplierId,
        branchList0Suppliers0Name: branchList0Suppliers0Name,
        branchList0Suppliers0VatNumber: branchList0Suppliers0VatNumber,
        branchList0Suppliers0Address: branchList0Suppliers0Address,
        branchList0Suppliers0City: branchList0Suppliers0City,
        branchList0Suppliers0Cap: branchList0Suppliers0Cap,
        branchList0Suppliers0Code: branchList0Suppliers0Code,
        branchList0Suppliers0PhoneNumber: branchList0Suppliers0PhoneNumber,
        branchList0Suppliers0Email: branchList0Suppliers0Email,
        branchList0Suppliers0Pec: branchList0Suppliers0Pec,
        branchList0Suppliers0Cf: branchList0Suppliers0Cf,
        branchList0Suppliers0Country: branchList0Suppliers0Country,
        branchList0Suppliers0CreatedByUserId:
            branchList0Suppliers0CreatedByUserId,
        branchList0Suppliers0BranchId: branchList0Suppliers0BranchId,
        branchList0Events0ExpenceEvents0ExpenceId:
            branchList0Events0ExpenceEvents0ExpenceId,
        branchList0Events0ExpenceEvents0Description:
            branchList0Events0ExpenceEvents0Description,
        branchList0Events0ExpenceEvents0Amount:
            branchList0Events0ExpenceEvents0Amount,
        branchList0Events0ExpenceEvents0DateIntert:
            branchList0Events0ExpenceEvents0DateIntert,
        branchList0Events0ExpenceEvents0EventId:
            branchList0Events0ExpenceEvents0EventId,
        branchList0Events0Workstations0Products0WorkstationProductId:
            branchList0Events0Workstations0Products0WorkstationProductId,
        branchList0Events0Workstations0Products0ProductName:
            branchList0Events0Workstations0Products0ProductName,
        branchList0Events0Workstations0Products0UnitMeasure:
            branchList0Events0Workstations0Products0UnitMeasure,
        branchList0Events0Workstations0Products0StockFromStorage:
            branchList0Events0Workstations0Products0StockFromStorage,
        branchList0Events0Workstations0Products0Consumed:
            branchList0Events0Workstations0Products0Consumed,
        branchList0Events0Workstations0Products0AmountHundred:
            branchList0Events0Workstations0Products0AmountHundred,
        branchList0Events0Workstations0Products0ProductId:
            branchList0Events0Workstations0Products0ProductId,
        branchList0Events0Workstations0Products0StorageId:
            branchList0Events0Workstations0Products0StorageId,
        branchList0Events0Workstations0WorkstationId:
            branchList0Events0Workstations0WorkstationId,
        branchList0Events0Workstations0Name:
            branchList0Events0Workstations0Name,
        branchList0Events0Workstations0Responsable:
            branchList0Events0Workstations0Responsable,
        branchList0Events0Workstations0Extra:
            branchList0Events0Workstations0Extra,
        branchList0Events0Workstations0WorkstationType:
            branchList0Events0Workstations0WorkstationType,
        branchList0Events0Workstations0EventId:
            branchList0Events0Workstations0EventId,
        branchList0Events0EventId: branchList0Events0EventId,
        branchList0Events0Name: branchList0Events0Name,
        branchList0Events0DateEvent: branchList0Events0DateEvent,
        branchList0Events0DateCreation: branchList0Events0DateCreation,
        branchList0Events0EventStatus: branchList0Events0EventStatus,
        branchList0Events0Location: branchList0Events0Location,
        branchList0Events0BranchId: branchList0Events0BranchId,
        branchList0Events0StorageId: branchList0Events0StorageId,
        branchList0Orders0Products0OrderProductId:
            branchList0Orders0Products0OrderProductId,
        branchList0Orders0Products0ProductName:
            branchList0Orders0Products0ProductName,
        branchList0Orders0Products0UnitMeasure:
            branchList0Orders0Products0UnitMeasure,
        branchList0Orders0Products0ProductId:
            branchList0Orders0Products0ProductId,
        branchList0Orders0Products0Price: branchList0Orders0Products0Price,
        branchList0Orders0Products0Amount: branchList0Orders0Products0Amount,
        branchList0Orders0OrderId: branchList0Orders0OrderId,
        branchList0Orders0Code: branchList0Orders0Code,
        branchList0Orders0Total: branchList0Orders0Total,
        branchList0Orders0OrderStatus: branchList0Orders0OrderStatus,
        branchList0Orders0ErrorStatus: branchList0Orders0ErrorStatus,
        branchList0Orders0CreationDate: branchList0Orders0CreationDate,
        branchList0Orders0SenderUser: branchList0Orders0SenderUser,
        branchList0Orders0Details: branchList0Orders0Details,
        branchList0Orders0DeliveryDate: branchList0Orders0DeliveryDate,
        branchList0Orders0ClosedBy: branchList0Orders0ClosedBy,
        branchList0Orders0SupplierId: branchList0Orders0SupplierId,
        branchList0Orders0BranchId: branchList0Orders0BranchId,
        branchList0Orders0StorageId: branchList0Orders0StorageId,
        branchList0BranchId: branchList0BranchId,
        branchList0BranchCode: branchList0BranchCode,
        branchList0Name: branchList0Name,
        branchList0Email: branchList0Email,
        branchList0VatNumber: branchList0VatNumber,
        branchList0Address: branchList0Address,
        branchList0City: branchList0City,
        branchList0Cap: branchList0Cap,
        branchList0PhoneNumber: branchList0PhoneNumber,
        branchList0UserId: branchList0UserId,
        branchList0Token: branchList0Token,
        branchList0UserPriviledge: branchList0UserPriviledge,
        userId: userId,
        name: name,
        lastname: lastname,
        email: email,
        phone: phone);
  }

  ///save
  ///@param branchList[0].storages[0].products[0].storageProductId
  ///@param branchList[0].storages[0].products[0].productName
  ///@param branchList[0].storages[0].products[0].unitMeasure
  ///@param branchList[0].storages[0].products[0].stock
  ///@param branchList[0].storages[0].products[0].amountHundred
  ///@param branchList[0].storages[0].products[0].productId
  ///@param branchList[0].storages[0].storageId
  ///@param branchList[0].storages[0].name
  ///@param branchList[0].storages[0].creationDate
  ///@param branchList[0].storages[0].address
  ///@param branchList[0].storages[0].city
  ///@param branchList[0].storages[0].cap
  ///@param branchList[0].storages[0].branchId
  ///@param branchList[0].suppliers[0].productList[0].productId
  ///@param branchList[0].suppliers[0].productList[0].name
  ///@param branchList[0].suppliers[0].productList[0].code
  ///@param branchList[0].suppliers[0].productList[0].unitMeasure
  ///@param branchList[0].suppliers[0].productList[0].unitMeasureOTH
  ///@param branchList[0].suppliers[0].productList[0].vatApplied
  ///@param branchList[0].suppliers[0].productList[0].price
  ///@param branchList[0].suppliers[0].productList[0].description
  ///@param branchList[0].suppliers[0].productList[0].category
  ///@param branchList[0].suppliers[0].productList[0].supplierId
  ///@param branchList[0].suppliers[0].supplierId
  ///@param branchList[0].suppliers[0].name
  ///@param branchList[0].suppliers[0].vatNumber
  ///@param branchList[0].suppliers[0].address
  ///@param branchList[0].suppliers[0].city
  ///@param branchList[0].suppliers[0].cap
  ///@param branchList[0].suppliers[0].code
  ///@param branchList[0].suppliers[0].phoneNumber
  ///@param branchList[0].suppliers[0].email
  ///@param branchList[0].suppliers[0].pec
  ///@param branchList[0].suppliers[0].cf
  ///@param branchList[0].suppliers[0].country
  ///@param branchList[0].suppliers[0].createdByUserId
  ///@param branchList[0].suppliers[0].branchId
  ///@param branchList[0].events[0].expenceEvents[0].expenceId
  ///@param branchList[0].events[0].expenceEvents[0].description
  ///@param branchList[0].events[0].expenceEvents[0].amount
  ///@param branchList[0].events[0].expenceEvents[0].dateIntert
  ///@param branchList[0].events[0].expenceEvents[0].eventId
  ///@param branchList[0].events[0].workstations[0].products[0].workstationProductId
  ///@param branchList[0].events[0].workstations[0].products[0].productName
  ///@param branchList[0].events[0].workstations[0].products[0].unitMeasure
  ///@param branchList[0].events[0].workstations[0].products[0].stockFromStorage
  ///@param branchList[0].events[0].workstations[0].products[0].consumed
  ///@param branchList[0].events[0].workstations[0].products[0].amountHundred
  ///@param branchList[0].events[0].workstations[0].products[0].productId
  ///@param branchList[0].events[0].workstations[0].products[0].storageId
  ///@param branchList[0].events[0].workstations[0].workstationId
  ///@param branchList[0].events[0].workstations[0].name
  ///@param branchList[0].events[0].workstations[0].responsable
  ///@param branchList[0].events[0].workstations[0].extra
  ///@param branchList[0].events[0].workstations[0].workstationType
  ///@param branchList[0].events[0].workstations[0].eventId
  ///@param branchList[0].events[0].eventId
  ///@param branchList[0].events[0].name
  ///@param branchList[0].events[0].dateEvent
  ///@param branchList[0].events[0].dateCreation
  ///@param branchList[0].events[0].eventStatus
  ///@param branchList[0].events[0].location
  ///@param branchList[0].events[0].branchId
  ///@param branchList[0].events[0].storageId
  ///@param branchList[0].orders[0].products[0].orderProductId
  ///@param branchList[0].orders[0].products[0].productName
  ///@param branchList[0].orders[0].products[0].unitMeasure
  ///@param branchList[0].orders[0].products[0].productId
  ///@param branchList[0].orders[0].products[0].price
  ///@param branchList[0].orders[0].products[0].amount
  ///@param branchList[0].orders[0].orderId
  ///@param branchList[0].orders[0].code
  ///@param branchList[0].orders[0].total
  ///@param branchList[0].orders[0].orderStatus
  ///@param branchList[0].orders[0].errorStatus
  ///@param branchList[0].orders[0].creationDate
  ///@param branchList[0].orders[0].senderUser
  ///@param branchList[0].orders[0].details
  ///@param branchList[0].orders[0].deliveryDate
  ///@param branchList[0].orders[0].closedBy
  ///@param branchList[0].orders[0].supplierId
  ///@param branchList[0].orders[0].branchId
  ///@param branchList[0].orders[0].storageId
  ///@param branchList[0].branchId
  ///@param branchList[0].branchCode
  ///@param branchList[0].name
  ///@param branchList[0].email
  ///@param branchList[0].vatNumber
  ///@param branchList[0].address
  ///@param branchList[0].city
  ///@param branchList[0].cap
  ///@param branchList[0].phoneNumber
  ///@param branchList[0].userId
  ///@param branchList[0].token
  ///@param branchList[0].userPriviledge
  ///@param userId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  @Post(
    path: '/api/v1/app/users/save',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppUsersSavePost({
    @Query('branchList[0].storages[0].products[0].storageProductId')
        int? branchList0Storages0Products0StorageProductId,
    @Query('branchList[0].storages[0].products[0].productName')
        String? branchList0Storages0Products0ProductName,
    @Query('branchList[0].storages[0].products[0].unitMeasure')
        String? branchList0Storages0Products0UnitMeasure,
    @Query('branchList[0].storages[0].products[0].stock')
        num? branchList0Storages0Products0Stock,
    @Query('branchList[0].storages[0].products[0].amountHundred')
        num? branchList0Storages0Products0AmountHundred,
    @Query('branchList[0].storages[0].products[0].productId')
        int? branchList0Storages0Products0ProductId,
    @Query('branchList[0].storages[0].storageId')
        int? branchList0Storages0StorageId,
    @Query('branchList[0].storages[0].name') String? branchList0Storages0Name,
    @Query('branchList[0].storages[0].creationDate')
        String? branchList0Storages0CreationDate,
    @Query('branchList[0].storages[0].address')
        String? branchList0Storages0Address,
    @Query('branchList[0].storages[0].city') String? branchList0Storages0City,
    @Query('branchList[0].storages[0].cap') String? branchList0Storages0Cap,
    @Query('branchList[0].storages[0].branchId')
        int? branchList0Storages0BranchId,
    @Query('branchList[0].suppliers[0].productList[0].productId')
        int? branchList0Suppliers0ProductList0ProductId,
    @Query('branchList[0].suppliers[0].productList[0].name')
        String? branchList0Suppliers0ProductList0Name,
    @Query('branchList[0].suppliers[0].productList[0].code')
        String? branchList0Suppliers0ProductList0Code,
    @Query('branchList[0].suppliers[0].productList[0].unitMeasure')
        String? branchList0Suppliers0ProductList0UnitMeasure,
    @Query('branchList[0].suppliers[0].productList[0].unitMeasureOTH')
        String? branchList0Suppliers0ProductList0UnitMeasureOTH,
    @Query('branchList[0].suppliers[0].productList[0].vatApplied')
        int? branchList0Suppliers0ProductList0VatApplied,
    @Query('branchList[0].suppliers[0].productList[0].price')
        num? branchList0Suppliers0ProductList0Price,
    @Query('branchList[0].suppliers[0].productList[0].description')
        String? branchList0Suppliers0ProductList0Description,
    @Query('branchList[0].suppliers[0].productList[0].category')
        String? branchList0Suppliers0ProductList0Category,
    @Query('branchList[0].suppliers[0].productList[0].supplierId')
        int? branchList0Suppliers0ProductList0SupplierId,
    @Query('branchList[0].suppliers[0].supplierId')
        int? branchList0Suppliers0SupplierId,
    @Query('branchList[0].suppliers[0].name') String? branchList0Suppliers0Name,
    @Query('branchList[0].suppliers[0].vatNumber')
        String? branchList0Suppliers0VatNumber,
    @Query('branchList[0].suppliers[0].address')
        String? branchList0Suppliers0Address,
    @Query('branchList[0].suppliers[0].city') String? branchList0Suppliers0City,
    @Query('branchList[0].suppliers[0].cap') String? branchList0Suppliers0Cap,
    @Query('branchList[0].suppliers[0].code') String? branchList0Suppliers0Code,
    @Query('branchList[0].suppliers[0].phoneNumber')
        String? branchList0Suppliers0PhoneNumber,
    @Query('branchList[0].suppliers[0].email')
        String? branchList0Suppliers0Email,
    @Query('branchList[0].suppliers[0].pec') String? branchList0Suppliers0Pec,
    @Query('branchList[0].suppliers[0].cf') String? branchList0Suppliers0Cf,
    @Query('branchList[0].suppliers[0].country')
        String? branchList0Suppliers0Country,
    @Query('branchList[0].suppliers[0].createdByUserId')
        int? branchList0Suppliers0CreatedByUserId,
    @Query('branchList[0].suppliers[0].branchId')
        int? branchList0Suppliers0BranchId,
    @Query('branchList[0].events[0].expenceEvents[0].expenceId')
        int? branchList0Events0ExpenceEvents0ExpenceId,
    @Query('branchList[0].events[0].expenceEvents[0].description')
        String? branchList0Events0ExpenceEvents0Description,
    @Query('branchList[0].events[0].expenceEvents[0].amount')
        num? branchList0Events0ExpenceEvents0Amount,
    @Query('branchList[0].events[0].expenceEvents[0].dateIntert')
        String? branchList0Events0ExpenceEvents0DateIntert,
    @Query('branchList[0].events[0].expenceEvents[0].eventId')
        int? branchList0Events0ExpenceEvents0EventId,
    @Query('branchList[0].events[0].workstations[0].products[0].workstationProductId')
        int? branchList0Events0Workstations0Products0WorkstationProductId,
    @Query('branchList[0].events[0].workstations[0].products[0].productName')
        String? branchList0Events0Workstations0Products0ProductName,
    @Query('branchList[0].events[0].workstations[0].products[0].unitMeasure')
        String? branchList0Events0Workstations0Products0UnitMeasure,
    @Query('branchList[0].events[0].workstations[0].products[0].stockFromStorage')
        num? branchList0Events0Workstations0Products0StockFromStorage,
    @Query('branchList[0].events[0].workstations[0].products[0].consumed')
        num? branchList0Events0Workstations0Products0Consumed,
    @Query('branchList[0].events[0].workstations[0].products[0].amountHundred')
        num? branchList0Events0Workstations0Products0AmountHundred,
    @Query('branchList[0].events[0].workstations[0].products[0].productId')
        int? branchList0Events0Workstations0Products0ProductId,
    @Query('branchList[0].events[0].workstations[0].products[0].storageId')
        int? branchList0Events0Workstations0Products0StorageId,
    @Query('branchList[0].events[0].workstations[0].workstationId')
        int? branchList0Events0Workstations0WorkstationId,
    @Query('branchList[0].events[0].workstations[0].name')
        String? branchList0Events0Workstations0Name,
    @Query('branchList[0].events[0].workstations[0].responsable')
        String? branchList0Events0Workstations0Responsable,
    @Query('branchList[0].events[0].workstations[0].extra')
        String? branchList0Events0Workstations0Extra,
    @Query('branchList[0].events[0].workstations[0].workstationType')
        String? branchList0Events0Workstations0WorkstationType,
    @Query('branchList[0].events[0].workstations[0].eventId')
        int? branchList0Events0Workstations0EventId,
    @Query('branchList[0].events[0].eventId') int? branchList0Events0EventId,
    @Query('branchList[0].events[0].name') String? branchList0Events0Name,
    @Query('branchList[0].events[0].dateEvent')
        String? branchList0Events0DateEvent,
    @Query('branchList[0].events[0].dateCreation')
        String? branchList0Events0DateCreation,
    @Query('branchList[0].events[0].eventStatus')
        String? branchList0Events0EventStatus,
    @Query('branchList[0].events[0].location')
        String? branchList0Events0Location,
    @Query('branchList[0].events[0].branchId') int? branchList0Events0BranchId,
    @Query('branchList[0].events[0].storageId')
        int? branchList0Events0StorageId,
    @Query('branchList[0].orders[0].products[0].orderProductId')
        int? branchList0Orders0Products0OrderProductId,
    @Query('branchList[0].orders[0].products[0].productName')
        String? branchList0Orders0Products0ProductName,
    @Query('branchList[0].orders[0].products[0].unitMeasure')
        String? branchList0Orders0Products0UnitMeasure,
    @Query('branchList[0].orders[0].products[0].productId')
        int? branchList0Orders0Products0ProductId,
    @Query('branchList[0].orders[0].products[0].price')
        num? branchList0Orders0Products0Price,
    @Query('branchList[0].orders[0].products[0].amount')
        num? branchList0Orders0Products0Amount,
    @Query('branchList[0].orders[0].orderId') int? branchList0Orders0OrderId,
    @Query('branchList[0].orders[0].code') String? branchList0Orders0Code,
    @Query('branchList[0].orders[0].total') num? branchList0Orders0Total,
    @Query('branchList[0].orders[0].orderStatus')
        String? branchList0Orders0OrderStatus,
    @Query('branchList[0].orders[0].errorStatus')
        String? branchList0Orders0ErrorStatus,
    @Query('branchList[0].orders[0].creationDate')
        String? branchList0Orders0CreationDate,
    @Query('branchList[0].orders[0].senderUser')
        String? branchList0Orders0SenderUser,
    @Query('branchList[0].orders[0].details') String? branchList0Orders0Details,
    @Query('branchList[0].orders[0].deliveryDate')
        String? branchList0Orders0DeliveryDate,
    @Query('branchList[0].orders[0].closedBy')
        String? branchList0Orders0ClosedBy,
    @Query('branchList[0].orders[0].supplierId')
        int? branchList0Orders0SupplierId,
    @Query('branchList[0].orders[0].branchId') int? branchList0Orders0BranchId,
    @Query('branchList[0].orders[0].storageId')
        int? branchList0Orders0StorageId,
    @Query('branchList[0].branchId') int? branchList0BranchId,
    @Query('branchList[0].branchCode') String? branchList0BranchCode,
    @Query('branchList[0].name') String? branchList0Name,
    @Query('branchList[0].email') String? branchList0Email,
    @Query('branchList[0].vatNumber') String? branchList0VatNumber,
    @Query('branchList[0].address') String? branchList0Address,
    @Query('branchList[0].city') String? branchList0City,
    @Query('branchList[0].cap') String? branchList0Cap,
    @Query('branchList[0].phoneNumber') String? branchList0PhoneNumber,
    @Query('branchList[0].userId') int? branchList0UserId,
    @Query('branchList[0].token') String? branchList0Token,
    @Query('branchList[0].userPriviledge') String? branchList0UserPriviledge,
    @Query('userId') int? userId,
    @Query('name') String? name,
    @Query('lastname') String? lastname,
    @Query('email') String? email,
    @Query('phone') String? phone,
  });

  ///update
  ///@param branchList[0].storages[0].products[0].storageProductId
  ///@param branchList[0].storages[0].products[0].productName
  ///@param branchList[0].storages[0].products[0].unitMeasure
  ///@param branchList[0].storages[0].products[0].stock
  ///@param branchList[0].storages[0].products[0].amountHundred
  ///@param branchList[0].storages[0].products[0].productId
  ///@param branchList[0].storages[0].storageId
  ///@param branchList[0].storages[0].name
  ///@param branchList[0].storages[0].creationDate
  ///@param branchList[0].storages[0].address
  ///@param branchList[0].storages[0].city
  ///@param branchList[0].storages[0].cap
  ///@param branchList[0].storages[0].branchId
  ///@param branchList[0].suppliers[0].productList[0].productId
  ///@param branchList[0].suppliers[0].productList[0].name
  ///@param branchList[0].suppliers[0].productList[0].code
  ///@param branchList[0].suppliers[0].productList[0].unitMeasure
  ///@param branchList[0].suppliers[0].productList[0].unitMeasureOTH
  ///@param branchList[0].suppliers[0].productList[0].vatApplied
  ///@param branchList[0].suppliers[0].productList[0].price
  ///@param branchList[0].suppliers[0].productList[0].description
  ///@param branchList[0].suppliers[0].productList[0].category
  ///@param branchList[0].suppliers[0].productList[0].supplierId
  ///@param branchList[0].suppliers[0].supplierId
  ///@param branchList[0].suppliers[0].name
  ///@param branchList[0].suppliers[0].vatNumber
  ///@param branchList[0].suppliers[0].address
  ///@param branchList[0].suppliers[0].city
  ///@param branchList[0].suppliers[0].cap
  ///@param branchList[0].suppliers[0].code
  ///@param branchList[0].suppliers[0].phoneNumber
  ///@param branchList[0].suppliers[0].email
  ///@param branchList[0].suppliers[0].pec
  ///@param branchList[0].suppliers[0].cf
  ///@param branchList[0].suppliers[0].country
  ///@param branchList[0].suppliers[0].createdByUserId
  ///@param branchList[0].suppliers[0].branchId
  ///@param branchList[0].events[0].expenceEvents[0].expenceId
  ///@param branchList[0].events[0].expenceEvents[0].description
  ///@param branchList[0].events[0].expenceEvents[0].amount
  ///@param branchList[0].events[0].expenceEvents[0].dateIntert
  ///@param branchList[0].events[0].expenceEvents[0].eventId
  ///@param branchList[0].events[0].workstations[0].products[0].workstationProductId
  ///@param branchList[0].events[0].workstations[0].products[0].productName
  ///@param branchList[0].events[0].workstations[0].products[0].unitMeasure
  ///@param branchList[0].events[0].workstations[0].products[0].stockFromStorage
  ///@param branchList[0].events[0].workstations[0].products[0].consumed
  ///@param branchList[0].events[0].workstations[0].products[0].amountHundred
  ///@param branchList[0].events[0].workstations[0].products[0].productId
  ///@param branchList[0].events[0].workstations[0].products[0].storageId
  ///@param branchList[0].events[0].workstations[0].workstationId
  ///@param branchList[0].events[0].workstations[0].name
  ///@param branchList[0].events[0].workstations[0].responsable
  ///@param branchList[0].events[0].workstations[0].extra
  ///@param branchList[0].events[0].workstations[0].workstationType
  ///@param branchList[0].events[0].workstations[0].eventId
  ///@param branchList[0].events[0].eventId
  ///@param branchList[0].events[0].name
  ///@param branchList[0].events[0].dateEvent
  ///@param branchList[0].events[0].dateCreation
  ///@param branchList[0].events[0].eventStatus
  ///@param branchList[0].events[0].location
  ///@param branchList[0].events[0].branchId
  ///@param branchList[0].events[0].storageId
  ///@param branchList[0].orders[0].products[0].orderProductId
  ///@param branchList[0].orders[0].products[0].productName
  ///@param branchList[0].orders[0].products[0].unitMeasure
  ///@param branchList[0].orders[0].products[0].productId
  ///@param branchList[0].orders[0].products[0].price
  ///@param branchList[0].orders[0].products[0].amount
  ///@param branchList[0].orders[0].orderId
  ///@param branchList[0].orders[0].code
  ///@param branchList[0].orders[0].total
  ///@param branchList[0].orders[0].orderStatus
  ///@param branchList[0].orders[0].errorStatus
  ///@param branchList[0].orders[0].creationDate
  ///@param branchList[0].orders[0].senderUser
  ///@param branchList[0].orders[0].details
  ///@param branchList[0].orders[0].deliveryDate
  ///@param branchList[0].orders[0].closedBy
  ///@param branchList[0].orders[0].supplierId
  ///@param branchList[0].orders[0].branchId
  ///@param branchList[0].orders[0].storageId
  ///@param branchList[0].branchId
  ///@param branchList[0].branchCode
  ///@param branchList[0].name
  ///@param branchList[0].email
  ///@param branchList[0].vatNumber
  ///@param branchList[0].address
  ///@param branchList[0].city
  ///@param branchList[0].cap
  ///@param branchList[0].phoneNumber
  ///@param branchList[0].userId
  ///@param branchList[0].token
  ///@param branchList[0].userPriviledge
  ///@param userId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  Future<chopper.Response> apiV1AppUsersUpdatePut({
    int? branchList0Storages0Products0StorageProductId,
    String? branchList0Storages0Products0ProductName,
    String? branchList0Storages0Products0UnitMeasure,
    num? branchList0Storages0Products0Stock,
    num? branchList0Storages0Products0AmountHundred,
    int? branchList0Storages0Products0ProductId,
    int? branchList0Storages0StorageId,
    String? branchList0Storages0Name,
    String? branchList0Storages0CreationDate,
    String? branchList0Storages0Address,
    String? branchList0Storages0City,
    String? branchList0Storages0Cap,
    int? branchList0Storages0BranchId,
    int? branchList0Suppliers0ProductList0ProductId,
    String? branchList0Suppliers0ProductList0Name,
    String? branchList0Suppliers0ProductList0Code,
    String? branchList0Suppliers0ProductList0UnitMeasure,
    String? branchList0Suppliers0ProductList0UnitMeasureOTH,
    int? branchList0Suppliers0ProductList0VatApplied,
    num? branchList0Suppliers0ProductList0Price,
    String? branchList0Suppliers0ProductList0Description,
    String? branchList0Suppliers0ProductList0Category,
    int? branchList0Suppliers0ProductList0SupplierId,
    int? branchList0Suppliers0SupplierId,
    String? branchList0Suppliers0Name,
    String? branchList0Suppliers0VatNumber,
    String? branchList0Suppliers0Address,
    String? branchList0Suppliers0City,
    String? branchList0Suppliers0Cap,
    String? branchList0Suppliers0Code,
    String? branchList0Suppliers0PhoneNumber,
    String? branchList0Suppliers0Email,
    String? branchList0Suppliers0Pec,
    String? branchList0Suppliers0Cf,
    String? branchList0Suppliers0Country,
    int? branchList0Suppliers0CreatedByUserId,
    int? branchList0Suppliers0BranchId,
    int? branchList0Events0ExpenceEvents0ExpenceId,
    String? branchList0Events0ExpenceEvents0Description,
    num? branchList0Events0ExpenceEvents0Amount,
    String? branchList0Events0ExpenceEvents0DateIntert,
    int? branchList0Events0ExpenceEvents0EventId,
    int? branchList0Events0Workstations0Products0WorkstationProductId,
    String? branchList0Events0Workstations0Products0ProductName,
    String? branchList0Events0Workstations0Products0UnitMeasure,
    num? branchList0Events0Workstations0Products0StockFromStorage,
    num? branchList0Events0Workstations0Products0Consumed,
    num? branchList0Events0Workstations0Products0AmountHundred,
    int? branchList0Events0Workstations0Products0ProductId,
    int? branchList0Events0Workstations0Products0StorageId,
    int? branchList0Events0Workstations0WorkstationId,
    String? branchList0Events0Workstations0Name,
    String? branchList0Events0Workstations0Responsable,
    String? branchList0Events0Workstations0Extra,
    String? branchList0Events0Workstations0WorkstationType,
    int? branchList0Events0Workstations0EventId,
    int? branchList0Events0EventId,
    String? branchList0Events0Name,
    String? branchList0Events0DateEvent,
    String? branchList0Events0DateCreation,
    String? branchList0Events0EventStatus,
    String? branchList0Events0Location,
    int? branchList0Events0BranchId,
    int? branchList0Events0StorageId,
    int? branchList0Orders0Products0OrderProductId,
    String? branchList0Orders0Products0ProductName,
    String? branchList0Orders0Products0UnitMeasure,
    int? branchList0Orders0Products0ProductId,
    num? branchList0Orders0Products0Price,
    num? branchList0Orders0Products0Amount,
    int? branchList0Orders0OrderId,
    String? branchList0Orders0Code,
    num? branchList0Orders0Total,
    String? branchList0Orders0OrderStatus,
    String? branchList0Orders0ErrorStatus,
    String? branchList0Orders0CreationDate,
    String? branchList0Orders0SenderUser,
    String? branchList0Orders0Details,
    String? branchList0Orders0DeliveryDate,
    String? branchList0Orders0ClosedBy,
    int? branchList0Orders0SupplierId,
    int? branchList0Orders0BranchId,
    int? branchList0Orders0StorageId,
    int? branchList0BranchId,
    String? branchList0BranchCode,
    String? branchList0Name,
    String? branchList0Email,
    String? branchList0VatNumber,
    String? branchList0Address,
    String? branchList0City,
    String? branchList0Cap,
    String? branchList0PhoneNumber,
    int? branchList0UserId,
    String? branchList0Token,
    String? branchList0UserPriviledge,
    int? userId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
  }) {
    return _apiV1AppUsersUpdatePut(
        branchList0Storages0Products0StorageProductId:
            branchList0Storages0Products0StorageProductId,
        branchList0Storages0Products0ProductName:
            branchList0Storages0Products0ProductName,
        branchList0Storages0Products0UnitMeasure:
            branchList0Storages0Products0UnitMeasure,
        branchList0Storages0Products0Stock: branchList0Storages0Products0Stock,
        branchList0Storages0Products0AmountHundred:
            branchList0Storages0Products0AmountHundred,
        branchList0Storages0Products0ProductId:
            branchList0Storages0Products0ProductId,
        branchList0Storages0StorageId: branchList0Storages0StorageId,
        branchList0Storages0Name: branchList0Storages0Name,
        branchList0Storages0CreationDate: branchList0Storages0CreationDate,
        branchList0Storages0Address: branchList0Storages0Address,
        branchList0Storages0City: branchList0Storages0City,
        branchList0Storages0Cap: branchList0Storages0Cap,
        branchList0Storages0BranchId: branchList0Storages0BranchId,
        branchList0Suppliers0ProductList0ProductId:
            branchList0Suppliers0ProductList0ProductId,
        branchList0Suppliers0ProductList0Name:
            branchList0Suppliers0ProductList0Name,
        branchList0Suppliers0ProductList0Code:
            branchList0Suppliers0ProductList0Code,
        branchList0Suppliers0ProductList0UnitMeasure:
            branchList0Suppliers0ProductList0UnitMeasure,
        branchList0Suppliers0ProductList0UnitMeasureOTH:
            branchList0Suppliers0ProductList0UnitMeasureOTH,
        branchList0Suppliers0ProductList0VatApplied:
            branchList0Suppliers0ProductList0VatApplied,
        branchList0Suppliers0ProductList0Price:
            branchList0Suppliers0ProductList0Price,
        branchList0Suppliers0ProductList0Description:
            branchList0Suppliers0ProductList0Description,
        branchList0Suppliers0ProductList0Category:
            branchList0Suppliers0ProductList0Category,
        branchList0Suppliers0ProductList0SupplierId:
            branchList0Suppliers0ProductList0SupplierId,
        branchList0Suppliers0SupplierId: branchList0Suppliers0SupplierId,
        branchList0Suppliers0Name: branchList0Suppliers0Name,
        branchList0Suppliers0VatNumber: branchList0Suppliers0VatNumber,
        branchList0Suppliers0Address: branchList0Suppliers0Address,
        branchList0Suppliers0City: branchList0Suppliers0City,
        branchList0Suppliers0Cap: branchList0Suppliers0Cap,
        branchList0Suppliers0Code: branchList0Suppliers0Code,
        branchList0Suppliers0PhoneNumber: branchList0Suppliers0PhoneNumber,
        branchList0Suppliers0Email: branchList0Suppliers0Email,
        branchList0Suppliers0Pec: branchList0Suppliers0Pec,
        branchList0Suppliers0Cf: branchList0Suppliers0Cf,
        branchList0Suppliers0Country: branchList0Suppliers0Country,
        branchList0Suppliers0CreatedByUserId:
            branchList0Suppliers0CreatedByUserId,
        branchList0Suppliers0BranchId: branchList0Suppliers0BranchId,
        branchList0Events0ExpenceEvents0ExpenceId:
            branchList0Events0ExpenceEvents0ExpenceId,
        branchList0Events0ExpenceEvents0Description:
            branchList0Events0ExpenceEvents0Description,
        branchList0Events0ExpenceEvents0Amount:
            branchList0Events0ExpenceEvents0Amount,
        branchList0Events0ExpenceEvents0DateIntert:
            branchList0Events0ExpenceEvents0DateIntert,
        branchList0Events0ExpenceEvents0EventId:
            branchList0Events0ExpenceEvents0EventId,
        branchList0Events0Workstations0Products0WorkstationProductId:
            branchList0Events0Workstations0Products0WorkstationProductId,
        branchList0Events0Workstations0Products0ProductName:
            branchList0Events0Workstations0Products0ProductName,
        branchList0Events0Workstations0Products0UnitMeasure:
            branchList0Events0Workstations0Products0UnitMeasure,
        branchList0Events0Workstations0Products0StockFromStorage:
            branchList0Events0Workstations0Products0StockFromStorage,
        branchList0Events0Workstations0Products0Consumed:
            branchList0Events0Workstations0Products0Consumed,
        branchList0Events0Workstations0Products0AmountHundred:
            branchList0Events0Workstations0Products0AmountHundred,
        branchList0Events0Workstations0Products0ProductId:
            branchList0Events0Workstations0Products0ProductId,
        branchList0Events0Workstations0Products0StorageId:
            branchList0Events0Workstations0Products0StorageId,
        branchList0Events0Workstations0WorkstationId:
            branchList0Events0Workstations0WorkstationId,
        branchList0Events0Workstations0Name:
            branchList0Events0Workstations0Name,
        branchList0Events0Workstations0Responsable:
            branchList0Events0Workstations0Responsable,
        branchList0Events0Workstations0Extra:
            branchList0Events0Workstations0Extra,
        branchList0Events0Workstations0WorkstationType:
            branchList0Events0Workstations0WorkstationType,
        branchList0Events0Workstations0EventId:
            branchList0Events0Workstations0EventId,
        branchList0Events0EventId: branchList0Events0EventId,
        branchList0Events0Name: branchList0Events0Name,
        branchList0Events0DateEvent: branchList0Events0DateEvent,
        branchList0Events0DateCreation: branchList0Events0DateCreation,
        branchList0Events0EventStatus: branchList0Events0EventStatus,
        branchList0Events0Location: branchList0Events0Location,
        branchList0Events0BranchId: branchList0Events0BranchId,
        branchList0Events0StorageId: branchList0Events0StorageId,
        branchList0Orders0Products0OrderProductId:
            branchList0Orders0Products0OrderProductId,
        branchList0Orders0Products0ProductName:
            branchList0Orders0Products0ProductName,
        branchList0Orders0Products0UnitMeasure:
            branchList0Orders0Products0UnitMeasure,
        branchList0Orders0Products0ProductId:
            branchList0Orders0Products0ProductId,
        branchList0Orders0Products0Price: branchList0Orders0Products0Price,
        branchList0Orders0Products0Amount: branchList0Orders0Products0Amount,
        branchList0Orders0OrderId: branchList0Orders0OrderId,
        branchList0Orders0Code: branchList0Orders0Code,
        branchList0Orders0Total: branchList0Orders0Total,
        branchList0Orders0OrderStatus: branchList0Orders0OrderStatus,
        branchList0Orders0ErrorStatus: branchList0Orders0ErrorStatus,
        branchList0Orders0CreationDate: branchList0Orders0CreationDate,
        branchList0Orders0SenderUser: branchList0Orders0SenderUser,
        branchList0Orders0Details: branchList0Orders0Details,
        branchList0Orders0DeliveryDate: branchList0Orders0DeliveryDate,
        branchList0Orders0ClosedBy: branchList0Orders0ClosedBy,
        branchList0Orders0SupplierId: branchList0Orders0SupplierId,
        branchList0Orders0BranchId: branchList0Orders0BranchId,
        branchList0Orders0StorageId: branchList0Orders0StorageId,
        branchList0BranchId: branchList0BranchId,
        branchList0BranchCode: branchList0BranchCode,
        branchList0Name: branchList0Name,
        branchList0Email: branchList0Email,
        branchList0VatNumber: branchList0VatNumber,
        branchList0Address: branchList0Address,
        branchList0City: branchList0City,
        branchList0Cap: branchList0Cap,
        branchList0PhoneNumber: branchList0PhoneNumber,
        branchList0UserId: branchList0UserId,
        branchList0Token: branchList0Token,
        branchList0UserPriviledge: branchList0UserPriviledge,
        userId: userId,
        name: name,
        lastname: lastname,
        email: email,
        phone: phone);
  }

  ///update
  ///@param branchList[0].storages[0].products[0].storageProductId
  ///@param branchList[0].storages[0].products[0].productName
  ///@param branchList[0].storages[0].products[0].unitMeasure
  ///@param branchList[0].storages[0].products[0].stock
  ///@param branchList[0].storages[0].products[0].amountHundred
  ///@param branchList[0].storages[0].products[0].productId
  ///@param branchList[0].storages[0].storageId
  ///@param branchList[0].storages[0].name
  ///@param branchList[0].storages[0].creationDate
  ///@param branchList[0].storages[0].address
  ///@param branchList[0].storages[0].city
  ///@param branchList[0].storages[0].cap
  ///@param branchList[0].storages[0].branchId
  ///@param branchList[0].suppliers[0].productList[0].productId
  ///@param branchList[0].suppliers[0].productList[0].name
  ///@param branchList[0].suppliers[0].productList[0].code
  ///@param branchList[0].suppliers[0].productList[0].unitMeasure
  ///@param branchList[0].suppliers[0].productList[0].unitMeasureOTH
  ///@param branchList[0].suppliers[0].productList[0].vatApplied
  ///@param branchList[0].suppliers[0].productList[0].price
  ///@param branchList[0].suppliers[0].productList[0].description
  ///@param branchList[0].suppliers[0].productList[0].category
  ///@param branchList[0].suppliers[0].productList[0].supplierId
  ///@param branchList[0].suppliers[0].supplierId
  ///@param branchList[0].suppliers[0].name
  ///@param branchList[0].suppliers[0].vatNumber
  ///@param branchList[0].suppliers[0].address
  ///@param branchList[0].suppliers[0].city
  ///@param branchList[0].suppliers[0].cap
  ///@param branchList[0].suppliers[0].code
  ///@param branchList[0].suppliers[0].phoneNumber
  ///@param branchList[0].suppliers[0].email
  ///@param branchList[0].suppliers[0].pec
  ///@param branchList[0].suppliers[0].cf
  ///@param branchList[0].suppliers[0].country
  ///@param branchList[0].suppliers[0].createdByUserId
  ///@param branchList[0].suppliers[0].branchId
  ///@param branchList[0].events[0].expenceEvents[0].expenceId
  ///@param branchList[0].events[0].expenceEvents[0].description
  ///@param branchList[0].events[0].expenceEvents[0].amount
  ///@param branchList[0].events[0].expenceEvents[0].dateIntert
  ///@param branchList[0].events[0].expenceEvents[0].eventId
  ///@param branchList[0].events[0].workstations[0].products[0].workstationProductId
  ///@param branchList[0].events[0].workstations[0].products[0].productName
  ///@param branchList[0].events[0].workstations[0].products[0].unitMeasure
  ///@param branchList[0].events[0].workstations[0].products[0].stockFromStorage
  ///@param branchList[0].events[0].workstations[0].products[0].consumed
  ///@param branchList[0].events[0].workstations[0].products[0].amountHundred
  ///@param branchList[0].events[0].workstations[0].products[0].productId
  ///@param branchList[0].events[0].workstations[0].products[0].storageId
  ///@param branchList[0].events[0].workstations[0].workstationId
  ///@param branchList[0].events[0].workstations[0].name
  ///@param branchList[0].events[0].workstations[0].responsable
  ///@param branchList[0].events[0].workstations[0].extra
  ///@param branchList[0].events[0].workstations[0].workstationType
  ///@param branchList[0].events[0].workstations[0].eventId
  ///@param branchList[0].events[0].eventId
  ///@param branchList[0].events[0].name
  ///@param branchList[0].events[0].dateEvent
  ///@param branchList[0].events[0].dateCreation
  ///@param branchList[0].events[0].eventStatus
  ///@param branchList[0].events[0].location
  ///@param branchList[0].events[0].branchId
  ///@param branchList[0].events[0].storageId
  ///@param branchList[0].orders[0].products[0].orderProductId
  ///@param branchList[0].orders[0].products[0].productName
  ///@param branchList[0].orders[0].products[0].unitMeasure
  ///@param branchList[0].orders[0].products[0].productId
  ///@param branchList[0].orders[0].products[0].price
  ///@param branchList[0].orders[0].products[0].amount
  ///@param branchList[0].orders[0].orderId
  ///@param branchList[0].orders[0].code
  ///@param branchList[0].orders[0].total
  ///@param branchList[0].orders[0].orderStatus
  ///@param branchList[0].orders[0].errorStatus
  ///@param branchList[0].orders[0].creationDate
  ///@param branchList[0].orders[0].senderUser
  ///@param branchList[0].orders[0].details
  ///@param branchList[0].orders[0].deliveryDate
  ///@param branchList[0].orders[0].closedBy
  ///@param branchList[0].orders[0].supplierId
  ///@param branchList[0].orders[0].branchId
  ///@param branchList[0].orders[0].storageId
  ///@param branchList[0].branchId
  ///@param branchList[0].branchCode
  ///@param branchList[0].name
  ///@param branchList[0].email
  ///@param branchList[0].vatNumber
  ///@param branchList[0].address
  ///@param branchList[0].city
  ///@param branchList[0].cap
  ///@param branchList[0].phoneNumber
  ///@param branchList[0].userId
  ///@param branchList[0].token
  ///@param branchList[0].userPriviledge
  ///@param userId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  @Put(
    path: '/api/v1/app/users/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppUsersUpdatePut({
    @Query('branchList[0].storages[0].products[0].storageProductId')
        int? branchList0Storages0Products0StorageProductId,
    @Query('branchList[0].storages[0].products[0].productName')
        String? branchList0Storages0Products0ProductName,
    @Query('branchList[0].storages[0].products[0].unitMeasure')
        String? branchList0Storages0Products0UnitMeasure,
    @Query('branchList[0].storages[0].products[0].stock')
        num? branchList0Storages0Products0Stock,
    @Query('branchList[0].storages[0].products[0].amountHundred')
        num? branchList0Storages0Products0AmountHundred,
    @Query('branchList[0].storages[0].products[0].productId')
        int? branchList0Storages0Products0ProductId,
    @Query('branchList[0].storages[0].storageId')
        int? branchList0Storages0StorageId,
    @Query('branchList[0].storages[0].name') String? branchList0Storages0Name,
    @Query('branchList[0].storages[0].creationDate')
        String? branchList0Storages0CreationDate,
    @Query('branchList[0].storages[0].address')
        String? branchList0Storages0Address,
    @Query('branchList[0].storages[0].city') String? branchList0Storages0City,
    @Query('branchList[0].storages[0].cap') String? branchList0Storages0Cap,
    @Query('branchList[0].storages[0].branchId')
        int? branchList0Storages0BranchId,
    @Query('branchList[0].suppliers[0].productList[0].productId')
        int? branchList0Suppliers0ProductList0ProductId,
    @Query('branchList[0].suppliers[0].productList[0].name')
        String? branchList0Suppliers0ProductList0Name,
    @Query('branchList[0].suppliers[0].productList[0].code')
        String? branchList0Suppliers0ProductList0Code,
    @Query('branchList[0].suppliers[0].productList[0].unitMeasure')
        String? branchList0Suppliers0ProductList0UnitMeasure,
    @Query('branchList[0].suppliers[0].productList[0].unitMeasureOTH')
        String? branchList0Suppliers0ProductList0UnitMeasureOTH,
    @Query('branchList[0].suppliers[0].productList[0].vatApplied')
        int? branchList0Suppliers0ProductList0VatApplied,
    @Query('branchList[0].suppliers[0].productList[0].price')
        num? branchList0Suppliers0ProductList0Price,
    @Query('branchList[0].suppliers[0].productList[0].description')
        String? branchList0Suppliers0ProductList0Description,
    @Query('branchList[0].suppliers[0].productList[0].category')
        String? branchList0Suppliers0ProductList0Category,
    @Query('branchList[0].suppliers[0].productList[0].supplierId')
        int? branchList0Suppliers0ProductList0SupplierId,
    @Query('branchList[0].suppliers[0].supplierId')
        int? branchList0Suppliers0SupplierId,
    @Query('branchList[0].suppliers[0].name') String? branchList0Suppliers0Name,
    @Query('branchList[0].suppliers[0].vatNumber')
        String? branchList0Suppliers0VatNumber,
    @Query('branchList[0].suppliers[0].address')
        String? branchList0Suppliers0Address,
    @Query('branchList[0].suppliers[0].city') String? branchList0Suppliers0City,
    @Query('branchList[0].suppliers[0].cap') String? branchList0Suppliers0Cap,
    @Query('branchList[0].suppliers[0].code') String? branchList0Suppliers0Code,
    @Query('branchList[0].suppliers[0].phoneNumber')
        String? branchList0Suppliers0PhoneNumber,
    @Query('branchList[0].suppliers[0].email')
        String? branchList0Suppliers0Email,
    @Query('branchList[0].suppliers[0].pec') String? branchList0Suppliers0Pec,
    @Query('branchList[0].suppliers[0].cf') String? branchList0Suppliers0Cf,
    @Query('branchList[0].suppliers[0].country')
        String? branchList0Suppliers0Country,
    @Query('branchList[0].suppliers[0].createdByUserId')
        int? branchList0Suppliers0CreatedByUserId,
    @Query('branchList[0].suppliers[0].branchId')
        int? branchList0Suppliers0BranchId,
    @Query('branchList[0].events[0].expenceEvents[0].expenceId')
        int? branchList0Events0ExpenceEvents0ExpenceId,
    @Query('branchList[0].events[0].expenceEvents[0].description')
        String? branchList0Events0ExpenceEvents0Description,
    @Query('branchList[0].events[0].expenceEvents[0].amount')
        num? branchList0Events0ExpenceEvents0Amount,
    @Query('branchList[0].events[0].expenceEvents[0].dateIntert')
        String? branchList0Events0ExpenceEvents0DateIntert,
    @Query('branchList[0].events[0].expenceEvents[0].eventId')
        int? branchList0Events0ExpenceEvents0EventId,
    @Query('branchList[0].events[0].workstations[0].products[0].workstationProductId')
        int? branchList0Events0Workstations0Products0WorkstationProductId,
    @Query('branchList[0].events[0].workstations[0].products[0].productName')
        String? branchList0Events0Workstations0Products0ProductName,
    @Query('branchList[0].events[0].workstations[0].products[0].unitMeasure')
        String? branchList0Events0Workstations0Products0UnitMeasure,
    @Query('branchList[0].events[0].workstations[0].products[0].stockFromStorage')
        num? branchList0Events0Workstations0Products0StockFromStorage,
    @Query('branchList[0].events[0].workstations[0].products[0].consumed')
        num? branchList0Events0Workstations0Products0Consumed,
    @Query('branchList[0].events[0].workstations[0].products[0].amountHundred')
        num? branchList0Events0Workstations0Products0AmountHundred,
    @Query('branchList[0].events[0].workstations[0].products[0].productId')
        int? branchList0Events0Workstations0Products0ProductId,
    @Query('branchList[0].events[0].workstations[0].products[0].storageId')
        int? branchList0Events0Workstations0Products0StorageId,
    @Query('branchList[0].events[0].workstations[0].workstationId')
        int? branchList0Events0Workstations0WorkstationId,
    @Query('branchList[0].events[0].workstations[0].name')
        String? branchList0Events0Workstations0Name,
    @Query('branchList[0].events[0].workstations[0].responsable')
        String? branchList0Events0Workstations0Responsable,
    @Query('branchList[0].events[0].workstations[0].extra')
        String? branchList0Events0Workstations0Extra,
    @Query('branchList[0].events[0].workstations[0].workstationType')
        String? branchList0Events0Workstations0WorkstationType,
    @Query('branchList[0].events[0].workstations[0].eventId')
        int? branchList0Events0Workstations0EventId,
    @Query('branchList[0].events[0].eventId') int? branchList0Events0EventId,
    @Query('branchList[0].events[0].name') String? branchList0Events0Name,
    @Query('branchList[0].events[0].dateEvent')
        String? branchList0Events0DateEvent,
    @Query('branchList[0].events[0].dateCreation')
        String? branchList0Events0DateCreation,
    @Query('branchList[0].events[0].eventStatus')
        String? branchList0Events0EventStatus,
    @Query('branchList[0].events[0].location')
        String? branchList0Events0Location,
    @Query('branchList[0].events[0].branchId') int? branchList0Events0BranchId,
    @Query('branchList[0].events[0].storageId')
        int? branchList0Events0StorageId,
    @Query('branchList[0].orders[0].products[0].orderProductId')
        int? branchList0Orders0Products0OrderProductId,
    @Query('branchList[0].orders[0].products[0].productName')
        String? branchList0Orders0Products0ProductName,
    @Query('branchList[0].orders[0].products[0].unitMeasure')
        String? branchList0Orders0Products0UnitMeasure,
    @Query('branchList[0].orders[0].products[0].productId')
        int? branchList0Orders0Products0ProductId,
    @Query('branchList[0].orders[0].products[0].price')
        num? branchList0Orders0Products0Price,
    @Query('branchList[0].orders[0].products[0].amount')
        num? branchList0Orders0Products0Amount,
    @Query('branchList[0].orders[0].orderId') int? branchList0Orders0OrderId,
    @Query('branchList[0].orders[0].code') String? branchList0Orders0Code,
    @Query('branchList[0].orders[0].total') num? branchList0Orders0Total,
    @Query('branchList[0].orders[0].orderStatus')
        String? branchList0Orders0OrderStatus,
    @Query('branchList[0].orders[0].errorStatus')
        String? branchList0Orders0ErrorStatus,
    @Query('branchList[0].orders[0].creationDate')
        String? branchList0Orders0CreationDate,
    @Query('branchList[0].orders[0].senderUser')
        String? branchList0Orders0SenderUser,
    @Query('branchList[0].orders[0].details') String? branchList0Orders0Details,
    @Query('branchList[0].orders[0].deliveryDate')
        String? branchList0Orders0DeliveryDate,
    @Query('branchList[0].orders[0].closedBy')
        String? branchList0Orders0ClosedBy,
    @Query('branchList[0].orders[0].supplierId')
        int? branchList0Orders0SupplierId,
    @Query('branchList[0].orders[0].branchId') int? branchList0Orders0BranchId,
    @Query('branchList[0].orders[0].storageId')
        int? branchList0Orders0StorageId,
    @Query('branchList[0].branchId') int? branchList0BranchId,
    @Query('branchList[0].branchCode') String? branchList0BranchCode,
    @Query('branchList[0].name') String? branchList0Name,
    @Query('branchList[0].email') String? branchList0Email,
    @Query('branchList[0].vatNumber') String? branchList0VatNumber,
    @Query('branchList[0].address') String? branchList0Address,
    @Query('branchList[0].city') String? branchList0City,
    @Query('branchList[0].cap') String? branchList0Cap,
    @Query('branchList[0].phoneNumber') String? branchList0PhoneNumber,
    @Query('branchList[0].userId') int? branchList0UserId,
    @Query('branchList[0].token') String? branchList0Token,
    @Query('branchList[0].userPriviledge') String? branchList0UserPriviledge,
    @Query('userId') int? userId,
    @Query('name') String? name,
    @Query('lastname') String? lastname,
    @Query('email') String? email,
    @Query('phone') String? phone,
  });

  ///insertProductIntoStorage
  ///@param workstationId workstationId
  ///@param productId productId
  ///@param storageId storageId
  Future<chopper.Response> apiV1AppWorkstationInsertproductGet({
    required int? workstationId,
    required int? productId,
    required int? storageId,
  }) {
    return _apiV1AppWorkstationInsertproductGet(
        workstationId: workstationId,
        productId: productId,
        storageId: storageId);
  }

  ///insertProductIntoStorage
  ///@param workstationId workstationId
  ///@param productId productId
  ///@param storageId storageId
  @Get(path: '/api/v1/app/workstation/insertproduct')
  Future<chopper.Response> _apiV1AppWorkstationInsertproductGet({
    @Query('workstationId') required int? workstationId,
    @Query('productId') required int? productId,
    @Query('storageId') required int? storageId,
  });

  ///removeProductIntoStorage
  ///@param workstationProductId workstationProductId
  Future<chopper.Response> apiV1AppWorkstationRemoveproductDelete(
      {required int? workstationProductId}) {
    return _apiV1AppWorkstationRemoveproductDelete(
        workstationProductId: workstationProductId);
  }

  ///removeProductIntoStorage
  ///@param workstationProductId workstationProductId
  @Delete(path: '/api/v1/app/workstation/removeproduct')
  Future<chopper.Response> _apiV1AppWorkstationRemoveproductDelete(
      {@Query('workstationProductId') required int? workstationProductId});

  ///deleteById
  ///@param customerId customerId
  Future<chopper.Response> apiV1WebsiteCustomeraccessDeleteDelete(
      {int? customerId}) {
    return _apiV1WebsiteCustomeraccessDeleteDelete(customerId: customerId);
  }

  ///deleteById
  ///@param customerId customerId
  @Delete(path: '/api/v1/website/customeraccess/delete')
  Future<chopper.Response> _apiV1WebsiteCustomeraccessDeleteDelete(
      {@Query('customerId') int? customerId});

  ///retrieveAll
  Future<chopper.Response<List<CustomerAccess>>>
      apiV1WebsiteCustomeraccessFindallGet() {
    generatedMapping.putIfAbsent(
        CustomerAccess, () => CustomerAccess.fromJsonFactory);

    return _apiV1WebsiteCustomeraccessFindallGet();
  }

  ///retrieveAll
  @Get(path: '/api/v1/website/customeraccess/findall')
  Future<chopper.Response<List<CustomerAccess>>>
      _apiV1WebsiteCustomeraccessFindallGet();

  ///retrieveByCustomerId
  ///@param customerId customerId
  Future<chopper.Response<List<CustomerAccess>>>
      apiV1WebsiteCustomeraccessFindbycustomeridGet(
          {required int? customerId}) {
    generatedMapping.putIfAbsent(
        CustomerAccess, () => CustomerAccess.fromJsonFactory);

    return _apiV1WebsiteCustomeraccessFindbycustomeridGet(
        customerId: customerId);
  }

  ///retrieveByCustomerId
  ///@param customerId customerId
  @Get(path: '/api/v1/website/customeraccess/findbycustomerid')
  Future<chopper.Response<List<CustomerAccess>>>
      _apiV1WebsiteCustomeraccessFindbycustomeridGet(
          {@Query('customerId') required int? customerId});

  ///save
  ///@param customerAccessId
  ///@param accessDate
  ///@param branchLocation
  ///@param customerId
  Future<chopper.Response> apiV1WebsiteCustomeraccessSavePost({
    int? customerAccessId,
    String? accessDate,
    String? branchLocation,
    int? customerId,
  }) {
    return _apiV1WebsiteCustomeraccessSavePost(
        customerAccessId: customerAccessId,
        accessDate: accessDate,
        branchLocation: branchLocation,
        customerId: customerId);
  }

  ///save
  ///@param customerAccessId
  ///@param accessDate
  ///@param branchLocation
  ///@param customerId
  @Post(
    path: '/api/v1/website/customeraccess/save',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1WebsiteCustomeraccessSavePost({
    @Query('customerAccessId') int? customerAccessId,
    @Query('accessDate') String? accessDate,
    @Query('branchLocation') String? branchLocation,
    @Query('customerId') int? customerId,
  });

  ///deleteById
  ///@param customerId customerId
  Future<chopper.Response> apiV1WebsiteCustomersDeleteDelete(
      {int? customerId}) {
    return _apiV1WebsiteCustomersDeleteDelete(customerId: customerId);
  }

  ///deleteById
  ///@param customerId customerId
  @Delete(path: '/api/v1/website/customers/delete')
  Future<chopper.Response> _apiV1WebsiteCustomersDeleteDelete(
      {@Query('customerId') int? customerId});

  ///retrieveAll
  Future<chopper.Response<List<Customer>>> apiV1WebsiteCustomersFindallGet() {
    generatedMapping.putIfAbsent(Customer, () => Customer.fromJsonFactory);

    return _apiV1WebsiteCustomersFindallGet();
  }

  ///retrieveAll
  @Get(path: '/api/v1/website/customers/findall')
  Future<chopper.Response<List<Customer>>> _apiV1WebsiteCustomersFindallGet();

  ///retrieveAllByDate
  ///@param date date
  Future<chopper.Response<List<Customer>>>
      apiV1WebsiteCustomersFindallbydateGet({required String? date}) {
    generatedMapping.putIfAbsent(Customer, () => Customer.fromJsonFactory);

    return _apiV1WebsiteCustomersFindallbydateGet(date: date);
  }

  ///retrieveAllByDate
  ///@param date date
  @Get(path: '/api/v1/website/customers/findallbydate')
  Future<chopper.Response<List<Customer>>>
      _apiV1WebsiteCustomersFindallbydateGet(
          {@Query('date') required String? date});

  ///retrieveByPhone
  ///@param phone phone
  Future<chopper.Response<Customer>> apiV1WebsiteCustomersFindbyphoneGet(
      {required String? phone}) {
    generatedMapping.putIfAbsent(Customer, () => Customer.fromJsonFactory);

    return _apiV1WebsiteCustomersFindbyphoneGet(phone: phone);
  }

  ///retrieveByPhone
  ///@param phone phone
  @Get(path: '/api/v1/website/customers/findbyphone')
  Future<chopper.Response<Customer>> _apiV1WebsiteCustomersFindbyphoneGet(
      {@Query('phone') required String? phone});

  ///save
  ///@param accessesList[0].customerAccessId
  ///@param accessesList[0].accessDate
  ///@param accessesList[0].branchLocation
  ///@param accessesList[0].customerId
  ///@param customerId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  ///@param dob
  ///@param treatmentPersonalData
  Future<chopper.Response<int>> apiV1WebsiteCustomersSavePost({
    int? accessesList0CustomerAccessId,
    String? accessesList0AccessDate,
    String? accessesList0BranchLocation,
    int? accessesList0CustomerId,
    int? customerId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
    String? dob,
    bool? treatmentPersonalData,
  }) {
    return _apiV1WebsiteCustomersSavePost(
        accessesList0CustomerAccessId: accessesList0CustomerAccessId,
        accessesList0AccessDate: accessesList0AccessDate,
        accessesList0BranchLocation: accessesList0BranchLocation,
        accessesList0CustomerId: accessesList0CustomerId,
        customerId: customerId,
        name: name,
        lastname: lastname,
        email: email,
        phone: phone,
        dob: dob,
        treatmentPersonalData: treatmentPersonalData);
  }

  ///save
  ///@param accessesList[0].customerAccessId
  ///@param accessesList[0].accessDate
  ///@param accessesList[0].branchLocation
  ///@param accessesList[0].customerId
  ///@param customerId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  ///@param dob
  ///@param treatmentPersonalData
  @Post(
    path: '/api/v1/website/customers/save',
    optionalBody: true,
  )
  Future<chopper.Response<int>> _apiV1WebsiteCustomersSavePost({
    @Query('accessesList[0].customerAccessId')
        int? accessesList0CustomerAccessId,
    @Query('accessesList[0].accessDate') String? accessesList0AccessDate,
    @Query('accessesList[0].branchLocation')
        String? accessesList0BranchLocation,
    @Query('accessesList[0].customerId') int? accessesList0CustomerId,
    @Query('customerId') int? customerId,
    @Query('name') String? name,
    @Query('lastname') String? lastname,
    @Query('email') String? email,
    @Query('phone') String? phone,
    @Query('dob') String? dob,
    @Query('treatmentPersonalData') bool? treatmentPersonalData,
  });

  ///update
  ///@param accessesList[0].customerAccessId
  ///@param accessesList[0].accessDate
  ///@param accessesList[0].branchLocation
  ///@param accessesList[0].customerId
  ///@param customerId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  ///@param dob
  ///@param treatmentPersonalData
  Future<chopper.Response> apiV1WebsiteCustomersUpdatePut({
    int? accessesList0CustomerAccessId,
    String? accessesList0AccessDate,
    String? accessesList0BranchLocation,
    int? accessesList0CustomerId,
    int? customerId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
    String? dob,
    bool? treatmentPersonalData,
  }) {
    return _apiV1WebsiteCustomersUpdatePut(
        accessesList0CustomerAccessId: accessesList0CustomerAccessId,
        accessesList0AccessDate: accessesList0AccessDate,
        accessesList0BranchLocation: accessesList0BranchLocation,
        accessesList0CustomerId: accessesList0CustomerId,
        customerId: customerId,
        name: name,
        lastname: lastname,
        email: email,
        phone: phone,
        dob: dob,
        treatmentPersonalData: treatmentPersonalData);
  }

  ///update
  ///@param accessesList[0].customerAccessId
  ///@param accessesList[0].accessDate
  ///@param accessesList[0].branchLocation
  ///@param accessesList[0].customerId
  ///@param customerId
  ///@param name
  ///@param lastname
  ///@param email
  ///@param phone
  ///@param dob
  ///@param treatmentPersonalData
  @Put(
    path: '/api/v1/website/customers/update',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1WebsiteCustomersUpdatePut({
    @Query('accessesList[0].customerAccessId')
        int? accessesList0CustomerAccessId,
    @Query('accessesList[0].accessDate') String? accessesList0AccessDate,
    @Query('accessesList[0].branchLocation')
        String? accessesList0BranchLocation,
    @Query('accessesList[0].customerId') int? accessesList0CustomerId,
    @Query('customerId') int? customerId,
    @Query('name') String? name,
    @Query('lastname') String? lastname,
    @Query('email') String? email,
    @Query('phone') String? phone,
    @Query('dob') String? dob,
    @Query('treatmentPersonalData') bool? treatmentPersonalData,
  });

  ///save
  ///@param numbers
  ///@param wsCampainId
  ///@param message
  ///@param date
  ///@param errors
  Future<chopper.Response> apiV1WebsiteWhatsappStartcampainPost({
    List<String>? numbers,
    int? wsCampainId,
    String? message,
    String? date,
    String? errors,
  }) {
    return _apiV1WebsiteWhatsappStartcampainPost(
        numbers: numbers,
        wsCampainId: wsCampainId,
        message: message,
        date: date,
        errors: errors);
  }

  ///save
  ///@param numbers
  ///@param wsCampainId
  ///@param message
  ///@param date
  ///@param errors
  @Post(
    path: '/api/v1/website/whatsapp/startcampain',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1WebsiteWhatsappStartcampainPost({
    @Query('numbers') List<String>? numbers,
    @Query('wsCampainId') int? wsCampainId,
    @Query('message') String? message,
    @Query('date') String? date,
    @Query('errors') String? errors,
  });
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
      chopper.Response response) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
