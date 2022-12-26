import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vat_calculator/client/email_sender/emailservice.dart';
import 'package:vat_calculator/client/vatservice/model/response_fornitori.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';
import 'package:vat_calculator/client/vatservice/model/order_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_model.dart';
import 'package:vat_calculator/client/vatservice/model/product_order_amount_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_model.dart';
import 'package:vat_calculator/client/vatservice/model/storage_product_model.dart';
import 'package:vat_calculator/client/vatservice/model/user_model.dart';
import 'package:vat_calculator/client/vatservice/model/workstation_model.dart';
import 'package:vat_calculator/components/vat_data.dart';
import 'package:vat_calculator/swagger/swagger.enums.swagger.dart';
import '../client/firebase_service/firebase_messaging_service_impl.dart';
import '../client/vatservice/model/expence_event_model.dart';
import '../client/vatservice/model/workstation_product_model.dart';
import '../constants.dart';
import '../swagger/swagger.models.swagger.dart';
import '../swagger/swagger.swagger.dart';
import 'bundle_users_storage_supplier_forbranch.dart';
import 'databundle.dart';



class DataBundleNotifier extends ChangeNotifier {

  String baseUrlHttps = 'https://servicedbacorp741w.com:8444/ventimetriservice';

  String baseUrlHttp = 'http://localhost:16172/ventimetriquadriservice';

  Swagger getSwaggerClient(){
    if(kIsWeb){
      return Swagger.create(
          baseUrl: baseUrlHttps
      );
    }else{
      return Swagger.create(
          baseUrl: baseUrlHttp
      );
    }
  }
  UserEntity _userEntity = UserEntity(userId: 0);
  Branch _currentBranch = Branch(branchId: 0);
  Storage _currentStorage = Storage(storageId: 0);


  void refreshCurrentBranchData() async {
    Response response = await getSwaggerClient().apiV1AppBranchesRetrievebranchbyidGet(branchid: _currentBranch.branchId!.toInt());
    if(response.isSuccessful){
      Branch branch = response.body;
      setBranch(branch);
      if(branch.storages!.isNotEmpty){
        setStorage(branch.storages!.first);
      }

    }else{
      print(response.error);
      print(response.base.headers.toString());
    }
    notifyListeners();
  }
  void setBranch(Branch branch){
    _currentBranch = branch;
    notifyListeners();
  }

  void setUser(UserEntity user){
    print('Set user to databundle: ' + user.toJson().toString());
    _userEntity = user;
    if(user.branchList!.isNotEmpty){
      _currentBranch = user.branchList![0];
      if(_currentBranch!.storages!.isNotEmpty){
        setStorage(_currentBranch.storages!.first);
      }
    }
    notifyListeners();
  }

  void setStorage(Storage storage) {
    _currentStorage = storage;
    notifyListeners();
  }


  UserEntity getUserEntity(){
    return _userEntity;
  }

  Branch getCurrentBranch(){
    return _currentBranch;
  }

  Storage getCurrentStorage(){
    return _currentStorage;
  }



  List<ROrderProduct> buildROrderProductFromSupplierProdList(List<Product> productList) {

    List<ROrderProduct> returnRProdList = [];
    productList.forEach((prod) {
      returnRProdList.add(ROrderProduct(
        productId: prod.productId,
        unitMeasure: productUnitMeasureToJson(prod.unitMeasure),
        price: prod.price,
        amount: 0,
        productName: prod.name,
      ));
    });

    return returnRProdList;

  }

  List<ROrderProduct> basket = [];

  void resetBasket(List<Product> productList) {
    basket.clear();
    basket.addAll(buildROrderProductFromSupplierProdList(productList));
    notifyListeners();
  }

  String getProdNumberFromBasket() {
    int i = 0;
    basket.forEach((element) {
      if(element.amount != 0){
        i ++;
      }
    });
    return i.toString();
  }

  double calculateTotalFromBasket() {
    double total = 0.0;
    if(basket.isEmpty){
      return 0.0;
    }else{
      basket.forEach((element) {
        total = total + element.amount! * element.price!;
      });
    }
    return total;
  }


  Map<num?, List<Product>> getProdToAddToCurrentStorage() {
    Map<int, List<Product>> map = {};

    List<num?> alreadyIdsProductPresentIntoStorage = getIds(getCurrentStorage().products);


    for (var supplier in getCurrentBranch()!.suppliers!) {

      List<Product> products = [];
      for (var prod in supplier.productList!) {
        if(!alreadyIdsProductPresentIntoStorage.contains(prod.productId)){
          products.add(prod);
        }
      }
      if(products.isNotEmpty){
        map[supplier!.supplierId!.toInt()] = products;
      }
    }
    print('produtct: ' + map.toString());
    return map;
  }

  List<num?> getIds(List<RStorageProduct>? products) {
    List<num?> ids = [];

    for (var element in products!) {
      ids.add(element.productId);
    }
    return ids;
  }


  void addProductToCurrentStorage(body) {
    getCurrentStorage().products!.add(body);
    notifyListeners();
  }


































  // ====================================== OLD CODE TO REMOVE ALLLLLLLL ==========================================================////////////////////////////////////
  List<UserDetailsModel> userDetailsList = [
  ];

  List<SupplierModel> currentListSuppliers = [
  ];

  List<SupplierModel> currentListSuppliersDuplicated = [
  ];

  List<StorageModel> currentStorageList = [
  ];

  Map<int, BundleUserStorageSupplier> currentMapBranchIdBundleSupplierStorageUsers = {
  };

  List<Product> currentProductModelListForSupplier = [
  ];

  List<Product> currentProductModelListForSupplierDuplicated = [
  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorage = [
  ];

  List<StorageProductModel> currentStorageProductListForCurrentStorageDuplicated = [];
  List<Product> productToAddToStorage = [];

  List<Product> productToAddToStorageDuplicated = [];

  List<OrderModel> currentOrdersForCurrentBranch = [];

  List<OrderModel> currentTodayOrdersForCurrentBranch = [];

  List<OrderModel> currentUnderWorkingOrdersList = [];

  List<String> currentBossTokenList = [];
  List<ProductModel> productListForChoicedSupplierToPerformOrder = [];
  List<CharData> charDataCreditIva = [];

  List<CharData> charDataDebitIva = [];
  List<EventModel> eventModelList = [];

  List<EventModel> eventModelListOlderThanToday = [];

  String currentPrivilegeType = '';
  ClientVatService clientService = ClientVatService();
  FirebaseMessagingService clientMessagingFirebase = FirebaseMessagingService();

  EmailSenderService emailService = EmailSenderService();
  late BranchModel currentBranch;

  late StorageModel currentStorage;
  DateTime currentDateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0);

  late DateTimeRange currentDateTimeRangeVatService;
  bool cupertinoSwitch = false;

  bool isZtoAOrderded = false;
  int daysRangeDate = DateUtils.getDaysInMonth(DateTime.now().year, DateTime.now().month);
  int currentYear = DateTime.now().year;
  DateTime currentDate = DateTime.now();

  late DateTimeRange currentWeek;
  List<ProductModel> storageTempListProduct = [];

  List<ProductOrderAmountModel> currentProdOrderModelList = [];

  Map<int, List<ProductOrderAmountModel>> orderIdProductListMap = {};

  void setCurrentPrivilegeType(String privilege){
    currentPrivilegeType = privilege;
    notifyListeners();
  }

  void setProductListForChoicedSupplierToPerformOrder(List<ProductModel> list){
    productListForChoicedSupplierToPerformOrder.clear();
    productListForChoicedSupplierToPerformOrder = list;
    notifyListeners();
  }

  ClientVatService getclientServiceInstance(){
    if(clientService == null){
      return ClientVatService();
    }else{
      return clientService;
    }
  }

  FirebaseMessagingService getclientMessagingFirebase(){
    if(clientMessagingFirebase == null){
      return FirebaseMessagingService();
    }else{
      return clientMessagingFirebase;
    }
  }

  EmailSenderService getEmailServiceInstance(){
    if(emailService == null){
      return EmailSenderService();
    }else{
      return emailService;
    }
  }

  void addAllCurrentProductSupplierList(List<Product> listProduct){

    currentProductModelListForSupplier.clear();
    currentProductModelListForSupplier.addAll(listProduct);
    currentProductModelListForSupplierDuplicated.clear();
    currentProductModelListForSupplierDuplicated.addAll(listProduct);
    notifyListeners();
  }

  void addAllCurrentListProductToProductListToAddToStorage(List<Product> listProduct){
    productToAddToStorage.clear();
    productToAddToStorage.addAll(listProduct);

    productToAddToStorageDuplicated.clear();
    productToAddToStorageDuplicated.addAll(listProduct);

    clearAndUpdateMapBundle();
    notifyListeners();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }
  bool showIvaButtonPressed = false;
  int indexIvaList = 0;

  List<int> ivaList = [22, 10, 4, 0];



  late int trimCounter;

  void addDataBundle(UserDetailsModel bundle){
    print('Adding bundle to Notifier' + bundle.email.toString());
    userDetailsList.add(bundle);
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  Future<void> addBranches(List<BranchModel> branchList) async {
    userDetailsList[0].companyList.clear();
    userDetailsList[0].companyList = branchList;

    if(userDetailsList[0].companyList.isNotEmpty){

      currentBranch = userDetailsList[0].companyList[0];
      setCurrentPrivilegeType(currentBranch.accessPrivilege);
      List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);
      currentOrdersForCurrentBranch.clear();
      currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);

      currentTodayOrdersForCurrentBranch.clear();
      orderIdProductListMap.clear();
      currentUnderWorkingOrdersList.clear();

      currentOrdersForCurrentBranch.forEach((orderItem) async {

        if(orderItem.delivery_date != null)
          currentUnderWorkingOrdersList.add(orderItem);

        DateTime currentDeliveryDate = dateFormat.parse(orderItem.delivery_date);
        if(currentDeliveryDate.day == DateTime.now().day &&
            currentDeliveryDate.month == DateTime.now().month &&
            currentDeliveryDate.year == DateTime.now().year){
          currentTodayOrdersForCurrentBranch.add(orderItem);
        }
      });
    }

    clearAndUpdateMapBundle();
    notifyListeners();
  }

  Future<void> setCurrentBranch(Branch branchModel) async {

    sleep(const Duration(milliseconds: 500));

    _currentBranch = branchModel;

    setCurrentPrivilegeType(currentBranch.accessPrivilege);


    List<EventModel> _eventModelList = await clientService.retrieveEventsListByBranchId(currentBranch);

    addCurrentEventsList(_eventModelList);
    List<SupplierModel> _supplierModelList = await clientService.retrieveSuppliersListByBranch(currentBranch);
    currentListSuppliers.clear();
    currentListSuppliersDuplicated.clear();

    currentListSuppliers.addAll(_supplierModelList);
    currentListSuppliersDuplicated.addAll(_supplierModelList);

    List<StorageModel> _storageModel = await clientService.retrieveStorageListByBranch(currentBranch);
    currentStorageList.clear();
    currentStorageList.addAll(_storageModel);

    if(currentStorageList.isNotEmpty){
      currentStorage = currentStorageList[0];
      setCurrentStorage(currentStorageList[0]);
    }
    if(currentStorageList.isNotEmpty){
      List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);

      currentStorageProductListForCurrentStorage.clear();
      currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);
    }

    List<OrderModel> retrieveOrdersByBranch = await getclientServiceInstance().retrieveOrdersByBranch(currentBranch);

    currentOrdersForCurrentBranch.clear();
    currentOrdersForCurrentBranch.addAll(retrieveOrdersByBranch);
    currentTodayOrdersForCurrentBranch.clear();
    orderIdProductListMap.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {

      print(orderItem.toMap().toString());

      if(orderItem.delivery_date != null) {
        DateTime currentDeliveryDate = dateFormat.parse(orderItem.delivery_date);

        if(currentDeliveryDate.day == DateTime.now().day &&
            currentDeliveryDate.month == DateTime.now().month &&
            currentDeliveryDate.year == DateTime.now().year) {
          currentTodayOrdersForCurrentBranch.add(orderItem);
        }
        currentUnderWorkingOrdersList.add(orderItem);
      }
    });


    List<String> tokenList = await clientService.retrieveTokenList(currentBranch);
    setCurrentBossTokenList(tokenList);
    notifyListeners();
  }

  String getCurrentDate(){
    if(currentDateTime.day == DateTime.now().day && currentDateTime.month == DateTime.now().month && currentDateTime.year == DateTime.now().year){
      return 'OGGI';
    } else {
      return currentDateTime.day.toString() + '.' + currentDateTime.month.toString() + ' - ' + getNameDayFromWeekDay(currentDateTime.weekday);
    }
  }

  void setCurrentDateTime(DateTime newDateTime){
    currentDateTime = newDateTime;
    notifyListeners();
  }

  void clearAll(){
    if(userDetailsList.isNotEmpty){
      userDetailsList.clear();
    }

    if(currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
      orderIdProductListMap.clear();
      currentUnderWorkingOrdersList.clear();
      currentTodayOrdersForCurrentBranch.clear();

    }

    if(currentListSuppliers.isNotEmpty){
      currentListSuppliers.clear();
    }
    if(currentListSuppliersDuplicated.isNotEmpty){
      currentListSuppliers.clear();
    }

    if(currentStorageList.isNotEmpty){
      currentStorageList.clear();
    }
    if(currentOrdersForCurrentBranch.isNotEmpty){
      currentOrdersForCurrentBranch.clear();
    }
    if(currentTodayOrdersForCurrentBranch.isNotEmpty){
      currentTodayOrdersForCurrentBranch.clear();
    }

    indexIvaList = 0;

    notifyListeners();
  }

  void removeOneDayToDate() {
    currentDateTime = currentDateTime.subtract(const Duration(days: 1));
    notifyListeners();
  }


  void addOneDayToDate() {
    currentDateTime = currentDateTime.add(const Duration(days: 1));
    notifyListeners();
  }

  void addCurrentSuppliersList(List<SupplierModel> suppliersModelList) {
    currentListSuppliers.clear();
    currentListSuppliersDuplicated.clear();
    currentListSuppliers.addAll(suppliersModelList);
    currentListSuppliersDuplicated.addAll(suppliersModelList);
    notifyListeners();
  }

  Future<void> setCurrentStorage(StorageModel storageModel) async {
    currentStorage = storageModel;
    List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);
    currentStorageProductListForCurrentStorage.clear();
    currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

    currentStorageProductListForCurrentStorageDuplicated.clear();
    currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);

    List<ProductModel> retrieveProductsByBranch = await getclientServiceInstance().retrieveProductsByBranch(currentBranch);

    storageTempListProduct.addAll(retrieveProductsByBranch);

    List<int> listProductIdsToRemove = [];
    currentStorageProductListForCurrentStorage.forEach((currentProductAlreadyPresent) {
      listProductIdsToRemove.add(currentProductAlreadyPresent.fkProductId);
    });

    retrieveProductsByBranch.removeWhere((element) =>
        listProductIdsToRemove.contains(element.pkProductId),
    );

    //addAllCurrentListProductToProductListToAddToStorage(retrieveProductsByBranch);
    notifyListeners();
  }

  Future<void> refreshProductListAfterInsertProductIntoStorage() async {

    List<StorageProductModel> storageProductModelList = await clientService.retrieveRelationalModelProductsStorage(currentStorage.pkStorageId);

    currentStorageProductListForCurrentStorage.clear();
    currentStorageProductListForCurrentStorage.addAll(storageProductModelList);

    currentStorageProductListForCurrentStorageDuplicated.clear();
    currentStorageProductListForCurrentStorageDuplicated.addAll(storageProductModelList);

    notifyListeners();
  }

  Future<void> addCurrentOrdersList(List<OrderModel> orderModelList) async {
    currentOrdersForCurrentBranch.clear();
    currentTodayOrdersForCurrentBranch.clear();
    currentOrdersForCurrentBranch.addAll(orderModelList);
    orderIdProductListMap.clear();
    currentUnderWorkingOrdersList.clear();

    currentOrdersForCurrentBranch.forEach((orderItem) async {
      if(orderItem.delivery_date != null)
        currentUnderWorkingOrdersList.add(orderItem);
      DateTime deliveryDate = dateFormat.parse(orderItem.delivery_date);
      if(deliveryDate.day == DateTime.now().day &&
          deliveryDate.month == DateTime.now().month &&
          deliveryDate.year == DateTime.now().year){

        currentTodayOrdersForCurrentBranch.add(orderItem);
      }
    });
    notifyListeners();
  }

  String getSupplierName(int fk_supplier_id) {

    String currentSupplierName = 'Fornitore Sconosciuto';

    currentListSuppliers.forEach((currentSupplier) {

      if(currentSupplier.pkSupplierId == fk_supplier_id){
        currentSupplierName = currentSupplier.nome;
      }
    });
    return currentSupplierName;
  }

  Future<void> addCurrentStorageList(List<StorageModel> storageModelList) async {

    currentStorageList.clear();
    currentStorageList.addAll(storageModelList);
    if(currentStorageList.isNotEmpty){
      currentStorage = currentStorageList[0];
      List<ProductModel> retrieveProductsByBranch = await getclientServiceInstance().retrieveProductsByBranch(currentBranch);
      List<int> listProductIdsToRemove = [];
      print('coming list size ' + retrieveProductsByBranch.length.toString());
      currentStorageProductListForCurrentStorage.forEach((currentProductAlreadyPresent) {
        listProductIdsToRemove.add(currentProductAlreadyPresent.fkProductId);
      });

      retrieveProductsByBranch.removeWhere((element) =>
          listProductIdsToRemove.contains(element.pkProductId),
      );

      print('coming list size ' + retrieveProductsByBranch.length.toString());
      //addAllCurrentListProductToProductListToAddToStorage(retrieveProductsByBranch);
    }

    if(currentStorageList.isNotEmpty) {
      List<StorageProductModel> storageProductModelList = await clientService
          .retrieveRelationalModelProductsStorage(
          currentStorageList[0].pkStorageId);
      currentStorageProductListForCurrentStorage.clear();
      currentStorageProductListForCurrentStorage.addAll(
          storageProductModelList);

      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(
          storageProductModelList);
    }
    clearAndUpdateMapBundle();
    notifyListeners();
  }

  List<String> retrieveListStoragesName(){
    List<String> listNames = [];

    currentStorageList.forEach((element) {
      listNames.add(element.name);
    });

    return listNames;
  }

  String retrieveSupplierById(int supplierId) {
    String currentSupplier = '';
    currentListSuppliers.forEach((element) {
      if(element.pkSupplierId == supplierId){
        currentSupplier = element.nome;
      }
    });
    return currentSupplier;
  }

  void filterCurrentListSupplierByName(String currentText) {
    if(currentText == ''){
      currentListSuppliersDuplicated.clear();
      currentListSuppliersDuplicated.addAll(currentListSuppliers);
    }else {

      List<SupplierModel> listTemp = [];
      currentListSuppliers.forEach((element) {
        if(element.nome.toLowerCase().contains(currentText.toLowerCase())
            || element.extra.toLowerCase().contains(currentText.toLowerCase())){
          listTemp.add(
              element
          );
        }
      });
      currentListSuppliersDuplicated.clear();
      currentListSuppliersDuplicated.addAll(listTemp);
    }
    notifyListeners();
  }

  void filterCurrentListProductByName(String currentText) {

    if(currentText == ''){
      currentProductModelListForSupplierDuplicated.clear();
      currentProductModelListForSupplierDuplicated.addAll(currentProductModelListForSupplier);
    }else{


      List<Product> listTemp = [];
      currentProductModelListForSupplier.forEach((element) {
        if(element.name!.toLowerCase().contains(currentText.toLowerCase())){
          listTemp.add(element);
        }
      });
      currentProductModelListForSupplierDuplicated.clear();
      currentProductModelListForSupplierDuplicated.addAll(listTemp);
    }
    notifyListeners();
  }

  void filterStorageProductList(String currentText) {

    if(currentText == '' || currentText == 'Tutti i fornitori'){
      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(currentStorageProductListForCurrentStorage);
    }else{

      List<StorageProductModel> listTemp = [];
      currentStorageProductListForCurrentStorage.forEach((element) {

        if(element.productName.toLowerCase().contains(currentText.toLowerCase()) ||
            element.supplierName.toLowerCase().contains(currentText.toLowerCase())){
          listTemp.add(element);
        }
      });
      currentStorageProductListForCurrentStorageDuplicated.clear();
      currentStorageProductListForCurrentStorageDuplicated.addAll(listTemp);
    }
    notifyListeners();
  }

  refreshSearchButtonStoreConfiguration(){
    isZtoAOrderded = false;
    notifyListeners();
  }

  void sortCurrentStorageListDuplicatedFromAToZ() {
    if(isZtoAOrderded){
      currentStorageProductListForCurrentStorageDuplicated.sort((a, b) => a.productName.toLowerCase().compareTo(b.productName.toLowerCase()));
      isZtoAOrderded = false;
    }else{
      currentStorageProductListForCurrentStorageDuplicated.sort((a, b) => b.productName.toLowerCase().compareTo(a.productName.toLowerCase()));
      isZtoAOrderded = true;
    }


    notifyListeners();
  }

  void clearAndUpdateMapBundle() {
    currentMapBranchIdBundleSupplierStorageUsers.clear();
    userDetailsList[0].companyList.forEach((currentBranch) async {

      List<StorageModel> listStorages = await getclientServiceInstance().retrieveStorageListByBranch(BranchModel(
          pkBranchId: currentBranch.pkBranchId, companyName: '', phoneNumber: '', city: '', cap: 0, address: '', accessPrivilege: '', apiKeyOrUser: '', apiUidOrPassword: '', eMail: '' ,providerFatture: '', token: '', vatNumber: ''
      ));

      List<SupplierModel> listSuppliers = await getclientServiceInstance().retrieveSuppliersListByBranch(BranchModel(
          pkBranchId: currentBranch.pkBranchId, companyName: '', phoneNumber: '', city: '', cap: 0, address: '', accessPrivilege: '', apiKeyOrUser: '', apiUidOrPassword: '', eMail: '' ,providerFatture: '', token: '', vatNumber: ''
      ));

      List<UserModel> listUsers = await getclientServiceInstance().retrieveUserListRelatedWithBranchByBranchId(BranchModel(
          pkBranchId: currentBranch.pkBranchId, companyName: '', phoneNumber: '', city: '', cap: 0, address: '', accessPrivilege: '', apiKeyOrUser: '', apiUidOrPassword: '', eMail: '' ,providerFatture: '', token: '', vatNumber: ''));
      currentMapBranchIdBundleSupplierStorageUsers[currentBranch.pkBranchId] = BundleUserStorageSupplier(currentBranch.pkBranchId, listStorages, listUsers, listSuppliers);
    });
    notifyListeners();
  }

  StorageModel? getStorageFromCurrentStorageListByStorageId(int storageId) {
    StorageModel? storageResult;
    currentStorageList.forEach((storage) {
      if(storage.pkStorageId == storageId){
        storageResult = storage;
      }
    });
    return storageResult;
  }

  void updateOrderStatusById(int pk_order_id, String received_archived, String date, String closedByUser) {

    List<OrderModel> orderModelToRemove = [];

    currentUnderWorkingOrdersList.forEach((currentUnderWorkingOrderItem) {

      if(currentUnderWorkingOrderItem.pk_order_id == pk_order_id){
        orderModelToRemove.add(currentUnderWorkingOrderItem);
        currentUnderWorkingOrderItem.delivery_date = date;
        currentUnderWorkingOrderItem.status = received_archived;
        currentUnderWorkingOrderItem.closedby = closedByUser;
      }
    });

    currentUnderWorkingOrdersList.removeWhere((element) => element.pk_order_id == pk_order_id);
    notifyListeners();
  }

  void removeProviderFromCurrentBranch() {
    currentBranch.providerFatture = '';
    currentBranch.apiUidOrPassword = '';
    currentBranch.apiKeyOrUser = '';
    notifyListeners();

  }

  String retrieveNameLastNameCurrentUser() {
    if(userDetailsList.isNotEmpty){
      return userDetailsList[0].firstName + ' ' + userDetailsList[0].lastName;
    }else{
      return 'Error retrieving user name';
    }
  }

  String normalizeDayValue(int day) {
    if(day < 10){
      return '0' + day.toString();
    }else{
      return day.toString();
    }
  }

  String normalizeMonth(int month) {
    if(month < 10){
      return '0' + month.toString();
    }else{
      return month.toString();
    }
  }




  String buildKeyFromTimeRange(int i) {
    return normalizeDayValue(currentDateTimeRangeVatService.end.subtract(Duration(days: i)).day) + '/' + normalizeMonth(currentDateTimeRangeVatService.end.subtract(Duration(days: i)).month) + '/' + currentDateTimeRangeVatService.end.subtract(Duration(days: i)).year.toString();
  }

  StorageModel? retrieveStorageFromStorageListByIdName(String storageIdName) {
    StorageModel? storageModelToReturn;

    currentStorageList.forEach((storage) {
      if(storageIdName.contains(storage.name) &&
          storageIdName.contains(storage.pkStorageId.toString())){
        storageModelToReturn = storage;
      }
    });
    return storageModelToReturn;
  }

  void setIndexIvaListValue(int index) {
    indexIvaList = index;
    notifyListeners();
  }

  void removeProductToAddToStorage(ProductModel element) {
    productToAddToStorage.remove(element);
    notifyListeners();
  }

  SupplierModel? retrieveSupplierFromSupplierListByIdName(String selectedSupplier) {
    SupplierModel? supplierToReturn;
    currentListSuppliers.forEach((supplier) {
      if(selectedSupplier.contains(supplier.nome) &&
          selectedSupplier.contains(supplier.pkSupplierId.toString())){
        supplierToReturn = supplier;
      }
    });
    return supplierToReturn;
  }

  SupplierModel? retrieveSupplierFromSupplierListById(int fk_supplier_id) {
    SupplierModel? supplierToReturn;
    currentListSuppliers.forEach((supplier) {
      if(supplier.pkSupplierId == fk_supplier_id){
        supplierToReturn = supplier;
      }
    });
    return supplierToReturn;
  }

  void setCurrentProductListToSendDraftOrder(List<ProductOrderAmountModel> prodOrderModelList) {
    currentProdOrderModelList.clear();
    currentProdOrderModelList.addAll(prodOrderModelList);
    notifyListeners();
  }

  int retrieveEventsNumberForCurrentDate(DateTime date) {

    int counter = 0;
    if(eventModelList.isEmpty){
      return counter;
    }else{
      eventModelList.forEach((eventItem) {
        if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day == date.day &&
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month == date.month &&
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year == date.year){
          counter = counter + 1;
        }
      });
      return counter;
    }
  }

  int retrieveOrdersNumberForCurrentDate(DateTime date) {

    int counter = 0;
    if(currentUnderWorkingOrdersList.isEmpty){
      return counter;
    }else{
      currentUnderWorkingOrdersList.forEach((orderItem) {
        DateTime currentDeliveryDate = dateFormat.parse(orderItem.delivery_date);
        if(currentDeliveryDate.day == date.day &&
            currentDeliveryDate.month == date.month &&
            currentDeliveryDate.year == date.year){
          counter = counter + 1;
        }
      });
      return counter;
    }
  }

  List<OrderModel> retrieveOrdersUnderWorkingForCurrentDate(DateTime date) {

    List<OrderModel> orders = [];

    if(currentUnderWorkingOrdersList.isEmpty){
      return orders;
    }else{

      currentUnderWorkingOrdersList.forEach((order) {
        DateTime deliveryDate = dateFormat.parse(order.delivery_date);
        if(deliveryDate.day == date.day &&
            deliveryDate.month == date.month &&
            deliveryDate.year == date.year){
          orders.add(order);
        }
      });
      return orders;
    }
  }

  List<EventModel> retrieveEventsForCurrentDate(DateTime date) {

    List<EventModel> events = [];

    if(eventModelList.isEmpty){
      return events;
    }else{
      eventModelList.forEach((eventItem) {
        if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day == date.day &&
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month == date.month &&
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year == date.year){
          events.add(eventItem);
        }
      });
      return events;
    }
  }

  void addCurrentEventsList(List<EventModel> eventList) {
    eventModelList.clear();
    eventModelList.addAll(eventList);
    notifyListeners();
  }

  String retrieveEventsNumberOpenStatus() {
    int counter = 0;
    if(eventModelList.isEmpty){
      return counter.toString();
    }else{
      eventModelList.forEach((eventItem) {
        print(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).toString());
        if(eventItem.closed == 'N'){
          counter = counter + 1;
        }
      });
      return counter.toString();
    }
  }

  String retrieveStorageById(int fkStorageId) {
    StorageModel? storage;
    currentStorageList.forEach((element) {
      if(element.pkStorageId == fkStorageId){
        storage = element;
      }
    });
    if(storage != null && storage!.name != null && storage!.name != ''){
      return storage!.name;
    }else{
      return 'Nessun magazzino trovato';
    }
  }

  BranchModel? retrieveBranchById(int key) {
    BranchModel? branchToReturn;

    userDetailsList[0].companyList.forEach((branch) {
      if(branch.pkBranchId == key){
        branchToReturn = branch;
      }
    });
    return branchToReturn;
  }

  buildDateKey(int dateTimeRecessed) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTimeRecessed);
    return normalizeDayValue(date.day).toString()+'/'+normalizeMonth(date.month).toString()+'/'+date.year.toString();
  }

  void setCurrentDateTimeRange(DateTimeRange dateTimeRange) {
    currentDateTimeRangeVatService = dateTimeRange;
    notifyListeners();
  }

  StorageModel? getStorageModelById(int fkStorageId) {
    StorageModel? storageModel;

    currentStorageList.forEach((element) {
      if(element.pkStorageId == fkStorageId){
        storageModel = element;
      }
    });
    return storageModel;
  }

  SupplierModel? getSupplierFromList(int fk_supplier_id) {
    print('Retrieve supplier for id ' + fk_supplier_id.toString());
    SupplierModel? currentSupplierName;

    currentListSuppliers.forEach((currentSupplier) {

      if(currentSupplier.pkSupplierId == fk_supplier_id){
        currentSupplierName = currentSupplier;
      }
    });

    return currentSupplierName;
  }
  Color getProviderColor() {
    if(currentBranch == null || currentBranch.providerFatture == '' &&  currentBranch.providerFatture == null){
      return Colors.white;
    }else{
      switch(currentBranch.providerFatture){
        case 'fatture_in_cloud':
          return Colors.lightBlueAccent;
        case 'aruba':
          return Colors.orange;
        default:
          return Colors.white;
      }
    }
  }

  int areEventsOrOrderOlderThanTodayPresent() {

    int result = 0;
    if(currentUnderWorkingOrdersList.isNotEmpty){
      currentUnderWorkingOrdersList.forEach((orderItem) {
        if(orderItem != null && orderItem.delivery_date != null){

          DateTime deliveryDate = dateFormat.parse(orderItem.delivery_date);
          if(deliveryDate.day < DateTime.now().day ||
              deliveryDate.month < DateTime.now().month ||
              deliveryDate.year < DateTime.now().year){
            result = result + 1;
          }
        }
      });
    }
    if(eventModelList.isNotEmpty){
      eventModelList.forEach((eventItem) {

        if((DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).day < DateTime.now().day ||
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).month < DateTime.now().month ||
            DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).year < DateTime.now().year)
            && eventItem.closed == 'N'){

          result = result + 1;
        }
      });
    }
    return result;
  }

  List<OrderModel> getOrdersOlderThanTodayUnderWorking() {

    List<OrderModel> list = [];
    if(currentUnderWorkingOrdersList.isNotEmpty){
      currentUnderWorkingOrdersList.forEach((orderItem) {
        if(dateFormat.parse(orderItem.delivery_date).isBefore(DateTime.now())){
          list.add(orderItem);
        }
      });
    }
    return list;
  }

  List<EventModel> getEventsOlderThanTodayNotClosed() {

    List<EventModel> list = [];
    if(eventModelList.isNotEmpty){
      eventModelList.forEach((eventItem) {
        if(DateTime.fromMillisecondsSinceEpoch(eventItem.eventDate).isBefore(DateTime.now()) && eventItem.closed == 'N'){
          list.add(eventItem);
        }
      });
    }

    return list;
  }

  void setCurrentBossTokenList(List<String> tokenList) {
    currentBossTokenList.clear();
    currentBossTokenList.addAll(tokenList);
    notifyListeners();
  }

  List<ExpenceEventModel> listExpenceEvent = [];

  void addExpenceEventItem(ExpenceEventModel expenceEventModel) {
    listExpenceEvent.add(expenceEventModel);
    notifyListeners();
  }

  void updateExpenceEventItem(ExpenceEventModel expenceEventModel) {
    listExpenceEvent.forEach((expenceEvent) {
      if(expenceEventModel.pkEventExpenceId == expenceEvent.pkEventExpenceId){
        expenceEvent.amount = expenceEventModel.amount;
        expenceEvent.description = expenceEventModel.description;
        expenceEvent.cost = expenceEventModel.cost;
      }
    });
    notifyListeners();
  }

  void removeExpenceEventItem(ExpenceEventModel expenceEventModel) {
    listExpenceEvent.removeWhere((expt) =>
    expt.pkEventExpenceId == expenceEventModel.pkEventExpenceId
    );
    notifyListeners();
  }

  void cleanExtraArgsListProduct() {
    currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      element.extra = 0.0;
    });
    notifyListeners();
  }


  bool isLandingButtonPressed = false;

  void switchLandingButton(){
    if(isLandingButtonPressed){
      isLandingButtonPressed = false;
    }else{
      isLandingButtonPressed = true;
    }
    notifyListeners();
  }


  List<OrderModel> currentArchiviedWorkingOrdersList = [];
  void setCurrentArchiviedWorkingOrdersList(List<OrderModel> orderList){
    currentArchiviedWorkingOrdersList.clear();
    currentArchiviedWorkingOrdersList.addAll(orderList);
    notifyListeners();

  }

  List<WorkstationModel> currentWorkstationModelList = [];
  void setCurrentWorkstationModelList(List<WorkstationModel> workstationModelList) {
    currentWorkstationModelList.clear();
    currentWorkstationModelList.addAll(workstationModelList);
    notifyListeners();
  }

  late EventModel currentEventModel;

  void setCurrentEventModel(EventModel eventModel) {
    currentEventModel = eventModel;
    notifyListeners();
  }

  void setCurrentExpenceEventList(List<ExpenceEventModel> list){
    listExpenceEvent.clear();
    listExpenceEvent.addAll(list);
    notifyListeners();
  }

  Map<int, List<WorkstationProductModel>> workstationsProductsMap = {};

  Future<void> workstationsProductsMapCalculate() async {

    workstationsProductsMap.clear();

    await Future.forEach(currentWorkstationModelList,
            (WorkstationModel workstationModel) async {

          if(workstationsProductsMap.containsKey(workstationModel.pkWorkstationId)){
            workstationsProductsMap[workstationModel.pkWorkstationId]!.clear();
            workstationsProductsMap[workstationModel.pkWorkstationId] = await getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstationModel);
          }else{
            workstationsProductsMap[workstationModel.pkWorkstationId] = await getclientServiceInstance().retrieveWorkstationProductModelByWorkstationId(workstationModel);
          }
        });

    notifyListeners();
  }

  DateTime currentDateEvent = DateTime.now();



  void setEventDateTime(DateTime date){
    currentDateEvent = date;
    notifyListeners();
  }
  List<OrderModel> retrievedOrderModelArchiviedNotPaid = [];
  String executeLoadStorage = 'SI';

  String signAsPaid = 'NO';

  String sameTotalThanCalculated = 'NO';

  void setExdecuteLoadStorage(String value){
    executeLoadStorage = value;
    notifyListeners();
  }

  void setSignAsPaid(String value){
    signAsPaid = value;
    notifyListeners();
  }

  void setSameTotalThanCalcuated(String value){
    sameTotalThanCalculated = value;
    notifyListeners();
  }

  void removeFromUnderWorkingOrdersTheOnesUpdateAsReceived(int pk_order_id_incoming) {
    currentUnderWorkingOrdersList.removeWhere((element) => element.pk_order_id == pk_order_id_incoming);
    notifyListeners();
  }

  void setTo0ExtraFieldAfterOrderPerform(int supplierId) {
    currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      if(element.supplierId == supplierId){
        element.extra = 0.0;
      }
    });
    notifyListeners();
  }
  void refreshExtraFieldsIntoDuplicatedProductList() {
    currentStorageProductListForCurrentStorageDuplicated.forEach((element) {
      element.extra = 0.0;
    });
    notifyListeners();
  }

  DateTime marketingDate = DateTime.now();

  Map<String, List<Customer>> customersMarketingMap = {};
  void setMarketingDate(DateTime date) {
    marketingDate = date;
    notifyListeners();
  }
  Set<Customer> customerListCisternino = <Customer>{};

  Set<Customer> customerListLocorotondo = <Customer>{};

  Set<Customer> customerListMonopoli = <Customer>{};

  void setCurrentCustomerList(List<Customer> customers) {
    customerListCisternino.clear();
    customerListLocorotondo.clear();
    customerListMonopoli.clear();
    customers.forEach((customer) {
      customer.accessesList!.forEach((CustomerAccess access) {
        switch(access.branchLocation){
          case CustomerAccessBranchLocation.cisternino:
            customerListCisternino.add(customer);
            break;
          case CustomerAccessBranchLocation.locorotondo:
            customerListLocorotondo.add(customer);
            break;
          case CustomerAccessBranchLocation.monopoli:
            customerListMonopoli.add(customer);
            break;
        }
      });
    });
    notifyListeners();
  }

}
