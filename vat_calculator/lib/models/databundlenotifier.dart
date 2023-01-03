import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../swagger/swagger.models.swagger.dart';
import '../swagger/swagger.swagger.dart';

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

  void refreshCurrentBranchDataWithStorageTrakingId(int storageId) async {
    Response response = await getSwaggerClient().apiV1AppBranchesRetrievebranchbyidGet(branchid: _currentBranch.branchId!.toInt());
    if(response.isSuccessful){
      Branch branch = response.body;
      setBranch(branch);
      if(branch.storages!.isNotEmpty){
        setStorage(branch.storages!.where((element) => element.storageId == storageId).first);
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

  late Event _currentEventModel;

  void setCurrentEvent(Event eventModel) {
    _currentEventModel = eventModel;
    notifyListeners();
  }

  Event getCurrentEvent(){
    return _currentEventModel;
  }

  void refreshEventById(Workstation workstation) {
    _currentEventModel.workstations!.add(workstation);
    notifyListeners();
  }

  List<RWorkstationProduct> _listBarProduct = [];
  List<RWorkstationProduct> _listChampagnerieProduct = [];

  List<RWorkstationProduct> getListBarProduct(){
    return _listBarProduct;
  }

  List<RWorkstationProduct> getListChampagnerieProduct(){
    return _listChampagnerieProduct;
  }

  void addProdToBarListProd(RWorkstationProduct rWorkstationProduct) {
    _listBarProduct.add(rWorkstationProduct);
    notifyListeners();
  }

  void removeProdFromBarListProduct(RWorkstationProduct product) {
    _listBarProduct.removeWhere((element) => element.productId == product.productId);
    notifyListeners();
  }

  void addSavedProductToSupplierList(Product body, int supplierId) {
    _currentBranch.suppliers!.where((element) => element.supplierId == supplierId).first.productList!.add(body);
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






























































  // ====================================== OLD CODE TO REMOVE ALLLLLLLL ==========================================================////////////////////////////////////


  }