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
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import 'add_prod_workstation_element.dart';

class WorkstationManagerScreen extends StatefulWidget {
  const WorkstationManagerScreen({Key? key}) : super(key: key);


  @override
  State<WorkstationManagerScreen> createState() => _WorkstationManagerScreenState();
}

class _WorkstationManagerScreenState extends State<WorkstationManagerScreen> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController loadPaxController = TextEditingController(text: '');

  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        overlayWidget: const LoaderOverlayWidget(message: 'Attendi. Sto processando i dati...',),
        child: Consumer<DataBundleNotifier>(
          builder: (child, dataBundleNotifier, _){

            List<RStorageProduct> prodList = dataBundleNotifier.getStorageById(dataBundleNotifier.getCurrentEvent().storageId!)!.products!;

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                key: _scaffoldKey,
                appBar: AppBar(
                  actions: [
                    IconButton(
                      onPressed: (){

                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  var height = MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return SizedBox(
                                    height: getProportionateScreenHeight(300),
                                    width: width - 90,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  topLeft: Radius.circular(10.0) ),
                                              color: kCustomGrey,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('  Aggiorna postazione ',style: TextStyle(
                                                      fontSize: getProportionateScreenWidth(14),
                                                      fontWeight: FontWeight.bold,
                                                      color: kCustomWhite,
                                                    ),),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ), onPressed: () { Navigator.pop(context); },),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          buildSettingWorkstationWidget(dataBundleNotifier)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                        );
                      },
                      icon: SvgPicture.asset('assets/icons/Settings.svg', color: kCustomGrey, height: getProportionateScreenWidth(30)),
                    ),
                    IconButton(
                      onPressed: (){
                        TextEditingController controllerAmountHundred = TextEditingController();
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                      Radius.circular(10.0))),
                              content: Builder(
                                builder: (context) {
                                  var height = MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return SizedBox(
                                    height: getProportionateScreenHeight(340),
                                    width: width - 90,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  topLeft: Radius.circular(10.0) ),
                                              color: kCustomGrey,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text('  Configura quantità per carico ',style: TextStyle(
                                                      fontSize: getProportionateScreenWidth(14),
                                                      fontWeight: FontWeight.bold,
                                                      color: kCustomWhite,
                                                    ),),
                                                    IconButton(icon: const Icon(
                                                      Icons.clear,
                                                      color: kCustomWhite,
                                                    ), onPressed: () { Navigator.pop(context); },),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                                child: Text('Configura il numero dei clienti attesi all\'evento per configurare il carico in'
                                                    ' base al valore Q/100 configurato per ciascun prodotto.', style: TextStyle(color: kCustomGrey),),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                                child: Text('INSERISCI NUMERO CLIENTI: ', style: TextStyle(color: kCustomGrey),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: getProportionateScreenWidth(400),
                                                  child: CupertinoTextField(
                                                    controller: controllerAmountHundred,
                                                    textInputAction: TextInputAction.next,
                                                    keyboardType: const TextInputType.numberWithOptions(signed: false,decimal:  true),
                                                    clearButtonMode: OverlayVisibilityMode.never,
                                                    textAlign: TextAlign.center,
                                                    autocorrect: false,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                                child: Text('RICORDA DI SALVARE IL CARICO!', style: TextStyle(color: kCustomGrey),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: getProportionateScreenWidth(400),
                                                  height: getProportionateScreenHeight(55),
                                                  child: OutlinedButton(
                                                    onPressed: () async {

                                                      if(controllerAmountHundred.text != '0'){
                                                        dataBundleNotifier.configureLoadByAmountHundred(double.parse(controllerAmountHundred.text));
                                                        Navigator.of(context).pop(false);
                                                      }else{
                                                        Navigator.of(context).pop(false);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                                duration:
                                                                Duration(milliseconds: 2000),
                                                                backgroundColor: kRed,
                                                                content: Text(
                                                                  'Immettere un valore maggiore di 0',
                                                                  style: TextStyle(color: Colors.white),
                                                                )));
                                                      }


                                                    },
                                                    style: ButtonStyle(
                                                      elevation: MaterialStateProperty.resolveWith((states) => 5),
                                                      backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                                                      side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                                                    ),
                                                    child: Text('Imposta quantità per il carico', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                        );
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Q',textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(9))),
                          Divider(color: kCustomGrey,height: 0),
                          Text('100',textAlign: TextAlign.center, style: TextStyle(color: kCustomGrey, fontSize: getProportionateScreenHeight(9))),                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
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
                        icon: Icon(Icons.add, color: kCustomGrey, size: getProportionateScreenHeight(30),),
                      ),
                    ),

                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: kCustomGrey,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('CARICO', style: TextStyle(color: kCustomGreen, fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('GIACENZA', style: TextStyle(color: kCustomBordeaux, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => {
                        Navigator.of(context).pop(),
                      }),
                  iconTheme: const IconThemeData(color: kCustomGrey),

                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataBundleNotifier.getCurrentWorkstation().name!,
                        style: TextStyle(fontSize: getProportionateScreenHeight(19), color: kCustomGrey, fontWeight: FontWeight.bold),),
                      Text(
                        'Responsabile: ' + dataBundleNotifier.getCurrentWorkstation().responsable!,
                        style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGrey, fontWeight: FontWeight.bold),),
                      Text(
                        'Tipo workstation: ' + workstationWorkstationTypeToJson(dataBundleNotifier.getCurrentWorkstation().workstationType!)!,
                        style: TextStyle(fontSize: getProportionateScreenHeight(10), color: kCustomGrey, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    buildLoadWorkstationScreen(dataBundleNotifier, dataBundleNotifier.getCurrentWorkstation(), prodList),
                    buildUnloadWorkstationScreen(dataBundleNotifier, dataBundleNotifier.getCurrentWorkstation(), prodList),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  buildUnloadWorkstationScreen(DataBundleNotifier dataBundleNotifier, Workstation workstationModel, List<RStorageProduct> storageProductList) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: getProportionateScreenWidth(400),
          height: getProportionateScreenHeight(55),
          child: OutlinedButton(
            onPressed: () async {
              print('Perform unload product into workstation');
              try{
                context.loaderOverlay.show();
                List<WorkstationLoadUnloadProduct> prodLoadList = [];
                for (RWorkstationProduct rWorkstationProd in dataBundleNotifier.getCurrentWorkstation().products!) {
                  num storageProductId = 0;
                  if(storageProductList.where((prod) => prod.productId == rWorkstationProd.productId).isNotEmpty){
                    storageProductId = storageProductList.where((prod) => prod.productId == rWorkstationProd.productId).first.storageProductId!;
                  }

                  if(rWorkstationProd.amountUnload! > 0){
                    prodLoadList.add(WorkstationLoadUnloadProduct(
                        productId: rWorkstationProd.productId,
                        storageId: rWorkstationProd.storageId,
                        amount: rWorkstationProd.amountUnload,
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
                            'Immettere quantità di giacenza per almeno un prodotto',
                            style: TextStyle(color: Colors.white),
                          )));
                }else{
                  Response apiV1AppWorkstationLoadPost = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationUnloadPost(workstationLoadUnloadProductList: prodLoadList);

                  if(apiV1AppWorkstationLoadPost.isSuccessful){
                    dataBundleNotifier.refreshCurrentBranchData();
                    dataBundleNotifier.getCurrentWorkstation().products!.where((element) => element.amountUnload!>0).forEach((element) {
                      element.consumed = element.consumed! + element.amountUnload!;
                      element.amountUnload = 0;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration:
                            Duration(milliseconds: 1000),
                            backgroundColor: kCustomGreen,
                            content: Text(
                              'Giacenza configurata correttamente',
                              style: TextStyle(color: Colors.white),
                            )));

                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            duration:
                            const Duration(milliseconds: 3000),
                            backgroundColor: kRed,
                            content: Text(
                              'Errore durante la configurazione giacenza prodotti. Err: ' + apiV1AppWorkstationLoadPost.error.toString(),
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
                      'Errore durante la configurazione giacenza prodotti. Err: ' + e.toString(),
                      style: const TextStyle(color: Colors.white),
                    )));
              }finally{
                context.loaderOverlay.hide();
              }

            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => 5),
              backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomBordeaux),
              side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            ),
            child: Text('Configura GIACENZA', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: workstationModel.products!.length! * getProportionateScreenHeight(300),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            duration:
                            const Duration(milliseconds: 3000),
                            backgroundColor: kCustomBordeaux,
                            content: Text(
                              'Ho riscontrato problemi durante l\'operazione. Err: ' + e.toString(),
                              style: TextStyle(color: Colors.white),
                            )));
                  }
                },
                child: ListTile(
                  title: Column(
                    children: [
                      buildUnLoadProductRow(rWorkstationProduct, storageProductList, dataBundleNotifier),
                      const Divider(color: Colors.grey, height: 4,),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  buildLoadWorkstationScreen(DataBundleNotifier dataBundleNotifier, Workstation workstationModel, List<RStorageProduct> storageProductList) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Padding(
        padding: const EdgeInsets.all(15.0),
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
                  if(storageProductList.where((prod) => prod.productId == rWorkstationProd.productId).isNotEmpty){
                    storageProductId = storageProductList.where((prod) => prod.productId == rWorkstationProd.productId).first.storageProductId!;
                  }

                  if(rWorkstationProd.amountLoad! > 0){
                    prodLoadList.add(WorkstationLoadUnloadProduct(
                        productId: rWorkstationProd.productId,
                        storageId: rWorkstationProd.storageId,
                        amount: rWorkstationProd.amountLoad,
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
                    dataBundleNotifier.getCurrentWorkstation().products!.where((element) => element.amountLoad!>0).forEach((element) {
                      element.stockFromStorage = element.stockFromStorage! + element.amountLoad!;
                      element.amountLoad = 0;
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
      body: SingleChildScrollView(
        child: Container(
          height: workstationModel.products!.length! * getProportionateScreenHeight(300),
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
                    Response apiV1AppWorkstationRemoveproductDelete = await dataBundleNotifier.getSwaggerClient()
                        .apiV1AppWorkstationRemoveproductDelete(workstationProductId: rWorkstationProduct.workstationProductId!.toInt());

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
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            duration:
                            const Duration(milliseconds: 3000),
                            backgroundColor: kCustomBordeaux,
                            content: Text(
                              'Ho riscontrato problemi durante l\'operazione. Err: ' + e.toString(),
                              style: TextStyle(color: Colors.white),
                            )));
                  }
                },
                child: ListTile(
                  title: Column(
                    children: [
                      buildLoadProductRow(rWorkstationProduct, storageProductList, dataBundleNotifier),
                      const Divider(color:  Colors.grey, height: 4,),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  buildLoadProductRow(RWorkstationProduct product, List<RStorageProduct> prodList, DataBundleNotifier dataBundleNotifier) {
    TextEditingController controller = TextEditingController(text: product.amountLoad! > 0 ? product.amountLoad!.toString() : '');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(21))),
                        prodList.where((productL) => productL.productId == product.productId).isNotEmpty ? SizedBox(
                          width: getProportionateScreenWidth(170),
                          child: Row(
                            children: [
                              Text('Stock: ', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(11))),
                              Text((prodList.where((productL) => productL.productId == product.productId)!.first!.stock! - product.amountLoad!).toStringAsFixed(2).replaceAll('.00', '') + ' x ' + product.unitMeasure!, style: TextStyle(fontWeight: FontWeight.bold, color:(prodList.where((productL) => productL.productId == product.productId)!.first!.stock! - product.amountLoad!) > 0 ? kCustomGreen : kCustomBordeaux, fontSize: getProportionateScreenHeight(13))),
                            ],
                          ),) :
                        Text('Prodotto non presente in magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomBordeaux, fontSize: getProportionateScreenHeight(8))),
                        Text('Q/100: ' + product.amountHundred!.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(12))),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: OutlinedButton(

                            onLongPress: () async {

                              Response response = await dataBundleNotifier
                                  .getSwaggerClient().apiV1AppWorkstationResetproductstockvaluePut(workstationProductId: product.workstationProductId!.toInt());

                              if(product.stockFromStorage != 0){
                                if(response.isSuccessful){
                                  product.stockFromStorage = 0;
                                  product.amountLoad = 0;
                                  dataBundleNotifier.refreshCurrentBranchDataWithStorageTrakingId(product.storageId!.toInt());
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    backgroundColor: kCustomGreen,
                                    duration: Duration(seconds: 3),
                                    content: Text('Reset ok'),
                                  ));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: kCustomBordeaux,
                                    duration: Duration(seconds: 3),
                                    content: Text('Errore -  ' + response.error!.toString()),
                                  ));
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  backgroundColor: kCustomGreen,
                                  duration: Duration(seconds: 3),
                                  content: Text('Reset ok'),
                                ));
                              }

                            },
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                backgroundColor: kCustomBordeaux,
                                duration: Duration(seconds: 3),
                                content: Text('Tieni premuto sul pulsante Reset per 1 secondo per ripristinare la quantità di carico'),
                              ));
                            },
                            child: Text('Reset', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  children: [
                    Text((product.stockFromStorage! + product.amountLoad!).toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.bold, color:kCustomGreen, fontSize: getProportionateScreenHeight(20))),
                    Text(product.unitMeasure!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(15))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(product.amountLoad! > 0){
                                  product.amountLoad = product.amountLoad! - 1;
                                }
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.minus,
                                color: kCustomBordeaux,
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
                                product.amountLoad = double.parse(text.replaceAll(',', '.'));
                              },
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                color: kCustomGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: getProportionateScreenHeight(15),
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
                                product.amountLoad = product.amountLoad! + 1;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(FontAwesomeIcons.plus,
                                  color: kCustomGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  buildUnLoadProductRow(RWorkstationProduct product,
      List<RStorageProduct> prodList,
      DataBundleNotifier dataBundleNotifier) {
    TextEditingController controller = TextEditingController(text: product.amountUnload! > 0 ? product.amountUnload!.toString() : '');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: getProportionateScreenWidth(170),
                    child: Text(product.productName!, style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGrey, fontSize: getProportionateScreenHeight(21)))),

                prodList.where((productL) => productL.productId == product.productId).isNotEmpty ? SizedBox(
                  width: getProportionateScreenWidth(170),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Carico: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: getProportionateScreenHeight(14))),
                          Text(product.stockFromStorage!.toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.bold, color: kCustomGreen, fontSize: getProportionateScreenHeight(15))),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Consumato: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: getProportionateScreenHeight(14))),
                          Text((product.stockFromStorage! - product.consumed!).toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.bold, color: kCustomBordeaux, fontSize: getProportionateScreenHeight(15))),
                        ],
                      ),
                    ],
                  ),) :

                SizedBox(
                  width: getProportionateScreenWidth(170),
                  child: Text('Prodotto non presente in magazzino', style: TextStyle(fontWeight: FontWeight.bold, color: kCustomBordeaux, fontSize: getProportionateScreenHeight(8))),),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kCustomBordeaux,
                        duration: Duration(seconds: 3),
                        content: Text('Tieni premuto sul pulsante Reset per 1 secondo per ripristinare la quantità di giacenza'),
                      ));
                    },
                    onLongPress: () async {
                      Response response = await dataBundleNotifier.getSwaggerClient()
                          .apiV1AppWorkstationResetproductconsumedvaluePut(workstationProductId: product.workstationProductId!.toInt());

                      if(response.isSuccessful){
                        dataBundleNotifier.setGiacenza0ToProductIntoCurrentWorkstation(product.workstationProductId!.toInt());
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: kCustomGreen,
                          duration: Duration(milliseconds: 1000),
                          content: Text(
                              'Operazione di ripristino valore giacenza completata'),
                        ));
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: kCustomBordeaux,
                          duration: Duration(milliseconds: 3000),
                          content: Text(
                              'Ho riscontrato un errore durante l\'operazione: ' + response.error!.toString()),
                        ));
                      }
                    },
                    child: const Text('Reset', style: TextStyle(color: Colors.grey)),
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
                        Text((product.consumed! + product.amountUnload!).toStringAsFixed(2).replaceAll('.00', ''), style: TextStyle(fontWeight: FontWeight.bold, color:kCustomBordeaux, fontSize: getProportionateScreenHeight(20))),
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
                            if(product.amountUnload! > 0){
                              product.amountUnload = product.amountUnload! - 1;
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            FontAwesomeIcons.minus,
                            color: kCustomBordeaux,
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
                            product.amountUnload = double.parse(text.replaceAll(',', '.'));
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
                            product.amountUnload = product.amountUnload! + 1;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
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

  buildSettingWorkstationWidget(DataBundleNotifier dataBundleNotifier) {
    TextEditingController controllerName = TextEditingController(text: dataBundleNotifier.getCurrentWorkstation().name);
    TextEditingController controllerResponsable = TextEditingController(text: dataBundleNotifier.getCurrentWorkstation().responsable);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Text('Nome postazione: ', style: TextStyle(color: kCustomGrey),),
          ),
          SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoTextField(
              controller: controllerName,
              textInputAction: TextInputAction.next,
              clearButtonMode: OverlayVisibilityMode.never,
              textAlign: TextAlign.center,
              autocorrect: false,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
            child: Text('Responsabile: ', style: TextStyle(color: kCustomGrey),),
          ),
          SizedBox(
            width: getProportionateScreenWidth(400),
            child: CupertinoTextField(
              controller: controllerResponsable,
              textInputAction: TextInputAction.next,
              clearButtonMode: OverlayVisibilityMode.never,
              textAlign: TextAlign.center,
              autocorrect: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: getProportionateScreenWidth(400),
              height: getProportionateScreenHeight(55),
              child: OutlinedButton(
                onPressed: () async {
                  if(controllerName.text == ''){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kCustomBordeaux,
                      duration: Duration(milliseconds: 2600),
                      content: Text(
                          'Immettere il nome della workstation'),
                    ));
                  }else{
                    Response responseupdate = await dataBundleNotifier.getSwaggerClient().apiV1AppWorkstationUpdatePut(workstation: Workstation(
                        name: controllerName.text,
                        responsable: controllerResponsable.text,
                        workstationId: dataBundleNotifier.getCurrentWorkstation().workstationId
                    ));

                    if(responseupdate.isSuccessful){

                      dataBundleNotifier.updateCurrentWorkstation(controllerName.text, controllerResponsable.text);
                      Navigator.of(context).pop(false);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: kCustomGreen,
                        duration: Duration(milliseconds: 2600),
                        content: Text(
                            'Impostazioni salvate correttamente'),
                      ));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: kCustomBordeaux,
                        duration: Duration(milliseconds: 2600),
                        content: Text(
                            'Errore durante il salvataggio. Err: ' + responseupdate.error.toString() ),
                      ));
                    }
                  }
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.resolveWith((states) => 5),
                  backgroundColor: MaterialStateProperty.resolveWith((states) => dataBundleNotifier.getCurrentWorkstation().workstationType == WorkstationWorkstationType.bar ? kCustomGreen : kCustomPinkAccent),
                  side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey.shade100),),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                ),
                child: Text('Salva impostazioni', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20)),),
              ),
            ),
          )
        ],
      ),
    );


  }
}
