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
        Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesDeleteDelete(
      {required Branch? branch}) {
    final String $url = '/api/v1/app/branches/delete';
    final $body = branch;
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Branch>>> _apiV1AppBranchesFindallGet() {
    final String $url = '/api/v1/app/branches/findall';
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
    );
    return client.send<List<Branch>, Branch>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesLinkbranchanduserGet({
    required int? branchId,
    required int? userId,
    required String? userPriviledge,
  }) {
    final String $url = '/api/v1/app/branches/linkbranchanduser';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchId': branchId,
      'userId': userId,
      'userPriviledge': userPriviledge,
    };
    final Request $request = Request(
      'GET',
      Uri.parse($url),
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
      Uri.parse($url),
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
      Uri.parse($url),
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
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppBranchesUpdatePut(
      {required Branch? branch}) {
    final String $url = '/api/v1/app/branches/update';
    final $body = branch;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventClosePut({required int? eventId}) {
    final String $url = '/api/v1/app/event/close';
    final Map<String, dynamic> $params = <String, dynamic>{'eventId': eventId};
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ExpenceEvent>> _apiV1AppEventExpenceCreatePost(
      {required ExpenceEvent? expenceEvent}) {
    final String $url = '/api/v1/app/event/expence/create';
    final $body = expenceEvent;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<ExpenceEvent, ExpenceEvent>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventExpenceDeleteDelete(
      {required ExpenceEvent? expenceEvent}) {
    final String $url = '/api/v1/app/event/expence/delete';
    final $body = expenceEvent;
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<ExpenceEvent>, ExpenceEvent>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventExpenceUpdatePut(
      {required ExpenceEvent? expenceEvent}) {
    final String $url = '/api/v1/app/event/expence/update';
    final $body = expenceEvent;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
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
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Event>, Event>($request);
  }

  @override
  Future<Response<Event>> _apiV1AppEventFindeventbyeventidGet(
      {required int? eventid}) {
    final String $url = '/api/v1/app/event/findeventbyeventid';
    final Map<String, dynamic> $params = <String, dynamic>{'eventid': eventid};
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Event, Event>($request);
  }

  @override
  Future<Response<Event>> _apiV1AppEventSavePost({required Event? event}) {
    final String $url = '/api/v1/app/event/save';
    final $body = event;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Event, Event>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppEventUpdatePut({required Event? event}) {
    final String $url = '/api/v1/app/event/update';
    final $body = event;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Workstation>> _apiV1AppEventWorkstationAddproductPost(
      {required Workstation? workstation}) {
    final String $url = '/api/v1/app/event/workstation/addproduct';
    final $body = workstation;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Workstation, Workstation>($request);
  }

  @override
  Future<Response<Workstation>> _apiV1AppEventWorkstationCreatePost(
      {required Workstation? workstation}) {
    final String $url = '/api/v1/app/event/workstation/create';
    final $body = workstation;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
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
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<OrderEntity, OrderEntity>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppOrderUpdatePut(
      {required OrderEntity? orderEntity}) {
    final String $url = '/api/v1/app/order/update';
    final $body = orderEntity;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppProductsDeleteDelete(
      {required Product? product}) {
    final String $url = '/api/v1/app/products/delete';
    final $body = product;
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Product>>> _apiV1AppProductsFindallGet() {
    final String $url = '/api/v1/app/products/findall';
    final Request $request = Request(
      'GET',
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Product>, Product>($request);
  }

  @override
  Future<Response<Product>> _apiV1AppProductsSavePost(
      {required Product? product}) {
    final String $url = '/api/v1/app/products/save';
    final $body = product;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Product, Product>($request);
  }

  @override
  Future<Response<Product>> _apiV1AppProductsUpdatePut(
      {required Product? product}) {
    final String $url = '/api/v1/app/products/update';
    final $body = product;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Product, Product>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageAmounthundredSaveconfigurationPut({
    required int? storageProductId,
    required num? qHundredAmount,
  }) {
    final String $url = '/api/v1/app/storage/amounthundred/saveconfiguration';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageProductId': storageProductId,
      'qHundredAmount': qHundredAmount,
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageDeleteDelete(
      {required Storage? storage}) {
    final String $url = '/api/v1/app/storage/delete';
    final $body = storage;
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageEmptystoragePut(
      {required int? storageId}) {
    final String $url = '/api/v1/app/storage/emptystorage';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageId': storageId
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<RStorageProduct>>>
      _apiV1AppStorageFindproductsbystorageidGet({required int? storageId}) {
    final String $url = '/api/v1/app/storage/findproductsbystorageid';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageId': storageId
    };
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<RStorageProduct>, RStorageProduct>($request);
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
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<RStorageProduct, RStorageProduct>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageLoadPut(
      {required List<LoadUnloadModel>? loadUnloadModel}) {
    final String $url = '/api/v1/app/storage/load';
    final $body = loadUnloadModel;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageMoveproductbetweenstoragesPut({
    required int? storageIdFrom,
    required int? storageIdTo,
    required int? productId,
    required num? amount,
  }) {
    final String $url = '/api/v1/app/storage/moveproductbetweenstorages';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageIdFrom': storageIdFrom,
      'storageIdTo': storageIdTo,
      'productId': productId,
      'amount': amount,
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Storage>> _apiV1AppStorageSavePost(
      {required Storage? storage}) {
    final String $url = '/api/v1/app/storage/save';
    final $body = storage;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Storage, Storage>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageSetstockzerotonegativeproductsPut(
      {required int? storageId}) {
    final String $url = '/api/v1/app/storage/setstockzerotonegativeproducts';
    final Map<String, dynamic> $params = <String, dynamic>{
      'storageId': storageId
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageUnloadPut(
      {required List<LoadUnloadModel>? loadUnloadModel}) {
    final String $url = '/api/v1/app/storage/unload';
    final $body = loadUnloadModel;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppStorageUpdatePut(
      {required Storage? storage}) {
    final String $url = '/api/v1/app/storage/update';
    final $body = storage;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppSuppliersConnectbranchsupplierGet({
    required int? branchId,
    required int? supplierId,
  }) {
    final String $url = '/api/v1/app/suppliers/connectbranchsupplier';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchId': branchId,
      'supplierId': supplierId,
    };
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppSuppliersDeleteDelete({
    required int? supplierId,
    required int? branchId,
  }) {
    final String $url = '/api/v1/app/suppliers/delete';
    final Map<String, dynamic> $params = <String, dynamic>{
      'supplierId': supplierId,
      'branchId': branchId,
    };
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
    );
    return client.send<List<Supplier>, Supplier>($request);
  }

  @override
  Future<Response<Supplier>> _apiV1AppSuppliersFindbycodeGet(
      {required String? suppliercode}) {
    final String $url = '/api/v1/app/suppliers/findbycode';
    final Map<String, dynamic> $params = <String, dynamic>{
      'suppliercode': suppliercode
    };
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Supplier, Supplier>($request);
  }

  @override
  Future<Response<Supplier>> _apiV1AppSuppliersSavePost(
      {required Supplier? supplier}) {
    final String $url = '/api/v1/app/suppliers/save';
    final $body = supplier;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Supplier, Supplier>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppSuppliersUpdatePut(
      {required Supplier? supplier}) {
    final String $url = '/api/v1/app/suppliers/update';
    final $body = supplier;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersDeleteDelete(
      {required UserEntity? userEntity}) {
    final String $url = '/api/v1/app/users/delete';
    final $body = userEntity;
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Branch>, Branch>($request);
  }

  @override
  Future<Response<List<UserBranch>>> _apiV1AppUsersFindAllUsersByBranchIdGet(
      {required int? branchId}) {
    final String $url = '/api/v1/app/users/findAllUsersByBranchId';
    final Map<String, dynamic> $params = <String, dynamic>{
      'branchId': branchId
    };
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<UserBranch>, UserBranch>($request);
  }

  @override
  Future<Response<List<UserEntity>>> _apiV1AppUsersFindallGet() {
    final String $url = '/api/v1/app/users/findall';
    final Request $request = Request(
      'GET',
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<UserEntity, UserEntity>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersRemoveuserfrombranchDelete({
    required int? userId,
    required int? branchId,
  }) {
    final String $url = '/api/v1/app/users/removeuserfrombranch';
    final Map<String, dynamic> $params = <String, dynamic>{
      'userId': userId,
      'branchId': branchId,
    };
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersSavePost(
      {required UserEntity? userEntity}) {
    final String $url = '/api/v1/app/users/save';
    final $body = userEntity;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersUpdatePut(
      {required UserEntity? userEntity}) {
    final String $url = '/api/v1/app/users/update';
    final $body = userEntity;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppUsersUpdatePermissionTypePut({
    required int? userBranchId,
    required String? userPriviledge,
  }) {
    final String $url = '/api/v1/app/users/updatePermissionType';
    final Map<String, dynamic> $params = <String, dynamic>{
      'userBranchId': userBranchId,
      'userPriviledge': userPriviledge,
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationDeleteproductDelete(
      {required int? workstationProductId}) {
    final String $url = '/api/v1/app/workstation/deleteproduct';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationProductId': workstationProductId
    };
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<RWorkstationProduct>> _apiV1AppWorkstationInsertproductGet({
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<RWorkstationProduct, RWorkstationProduct>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationLoadPost(
      {required List<WorkstationLoadUnloadProduct>?
          workstationLoadUnloadProductList}) {
    final String $url = '/api/v1/app/workstation/load';
    final $body = workstationLoadUnloadProductList;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationRemoveworkstationDelete(
      {required int? workstationId}) {
    final String $url = '/api/v1/app/workstation/removeworkstation';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationId': workstationId
    };
    final Request $request = Request(
      'DELETE',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationResetproductconsumedvaluePut(
      {required int? workstationProductId}) {
    final String $url = '/api/v1/app/workstation/resetproductconsumedvalue';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationProductId': workstationProductId
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationResetproductstockvaluePut(
      {required int? workstationProductId}) {
    final String $url = '/api/v1/app/workstation/resetproductstockvalue';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationProductId': workstationProductId
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<RWorkstationProduct>>>
      _apiV1AppWorkstationRetrieveAllProductByWorkstationIdGet(
          {required int? workstationId}) {
    final String $url =
        '/api/v1/app/workstation/retrieveAllProductByWorkstationId';
    final Map<String, dynamic> $params = <String, dynamic>{
      'workstationId': workstationId
    };
    final Request $request = Request(
      'GET',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<List<RWorkstationProduct>, RWorkstationProduct>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1AppWorkstationUnloadPost(
      {required List<WorkstationLoadUnloadProduct>?
          workstationLoadUnloadProductList}) {
    final String $url = '/api/v1/app/workstation/unload';
    final $body = workstationLoadUnloadProductList;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Workstation>> _apiV1AppWorkstationUpdatePut(
      {required Workstation? workstation}) {
    final String $url = '/api/v1/app/workstation/update';
    final $body = workstation;
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<Workstation, Workstation>($request);
  }

  @override
  Future<Response<List<Customer>>> _apiV1WebsiteCustomersFindallGet() {
    final String $url = '/api/v1/website/customers/findall';
    final Request $request = Request(
      'GET',
      Uri.parse($url),
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
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Customer>, Customer>($request);
  }

  @override
  Future<Response<int>> _apiV1WebsiteCustomersSavePost({
    int? customerId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
    String? dob,
    String? registrationDate,
    String? branchLocation,
    bool? treatmentPersonalData,
  }) {
    final String $url = '/api/v1/website/customers/save';
    final Map<String, dynamic> $params = <String, dynamic>{
      'customerId': customerId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'dob': dob,
      'registrationDate': registrationDate,
      'branchLocation': branchLocation,
      'treatmentPersonalData': treatmentPersonalData,
    };
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<int, int>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteCustomersSavecustomerPost(
      {required String? customer}) {
    final String $url = '/api/v1/website/customers/savecustomer';
    final $body = customer;
    final Request $request = Request(
      'POST',
      Uri.parse($url),
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1WebsiteCustomersUpdatePut({
    int? customerId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
    String? dob,
    String? registrationDate,
    String? branchLocation,
    bool? treatmentPersonalData,
  }) {
    final String $url = '/api/v1/website/customers/update';
    final Map<String, dynamic> $params = <String, dynamic>{
      'customerId': customerId,
      'name': name,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'dob': dob,
      'registrationDate': registrationDate,
      'branchLocation': branchLocation,
      'treatmentPersonalData': treatmentPersonalData,
    };
    final Request $request = Request(
      'PUT',
      Uri.parse($url),
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
