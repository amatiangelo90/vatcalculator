
class SaveProductToStorageRequest {
  int pkStorageProductCreationModelId;
  String user;
  int dateTimeCreation;
  int dateTimeEdit;
  int stock;
  String available;
  int fkProductId;
  int fkStorageId;

  SaveProductToStorageRequest(
  {required this.pkStorageProductCreationModelId,
    required this.user,
    required this.dateTimeCreation,
    required this.dateTimeEdit,
    required this.stock,
    required this.available,
    required this.fkProductId,
    required this.fkStorageId});

  toMap(){
    return {
      'pkStorageProductCreationModelId' : pkStorageProductCreationModelId,
      'user' : user,
      'dateTimeCreation' : dateTimeCreation,
      'dateTimeEdit' : dateTimeEdit,
      'stock' : stock,
      'available' : available,
      'fkProductId' : fkProductId,
      'fkStorageId' : fkStorageId
    };
  }
}