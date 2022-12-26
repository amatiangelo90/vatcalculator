//Generated code

part of 'swagger.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$Swagger extends Swagger {
  _$Swagger([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = Swagger;

  @override
  Future<Response<dynamic>> _apiV1AppBranchesCreatebranchsupplierrelationPut({
    required int? branchId,
    required int? supplierId,
  }) {
    final String $url = '/api/v1/app/branches/createbranchsupplierrelation';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchId': branchId,
      'supplierId': supplierId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesDeleteDelete({
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
    final String $url = '/api/v1/app/branches/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storages[0].products[0].storageProductId':
          storages0Products0StorageProductId,
      'storages[0].products[0].productName': storages0Products0ProductName,
      'storages[0].products[0].unitMeasure': storages0Products0UnitMeasure,
      'storages[0].products[0].stock': storages0Products0Stock,
      'storages[0].products[0].amountHundred': storages0Products0AmountHundred,
      'storages[0].products[0].productId': storages0Products0ProductId,
      'storages[0].storageId': storages0StorageId,
      'storages[0].name': storages0Name,
      'storages[0].creationDate': storages0CreationDate,
      'storages[0].address': storages0Address,
      'storages[0].city': storages0City,
      'storages[0].cap': storages0Cap,
      'storages[0].branchId': storages0BranchId,
      'suppliers[0].productList[0].productId': suppliers0ProductList0ProductId,
      'suppliers[0].productList[0].name': suppliers0ProductList0Name,
      'suppliers[0].productList[0].code': suppliers0ProductList0Code,
      'suppliers[0].productList[0].unitMeasure':
          suppliers0ProductList0UnitMeasure,
      'suppliers[0].productList[0].unitMeasureOTH':
          suppliers0ProductList0UnitMeasureOTH,
      'suppliers[0].productList[0].vatApplied':
          suppliers0ProductList0VatApplied,
      'suppliers[0].productList[0].price': suppliers0ProductList0Price,
      'suppliers[0].productList[0].description':
          suppliers0ProductList0Description,
      'suppliers[0].productList[0].category': suppliers0ProductList0Category,
      'suppliers[0].productList[0].supplierId':
          suppliers0ProductList0SupplierId,
      'suppliers[0].supplierId': suppliers0SupplierId,
      'suppliers[0].name': suppliers0Name,
      'suppliers[0].vatNumber': suppliers0VatNumber,
      'suppliers[0].address': suppliers0Address,
      'suppliers[0].city': suppliers0City,
      'suppliers[0].cap': suppliers0Cap,
      'suppliers[0].code': suppliers0Code,
      'suppliers[0].phoneNumber': suppliers0PhoneNumber,
      'suppliers[0].email': suppliers0Email,
      'suppliers[0].pec': suppliers0Pec,
      'suppliers[0].cf': suppliers0Cf,
      'suppliers[0].country': suppliers0Country,
      'suppliers[0].createdByUserId': suppliers0CreatedByUserId,
      'suppliers[0].branchId': suppliers0BranchId,
      'events[0].expenceEvents[0].expenceId': events0ExpenceEvents0ExpenceId,
      'events[0].expenceEvents[0].description':
          events0ExpenceEvents0Description,
      'events[0].expenceEvents[0].amount': events0ExpenceEvents0Amount,
      'events[0].expenceEvents[0].dateIntert': events0ExpenceEvents0DateIntert,
      'events[0].expenceEvents[0].eventId': events0ExpenceEvents0EventId,
      'events[0].workstations[0].products[0].workstationProductId':
          events0Workstations0Products0WorkstationProductId,
      'events[0].workstations[0].products[0].productName':
          events0Workstations0Products0ProductName,
      'events[0].workstations[0].products[0].unitMeasure':
          events0Workstations0Products0UnitMeasure,
      'events[0].workstations[0].products[0].stockFromStorage':
          events0Workstations0Products0StockFromStorage,
      'events[0].workstations[0].products[0].consumed':
          events0Workstations0Products0Consumed,
      'events[0].workstations[0].products[0].amountHundred':
          events0Workstations0Products0AmountHundred,
      'events[0].workstations[0].products[0].productId':
          events0Workstations0Products0ProductId,
      'events[0].workstations[0].products[0].storageId':
          events0Workstations0Products0StorageId,
      'events[0].workstations[0].workstationId':
          events0Workstations0WorkstationId,
      'events[0].workstations[0].name': events0Workstations0Name,
      'events[0].workstations[0].responsable': events0Workstations0Responsable,
      'events[0].workstations[0].extra': events0Workstations0Extra,
      'events[0].workstations[0].workstationType':
          events0Workstations0WorkstationType,
      'events[0].workstations[0].eventId': events0Workstations0EventId,
      'events[0].eventId': events0EventId,
      'events[0].name': events0Name,
      'events[0].dateEvent': events0DateEvent,
      'events[0].dateCreation': events0DateCreation,
      'events[0].eventStatus': events0EventStatus,
      'events[0].location': events0Location,
      'events[0].branchId': events0BranchId,
      'events[0].storageId': events0StorageId,
      'orders[0].products[0].orderProductId': orders0Products0OrderProductId,
      'orders[0].products[0].productName': orders0Products0ProductName,
      'orders[0].products[0].unitMeasure': orders0Products0UnitMeasure,
      'orders[0].products[0].productId': orders0Products0ProductId,
      'orders[0].products[0].price': orders0Products0Price,
      'orders[0].products[0].amount': orders0Products0Amount,
      'orders[0].orderId': orders0OrderId,
      'orders[0].code': orders0Code,
      'orders[0].total': orders0Total,
      'orders[0].orderStatus': orders0OrderStatus,
      'orders[0].errorStatus': orders0ErrorStatus,
      'orders[0].creationDate': orders0CreationDate,
      'orders[0].senderUser': orders0SenderUser,
      'orders[0].details': orders0Details,
      'orders[0].deliveryDate': orders0DeliveryDate,
      'orders[0].closedBy': orders0ClosedBy,
      'orders[0].supplierId': orders0SupplierId,
      'orders[0].branchId': orders0BranchId,
      'orders[0].storageId': orders0StorageId,
      'branchId': branchId,
      'branchCode': branchCode,
      'name': name,
      'email': email,
      'vatNumber': vatNumber,
      'address': address,
      'city': city,
      'cap': cap,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'token': token,
      'userPriviledge': userPriviledge,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Branch>>> _apiV1AppBranchesFindallGet() {
    final String $url = '/api/v1/app/branches/findall';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Branch>, Branch>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesLinkbranchanduserGet({
    int? branchId,
    int? userId,
    String? userPriviledge,
  }) {
    final String $url = '/api/v1/app/branches/linkbranchanduser';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchId': branchId,
      'userId': userId,
      'userPriviledge': userPriviledge,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Branch>> _apiV1AppBranchesRetrievebranchbycodeGet(
      {required String? branchcode}) {
    final String $url = '/api/v1/app/branches/retrievebranchbycode';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchcode': branchcode
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Branch, Branch>($request);
  }

  @override
  Future<Response<Branch>> _apiV1AppBranchesRetrievebranchbyidGet(
      {required int? branchid}) {
    final String $url = '/api/v1/app/branches/retrievebranchbyid';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchid': branchid
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Branch, Branch>($request);
  }

  @override
  Future<Response<List<Supplier>>>
      _apiV1AppBranchesRetrievesuppliersbybranchidGet(
          {required int? branchid}) {
    final String $url = '/api/v1/app/branches/retrievesuppliersbybranchid';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchid': branchid
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Supplier>, Supplier>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesSavePost(
      {required Branch? branch}) {
    final String $url = '/api/v1/app/branches/save';
    final $body = branch;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesUpdatePut({
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
    final String $url = '/api/v1/app/branches/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storages[0].products[0].storageProductId':
          storages0Products0StorageProductId,
      'storages[0].products[0].productName': storages0Products0ProductName,
      'storages[0].products[0].unitMeasure': storages0Products0UnitMeasure,
      'storages[0].products[0].stock': storages0Products0Stock,
      'storages[0].products[0].amountHundred': storages0Products0AmountHundred,
      'storages[0].products[0].productId': storages0Products0ProductId,
      'storages[0].storageId': storages0StorageId,
      'storages[0].name': storages0Name,
      'storages[0].creationDate': storages0CreationDate,
      'storages[0].address': storages0Address,
      'storages[0].city': storages0City,
      'storages[0].cap': storages0Cap,
      'storages[0].branchId': storages0BranchId,
      'suppliers[0].productList[0].productId': suppliers0ProductList0ProductId,
      'suppliers[0].productList[0].name': suppliers0ProductList0Name,
      'suppliers[0].productList[0].code': suppliers0ProductList0Code,
      'suppliers[0].productList[0].unitMeasure':
          suppliers0ProductList0UnitMeasure,
      'suppliers[0].productList[0].unitMeasureOTH':
          suppliers0ProductList0UnitMeasureOTH,
      'suppliers[0].productList[0].vatApplied':
          suppliers0ProductList0VatApplied,
      'suppliers[0].productList[0].price': suppliers0ProductList0Price,
      'suppliers[0].productList[0].description':
          suppliers0ProductList0Description,
      'suppliers[0].productList[0].category': suppliers0ProductList0Category,
      'suppliers[0].productList[0].supplierId':
          suppliers0ProductList0SupplierId,
      'suppliers[0].supplierId': suppliers0SupplierId,
      'suppliers[0].name': suppliers0Name,
      'suppliers[0].vatNumber': suppliers0VatNumber,
      'suppliers[0].address': suppliers0Address,
      'suppliers[0].city': suppliers0City,
      'suppliers[0].cap': suppliers0Cap,
      'suppliers[0].code': suppliers0Code,
      'suppliers[0].phoneNumber': suppliers0PhoneNumber,
      'suppliers[0].email': suppliers0Email,
      'suppliers[0].pec': suppliers0Pec,
      'suppliers[0].cf': suppliers0Cf,
      'suppliers[0].country': suppliers0Country,
      'suppliers[0].createdByUserId': suppliers0CreatedByUserId,
      'suppliers[0].branchId': suppliers0BranchId,
      'events[0].expenceEvents[0].expenceId': events0ExpenceEvents0ExpenceId,
      'events[0].expenceEvents[0].description':
          events0ExpenceEvents0Description,
      'events[0].expenceEvents[0].amount': events0ExpenceEvents0Amount,
      'events[0].expenceEvents[0].dateIntert': events0ExpenceEvents0DateIntert,
      'events[0].expenceEvents[0].eventId': events0ExpenceEvents0EventId,
      'events[0].workstations[0].products[0].workstationProductId':
          events0Workstations0Products0WorkstationProductId,
      'events[0].workstations[0].products[0].productName':
          events0Workstations0Products0ProductName,
      'events[0].workstations[0].products[0].unitMeasure':
          events0Workstations0Products0UnitMeasure,
      'events[0].workstations[0].products[0].stockFromStorage':
          events0Workstations0Products0StockFromStorage,
      'events[0].workstations[0].products[0].consumed':
          events0Workstations0Products0Consumed,
      'events[0].workstations[0].products[0].amountHundred':
          events0Workstations0Products0AmountHundred,
      'events[0].workstations[0].products[0].productId':
          events0Workstations0Products0ProductId,
      'events[0].workstations[0].products[0].storageId':
          events0Workstations0Products0StorageId,
      'events[0].workstations[0].workstationId':
          events0Workstations0WorkstationId,
      'events[0].workstations[0].name': events0Workstations0Name,
      'events[0].workstations[0].responsable': events0Workstations0Responsable,
      'events[0].workstations[0].extra': events0Workstations0Extra,
      'events[0].workstations[0].workstationType':
          events0Workstations0WorkstationType,
      'events[0].workstations[0].eventId': events0Workstations0EventId,
      'events[0].eventId': events0EventId,
      'events[0].name': events0Name,
      'events[0].dateEvent': events0DateEvent,
      'events[0].dateCreation': events0DateCreation,
      'events[0].eventStatus': events0EventStatus,
      'events[0].location': events0Location,
      'events[0].branchId': events0BranchId,
      'events[0].storageId': events0StorageId,
      'orders[0].products[0].orderProductId': orders0Products0OrderProductId,
      'orders[0].products[0].productName': orders0Products0ProductName,
      'orders[0].products[0].unitMeasure': orders0Products0UnitMeasure,
      'orders[0].products[0].productId': orders0Products0ProductId,
      'orders[0].products[0].price': orders0Products0Price,
      'orders[0].products[0].amount': orders0Products0Amount,
      'orders[0].orderId': orders0OrderId,
      'orders[0].code': orders0Code,
      'orders[0].total': orders0Total,
      'orders[0].orderStatus': orders0OrderStatus,
      'orders[0].errorStatus': orders0ErrorStatus,
      'orders[0].creationDate': orders0CreationDate,
      'orders[0].senderUser': orders0SenderUser,
      'orders[0].details': orders0Details,
      'orders[0].deliveryDate': orders0DeliveryDate,
      'orders[0].closedBy': orders0ClosedBy,
      'orders[0].supplierId': orders0SupplierId,
      'orders[0].branchId': orders0BranchId,
      'orders[0].storageId': orders0StorageId,
      'branchId': branchId,
      'branchCode': branchCode,
      'name': name,
      'email': email,
      'vatNumber': vatNumber,
      'address': address,
      'city': city,
      'cap': cap,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'token': token,
      'userPriviledge': userPriviledge,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventDeleteDelete(
      {required int? eventId}) {
    final String $url = '/api/v1/app/event/delete';
    final Map<String, dynamic> $params = <String, dynamic>{'eventId': eventId};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ExpenceEvent>> _apiV1AppEventExpenceCreatePost({
    int? expenceId,
    String? description,
    num? amount,
    String? dateIntert,
    int? eventId,
  }) {
    final String $url = '/api/v1/app/event/expence/create';
    final Map<String, dynamic> $params = <String, dynamic>{
      'expenceId': expenceId,
      'description': description,
      'amount': amount,
      'dateIntert': dateIntert,
      'eventId': eventId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ExpenceEvent, ExpenceEvent>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventExpenceDeleteDelete({
    int? expenceId,
    String? description,
    num? amount,
    String? dateIntert,
    int? eventId,
  }) {
    final String $url = '/api/v1/app/event/expence/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'expenceId': expenceId,
      'description': description,
      'amount': amount,
      'dateIntert': dateIntert,
      'eventId': eventId,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<ExpenceEvent>>>
      _apiV1AppEventExpenceRetrievebyeventidGet({required int? eventid}) {
    final String $url = '/api/v1/app/event/expence/retrievebyeventid';
    final Map<String, dynamic> $params = <String, dynamic>{'eventid': eventid};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<ExpenceEvent>, ExpenceEvent>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventExpenceUpdatePut({
    int? expenceId,
    String? description,
    num? amount,
    String? dateIntert,
    int? eventId,
  }) {
    final String $url = '/api/v1/app/event/expence/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'expenceId': expenceId,
      'description': description,
      'amount': amount,
      'dateIntert': dateIntert,
      'eventId': eventId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Event>>> _apiV1AppEventFindeventbybranchidClosedGet(
      {required int? branchid}) {
    final String $url = '/api/v1/app/event/findeventbybranchid/closed';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchid': branchid
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<List<Event>>> _apiV1AppEventFindeventbybranchidOpenGet(
      {required int? branchid}) {
    final String $url = '/api/v1/app/event/findeventbybranchid/open';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchid': branchid
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<Event>> _apiV1AppEventSavePost({
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
    final String $url = '/api/v1/app/event/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'expenceEvents[0].expenceId': expenceEvents0ExpenceId,
      'expenceEvents[0].description': expenceEvents0Description,
      'expenceEvents[0].amount': expenceEvents0Amount,
      'expenceEvents[0].dateIntert': expenceEvents0DateIntert,
      'expenceEvents[0].eventId': expenceEvents0EventId,
      'workstations[0].products[0].workstationProductId':
          workstations0Products0WorkstationProductId,
      'workstations[0].products[0].productName':
          workstations0Products0ProductName,
      'workstations[0].products[0].unitMeasure':
          workstations0Products0UnitMeasure,
      'workstations[0].products[0].stockFromStorage':
          workstations0Products0StockFromStorage,
      'workstations[0].products[0].consumed': workstations0Products0Consumed,
      'workstations[0].products[0].amountHundred':
          workstations0Products0AmountHundred,
      'workstations[0].products[0].productId': workstations0Products0ProductId,
      'workstations[0].products[0].storageId': workstations0Products0StorageId,
      'workstations[0].workstationId': workstations0WorkstationId,
      'workstations[0].name': workstations0Name,
      'workstations[0].responsable': workstations0Responsable,
      'workstations[0].extra': workstations0Extra,
      'workstations[0].workstationType': workstations0WorkstationType,
      'workstations[0].eventId': workstations0EventId,
      'eventId': eventId,
      'name': name,
      'dateEvent': dateEvent,
      'dateCreation': dateCreation,
      'eventStatus': eventStatus,
      'location': location,
      'branchId': branchId,
      'storageId': storageId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Event, Event>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventUpdatePut({
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
    final String $url = '/api/v1/app/event/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'expenceEvents[0].expenceId': expenceEvents0ExpenceId,
      'expenceEvents[0].description': expenceEvents0Description,
      'expenceEvents[0].amount': expenceEvents0Amount,
      'expenceEvents[0].dateIntert': expenceEvents0DateIntert,
      'expenceEvents[0].eventId': expenceEvents0EventId,
      'workstations[0].products[0].workstationProductId':
          workstations0Products0WorkstationProductId,
      'workstations[0].products[0].productName':
          workstations0Products0ProductName,
      'workstations[0].products[0].unitMeasure':
          workstations0Products0UnitMeasure,
      'workstations[0].products[0].stockFromStorage':
          workstations0Products0StockFromStorage,
      'workstations[0].products[0].consumed': workstations0Products0Consumed,
      'workstations[0].products[0].amountHundred':
          workstations0Products0AmountHundred,
      'workstations[0].products[0].productId': workstations0Products0ProductId,
      'workstations[0].products[0].storageId': workstations0Products0StorageId,
      'workstations[0].workstationId': workstations0WorkstationId,
      'workstations[0].name': workstations0Name,
      'workstations[0].responsable': workstations0Responsable,
      'workstations[0].extra': workstations0Extra,
      'workstations[0].workstationType': workstations0WorkstationType,
      'workstations[0].eventId': workstations0EventId,
      'eventId': eventId,
      'name': name,
      'dateEvent': dateEvent,
      'dateCreation': dateCreation,
      'eventStatus': eventStatus,
      'location': location,
      'branchId': branchId,
      'storageId': storageId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Workstation>> _apiV1AppEventWorkstationAddproductPost({
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
    final String $url = '/api/v1/app/event/workstation/addproduct';
    final Map<String, dynamic> $params = <String, dynamic>{
      'products[0].workstationProductId': products0WorkstationProductId,
      'products[0].productName': products0ProductName,
      'products[0].unitMeasure': products0UnitMeasure,
      'products[0].stockFromStorage': products0StockFromStorage,
      'products[0].consumed': products0Consumed,
      'products[0].amountHundred': products0AmountHundred,
      'products[0].productId': products0ProductId,
      'products[0].storageId': products0StorageId,
      'workstationId': workstationId,
      'name': name,
      'responsable': responsable,
      'extra': extra,
      'workstationType': workstationType,
      'eventId': eventId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Workstation, Workstation>($request);
  }

  @override
  Future<Response<Workstation>> _apiV1AppEventWorkstationCreatePost({
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
    final String $url = '/api/v1/app/event/workstation/create';
    final Map<String, dynamic> $params = <String, dynamic>{
      'products[0].workstationProductId': products0WorkstationProductId,
      'products[0].productName': products0ProductName,
      'products[0].unitMeasure': products0UnitMeasure,
      'products[0].stockFromStorage': products0StockFromStorage,
      'products[0].consumed': products0Consumed,
      'products[0].amountHundred': products0AmountHundred,
      'products[0].productId': products0ProductId,
      'products[0].storageId': products0StorageId,
      'workstationId': workstationId,
      'name': name,
      'responsable': responsable,
      'extra': extra,
      'workstationType': workstationType,
      'eventId': eventId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Workstation, Workstation>($request);
  }

  @override
  Future<Response<OrderEntity>> _apiV1AppOrderSendPost(
      {required OrderEntity? orderEntity}) {
    final String $url = '/api/v1/app/order/send';
    final $body = orderEntity;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<OrderEntity, OrderEntity>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppProductsDeleteDelete({
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
    final String $url = '/api/v1/app/products/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'productId': productId,
      'name': name,
      'code': code,
      'unitMeasure': unitMeasure,
      'unitMeasureOTH': unitMeasureOTH,
      'vatApplied': vatApplied,
      'price': price,
      'description': description,
      'category': category,
      'supplierId': supplierId,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Product>>> _apiV1AppProductsFindallGet() {
    final String $url = '/api/v1/app/products/findall';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Product>, Product>($request);
  }

  @override
  Future<Response<List<Product>>> _apiV1AppProductsRetrievebysupplierGet(
      {required int? supplierId}) {
    final String $url = '/api/v1/app/products/retrievebysupplier';
    final Map<String, dynamic> $params = <String, dynamic>{
      'supplierId': supplierId
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Product>, Product>($request);
  }

  @override
  Future<Response<Product>> _apiV1AppProductsSavePost({
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
    final String $url = '/api/v1/app/products/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'productId': productId,
      'name': name,
      'code': code,
      'unitMeasure': unitMeasure,
      'unitMeasureOTH': unitMeasureOTH,
      'vatApplied': vatApplied,
      'price': price,
      'description': description,
      'category': category,
      'supplierId': supplierId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Product, Product>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppProductsUpdatePut({
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
    final String $url = '/api/v1/app/products/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'productId': productId,
      'name': name,
      'code': code,
      'unitMeasure': unitMeasure,
      'unitMeasureOTH': unitMeasureOTH,
      'vatApplied': vatApplied,
      'price': price,
      'description': description,
      'category': category,
      'supplierId': supplierId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageDeleteDelete({
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
    final String $url = '/api/v1/app/storage/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'products[0].storageProductId': products0StorageProductId,
      'products[0].productName': products0ProductName,
      'products[0].unitMeasure': products0UnitMeasure,
      'products[0].stock': products0Stock,
      'products[0].amountHundred': products0AmountHundred,
      'products[0].productId': products0ProductId,
      'storageId': storageId,
      'name': name,
      'creationDate': creationDate,
      'address': address,
      'city': city,
      'cap': cap,
      'branchId': branchId,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageDeleteproductfromstorageDelete({
    required int? storageId,
    required int? productId,
  }) {
    final String $url = '/api/v1/app/storage/deleteproductfromstorage';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageId': storageId,
      'productId': productId,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Storage>>> _apiV1AppStorageFindstoragebybranchidGet(
      {required int? branchid}) {
    final String $url = '/api/v1/app/storage/findstoragebybranchid';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchid': branchid
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Storage>, Storage>($request);
  }

  @override
  Future<Response<RStorageProduct>> _apiV1AppStorageInsertproductGet({
    required int? storageId,
    required int? productId,
  }) {
    final String $url = '/api/v1/app/storage/insertproduct';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageId': storageId,
      'productId': productId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<RStorageProduct, RStorageProduct>($request);
  }

  @override
  Future<Response<Storage>> _apiV1AppStorageSavePost({
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
    final String $url = '/api/v1/app/storage/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'products[0].storageProductId': products0StorageProductId,
      'products[0].productName': products0ProductName,
      'products[0].unitMeasure': products0UnitMeasure,
      'products[0].stock': products0Stock,
      'products[0].amountHundred': products0AmountHundred,
      'products[0].productId': products0ProductId,
      'storageId': storageId,
      'name': name,
      'creationDate': creationDate,
      'address': address,
      'city': city,
      'cap': cap,
      'branchId': branchId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Storage, Storage>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageUpdatePut({
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
    final String $url = '/api/v1/app/storage/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'products[0].storageProductId': products0StorageProductId,
      'products[0].productName': products0ProductName,
      'products[0].unitMeasure': products0UnitMeasure,
      'products[0].stock': products0Stock,
      'products[0].amountHundred': products0AmountHundred,
      'products[0].productId': products0ProductId,
      'storageId': storageId,
      'name': name,
      'creationDate': creationDate,
      'address': address,
      'city': city,
      'cap': cap,
      'branchId': branchId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppSuppliersDeleteDelete({
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
    final String $url = '/api/v1/app/suppliers/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'productList[0].productId': productList0ProductId,
      'productList[0].name': productList0Name,
      'productList[0].code': productList0Code,
      'productList[0].unitMeasure': productList0UnitMeasure,
      'productList[0].unitMeasureOTH': productList0UnitMeasureOTH,
      'productList[0].vatApplied': productList0VatApplied,
      'productList[0].price': productList0Price,
      'productList[0].description': productList0Description,
      'productList[0].category': productList0Category,
      'productList[0].supplierId': productList0SupplierId,
      'supplierId': supplierId,
      'name': name,
      'vatNumber': vatNumber,
      'address': address,
      'city': city,
      'cap': cap,
      'code': code,
      'phoneNumber': phoneNumber,
      'email': email,
      'pec': pec,
      'cf': cf,
      'country': country,
      'createdByUserId': createdByUserId,
      'branchId': branchId,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Supplier>>> _apiV1AppSuppliersFindallGet() {
    final String $url = '/api/v1/app/suppliers/findall';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Supplier>, Supplier>($request);
  }

  @override
  Future<Response<Supplier>> _apiV1AppSuppliersFindbyphoneGet(
      {required String? phone}) {
    final String $url = '/api/v1/app/suppliers/findbyphone';
    final Map<String, dynamic> $params = <String, dynamic>{'phone': phone};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Supplier, Supplier>($request);
  }

  @override
  Future<Response<Supplier>> _apiV1AppSuppliersSavePost({
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
    final String $url = '/api/v1/app/suppliers/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'productList[0].productId': productList0ProductId,
      'productList[0].name': productList0Name,
      'productList[0].code': productList0Code,
      'productList[0].unitMeasure': productList0UnitMeasure,
      'productList[0].unitMeasureOTH': productList0UnitMeasureOTH,
      'productList[0].vatApplied': productList0VatApplied,
      'productList[0].price': productList0Price,
      'productList[0].description': productList0Description,
      'productList[0].category': productList0Category,
      'productList[0].supplierId': productList0SupplierId,
      'supplierId': supplierId,
      'name': name,
      'vatNumber': vatNumber,
      'address': address,
      'city': city,
      'cap': cap,
      'code': code,
      'phoneNumber': phoneNumber,
      'email': email,
      'pec': pec,
      'cf': cf,
      'country': country,
      'createdByUserId': createdByUserId,
      'branchId': branchId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Supplier, Supplier>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppSuppliersUpdatePut({
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
    final String $url = '/api/v1/app/suppliers/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'productList[0].productId': productList0ProductId,
      'productList[0].name': productList0Name,
      'productList[0].code': productList0Code,
      'productList[0].unitMeasure': productList0UnitMeasure,
      'productList[0].unitMeasureOTH': productList0UnitMeasureOTH,
      'productList[0].vatApplied': productList0VatApplied,
      'productList[0].price': productList0Price,
      'productList[0].description': productList0Description,
      'productList[0].category': productList0Category,
      'productList[0].supplierId': productList0SupplierId,
      'supplierId': supplierId,
      'name': name,
      'vatNumber': vatNumber,
      'address': address,
      'city': city,
      'cap': cap,
      'code': code,
      'phoneNumber': phoneNumber,
      'email': email,
      'pec': pec,
      'cf': cf,
      'country': country,
      'createdByUserId': createdByUserId,
      'branchId': branchId,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersDeleteDelete({
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
    final String $url = '/api/v1/app/users/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchList[0].storages[0].products[0].storageProductId':
          branchList0Storages0Products0StorageProductId,
      'branchList[0].storages[0].products[0].productName':
          branchList0Storages0Products0ProductName,
      'branchList[0].storages[0].products[0].unitMeasure':
          branchList0Storages0Products0UnitMeasure,
      'branchList[0].storages[0].products[0].stock':
          branchList0Storages0Products0Stock,
      'branchList[0].storages[0].products[0].amountHundred':
          branchList0Storages0Products0AmountHundred,
      'branchList[0].storages[0].products[0].productId':
          branchList0Storages0Products0ProductId,
      'branchList[0].storages[0].storageId': branchList0Storages0StorageId,
      'branchList[0].storages[0].name': branchList0Storages0Name,
      'branchList[0].storages[0].creationDate':
          branchList0Storages0CreationDate,
      'branchList[0].storages[0].address': branchList0Storages0Address,
      'branchList[0].storages[0].city': branchList0Storages0City,
      'branchList[0].storages[0].cap': branchList0Storages0Cap,
      'branchList[0].storages[0].branchId': branchList0Storages0BranchId,
      'branchList[0].suppliers[0].productList[0].productId':
          branchList0Suppliers0ProductList0ProductId,
      'branchList[0].suppliers[0].productList[0].name':
          branchList0Suppliers0ProductList0Name,
      'branchList[0].suppliers[0].productList[0].code':
          branchList0Suppliers0ProductList0Code,
      'branchList[0].suppliers[0].productList[0].unitMeasure':
          branchList0Suppliers0ProductList0UnitMeasure,
      'branchList[0].suppliers[0].productList[0].unitMeasureOTH':
          branchList0Suppliers0ProductList0UnitMeasureOTH,
      'branchList[0].suppliers[0].productList[0].vatApplied':
          branchList0Suppliers0ProductList0VatApplied,
      'branchList[0].suppliers[0].productList[0].price':
          branchList0Suppliers0ProductList0Price,
      'branchList[0].suppliers[0].productList[0].description':
          branchList0Suppliers0ProductList0Description,
      'branchList[0].suppliers[0].productList[0].category':
          branchList0Suppliers0ProductList0Category,
      'branchList[0].suppliers[0].productList[0].supplierId':
          branchList0Suppliers0ProductList0SupplierId,
      'branchList[0].suppliers[0].supplierId': branchList0Suppliers0SupplierId,
      'branchList[0].suppliers[0].name': branchList0Suppliers0Name,
      'branchList[0].suppliers[0].vatNumber': branchList0Suppliers0VatNumber,
      'branchList[0].suppliers[0].address': branchList0Suppliers0Address,
      'branchList[0].suppliers[0].city': branchList0Suppliers0City,
      'branchList[0].suppliers[0].cap': branchList0Suppliers0Cap,
      'branchList[0].suppliers[0].code': branchList0Suppliers0Code,
      'branchList[0].suppliers[0].phoneNumber':
          branchList0Suppliers0PhoneNumber,
      'branchList[0].suppliers[0].email': branchList0Suppliers0Email,
      'branchList[0].suppliers[0].pec': branchList0Suppliers0Pec,
      'branchList[0].suppliers[0].cf': branchList0Suppliers0Cf,
      'branchList[0].suppliers[0].country': branchList0Suppliers0Country,
      'branchList[0].suppliers[0].createdByUserId':
          branchList0Suppliers0CreatedByUserId,
      'branchList[0].suppliers[0].branchId': branchList0Suppliers0BranchId,
      'branchList[0].events[0].expenceEvents[0].expenceId':
          branchList0Events0ExpenceEvents0ExpenceId,
      'branchList[0].events[0].expenceEvents[0].description':
          branchList0Events0ExpenceEvents0Description,
      'branchList[0].events[0].expenceEvents[0].amount':
          branchList0Events0ExpenceEvents0Amount,
      'branchList[0].events[0].expenceEvents[0].dateIntert':
          branchList0Events0ExpenceEvents0DateIntert,
      'branchList[0].events[0].expenceEvents[0].eventId':
          branchList0Events0ExpenceEvents0EventId,
      'branchList[0].events[0].workstations[0].products[0].workstationProductId':
          branchList0Events0Workstations0Products0WorkstationProductId,
      'branchList[0].events[0].workstations[0].products[0].productName':
          branchList0Events0Workstations0Products0ProductName,
      'branchList[0].events[0].workstations[0].products[0].unitMeasure':
          branchList0Events0Workstations0Products0UnitMeasure,
      'branchList[0].events[0].workstations[0].products[0].stockFromStorage':
          branchList0Events0Workstations0Products0StockFromStorage,
      'branchList[0].events[0].workstations[0].products[0].consumed':
          branchList0Events0Workstations0Products0Consumed,
      'branchList[0].events[0].workstations[0].products[0].amountHundred':
          branchList0Events0Workstations0Products0AmountHundred,
      'branchList[0].events[0].workstations[0].products[0].productId':
          branchList0Events0Workstations0Products0ProductId,
      'branchList[0].events[0].workstations[0].products[0].storageId':
          branchList0Events0Workstations0Products0StorageId,
      'branchList[0].events[0].workstations[0].workstationId':
          branchList0Events0Workstations0WorkstationId,
      'branchList[0].events[0].workstations[0].name':
          branchList0Events0Workstations0Name,
      'branchList[0].events[0].workstations[0].responsable':
          branchList0Events0Workstations0Responsable,
      'branchList[0].events[0].workstations[0].extra':
          branchList0Events0Workstations0Extra,
      'branchList[0].events[0].workstations[0].workstationType':
          branchList0Events0Workstations0WorkstationType,
      'branchList[0].events[0].workstations[0].eventId':
          branchList0Events0Workstations0EventId,
      'branchList[0].events[0].eventId': branchList0Events0EventId,
      'branchList[0].events[0].name': branchList0Events0Name,
      'branchList[0].events[0].dateEvent': branchList0Events0DateEvent,
      'branchList[0].events[0].dateCreation': branchList0Events0DateCreation,
      'branchList[0].events[0].eventStatus': branchList0Events0EventStatus,
      'branchList[0].events[0].location': branchList0Events0Location,
      'branchList[0].events[0].branchId': branchList0Events0BranchId,
      'branchList[0].events[0].storageId': branchList0Events0StorageId,
      'branchList[0].orders[0].products[0].orderProductId':
          branchList0Orders0Products0OrderProductId,
      'branchList[0].orders[0].products[0].productName':
          branchList0Orders0Products0ProductName,
      'branchList[0].orders[0].products[0].unitMeasure':
          branchList0Orders0Products0UnitMeasure,
      'branchList[0].orders[0].products[0].productId':
          branchList0Orders0Products0ProductId,
      'branchList[0].orders[0].products[0].price':
          branchList0Orders0Products0Price,
      'branchList[0].orders[0].products[0].amount':
          branchList0Orders0Products0Amount,
      'branchList[0].orders[0].orderId': branchList0Orders0OrderId,
      'branchList[0].orders[0].code': branchList0Orders0Code,
      'branchList[0].orders[0].total': branchList0Orders0Total,
      'branchList[0].orders[0].orderStatus': branchList0Orders0OrderStatus,
      'branchList[0].orders[0].errorStatus': branchList0Orders0ErrorStatus,
      'branchList[0].orders[0].creationDate': branchList0Orders0CreationDate,
      'branchList[0].orders[0].senderUser': branchList0Orders0SenderUser,
      'branchList[0].orders[0].details': branchList0Orders0Details,
      'branchList[0].orders[0].deliveryDate': branchList0Orders0DeliveryDate,
      'branchList[0].orders[0].closedBy': branchList0Orders0ClosedBy,
      'branchList[0].orders[0].supplierId': branchList0Orders0SupplierId,
      'branchList[0].orders[0].branchId': branchList0Orders0BranchId,
      'branchList[0].orders[0].storageId': branchList0Orders0StorageId,
      'branchList[0].branchId': branchList0BranchId,
      'branchList[0].branchCode': branchList0BranchCode,
      'branchList[0].name': branchList0Name,
      'branchList[0].email': branchList0Email,
      'branchList[0].vatNumber': branchList0VatNumber,
      'branchList[0].address': branchList0Address,
      'branchList[0].city': branchList0City,
      'branchList[0].cap': branchList0Cap,
      'branchList[0].phoneNumber': branchList0PhoneNumber,
      'branchList[0].userId': branchList0UserId,
      'branchList[0].token': branchList0Token,
      'branchList[0].userPriviledge': branchList0UserPriviledge,
      'userId': userId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Branch>>> _apiV1AppUsersFindAllBranchesByUserIdGet(
      {required int? userId}) {
    final String $url = '/api/v1/app/users/findAllBranchesByUserId';
    final Map<String, dynamic> $params = <String, dynamic>{'userId': userId};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Branch>, Branch>($request);
  }

  @override
  Future<Response<List<UserEntity>>> _apiV1AppUsersFindallGet() {
    final String $url = '/api/v1/app/users/findall';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<UserEntity>, UserEntity>($request);
  }

  @override
  Future<Response<UserEntity>> _apiV1AppUsersFindbyemailGet(
      {required String? email}) {
    final String $url = '/api/v1/app/users/findbyemail';
    final Map<String, dynamic> $params = <String, dynamic>{'email': email};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<UserEntity, UserEntity>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersSavePost({
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
    final String $url = '/api/v1/app/users/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchList[0].storages[0].products[0].storageProductId':
          branchList0Storages0Products0StorageProductId,
      'branchList[0].storages[0].products[0].productName':
          branchList0Storages0Products0ProductName,
      'branchList[0].storages[0].products[0].unitMeasure':
          branchList0Storages0Products0UnitMeasure,
      'branchList[0].storages[0].products[0].stock':
          branchList0Storages0Products0Stock,
      'branchList[0].storages[0].products[0].amountHundred':
          branchList0Storages0Products0AmountHundred,
      'branchList[0].storages[0].products[0].productId':
          branchList0Storages0Products0ProductId,
      'branchList[0].storages[0].storageId': branchList0Storages0StorageId,
      'branchList[0].storages[0].name': branchList0Storages0Name,
      'branchList[0].storages[0].creationDate':
          branchList0Storages0CreationDate,
      'branchList[0].storages[0].address': branchList0Storages0Address,
      'branchList[0].storages[0].city': branchList0Storages0City,
      'branchList[0].storages[0].cap': branchList0Storages0Cap,
      'branchList[0].storages[0].branchId': branchList0Storages0BranchId,
      'branchList[0].suppliers[0].productList[0].productId':
          branchList0Suppliers0ProductList0ProductId,
      'branchList[0].suppliers[0].productList[0].name':
          branchList0Suppliers0ProductList0Name,
      'branchList[0].suppliers[0].productList[0].code':
          branchList0Suppliers0ProductList0Code,
      'branchList[0].suppliers[0].productList[0].unitMeasure':
          branchList0Suppliers0ProductList0UnitMeasure,
      'branchList[0].suppliers[0].productList[0].unitMeasureOTH':
          branchList0Suppliers0ProductList0UnitMeasureOTH,
      'branchList[0].suppliers[0].productList[0].vatApplied':
          branchList0Suppliers0ProductList0VatApplied,
      'branchList[0].suppliers[0].productList[0].price':
          branchList0Suppliers0ProductList0Price,
      'branchList[0].suppliers[0].productList[0].description':
          branchList0Suppliers0ProductList0Description,
      'branchList[0].suppliers[0].productList[0].category':
          branchList0Suppliers0ProductList0Category,
      'branchList[0].suppliers[0].productList[0].supplierId':
          branchList0Suppliers0ProductList0SupplierId,
      'branchList[0].suppliers[0].supplierId': branchList0Suppliers0SupplierId,
      'branchList[0].suppliers[0].name': branchList0Suppliers0Name,
      'branchList[0].suppliers[0].vatNumber': branchList0Suppliers0VatNumber,
      'branchList[0].suppliers[0].address': branchList0Suppliers0Address,
      'branchList[0].suppliers[0].city': branchList0Suppliers0City,
      'branchList[0].suppliers[0].cap': branchList0Suppliers0Cap,
      'branchList[0].suppliers[0].code': branchList0Suppliers0Code,
      'branchList[0].suppliers[0].phoneNumber':
          branchList0Suppliers0PhoneNumber,
      'branchList[0].suppliers[0].email': branchList0Suppliers0Email,
      'branchList[0].suppliers[0].pec': branchList0Suppliers0Pec,
      'branchList[0].suppliers[0].cf': branchList0Suppliers0Cf,
      'branchList[0].suppliers[0].country': branchList0Suppliers0Country,
      'branchList[0].suppliers[0].createdByUserId':
          branchList0Suppliers0CreatedByUserId,
      'branchList[0].suppliers[0].branchId': branchList0Suppliers0BranchId,
      'branchList[0].events[0].expenceEvents[0].expenceId':
          branchList0Events0ExpenceEvents0ExpenceId,
      'branchList[0].events[0].expenceEvents[0].description':
          branchList0Events0ExpenceEvents0Description,
      'branchList[0].events[0].expenceEvents[0].amount':
          branchList0Events0ExpenceEvents0Amount,
      'branchList[0].events[0].expenceEvents[0].dateIntert':
          branchList0Events0ExpenceEvents0DateIntert,
      'branchList[0].events[0].expenceEvents[0].eventId':
          branchList0Events0ExpenceEvents0EventId,
      'branchList[0].events[0].workstations[0].products[0].workstationProductId':
          branchList0Events0Workstations0Products0WorkstationProductId,
      'branchList[0].events[0].workstations[0].products[0].productName':
          branchList0Events0Workstations0Products0ProductName,
      'branchList[0].events[0].workstations[0].products[0].unitMeasure':
          branchList0Events0Workstations0Products0UnitMeasure,
      'branchList[0].events[0].workstations[0].products[0].stockFromStorage':
          branchList0Events0Workstations0Products0StockFromStorage,
      'branchList[0].events[0].workstations[0].products[0].consumed':
          branchList0Events0Workstations0Products0Consumed,
      'branchList[0].events[0].workstations[0].products[0].amountHundred':
          branchList0Events0Workstations0Products0AmountHundred,
      'branchList[0].events[0].workstations[0].products[0].productId':
          branchList0Events0Workstations0Products0ProductId,
      'branchList[0].events[0].workstations[0].products[0].storageId':
          branchList0Events0Workstations0Products0StorageId,
      'branchList[0].events[0].workstations[0].workstationId':
          branchList0Events0Workstations0WorkstationId,
      'branchList[0].events[0].workstations[0].name':
          branchList0Events0Workstations0Name,
      'branchList[0].events[0].workstations[0].responsable':
          branchList0Events0Workstations0Responsable,
      'branchList[0].events[0].workstations[0].extra':
          branchList0Events0Workstations0Extra,
      'branchList[0].events[0].workstations[0].workstationType':
          branchList0Events0Workstations0WorkstationType,
      'branchList[0].events[0].workstations[0].eventId':
          branchList0Events0Workstations0EventId,
      'branchList[0].events[0].eventId': branchList0Events0EventId,
      'branchList[0].events[0].name': branchList0Events0Name,
      'branchList[0].events[0].dateEvent': branchList0Events0DateEvent,
      'branchList[0].events[0].dateCreation': branchList0Events0DateCreation,
      'branchList[0].events[0].eventStatus': branchList0Events0EventStatus,
      'branchList[0].events[0].location': branchList0Events0Location,
      'branchList[0].events[0].branchId': branchList0Events0BranchId,
      'branchList[0].events[0].storageId': branchList0Events0StorageId,
      'branchList[0].orders[0].products[0].orderProductId':
          branchList0Orders0Products0OrderProductId,
      'branchList[0].orders[0].products[0].productName':
          branchList0Orders0Products0ProductName,
      'branchList[0].orders[0].products[0].unitMeasure':
          branchList0Orders0Products0UnitMeasure,
      'branchList[0].orders[0].products[0].productId':
          branchList0Orders0Products0ProductId,
      'branchList[0].orders[0].products[0].price':
          branchList0Orders0Products0Price,
      'branchList[0].orders[0].products[0].amount':
          branchList0Orders0Products0Amount,
      'branchList[0].orders[0].orderId': branchList0Orders0OrderId,
      'branchList[0].orders[0].code': branchList0Orders0Code,
      'branchList[0].orders[0].total': branchList0Orders0Total,
      'branchList[0].orders[0].orderStatus': branchList0Orders0OrderStatus,
      'branchList[0].orders[0].errorStatus': branchList0Orders0ErrorStatus,
      'branchList[0].orders[0].creationDate': branchList0Orders0CreationDate,
      'branchList[0].orders[0].senderUser': branchList0Orders0SenderUser,
      'branchList[0].orders[0].details': branchList0Orders0Details,
      'branchList[0].orders[0].deliveryDate': branchList0Orders0DeliveryDate,
      'branchList[0].orders[0].closedBy': branchList0Orders0ClosedBy,
      'branchList[0].orders[0].supplierId': branchList0Orders0SupplierId,
      'branchList[0].orders[0].branchId': branchList0Orders0BranchId,
      'branchList[0].orders[0].storageId': branchList0Orders0StorageId,
      'branchList[0].branchId': branchList0BranchId,
      'branchList[0].branchCode': branchList0BranchCode,
      'branchList[0].name': branchList0Name,
      'branchList[0].email': branchList0Email,
      'branchList[0].vatNumber': branchList0VatNumber,
      'branchList[0].address': branchList0Address,
      'branchList[0].city': branchList0City,
      'branchList[0].cap': branchList0Cap,
      'branchList[0].phoneNumber': branchList0PhoneNumber,
      'branchList[0].userId': branchList0UserId,
      'branchList[0].token': branchList0Token,
      'branchList[0].userPriviledge': branchList0UserPriviledge,
      'userId': userId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersUpdatePut({
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
    final String $url = '/api/v1/app/users/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchList[0].storages[0].products[0].storageProductId':
          branchList0Storages0Products0StorageProductId,
      'branchList[0].storages[0].products[0].productName':
          branchList0Storages0Products0ProductName,
      'branchList[0].storages[0].products[0].unitMeasure':
          branchList0Storages0Products0UnitMeasure,
      'branchList[0].storages[0].products[0].stock':
          branchList0Storages0Products0Stock,
      'branchList[0].storages[0].products[0].amountHundred':
          branchList0Storages0Products0AmountHundred,
      'branchList[0].storages[0].products[0].productId':
          branchList0Storages0Products0ProductId,
      'branchList[0].storages[0].storageId': branchList0Storages0StorageId,
      'branchList[0].storages[0].name': branchList0Storages0Name,
      'branchList[0].storages[0].creationDate':
          branchList0Storages0CreationDate,
      'branchList[0].storages[0].address': branchList0Storages0Address,
      'branchList[0].storages[0].city': branchList0Storages0City,
      'branchList[0].storages[0].cap': branchList0Storages0Cap,
      'branchList[0].storages[0].branchId': branchList0Storages0BranchId,
      'branchList[0].suppliers[0].productList[0].productId':
          branchList0Suppliers0ProductList0ProductId,
      'branchList[0].suppliers[0].productList[0].name':
          branchList0Suppliers0ProductList0Name,
      'branchList[0].suppliers[0].productList[0].code':
          branchList0Suppliers0ProductList0Code,
      'branchList[0].suppliers[0].productList[0].unitMeasure':
          branchList0Suppliers0ProductList0UnitMeasure,
      'branchList[0].suppliers[0].productList[0].unitMeasureOTH':
          branchList0Suppliers0ProductList0UnitMeasureOTH,
      'branchList[0].suppliers[0].productList[0].vatApplied':
          branchList0Suppliers0ProductList0VatApplied,
      'branchList[0].suppliers[0].productList[0].price':
          branchList0Suppliers0ProductList0Price,
      'branchList[0].suppliers[0].productList[0].description':
          branchList0Suppliers0ProductList0Description,
      'branchList[0].suppliers[0].productList[0].category':
          branchList0Suppliers0ProductList0Category,
      'branchList[0].suppliers[0].productList[0].supplierId':
          branchList0Suppliers0ProductList0SupplierId,
      'branchList[0].suppliers[0].supplierId': branchList0Suppliers0SupplierId,
      'branchList[0].suppliers[0].name': branchList0Suppliers0Name,
      'branchList[0].suppliers[0].vatNumber': branchList0Suppliers0VatNumber,
      'branchList[0].suppliers[0].address': branchList0Suppliers0Address,
      'branchList[0].suppliers[0].city': branchList0Suppliers0City,
      'branchList[0].suppliers[0].cap': branchList0Suppliers0Cap,
      'branchList[0].suppliers[0].code': branchList0Suppliers0Code,
      'branchList[0].suppliers[0].phoneNumber':
          branchList0Suppliers0PhoneNumber,
      'branchList[0].suppliers[0].email': branchList0Suppliers0Email,
      'branchList[0].suppliers[0].pec': branchList0Suppliers0Pec,
      'branchList[0].suppliers[0].cf': branchList0Suppliers0Cf,
      'branchList[0].suppliers[0].country': branchList0Suppliers0Country,
      'branchList[0].suppliers[0].createdByUserId':
          branchList0Suppliers0CreatedByUserId,
      'branchList[0].suppliers[0].branchId': branchList0Suppliers0BranchId,
      'branchList[0].events[0].expenceEvents[0].expenceId':
          branchList0Events0ExpenceEvents0ExpenceId,
      'branchList[0].events[0].expenceEvents[0].description':
          branchList0Events0ExpenceEvents0Description,
      'branchList[0].events[0].expenceEvents[0].amount':
          branchList0Events0ExpenceEvents0Amount,
      'branchList[0].events[0].expenceEvents[0].dateIntert':
          branchList0Events0ExpenceEvents0DateIntert,
      'branchList[0].events[0].expenceEvents[0].eventId':
          branchList0Events0ExpenceEvents0EventId,
      'branchList[0].events[0].workstations[0].products[0].workstationProductId':
          branchList0Events0Workstations0Products0WorkstationProductId,
      'branchList[0].events[0].workstations[0].products[0].productName':
          branchList0Events0Workstations0Products0ProductName,
      'branchList[0].events[0].workstations[0].products[0].unitMeasure':
          branchList0Events0Workstations0Products0UnitMeasure,
      'branchList[0].events[0].workstations[0].products[0].stockFromStorage':
          branchList0Events0Workstations0Products0StockFromStorage,
      'branchList[0].events[0].workstations[0].products[0].consumed':
          branchList0Events0Workstations0Products0Consumed,
      'branchList[0].events[0].workstations[0].products[0].amountHundred':
          branchList0Events0Workstations0Products0AmountHundred,
      'branchList[0].events[0].workstations[0].products[0].productId':
          branchList0Events0Workstations0Products0ProductId,
      'branchList[0].events[0].workstations[0].products[0].storageId':
          branchList0Events0Workstations0Products0StorageId,
      'branchList[0].events[0].workstations[0].workstationId':
          branchList0Events0Workstations0WorkstationId,
      'branchList[0].events[0].workstations[0].name':
          branchList0Events0Workstations0Name,
      'branchList[0].events[0].workstations[0].responsable':
          branchList0Events0Workstations0Responsable,
      'branchList[0].events[0].workstations[0].extra':
          branchList0Events0Workstations0Extra,
      'branchList[0].events[0].workstations[0].workstationType':
          branchList0Events0Workstations0WorkstationType,
      'branchList[0].events[0].workstations[0].eventId':
          branchList0Events0Workstations0EventId,
      'branchList[0].events[0].eventId': branchList0Events0EventId,
      'branchList[0].events[0].name': branchList0Events0Name,
      'branchList[0].events[0].dateEvent': branchList0Events0DateEvent,
      'branchList[0].events[0].dateCreation': branchList0Events0DateCreation,
      'branchList[0].events[0].eventStatus': branchList0Events0EventStatus,
      'branchList[0].events[0].location': branchList0Events0Location,
      'branchList[0].events[0].branchId': branchList0Events0BranchId,
      'branchList[0].events[0].storageId': branchList0Events0StorageId,
      'branchList[0].orders[0].products[0].orderProductId':
          branchList0Orders0Products0OrderProductId,
      'branchList[0].orders[0].products[0].productName':
          branchList0Orders0Products0ProductName,
      'branchList[0].orders[0].products[0].unitMeasure':
          branchList0Orders0Products0UnitMeasure,
      'branchList[0].orders[0].products[0].productId':
          branchList0Orders0Products0ProductId,
      'branchList[0].orders[0].products[0].price':
          branchList0Orders0Products0Price,
      'branchList[0].orders[0].products[0].amount':
          branchList0Orders0Products0Amount,
      'branchList[0].orders[0].orderId': branchList0Orders0OrderId,
      'branchList[0].orders[0].code': branchList0Orders0Code,
      'branchList[0].orders[0].total': branchList0Orders0Total,
      'branchList[0].orders[0].orderStatus': branchList0Orders0OrderStatus,
      'branchList[0].orders[0].errorStatus': branchList0Orders0ErrorStatus,
      'branchList[0].orders[0].creationDate': branchList0Orders0CreationDate,
      'branchList[0].orders[0].senderUser': branchList0Orders0SenderUser,
      'branchList[0].orders[0].details': branchList0Orders0Details,
      'branchList[0].orders[0].deliveryDate': branchList0Orders0DeliveryDate,
      'branchList[0].orders[0].closedBy': branchList0Orders0ClosedBy,
      'branchList[0].orders[0].supplierId': branchList0Orders0SupplierId,
      'branchList[0].orders[0].branchId': branchList0Orders0BranchId,
      'branchList[0].orders[0].storageId': branchList0Orders0StorageId,
      'branchList[0].branchId': branchList0BranchId,
      'branchList[0].branchCode': branchList0BranchCode,
      'branchList[0].name': branchList0Name,
      'branchList[0].email': branchList0Email,
      'branchList[0].vatNumber': branchList0VatNumber,
      'branchList[0].address': branchList0Address,
      'branchList[0].city': branchList0City,
      'branchList[0].cap': branchList0Cap,
      'branchList[0].phoneNumber': branchList0PhoneNumber,
      'branchList[0].userId': branchList0UserId,
      'branchList[0].token': branchList0Token,
      'branchList[0].userPriviledge': branchList0UserPriviledge,
      'userId': userId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationInsertproductGet({
    required int? workstationId,
    required int? productId,
    required int? storageId,
  }) {
    final String $url = '/api/v1/app/workstation/insertproduct';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationId': workstationId,
      'productId': productId,
      'storageId': storageId,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationRemoveproductDelete(
      {required int? workstationProductId}) {
    final String $url = '/api/v1/app/workstation/removeproduct';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationProductId': workstationProductId
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteCustomeraccessDeleteDelete(
      {int? customerId}) {
    final String $url = '/api/v1/website/customeraccess/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'customerId': customerId
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<CustomerAccess>>>
      _apiV1WebsiteCustomeraccessFindallGet() {
    final String $url = '/api/v1/website/customeraccess/findall';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<CustomerAccess>, CustomerAccess>($request);
  }

  @override
  Future<Response<List<CustomerAccess>>>
      _apiV1WebsiteCustomeraccessFindbycustomeridGet(
          {required int? customerId}) {
    final String $url = '/api/v1/website/customeraccess/findbycustomerid';
    final Map<String, dynamic> $params = <String, dynamic>{
      'customerId': customerId
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<CustomerAccess>, CustomerAccess>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteCustomeraccessSavePost({
    int? customerAccessId,
    String? accessDate,
    String? branchLocation,
    int? customerId,
  }) {
    final String $url = '/api/v1/website/customeraccess/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'customerAccessId': customerAccessId,
      'accessDate': accessDate,
      'branchLocation': branchLocation,
      'customerId': customerId,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteCustomersDeleteDelete(
      {int? customerId}) {
    final String $url = '/api/v1/website/customers/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'customerId': customerId
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Customer>>> _apiV1WebsiteCustomersFindallGet() {
    final String $url = '/api/v1/website/customers/findall';
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<Customer>, Customer>($request);
  }

  @override
  Future<Response<List<Customer>>> _apiV1WebsiteCustomersFindallbydateGet(
      {required String? date}) {
    final String $url = '/api/v1/website/customers/findallbydate';
    final Map<String, dynamic> $params = <String, dynamic>{'date': date};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Customer>, Customer>($request);
  }

  @override
  Future<Response<Customer>> _apiV1WebsiteCustomersFindbyphoneGet(
      {required String? phone}) {
    final String $url = '/api/v1/website/customers/findbyphone';
    final Map<String, dynamic> $params = <String, dynamic>{'phone': phone};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Customer, Customer>($request);
  }

  @override
  Future<Response<int>> _apiV1WebsiteCustomersSavePost({
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
    final String $url = '/api/v1/website/customers/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'accessesList[0].customerAccessId': accessesList0CustomerAccessId,
      'accessesList[0].accessDate': accessesList0AccessDate,
      'accessesList[0].branchLocation': accessesList0BranchLocation,
      'accessesList[0].customerId': accessesList0CustomerId,
      'customerId': customerId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'dob': dob,
      'treatmentPersonalData': treatmentPersonalData,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<int, int>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteCustomersUpdatePut({
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
    final String $url = '/api/v1/website/customers/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'accessesList[0].customerAccessId': accessesList0CustomerAccessId,
      'accessesList[0].accessDate': accessesList0AccessDate,
      'accessesList[0].branchLocation': accessesList0BranchLocation,
      'accessesList[0].customerId': accessesList0CustomerId,
      'customerId': customerId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'dob': dob,
      'treatmentPersonalData': treatmentPersonalData,
    };
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteWhatsappStartcampainPost({
    List<String>? numbers,
    int? wsCampainId,
    String? message,
    String? date,
    String? errors,
  }) {
    final String $url = '/api/v1/website/whatsapp/startcampain';
    final Map<String, dynamic> $params = <String, dynamic>{
      'numbers': numbers,
      'wsCampainId': wsCampainId,
      'message': message,
      'date': date,
      'errors': errors,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
