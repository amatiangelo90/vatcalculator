import 'package:flutter/foundation.dart';
import 'package:vat_calculator/client/vatservice/client_vatservice.dart';
import 'package:vat_calculator/client/vatservice/model/branch_model.dart';
import 'package:vat_calculator/client/vatservice/model/recessed_model.dart';

import '../constants.dart';
import 'databundle.dart';

class DataBundleNotifier extends ChangeNotifier {

  List<DataBundle> dataBundleList = [
  ];

  BranchModel currentBranch;
  List<RecessedModel> currentListRecessed = [];

  DateTime currentDateTime = DateTime.now();
  bool showIvaButtonPressed = false;
  int indexIvaList = 0;
  List<int> ivaList = [22, 10, 4, 0];


  void setShowIvaButtonToFalse(){
    showIvaButtonPressed = false;
    notifyListeners();
  }

  void setShowIvaButtonToTrue(){
    showIvaButtonPressed = true;
    notifyListeners();
  }

  List<RecessedModel> getRecessedListByRangeDate(DateTime start, DateTime end){
    List<RecessedModel> listToReturn = [];
    if(currentListRecessed.isEmpty){
      return listToReturn;
    }else{
      currentListRecessed.forEach((recessedElement) {
        if(DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isBefore(end) && DateTime.fromMillisecondsSinceEpoch(recessedElement.dateTimeRecessed).isAfter(start)){
          listToReturn.add(recessedElement);
        }
      });
      return listToReturn;
    }
  }
  List<int> getIvaList(){
    return ivaList;
  }

  void addDataBundle(DataBundle bundle){
    print('Adding bundle to Notifier' + bundle.email.toString());
    dataBundleList.add(bundle);
    notifyListeners();
  }

  void addBranches(List<BranchModel> branchList) {
    dataBundleList[0].companyList.clear();
    dataBundleList[0].companyList = branchList;
    if(dataBundleList[0].companyList.isNotEmpty){
      currentBranch = dataBundleList[0].companyList[0];
    }
    notifyListeners();
  }

  Future<void> setCurrentBranch(BranchModel branchModel) async {
    ClientVatService clientService = ClientVatService();
    currentBranch = branchModel;
    List<RecessedModel> _recessedModelList = await clientService.retrieveRecessedListByBranch(currentBranch);
    currentListRecessed.clear();
    currentListRecessed.addAll(_recessedModelList);
    notifyListeners();
  }

  String getCurrentDate(){
      if(currentDateTime.day == DateTime.now().day && currentDateTime.month == DateTime.now().month && currentDateTime.year == DateTime.now().year){
        return 'OGGI';
      } else {
        return currentDateTime.day.toString() + '.' + currentDateTime.month.toString() + ' - ' + getNameDayFromWeekDay(currentDateTime.weekday);
      }
  }

  List<RecessedModel> getCurrentListRecessed(){
    return currentListRecessed;
  }

  void setCurrentDateTime(DateTime newDateTime){
    currentDateTime = newDateTime;
    notifyListeners();
  }

  void clearAll(){
    if(dataBundleList.isNotEmpty){
      dataBundleList.clear();
    }
    if(currentBranch != null){
      currentBranch = null;
    }
    if(currentListRecessed.isNotEmpty){
      currentListRecessed.clear();
    }
    setShowIvaButtonToFalse();
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

  void addCurrentRecessedList(List<RecessedModel> recessedModelList) {
    currentListRecessed.clear();
    currentListRecessed = recessedModelList;

    notifyListeners();
  }

  void previousIva() {
    if(indexIvaList == 0){
      indexIvaList = 3;
    }else{
      indexIvaList --;
    }
    notifyListeners();
  }

  void nextIva() {
    if(indexIvaList == 3){
      indexIvaList = 0;
    }else{
      indexIvaList ++;
    }
    notifyListeners();
  }
}