import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vat_calculator/client/fattureICloud/model/response_ndc_api.dart';
import 'package:vat_calculator/client/fattureICloud/constant/utils_icloud.dart';

import 'model/request_api.dart';
import 'model/request_info.dart';
import 'model/request_info_company.dart';
import 'model/request_retrieve_fornitori.dart';
import 'model/response_acquisti_api.dart';
import 'model/response_fatture_api.dart';
import 'model/response_fornitori.dart';
import 'model/response_info_company.dart';


class FattureInCloudClient {

  Future<ResponseCompanyFattureInCloud> performRichiestaGetCompanyInfo(
      String apiUid,
      String apiKey) async {
    var dio = Dio();

    String body = json.encode(
        FattureInCloudRequestInfoCompany(
            apiKey: apiKey,
            apiUid: apiUid
        ).toMap());

    Response post;
    ResponseCompanyFattureInCloud responseInfoCompany;

    try{
      post = await dio.post(
        URL_FATTURE_ICLOUD_REQUEST_INFO_ACCOUNT,
        data: body,
      );

      print('Request to retrieve info company: ' + body);
      print('Response From Icloud - Get company info (' + URL_FATTURE_ICLOUD_REQUEST_INFO_ACCOUNT + '): ' + post.data.toString());

      String encode = json.encode(post.data);


      Map valueMap = jsonDecode(encode);
      if(valueMap.containsKey('success')){
        if(valueMap['success']){
          responseInfoCompany = ResponseCompanyFattureInCloud(
            tipo_licenza: valueMap['tipo_licenza'],
            nome: valueMap['nome'],
            durata_licenza: valueMap['durata_licenza']
          );
        }else{
          print('Impossible to retrieve data from ICloudFatture for info company');
          throw Exception('Impossible to retrieve data from ICloudFatture for info company');
        }
      }

    }catch(e){
      print(e);
    }
    return responseInfoCompany;
  }

  Future<Response> performRichiestaInfo(
      String apiUid,
      String apiKey) async {

    var dio = Dio();

    String body = json.encode(
        FattureInCloudRequestInfo(
          apiKey: apiKey,
          apiUid: apiUid
        ).toMap());

    Response post;
    try{
      post = await dio.post(

        URL_FATTURE_ICLOUD_REQUEST_INFO,
        data: body,
      );

      print('Request RichiestaInfo: ' + body);
      print('Response From Icloud (' + URL_FATTURE_ICLOUD_REQUEST_INFO + '): ' + post.data.toString());

    }catch(e){
      print(e);
    }
    return post;
  }

  Future<List<SupplierModel>> performRichiestaFornitori(
      String apiUid,
      String apiKey) async {
    var dio = Dio();

    String body = json.encode(
        FattureInCloudFornitoriRequest(
          apiKey: apiKey,
          apiUid: apiUid,
          cf: '',
          piva: '',
          id: '',
          nome: '',
          filtro: '',
          pagina: 1
        ).toMap());

    Response post;
    print('Request retrieve fornitori for current fattureincloud. Body: ' + body);
    try{
      post = await dio.post(

        URL_FATTURE_ICLOUD_FORNITORI,
        data: body,
      );

      print('Response From Icloud Retrieve Fornitori (' + URL_FATTURE_ICLOUD_FORNITORI + '): ' + post.data.toString());

    }catch(e){
      print(e);
    }
    return convertDataResponseIntoFornitoriList(post);
  }

  Future<List<ResponseAcquistiApi>> retrieveListaAcquisti(
      String apiUid,
      String apiKey,
      DateTime startDate,
      DateTime endDate,
      String idFornitore,
      String fornitore,
      int year) async {

    var dio = Dio();

    String body = json.encode(
        FattureInCloudRequest(
          apiKey: apiKey,
          apiUid: apiUid,
          year: year,
          dataFine: buildDateAsFormattedString(endDate),
          dataInizio: buildDateAsFormattedString(startDate),
          fornitore: fornitore,
          idFornitore: idFornitore,
          mostraLinkAllegato: '',
          saldato: '',

    ).toMap());

    Response post;
    try{
      post = await dio.post(
        URL_FATTURE_ICLOUD_ACQUISTI_LISTA,
        data: body,
      );

      print('Request (ResponseAcquistiApi expected as output)' + body);
      print('Response From Icloud (' + URL_FATTURE_ICLOUD_ACQUISTI_LISTA + '): ' + post.data.toString());

    }catch(e){
      print(e);
    }
    return convertResponseIntoListResponseAcquistiApi(post);
  }

  Future<List<ResponseFattureApi>> retrieveListaFatture(
      String apiUid,
      String apiKey,
      DateTime startDate,
      DateTime endDate,
      String idFornitore,
      String fornitore,
      int year) async {

    var dio = Dio();

    String body = json.encode(
        FattureInCloudRequest(
          apiKey: apiKey,
          apiUid: apiUid,
          year: year,
          dataFine: buildDateAsFormattedString(endDate),
          dataInizio: buildDateAsFormattedString(startDate),
          fornitore: fornitore,
          idFornitore: idFornitore,
          mostraLinkAllegato: '',
          saldato: '',

        ).toMap());

    Response post;
    try{
      post = await dio.post(
        URL_FATTURE_ICLOUD_FATTURE_LISTA,
        data: body,
      );
      print('Request' + body);
      print('Response From Icloud fatture (' + URL_FATTURE_ICLOUD_FATTURE_LISTA + '): ' + post.data.toString());

    }catch(e){
      print(e);
    }
    return convertResponseIntoListResponseFattureApi(post);
  }

  Future<List<ResponseNDCApi>> retrieveListaNdc(
      String apiUid,
      String apiKey,
      DateTime startDate,
      DateTime endDate,
      String idFornitore,
      String fornitore,
      int year) async {

    var dio = Dio();

    String body = json.encode(
        FattureInCloudRequest(
          apiKey: apiKey,
          apiUid: apiUid,
          year: year,
          dataFine: buildDateAsFormattedString(endDate),
          dataInizio: buildDateAsFormattedString(startDate),
          fornitore: fornitore,
          idFornitore: idFornitore,
          mostraLinkAllegato: '',
          saldato: '',

        ).toMap());

    Response post;
    try{
      post = await dio.post(
        URL_FATTURE_ICLOUD_NDC_LISTA,
        data: body,
      );
      print('Request' + body);
      print('Response From Icloud (' + URL_FATTURE_ICLOUD_NDC_LISTA + '): ' + post.data.toString());

    }catch(e){
      print(e);
    }
    return convertResponseIntoListResponseNdcApi(post);
  }

  //Utils methods
  buildDateAsFormattedString(DateTime date) {
    String currentDay;
    if(date.day < 10){
      currentDay = "0" + date.day.toString();
    }else{
      currentDay = date.day.toString();
    }

    String currentMonth;
    if(date.month < 10){
      currentMonth = "0" + date.month.toString();
    }else{
      currentMonth = date.month.toString();
    }

      return currentDay + "/" + currentMonth + "/" + date.year.toString();

  }

  List<ResponseAcquistiApi> convertResponseIntoListResponseAcquistiApi(Response post) {
    List<ResponseAcquistiApi> listOut = [];

    String encode = json.encode(post.data);

    Map valueMap = jsonDecode(encode);
    if(valueMap.containsKey('success')){
      if(valueMap['success']){
        if(valueMap.containsKey('lista_documenti')){
          List<dynamic> listDocuments = valueMap['lista_documenti'];
          listDocuments.forEach((currentFattura) {
            listOut.add(ResponseAcquistiApi.fromMap(currentFattura));
          });
        }
      }else{
        throw Exception('Impossible to retrieve data from ICloudFatture');
      }
    }
    return listOut;
  }

  List<ResponseFattureApi> convertResponseIntoListResponseFattureApi(Response post) {
    List<ResponseFattureApi> listOut = [];

    String encode = json.encode(post.data);

    Map valueMap = jsonDecode(encode);
    if(valueMap.containsKey('success')){
      if(valueMap['success']){
        if(valueMap.containsKey('lista_documenti')){
          List<dynamic> listDocuments = valueMap['lista_documenti'];
          listDocuments.forEach((currentFattura) {
            listOut.add(ResponseFattureApi.fromMap(currentFattura));
          });
        }
      }else{
        throw Exception('Impossible to retrieve data from ICloudFatture');
      }
    }
    return listOut;
  }

  List<ResponseNDCApi> convertResponseIntoListResponseNdcApi(Response post) {
    List<ResponseNDCApi> listOut = [];

    String encode = json.encode(post.data);

    Map valueMap = jsonDecode(encode);
    if(valueMap.containsKey('success')){
      if(valueMap['success']){
        if(valueMap.containsKey('lista_documenti')){
          List<dynamic> listDocuments = valueMap['lista_documenti'];
          listDocuments.forEach((currentNdc) {
            listOut.add(ResponseNDCApi.fromMap(currentNdc));
          });
        }
      }else{
        throw Exception('Impossible to retrieve data from ICloudFatture');
      }
    }
    return listOut;
  }

  List<SupplierModel> convertDataResponseIntoFornitoriList(Response post) {
    List<SupplierModel> listOut = [];

    String encode = json.encode(post.data);

    Map valueMap = jsonDecode(encode);
    if(valueMap.containsKey('success')){
      if(valueMap['success']){

        if(valueMap.containsKey('lista_fornitori')){
          List<dynamic> listDocuments = valueMap['lista_fornitori'];
          print('pina');
          print(listDocuments.length);
          listDocuments.forEach((currentFornitore) {
            listOut.add(SupplierModel.fromMap(currentFornitore));
          });
        }

      }else{
        throw Exception('Impossible to retrieve data from ICloudFatture');
      }
    }
    print(listOut.toSet().toList().length);
    listOut.toSet().toList().forEach((element) {
      print(element.nome);
    });

    return listOut.toSet().toList();
  }
}