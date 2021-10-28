
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
  {this.pkStorageProductCreationModelId,
    this.user,
    this.dateTimeCreation,
    this.dateTimeEdit,
    this.stock,
    this.available,
    this.fkProductId,
    this.fkStorageId});

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