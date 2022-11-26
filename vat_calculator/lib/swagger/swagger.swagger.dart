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
        baseUrl: baseUrl ??
            'http://servicedbacorp741w.com:8444/ventimetriquadriservice');
    return _$Swagger(newClient);
  }

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
