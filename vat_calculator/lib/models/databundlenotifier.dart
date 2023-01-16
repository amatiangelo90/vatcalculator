import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import '../swagger/swagger.models.swagger.dart';
import '../swagger/swagger.swagger.dart';

class DataBundleNotifier extends ChangeNotifier {

  String baseUrlHttps = 'https://servicedbacorp741w.com:8444/ventimetriservice';

  String baseUrlHttp = 'http://servicedbacorp741w.com:8080/ventimetriquadriservice';

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
  Workstation _currentWorkstation = Workstation(workstationId: 0);
  Supplier _currentSupplier = Supplier(supplierId: 0);


  void setCurrentSupplier(Supplier supplier) {
    _currentSupplier = supplier;
    notifyListeners();
  }

  void updateProfile(String name, String lastname, String phone, bool isComplete) {
    _userEntity.name = name;
    _userEntity.lastname = lastname;
    _userEntity.phone = phone;
    _userEntity.profileCompleted = isComplete;
    notifyListeners();
  }

  Supplier getCurrentSupplier(){
    return _currentSupplier;
  }

  void removeProductFromCurrentSupplier(num productId){
    _currentSupplier.productList!.removeWhere((element) => element.productId == productId);
    notifyListeners();
  }
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
    if(_currentBranch!.storages!.isNotEmpty){
      setStorage(_currentBranch.storages!.first);
    }
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

  void setCurrentWorkstation(Workstation workstation) {
    _currentWorkstation = workstation;
    notifyListeners();
  }

  Workstation getCurrentWorkstation(){
    return _currentWorkstation;
  }

  void updateCurrentWorkstation(String nameWorkstaiton, String responsable, num workstationID) {
    for(Workstation workstation in getCurrentEvent().workstations!){
      if(workstation.workstationId == workstationID){
        workstation.name = nameWorkstaiton;
        workstation.responsable = responsable;
      }
    }
    notifyListeners();

  }

  void configureLoadByAmountHundred(double pax) {

    for (var prod in _currentWorkstation.products!) {
      prod.amountLoad = (prod.amountHundred! * pax) / 100 ;
    }

    notifyListeners();
  }
  List<ROrderProduct> buildROrderProductFromSupplierProdList(List<Product> productList) {

    List<ROrderProduct> returnRProdList = [];
    productList.forEach((prod) {
      returnRProdList.add(ROrderProduct(
        productId: prod.productId,
        unitMeasure: prod.unitMeasure == ProductUnitMeasure.altro ? prod.unitMeasureOTH! : productUnitMeasureToJson(prod.unitMeasure),
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

  Map<num?, List<RStorageProduct>> getProdToGroupedBySupplierIdToPerformOrder() {
    Map<int, List<RStorageProduct>> map = {};

    for (RStorageProduct prod in getCurrentStorage().products!) {
      if(map.containsKey(prod.supplierId)){
        map[prod.supplierId!.toInt()]!.add(prod);
      }else{
        map[prod.supplierId!.toInt()] = [prod];
      }
    }
    print(map.toString());
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

  void removeSupplierFromCurrentBranch(num supplierId) {
    getCurrentBranch().suppliers!.removeWhere((element) => element.supplierId == supplierId);
    notifyListeners();
  }


  void addSavedProductToSupplierList(Product body, int supplierId) {
    _currentBranch.suppliers!.where((element) => element.supplierId == supplierId).first.productList!.add(body);
    notifyListeners();
  }


  String getSupplierNameById(num key) {
    String name = '';
    for (var element in getCurrentBranch().suppliers!) {
      if(element.supplierId == key){
        name = element.name!;
      }
    }

    return name;
  }

  void clearAmountOrderFromCurrentStorageProductList() {
    for (var prod in getCurrentStorage().products!) {
      prod.orderAmount = 0;
    }
    notifyListeners();
  }

  Storage getStorageById(num storageId) {
    return getCurrentBranch().storages!.where((element) => element.storageId == storageId).first;
  }

  void addRWorkstationProductToCurrentWorkstation(RWorkstationProduct rWorkstationProduct) {
    _currentWorkstation.products!.add(rWorkstationProduct);
    notifyListeners();
  }

  void removeProductFromCurrentWorkstation(RWorkstationProduct rWorkstationProduct) {
    _currentWorkstation.products!.removeWhere((element) => element.workstationProductId == rWorkstationProduct.workstationProductId);
    notifyListeners();
  }

  void removeWorkstationFromEvent(num workstationId) {
    _currentEventModel.workstations!.removeWhere((element) => element.workstationId == workstationId);
    notifyListeners();
  }

  void addSupplierToCurrentBranch(Supplier supplier) {
    getCurrentBranch().suppliers!.add(supplier);
    notifyListeners();
  }

  void replaceProductUpdatedIntoCurrentSupplier(Product product) {
    int currentPositionListToReplace = 0;

    for(int i = 0; i < getCurrentSupplier()!.productList!.length; i++){
      if(product.productId == getCurrentSupplier()!.productList![i].productId){
        currentPositionListToReplace = i;
      }
    }

    getCurrentSupplier().productList![currentPositionListToReplace] = product;
    notifyListeners();
  }

  void setGiacenza0ToProductIntoCurrentWorkstation(int id) {
    getCurrentWorkstation().products!.where((element) => element.workstationProductId == id).first.leftOvers = 0;
    notifyListeners();
  }

  void setExpenceToCurrentEvent(ExpenceEvent expence) {
    getCurrentEvent().expenceEvents!.add(expence);
    notifyListeners();
  }

  void removeExpence(ExpenceEvent currentEventExpence) {
    getCurrentEvent().expenceEvents!.removeWhere((element) => element.expenceId == currentEventExpence.expenceId);
    notifyListeners();
  }

  void updateExpenceToCurrentEvent({required double amount,
    required num expenceId,
    required String description,
    required double price,
    required int eventId}) {

    int idToReplace = 0;

    for(int i = 0; i < getCurrentEvent().expenceEvents!.length; i++){
      if(getCurrentEvent().expenceEvents![i]!.expenceId! == expenceId){
        idToReplace = i;
        break;
      }
    }
    getCurrentEvent().expenceEvents![idToReplace] = ExpenceEvent(eventId: eventId, price: price, description: description, amount: amount, expenceId: expenceId);
    notifyListeners();
  }

  String getTotalFromCurrentExpenceList() {
    double tot = 0.0;
    getCurrentEvent().expenceEvents!.forEach((element) {
      tot = tot + (element.price! * element.amount!);
    });
    return tot.toStringAsFixed(2).replaceAll('.00', '');
  }

  List<Event> _currentEventsClosed = [];

  List<Event> getListEventClosed(){
    return _currentEventsClosed;
  }
  void setClosedEventList(List<Event> eventClosed) {
    _currentEventsClosed.clear();
    _currentEventsClosed.addAll(eventClosed);
    notifyListeners();
  }

  Supplier _supplierToCreateNew = Supplier(supplierId: 0);

  Supplier getSupplierToCreateNew(){
    return _supplierToCreateNew;
  }

  void clearSupplier(){
    _supplierToCreateNew = Supplier(supplierId: 0);
    notifyListeners();
  }
  void setCurrentSupplierToCreateNew(Contact? contact) {
    _supplierToCreateNew = Supplier(
      name: contact!.name!.first + ' ' +  contact!.name!.last ?? '',
      phoneNumber: contact!.phones.first.number ?? '',
      email: contact!.emails!.isEmpty ? '' : contact!.emails!.first.address ?? '',
    );
    notifyListeners();
  }


  OrderEntity _orderToReview = OrderEntity(orderId: 0);

  void setCurrentOrderToReview(OrderEntity order) {
    _orderToReview = order;
    notifyListeners();
  }

  OrderEntity getOrderToReview(){
    return _orderToReview;
  }
}