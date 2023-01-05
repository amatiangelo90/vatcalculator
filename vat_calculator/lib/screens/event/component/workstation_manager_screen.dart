import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../../components/loader_overlay_widget.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.models.swagger.dart';
import 'add_prod_workstation_element.dart';

class WorkstationManagerScreen extends StatefulWidget {
  const WorkstationManagerScreen({Key? key}) : super(key: key);


  @override
  State<WorkstationManagerScreen> createState() => _WorkstationManagerScreenState();
}

class _WorkstationManagerScreenState extends State<WorkstationManagerScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loadPaxController = TextEditingController(text: '');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayOpacity: 0.9,
        overlayWidget: const LoaderOverlayWidget(message: 'Attendi. Sto effettuando il carico...',),
        child: Consumer<DataBundleNotifier>(
          builder: (child, dataBundleNotifier, _){

            List<RStorageProduct> prodList = dataBundleNotifier.getStorageById(dataBundleNotifier.getCurrentEvent().storageId!)!.products!;

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                bottomSheet: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: getProportionateScreenWidth(400),
                    height: getProportionateScreenHeight(55),
                    child: OutlinedButton(
                      onPressed: () async {
                        print('Perform load product into workstation');
                        try{
                          context.loaderOverlay.show();
                          List<WorkstationLoadUnloadProduct> prodLoadList = [];
                          for (RWorkstationProduct rWorkstationProd in dataBundleNotifier.getCurrentWorkstation().products!) {
                            num storageProductId = 0;
                            if(prodList.where((prod) => prod.productId == rWorkstationProd.productId).isNotEmpty){
                              storageProductId = prodList.where((prod) => prod.productId == rWorkstationProd.productId).first.storageProductId!;
                            }

                            if(rWorkstationProd.amount! > 0){
                              prodLoadList.add(WorkstationLoadUnloadProduct(
                                  productId: rWorkstationProd.productId,
                                  storageId: rWorkstationProd.storageId,
                                  amount: rWorkstationProd.amount,
                                  storageProductId: storageProductId,
                                  workstationProductId: rWorkstationProd.workstationProductId
                              ));
                            }
                          }

                          if(prodLoadList.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration:
                                    Duration(milliseconds: 2000),
                                    backgroundColor: kCustomBordeaux,
                                    content: Text(
                                      'Immettere quantità di carico per almeno un prodotto',
                                      style: TextStyle(color: Colors.white),
                                    )));
                          }else{
                            Response apiV1AppWorkstationLoadPost = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationLoadPost(workstationLoadUnloadProductList: prodLoadList);

                            if(apiV1AppWorkstationLoadPost.isSuccessful){

                              dataBundleNotifier.refreshCurrentBranchData();
                              dataBundleNotifier.getCurrentWorkstation().products!.where((element) => element.amount!>0).forEach((element) {
                                element.stockFromStorage = element.stockFromStorage! + element.amount!;
                                element.amount = 0;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration:
                                      Duration(milliseconds: 1000),
                                      backgroundColor: kCustomGreen,
                                      content: Text(
                                        'Carico effettuato correttamente',
                                        style: TextStyle(color: Colors.white),
                                      )));

                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration:
                                      const Duration(milliseconds: 3000),
                                      backgroundColor: kRed,
                                      content: Text(
                                        'Errore durante il carico prodotti. Err: ' + apiV1AppWorkstationLoadPost.error.toString(),
                                        style: const TextStyle(color: Colors.white),
                                      )));
                            }
                          }
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration:
                              const Duration(milliseconds: 3000),
                              backgroundColor: kRed,
                              content: Text(
                                'Errore durante il carico prodotti. Err: ' + e.toString(),
                                style: const TextStyle(color: Colors.white),
                              )));
                        }finally{
                          context.loaderOverlay.hide();
                        }

                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.resolveWith((states) => 5),
                        backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                        side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                      ),
                      child: Text('Effettua CARICO', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: (){
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Builder(
                            builder: (context) {
                              return SizedBox(
                                width: getProportionateScreenWidth(900),
                                height: getProportionateScreenHeight(600),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0)),
                                          color: kCustomGrey,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '  Lista Prodotti',
                                              style: TextStyle(
                                                fontSize:
                                                getProportionateScreenWidth(17),
                                                color: Colors.white,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.clear,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      AddElementIntoWorkstationWidget(),
                                      const SizedBox(height: 40),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  },
                  backgroundColor: kCustomGreen,
                  child: const Icon(Icons.add),
                ),
                backgroundColor: Colors.white,
                key: _scaffoldKey,
                appBar: AppBar(
                  bottom: const TabBar(
                    indicatorColor: kCustomGreen,
                    indicatorWeight: 3,
                    tabs: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('CARICO', style: TextStyle(color: kCustomGreen, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('SCARICO', style: TextStyle(color: kCustomBordeaux, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => {
                        Navigator.of(context).pop(),
                      }),
                  iconTheme: const IconThemeData(color: kCustomGrey),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(dataBundleNotifier.getCurrentWorkstation().name!,
                        style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomGrey, fontWeight: FontWeight.bold),),
                      Text(
                        'Tipo workstation: ' + workstationWorkstationTypeToJson(dataBundleNotifier.getCurrentWorkstation().workstationType!)!,
                        style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGreen, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    buildLoadWorkstationScreen(dataBundleNotifier, dataBundleNotifier.getCurrentWorkstation(), prodList),
                    Text(''),
                    //buildRefillWorkstationProductsPage(!, dataBundleNotifier),
                    //buildUnloadWorkstationProductsPage(dataBundleNotifier.workstationsProductsMap[widget.workstationModel.pkWorkstationId]!, dataBundleNotifier),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  getPriviledgeWarningContainer() {
    return Container(
      color: kCustomGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SvgPicture.asset('assets/icons/warning.svg', color: kPinaColor, height: 100,),
              const Text('WARNING', textAlign: TextAlign.center, style: TextStyle(color: kPinaColor)),                        ],
          ),
          Center(child: SizedBox(
              width: getProportionateScreenWidth(350),
              height: getProportionateScreenHeight(150),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('Utente non abilitato alla visualizzazione ed all\'utilizzo di questa sezione', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15),)),
              )),),
        ],
      ),
    );
  }

  buildLoadWorkstationScreen(DataBundleNotifier dataBundleNotifier, Workstation workstationModel, List<RStorageProduct> storageProductList) {

    return SingleChildScrollView(
      child: SizedBox(
        height: getProportionateScreenHeight(550),
        child: ListView.builder(
          itemCount: workstationModel.products!.length,
          itemBuilder: (context, index) {
            RWorkstationProduct rWorkstationProduct = workstationModel.products![index];
            return Dismissible(
              background: Container(
                color: kCustomBordeaux,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Icon(Icons.delete, color: Colors.white, size: getProportionateScreenHeight(40)),
                    )
                  ],
                ),
              ),
              key: Key(rWorkstationProduct.productId!.toString()),
              direction: DismissDirection.endToStart,
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Conferma operazione"),
                      content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Sei sicuro di voler eliminare il"
                            " prodotto?\nUna volta cancellato il prodotto verranno ricaricati nel magazzino \'${dataBundleNotifier.getStorageById(rWorkstationProduct.storageId!).name}\'"
                            " n° ${rWorkstationProduct.stockFromStorage} x ${rWorkstationProduct.unitMeasure} di ${rWorkstationProduct.productName}"),
                      ),
                      actions: <Widget>[
                        OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Elimina", style: TextStyle(color: kRed),)
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Indietro"),
                        ),
                      ],
                    );
                  },
                );
              },
              resizeDuration: Duration(seconds: 1),
              onDismissed: (direction) async {
                print('Remove product from storage: ' + dataBundleNotifier.getCurrentStorage().storageId!.toInt().toString() + ' prod id: ' + dataBundleNotifier.getCurrentStorage().products![index]!.productId!.toInt().toString());
                try {
                  Response apiV1AppWorkstationRemoveproductDelete = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationRemoveproductDelete(workstationProductId: rWorkstationProduct.workstationProductId!.toInt());

                  if(apiV1AppWorkstationRemoveproductDelete.isSuccessful){

                    dataBundleNotifier.removeProductFromCurrentWorkstation(rWorkstationProduct);
                    dataBundleNotifier.refreshCurrentBranchDataWithStorageTrakingId(rWorkstationProduct.storageId!.toInt());
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration:
                            Duration(milliseconds: 1000),
                            backgroundColor: kCustomGreen,
                            content: Text(
                              'Prodotto eliminato!',
                              style: TextStyle(color: Colors.white),
                            )));
                  } else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            duration:
                            const Duration(milliseconds: 3000),
                            backgroundColor: kCustomBordeaux,
                            content: Text(
                              'Ho riscontrato problemi durante l\'operazione. Err: ' + apiV1AppWorkstationRemoveproductDelete.error.toString(),
                              style: TextStyle(color: Colors.white),
                            )));
                  }
                } on Exception catch (e) {

                }
              },
              child: ListTile(
                title: Column(
                  children: [
                    GestureDetector(
                        onTap:(){
                        },
                        child: buildProductRow(rWorkstationProduct, storageProductList),
                    ),
                    const Divider(color: kCustomWhite, height: 4, endIndent: 80,),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  buildProductRow(RWorkstationProduct product, List<RStorageProduct> prodList) {
    TextEditingController controller = TextEditingController(text: product.amount!.toString());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                          width: getProportionateScreenWidth(170),
                          child: Text(product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(21)))),

                      SizedBox(
                        width: getProportionateScreenWidth(170),
                        child: Text('q/100: ' + product.amountHundred!.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: getProportionateScreenHeight(8))),),

                      prodList.where((productL) => productL.productId == product.productId).isNotEmpty ? SizedBox(
                        width: getProportionateScreenWidth(170),
                        child: Row(
                          children: [
                            Text('Stock in magazzino: ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(11))),
                            Text((prodList.where((productL) => productL.productId == product.productId)!.first!.stock! - product.amount!).toString(), style: TextStyle(fontWeight: FontWeight.bold, color:(prodList.where((productL) => productL.productId == product.productId)!.first!.stock! - product.amount!) > 0 ? kCustomGreen : kCustomBordeaux, fontSize: getProportionateScreenHeight(13))),
                          ],
                        ),) :
                      SizedBox(
                        width: getProportionateScreenWidth(170),
                        child: Text('Prodotto non presente in magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomBordeaux, fontSize: getProportionateScreenHeight(8))),),
                      SizedBox(height: getProportionateScreenHeight(40)),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                    width: getProportionateScreenWidth(100),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Text((product.stockFromStorage! + product.amount!).toString(), style: TextStyle(fontWeight: FontWeight.bold, color:kCustomGreen, fontSize: getProportionateScreenHeight(20))),
                          Text(product.unitMeasure!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(15))),
                        ],
                      ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if(product.amount! > 0){
                              product.amount = product.amount! - 1;
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.minus,
                            color: kPinaColor,
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.loose(Size(
                            getProportionateScreenWidth(60),
                            getProportionateScreenWidth(80))),
                        child: CupertinoTextField(
                          controller: controller,
                          onChanged: (text) {
                            product.amount = double.parse(text);
                          },
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            color: kCustomGrey,
                            fontWeight: FontWeight.w600,
                            fontSize: getProportionateScreenHeight(22),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          clearButtonMode: OverlayVisibilityMode.never,
                          textAlign: TextAlign.center,
                          autocorrect: false,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            product.amount = product.amount! + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(FontAwesomeIcons.plus,
                              color: kCustomGreen),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }
}
