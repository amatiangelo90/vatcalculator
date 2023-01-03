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
  ///@param branch branch
  Future<chopper.Response> apiV1AppBranchesDeleteDelete(
      {required Branch? branch}) {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppBranchesDeleteDelete(branch: branch);
  }

  ///delete
  ///@param branch branch
  @Delete(path: '/api/v1/app/branches/delete')
  Future<chopper.Response> _apiV1AppBranchesDeleteDelete(
      {@Body() required Branch? branch});

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
    required int? branchId,
    required int? userId,
    required String? userPriviledge,
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
    @Query('branchId') required int? branchId,
    @Query('userId') required int? userId,
    @Query('userPriviledge') required String? userPriviledge,
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
  ///@param branch branch
  Future<chopper.Response> apiV1AppBranchesUpdatePut(
      {required Branch? branch}) {
    generatedMapping.putIfAbsent(Branch, () => Branch.fromJsonFactory);

    return _apiV1AppBranchesUpdatePut(branch: branch);
  }

  ///update
  ///@param branch branch
  @Put(path: '/api/v1/app/branches/update')
  Future<chopper.Response> _apiV1AppBranchesUpdatePut(
      {@Body() required Branch? branch});

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
  ///@param expenceEvent expenceEvent
  Future<chopper.Response<ExpenceEvent>> apiV1AppEventExpenceCreatePost(
      {required ExpenceEvent? expenceEvent}) {
    generatedMapping.putIfAbsent(
        ExpenceEvent, () => ExpenceEvent.fromJsonFactory);

    return _apiV1AppEventExpenceCreatePost(expenceEvent: expenceEvent);
  }

  ///saveExpence
  ///@param expenceEvent expenceEvent
  @Post(path: '/api/v1/app/event/expence/create')
  Future<chopper.Response<ExpenceEvent>> _apiV1AppEventExpenceCreatePost(
      {@Body() required ExpenceEvent? expenceEvent});

  ///deleteExpence
  ///@param expenceEvent expenceEvent
  Future<chopper.Response> apiV1AppEventExpenceDeleteDelete(
      {required ExpenceEvent? expenceEvent}) {
    generatedMapping.putIfAbsent(
        ExpenceEvent, () => ExpenceEvent.fromJsonFactory);

    return _apiV1AppEventExpenceDeleteDelete(expenceEvent: expenceEvent);
  }

  ///deleteExpence
  ///@param expenceEvent expenceEvent
  @Delete(path: '/api/v1/app/event/expence/delete')
  Future<chopper.Response> _apiV1AppEventExpenceDeleteDelete(
      {@Body() required ExpenceEvent? expenceEvent});

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
  ///@param expenceEvent expenceEvent
  Future<chopper.Response> apiV1AppEventExpenceUpdatePut(
      {required ExpenceEvent? expenceEvent}) {
    generatedMapping.putIfAbsent(
        ExpenceEvent, () => ExpenceEvent.fromJsonFactory);

    return _apiV1AppEventExpenceUpdatePut(expenceEvent: expenceEvent);
  }

  ///updateExpence
  ///@param expenceEvent expenceEvent
  @Put(path: '/api/v1/app/event/expence/update')
  Future<chopper.Response> _apiV1AppEventExpenceUpdatePut(
      {@Body() required ExpenceEvent? expenceEvent});

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

  ///retrieveEventsByEventId
  ///@param eventid eventid
  Future<chopper.Response<Event>> apiV1AppEventFindeventbyeventidGet(
      {required int? eventid}) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiV1AppEventFindeventbyeventidGet(eventid: eventid);
  }

  ///retrieveEventsByEventId
  ///@param eventid eventid
  @Get(path: '/api/v1/app/event/findeventbyeventid')
  Future<chopper.Response<Event>> _apiV1AppEventFindeventbyeventidGet(
      {@Query('eventid') required int? eventid});

  ///save
  ///@param event event
  Future<chopper.Response<Event>> apiV1AppEventSavePost(
      {required Event? event}) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiV1AppEventSavePost(event: event);
  }

  ///save
  ///@param event event
  @Post(path: '/api/v1/app/event/save')
  Future<chopper.Response<Event>> _apiV1AppEventSavePost(
      {@Body() required Event? event});

  ///update
  ///@param event event
  Future<chopper.Response> apiV1AppEventUpdatePut({required Event? event}) {
    generatedMapping.putIfAbsent(Event, () => Event.fromJsonFactory);

    return _apiV1AppEventUpdatePut(event: event);
  }

  ///update
  ///@param event event
  @Put(path: '/api/v1/app/event/update')
  Future<chopper.Response> _apiV1AppEventUpdatePut(
      {@Body() required Event? event});

  ///addProductToWorkstation
  ///@param workstation workstation
  Future<chopper.Response<Workstation>> apiV1AppEventWorkstationAddproductPost(
      {required Workstation? workstation}) {
    generatedMapping.putIfAbsent(
        Workstation, () => Workstation.fromJsonFactory);

    return _apiV1AppEventWorkstationAddproductPost(workstation: workstation);
  }

  ///addProductToWorkstation
  ///@param workstation workstation
  @Post(path: '/api/v1/app/event/workstation/addproduct')
  Future<chopper.Response<Workstation>> _apiV1AppEventWorkstationAddproductPost(
      {@Body() required Workstation? workstation});

  ///createWorkstation
  ///@param workstation workstation
  Future<chopper.Response<Workstation>> apiV1AppEventWorkstationCreatePost(
      {required Workstation? workstation}) {
    generatedMapping.putIfAbsent(
        Workstation, () => Workstation.fromJsonFactory);

    return _apiV1AppEventWorkstationCreatePost(workstation: workstation);
  }

  ///createWorkstation
  ///@param workstation workstation
  @Post(path: '/api/v1/app/event/workstation/create')
  Future<chopper.Response<Workstation>> _apiV1AppEventWorkstationCreatePost(
      {@Body() required Workstation? workstation});

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

  ///updateOrder
  ///@param orderEntity orderEntity
  Future<chopper.Response> apiV1AppOrderUpdatePut(
      {required OrderEntity? orderEntity}) {
    generatedMapping.putIfAbsent(
        OrderEntity, () => OrderEntity.fromJsonFactory);

    return _apiV1AppOrderUpdatePut(orderEntity: orderEntity);
  }

  ///updateOrder
  ///@param orderEntity orderEntity
  @Put(path: '/api/v1/app/order/update')
  Future<chopper.Response> _apiV1AppOrderUpdatePut(
      {@Body() required OrderEntity? orderEntity});

  ///delete
  ///@param product product
  Future<chopper.Response> apiV1AppProductsDeleteDelete(
      {required Product? product}) {
    generatedMapping.putIfAbsent(Product, () => Product.fromJsonFactory);

    return _apiV1AppProductsDeleteDelete(product: product);
  }

  ///delete
  ///@param product product
  @Delete(path: '/api/v1/app/products/delete')
  Future<chopper.Response> _apiV1AppProductsDeleteDelete(
      {@Body() required Product? product});

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
  ///@param product product
  Future<chopper.Response<Product>> apiV1AppProductsSavePost(
      {required Product? product}) {
    generatedMapping.putIfAbsent(Product, () => Product.fromJsonFactory);

    return _apiV1AppProductsSavePost(product: product);
  }

  ///save
  ///@param product product
  @Post(path: '/api/v1/app/products/save')
  Future<chopper.Response<Product>> _apiV1AppProductsSavePost(
      {@Body() required Product? product});

  ///update
  ///@param product product
  Future<chopper.Response> apiV1AppProductsUpdatePut(
      {required Product? product}) {
    generatedMapping.putIfAbsent(Product, () => Product.fromJsonFactory);

    return _apiV1AppProductsUpdatePut(product: product);
  }

  ///update
  ///@param product product
  @Put(path: '/api/v1/app/products/update')
  Future<chopper.Response> _apiV1AppProductsUpdatePut(
      {@Body() required Product? product});

  ///delete
  ///@param storage storage
  Future<chopper.Response> apiV1AppStorageDeleteDelete(
      {required Storage? storage}) {
    generatedMapping.putIfAbsent(Storage, () => Storage.fromJsonFactory);

    return _apiV1AppStorageDeleteDelete(storage: storage);
  }

  ///delete
  ///@param storage storage
  @Delete(path: '/api/v1/app/storage/delete')
  Future<chopper.Response> _apiV1AppStorageDeleteDelete(
      {@Body() required Storage? storage});

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

  ///emptystorage
  ///@param storageId storageId
  Future<chopper.Response> apiV1AppStorageEmptystoragePut(
      {required int? storageId}) {
    return _apiV1AppStorageEmptystoragePut(storageId: storageId);
  }

  ///emptystorage
  ///@param storageId storageId
  @Put(
    path: '/api/v1/app/storage/emptystorage',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppStorageEmptystoragePut(
      {@Query('storageId') required int? storageId});

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

  ///loadAmountOnStorage
  ///@param loadUnloadModel loadUnloadModel
  Future<chopper.Response> apiV1AppStorageLoadPut(
      {required List<LoadUnloadModel>? loadUnloadModel}) {
    return _apiV1AppStorageLoadPut(loadUnloadModel: loadUnloadModel);
  }

  ///loadAmountOnStorage
  ///@param loadUnloadModel loadUnloadModel
  @Put(path: '/api/v1/app/storage/load')
  Future<chopper.Response> _apiV1AppStorageLoadPut(
      {@Body() required List<LoadUnloadModel>? loadUnloadModel});

  ///save
  ///@param storage storage
  Future<chopper.Response<Storage>> apiV1AppStorageSavePost(
      {required Storage? storage}) {
    generatedMapping.putIfAbsent(Storage, () => Storage.fromJsonFactory);

    return _apiV1AppStorageSavePost(storage: storage);
  }

  ///save
  ///@param storage storage
  @Post(path: '/api/v1/app/storage/save')
  Future<chopper.Response<Storage>> _apiV1AppStorageSavePost(
      {@Body() required Storage? storage});

  ///setstockzerotonegativeproducts
  ///@param storageId storageId
  Future<chopper.Response> apiV1AppStorageSetstockzerotonegativeproductsPut(
      {required int? storageId}) {
    return _apiV1AppStorageSetstockzerotonegativeproductsPut(
        storageId: storageId);
  }

  ///setstockzerotonegativeproducts
  ///@param storageId storageId
  @Put(
    path: '/api/v1/app/storage/setstockzerotonegativeproducts',
    optionalBody: true,
  )
  Future<chopper.Response> _apiV1AppStorageSetstockzerotonegativeproductsPut(
      {@Query('storageId') required int? storageId});

  ///unloadAmountOnStorage
  ///@param loadUnloadModel loadUnloadModel
  Future<chopper.Response> apiV1AppStorageUnloadPut(
      {required List<LoadUnloadModel>? loadUnloadModel}) {
    return _apiV1AppStorageUnloadPut(loadUnloadModel: loadUnloadModel);
  }

  ///unloadAmountOnStorage
  ///@param loadUnloadModel loadUnloadModel
  @Put(path: '/api/v1/app/storage/unload')
  Future<chopper.Response> _apiV1AppStorageUnloadPut(
      {@Body() required List<LoadUnloadModel>? loadUnloadModel});

  ///update
  ///@param storage storage
  Future<chopper.Response> apiV1AppStorageUpdatePut(
      {required Storage? storage}) {
    generatedMapping.putIfAbsent(Storage, () => Storage.fromJsonFactory);

    return _apiV1AppStorageUpdatePut(storage: storage);
  }

  ///update
  ///@param storage storage
  @Put(path: '/api/v1/app/storage/update')
  Future<chopper.Response> _apiV1AppStorageUpdatePut(
      {@Body() required Storage? storage});

  ///delete
  ///@param supplier supplier
  Future<chopper.Response> apiV1AppSuppliersDeleteDelete(
      {required Supplier? supplier}) {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppSuppliersDeleteDelete(supplier: supplier);
  }

  ///delete
  ///@param supplier supplier
  @Delete(path: '/api/v1/app/suppliers/delete')
  Future<chopper.Response> _apiV1AppSuppliersDeleteDelete(
      {@Body() required Supplier? supplier});

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
  ///@param supplier supplier
  Future<chopper.Response<Supplier>> apiV1AppSuppliersSavePost(
      {required Supplier? supplier}) {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppSuppliersSavePost(supplier: supplier);
  }

  ///save
  ///@param supplier supplier
  @Post(path: '/api/v1/app/suppliers/save')
  Future<chopper.Response<Supplier>> _apiV1AppSuppliersSavePost(
      {@Body() required Supplier? supplier});

  ///update
  ///@param supplier supplier
  Future<chopper.Response> apiV1AppSuppliersUpdatePut(
      {required Supplier? supplier}) {
    generatedMapping.putIfAbsent(Supplier, () => Supplier.fromJsonFactory);

    return _apiV1AppSuppliersUpdatePut(supplier: supplier);
  }

  ///update
  ///@param supplier supplier
  @Put(path: '/api/v1/app/suppliers/update')
  Future<chopper.Response> _apiV1AppSuppliersUpdatePut(
      {@Body() required Supplier? supplier});

  ///delete
  ///@param userEntity userEntity
  Future<chopper.Response> apiV1AppUsersDeleteDelete(
      {required UserEntity? userEntity}) {
    generatedMapping.putIfAbsent(UserEntity, () => UserEntity.fromJsonFactory);

    return _apiV1AppUsersDeleteDelete(userEntity: userEntity);
  }

  ///delete
  ///@param userEntity userEntity
  @Delete(path: '/api/v1/app/users/delete')
  Future<chopper.Response> _apiV1AppUsersDeleteDelete(
      {@Body() required UserEntity? userEntity});

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
  ///@param userEntity userEntity
  Future<chopper.Response> apiV1AppUsersSavePost(
      {required UserEntity? userEntity}) {
    generatedMapping.putIfAbsent(UserEntity, () => UserEntity.fromJsonFactory);

    return _apiV1AppUsersSavePost(userEntity: userEntity);
  }

  ///save
  ///@param userEntity userEntity
  @Post(path: '/api/v1/app/users/save')
  Future<chopper.Response> _apiV1AppUsersSavePost(
      {@Body() required UserEntity? userEntity});

  ///update
  ///@param userEntity userEntity
  Future<chopper.Response> apiV1AppUsersUpdatePut(
      {required UserEntity? userEntity}) {
    generatedMapping.putIfAbsent(UserEntity, () => UserEntity.fromJsonFactory);

    return _apiV1AppUsersUpdatePut(userEntity: userEntity);
  }

  ///update
  ///@param userEntity userEntity
  @Put(path: '/api/v1/app/users/update')
  Future<chopper.Response> _apiV1AppUsersUpdatePut(
      {@Body() required UserEntity? userEntity});

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

  ///updateWorkstation
  ///@param workstation workstation
  Future<chopper.Response<Workstation>> apiV1AppWorkstationUpdatePut(
      {required Workstation? workstation}) {
    generatedMapping.putIfAbsent(
        Workstation, () => Workstation.fromJsonFactory);

    return _apiV1AppWorkstationUpdatePut(workstation: workstation);
  }

  ///updateWorkstation
  ///@param workstation workstation
  @Put(path: '/api/v1/app/workstation/update')
  Future<chopper.Response<Workstation>> _apiV1AppWorkstationUpdatePut(
      {@Body() required Workstation? workstation});

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
