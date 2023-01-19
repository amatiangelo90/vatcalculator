import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/create_branch_button.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/branch_registration/branch_choice_registration.dart';
import 'package:vat_calculator/swagger/swagger.swagger.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../swagger/swagger.enums.swagger.dart';
import '../../../swagger/swagger.models.swagger.dart';
import '../../branch_registration/branch_update.dart';
import '../../authentication/edit_profile.dart';
import '../../event/event_home.dart';
import '../../orders/components/screens/order_creation/order_create_screen.dart';
import '../../orders/components/screens/recap_order_screen.dart';
import '../../storage/storage_screen.dart';
import '../../suppliers/suppliers_screen.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({Key? key}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        if (!dataBundleNotifier.getUserEntity().profileCompleted!) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: Text(
                  "Ciao, completa il profilo prima di iniziare",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.bold,
                    color: kCustomGrey,
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                height: getProportionateScreenHeight(50),
                child: OutlinedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
                    side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 0.5, color: Colors.grey),),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ), onPressed: () {
                  Navigator.pushNamed(context, EditProfileScreen.routeName);
                }, child: Text('Completa profilo', style: TextStyle(color: Colors.white, fontSize: getProportionateScreenHeight(20))),

                ),
              ),
            ],
          );
        } else if(dataBundleNotifier.getUserEntity().branchList!.isEmpty){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: Text(
                  "Sembra che tu non abbia configurato ancora nessuna attività. ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(13),
                    fontWeight: FontWeight.bold,
                    color: kCustomGrey,
                  ),
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.8,
                child: CreateBranchButton(),
              ),
            ],
          );
        } {
          return Container(
            color: kCustomGrey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildGestureDetectorBranchSelector(
                    context, dataBundleNotifier),


                buildStaffWidget(dataBundleNotifier),
                buildCateringButton('CATERING', (){
                  if(dataBundleNotifier.getCurrentBranch()!.storages!.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: kCustomBordeaux,
                      duration: Duration(seconds: 4),
                      content: Text('Per creare un evento catering devi prima creare un magazzino. Il magazzino creato potrà essere selezionato ed associato all\' evento in modo tale da ottenere una lista di prodotti da utilizzare in fase di carico/scarico'),
                    ));
                  }else{
                    Navigator.pushNamed(context, EventHomeScreen.routeName);
                  }
                }, dataBundleNotifier,),
                buildSuppliersStorageButton(width, dataBundleNotifier),

                buildOrderButton('ORDINI', dataBundleNotifier),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Developed by AmatiCorp', style: TextStyle(fontSize: 6)),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildGestureDetectorBranchSelector(
      BuildContext context, DataBundleNotifier dataBundleNotifier) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
          width: getProportionateScreenWidth(500),
          child: OutlinedButton(
            onPressed: (){
              showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: getProportionateScreenHeight(550),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('        Seleziona attività', style: TextStyle(fontSize: getProportionateScreenHeight(20), color: kCustomGrey, fontWeight: FontWeight.w900)),
                                  IconButton(icon: Icon(Icons.clear, size: getProportionateScreenHeight(30)), color: kCustomGrey, onPressed: (){
                                    Navigator.of(context).pop();
                                  },)
                                ],
                              ),
                            ),
                            Column(
                              children: buildListBranches(dataBundleNotifier),
                            ),

                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  });
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => 5),
              backgroundColor: MaterialStateProperty.resolveWith((states) => kCustomGreen),
              side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 1.5, color: Colors.white),),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  branchUserPriviledgeFromJson(dataBundleNotifier.getCurrentBranch().userPriviledge) == BranchUserPriviledge.employee ? SizedBox(height: 0,) : Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: IconButton(
                        icon: SvgPicture.asset('assets/icons/Settings.svg', color: Colors.white, height: getProportionateScreenHeight(27),),
                        onPressed: (){
                          Navigator.pushNamed(context, UpdateBranchScreen.routeName);
                        },
                      )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dataBundleNotifier.getCurrentBranch()!.name!, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          getProportionateScreenWidth(
                              17)),),
                      Text(dataBundleNotifier.getCurrentBranch()!.address! + ', ' + dataBundleNotifier.getCurrentBranch()!.city!, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          getProportionateScreenWidth(
                              11)),),
                      Text(dataBundleNotifier.getCurrentBranch()!.branchCode!, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          getProportionateScreenWidth(
                              16)),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: kCustomWhite,
                      size: getProportionateScreenWidth(30),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  buildListBranches(DataBundleNotifier dataBundleNotifier) {
    List<Widget> branchWidgetList = [];
    branchWidgetList.add(
        const Divider(color: Colors.grey, height: 10,)
    );
    for (var currentBranch in dataBundleNotifier.getUserEntity().branchList!) {
      branchWidgetList.add(
        ListTile(
          title: Text(currentBranch.name!, style: TextStyle(color: dataBundleNotifier.getCurrentBranch().branchId ==
              currentBranch.branchId ? kCustomGreen : Colors.grey, fontSize: getProportionateScreenHeight(18), fontWeight: FontWeight.w800)),
          leading: dataBundleNotifier.getCurrentBranch().branchId ==
              currentBranch.branchId ? const Icon(FontAwesomeIcons.checkCircle, color: kCustomGreen,) : const SizedBox(height: 0),
          onTap: () {
            if(dataBundleNotifier.getCurrentBranch().branchId ==
                currentBranch.branchId){
              Navigator.pop(context);
            }else{
              context.loaderOverlay.show();
              Navigator.pop(context);
              dataBundleNotifier.setBranch(currentBranch);
              context.loaderOverlay.hide();
            }
          },
        ),
      );
    }
    branchWidgetList.add(
        Divider(color: Colors.grey, height: 10,)
    );
    branchWidgetList.add(
        ListTile(
          leading: Icon(FontAwesomeIcons.plus, color: kCustomGrey,),
          title: Text('Crea Nuova Attività', style: TextStyle(fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.w900)),
          onTap: (){
            Navigator.of(context).pop();
            Navigator.pushNamed(context, BranchChoiceCreationEnjoy.routeName);
          },
        )
    );
    return branchWidgetList;
  }

  String normalizeCalendarValue(int day) {
    if (day < 10) {
      return '0' + day.toString();
    } else {
      return day.toString();
    }
  }





  buildOrderButton(String name, DataBundleNotifier dataBundleNotifier) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
              image: AssetImage("assets/images/orders.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: OutlinedButton(
            onPressed: (){
              Navigator.pushNamed(context, RecapOrderScreen.routeName);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.resolveWith((states) => 5),
              backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black.withOpacity(0.6)),
              side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 1.5, color: Colors.white),),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/receipt.svg', color: Colors.white, height: getProportionateScreenHeight(27),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(name,style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                            getProportionateScreenWidth(
                                16)),),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ordini in arrivo oggi: ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: getProportionateScreenWidth(12)),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(35),
                          width: getProportionateScreenHeight(35),
                          child: Card(
                            color: kCustomPinkAccent,
                            child: Center(
                              child: Text(dataBundleNotifier.getCurrentBranch().orders!.where((element)
                              => element.deliveryDate == dateFormat.format(DateTime.now())).length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, EventHomeScreen.routeName);
                      },
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2, style: BorderStyle.solid)),
                            child: FloatingActionButton(
                              heroTag: "btn375663452112456",
                                onPressed: (){
                                  Navigator.pushNamed(context, CreateOrderScreen.routeName);
                                },
                              child: Icon(Icons.add, color: Colors.white, size: getProportionateScreenWidth(30)),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  buildCateringButton(String name, Null Function() param1, DataBundleNotifier dataBundleNotifier) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
                image: AssetImage("assets/images/party.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            height:  getProportionateScreenWidth(150),
            child: OutlinedButton(
              onPressed: param1,
              style: ButtonStyle(
                elevation: MaterialStateProperty.resolveWith((states) => 5),
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black.withOpacity(0.6)),
                side: MaterialStateProperty.resolveWith((states) => const BorderSide(width: 1.5, color: Colors.white),),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/party.svg', color: Colors.white, height: getProportionateScreenHeight(27),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(name,style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                            getProportionateScreenWidth(
                                17)),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Eventi in programma oggi: ',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: getProportionateScreenWidth(12)),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(35),
                            width: getProportionateScreenHeight(35),
                            child: Card(
                              color: kCustomPinkAccent,
                              child: Center(
                                child: Text(dataBundleNotifier.getCurrentBranch().events!.where((event) => event.dateEvent == dateFormat.format(DateTime.now())).length.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EventHomeScreen.routeName);
                        },
                        child: Row(
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getProportionateScreenWidth(12),
                                  color: Colors.grey),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  buildSuppliersStorageButton(double width, DataBundleNotifier dataBundleNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 2, left: 4, top: 2),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
                    image: AssetImage("assets/images/supplier.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                height:  width * 3/7,
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, SuppliersScreen.routeName);
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black.withOpacity(0.6)),
                    side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 1.5, color: Colors.white),),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset('assets/icons/supplier.svg', color: Colors.white, height: getProportionateScreenHeight(27),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(dataBundleNotifier.getCurrentBranch().suppliers!.length.toString(), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(50),
                            color: Colors.white),),
                      ),
                      Text('FORNITORI',style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          getProportionateScreenWidth(
                              15)),),
                    ],
                  ),
                )
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 4, left: 2, top: 2),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
                    image: AssetImage("assets/images/magazzino.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                height:  width * 3/7,
                child: OutlinedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, StorageScreen.routeName);
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.resolveWith((states) => 5),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black.withOpacity(0.6)),
                    side: MaterialStateProperty.resolveWith((states) => BorderSide(width: 1.5, color: Colors.white),),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset('assets/icons/storage.svg', color: Colors.white, height: getProportionateScreenHeight(27),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(dataBundleNotifier.getCurrentBranch().storages!.length.toString(), style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getProportionateScreenWidth(50),
                            color: Colors.white),),
                      ),
                      Text('MAGAZZINI',style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          getProportionateScreenWidth(
                              15)),),
                    ],
                  ),
                )
            ),
          ),
        ),
      ],
    );
  }

  buildStaffWidget(DataBundleNotifier dataBundle) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Staff ' + dataBundle.getCurrentBranch().name!, style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: Colors.white),),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildListAvatars(dataBundle),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildListAvatars(DataBundleNotifier dataBundleNotifier) {

    List<Widget> widget = [];
    dataBundleNotifier.userBranchList!.forEach((userBranch) {
      widget.add(GestureDetector(
        onTap: (){
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
                                    '  Dettagli profilo',
                                    style: TextStyle(
                                      fontSize:
                                      getProportionateScreenWidth(13),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  userBranch.userEntity!.photo != null ?
                                  CircleAvatar(
                                    radius: 100,
                                    backgroundImage: NetworkImage(userBranch.userEntity!.photo!),
                                  ) : const CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage('assets/images/monkey.png'),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(userBranch.userEntity!.name! + ' ' + userBranch.userEntity!.lastname!, style: TextStyle(
                                          fontSize: getProportionateScreenWidth(27),
                                          color: kCustomGrey),),
                                    ],
                                  ),
                                  Text(userBranch.userEntity!.email!, style: TextStyle(
                                      fontSize: getProportionateScreenWidth(17),
                                      color: kCustomGrey),),
                                  Text(userBranch.userEntity!.phone!, style: TextStyle(
                                      fontSize: getProportionateScreenWidth(17),
                                      color: kCustomGrey),),

                                  userBranch.userEntity!.userId == dataBundleNotifier.getUserEntity().userId ? Text('') : dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.employee ? const Text('') : Padding(
                                    padding: const EdgeInsets.all(38.0),
                                    child: OutlinedButton(onPressed: () async {

                                      Response responseUpdatePriviledge;

                                      if(userBranch.userPriviledge == UserBranchUserPriviledge.admin){
                                        responseUpdatePriviledge = await dataBundleNotifier.getSwaggerClient().apiV1AppUsersUpdatePermissionTypePut(userBranchId: userBranch.userbranchid!.toInt(),
                                            userPriviledge: userBranchUserPriviledgeToJson(UserBranchUserPriviledge.employee));
                                      }else{
                                        responseUpdatePriviledge = await dataBundleNotifier.getSwaggerClient().apiV1AppUsersUpdatePermissionTypePut(userBranchId: userBranch.userbranchid!.toInt(),
                                            userPriviledge: userBranchUserPriviledgeToJson(UserBranchUserPriviledge.admin));
                                      }

                                      Navigator.of(context).pop();
                                      if(responseUpdatePriviledge.isSuccessful){
                                        Response response = await dataBundleNotifier.getSwaggerClient()
                                            .apiV1AppUsersFindAllUsersByBranchIdGet(branchId: dataBundleNotifier.getCurrentBranch().branchId!.toInt());
                                        if(response.isSuccessful){
                                          dataBundleNotifier.setUserListForCurrentBranch(response.body);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              backgroundColor: kCustomGreen,
                                              duration: const Duration(milliseconds: 800),
                                              content: const Text('Utenza aggiornata correttamente')));
                                        }else{
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              backgroundColor: kCustomBordeaux,
                                              duration: const Duration(milliseconds: 1800),
                                              content: Text('Errore durante l\'operazione. Erro: ' + response.error.toString())));

                                        }
                                      }else{
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            backgroundColor: kCustomBordeaux,
                                            duration: const Duration(milliseconds: 1800),
                                            content: Text('Errore durante l\'operazione. Erro: ' + responseUpdatePriviledge.error.toString())));
                                      }
                                    }, child: Text(userBranch.userPriviledge == UserBranchUserPriviledge.admin ? 'Rendi Dipendente' : 'Rendi Amministratore', style: TextStyle(color: kCustomGreen),)),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 140),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(userBranchUserPriviledgeToJson(userBranch.userPriviledge)!, style: TextStyle(
                    fontSize: getProportionateScreenWidth(7),
                    color: Colors.white),),
              ),
              userBranch.userEntity!.photo != null ?
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(userBranch.userEntity!.photo!),
              ) : const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/monkey.png'),
              ),

              Text(userBranch.userEntity!.name!, style: TextStyle(
                  fontSize: getProportionateScreenWidth(10),
                  color: Colors.white),),
              Text(userBranch.userEntity!.lastname!, style: TextStyle(
                  fontSize: getProportionateScreenWidth(7),
                  color: Colors.white),),
            ],
          ),
        ),
      ),);
    });

    return widget;
  }

}
