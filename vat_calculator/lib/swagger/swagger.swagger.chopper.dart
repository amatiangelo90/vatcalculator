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
