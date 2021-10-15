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

  void addDataBundle(DataBundle bundle){
    print('Adding bundle to Notifier' + bundle.email.toString());
    dataBundleList.add(bundle);
    notifyListeners();
  }

  void addBranches(List<BranchModel> branchList) {
    dataBundleList[0].companyList.clear();
    dataBundleList[0].companyList = branchList;
    currentBranch = dataBundleList[0].companyList[0];
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
    dataBundleList.clear();
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
}