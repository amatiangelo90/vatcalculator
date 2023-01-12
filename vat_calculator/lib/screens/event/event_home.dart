import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../../swagger/swagger.enums.swagger.dart';
import '../../swagger/swagger.models.swagger.dart';
import '../home/main_page.dart';
import 'component/event_body.dart';
import 'component/event_create_screen.dart';
import 'component/event_manager_screen_closed.dart';

class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({Key? key}) : super(key: key);
  static String routeName = "/eventscreen";

  @override
  _EventHomeScreenState createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {


  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayOpacity: 0.9,
      overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati in corso...',),
      child: Consumer<DataBundleNotifier>(
          builder: (context, dataBundleNotifier, child) {
            print(dataBundleNotifier.getCurrentBranch().userPriviledge);
            print(BranchUserPriviledge.employee);

            return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: dataBundleNotifier.getCurrentBranch().userPriviledge == BranchUserPriviledge.admin ?
              FloatingActionButton(
                  heroTag: "bt123541b12b3123",
                  backgroundColor: kCustomGreen,
                  child: Icon(Icons.add, color: Colors.white, size: getProportionateScreenWidth(30)),
                  onPressed: (){
                Navigator.pushNamed(context, EventCreateScreen.routeName);
              }) : Text(''),
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreenMain.routeName);
                    }),
                iconTheme: const IconThemeData(color: kCustomGrey),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Area Eventi',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: kCustomGrey,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              dataBundleNotifier.getCurrentBranch().name!,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(13),
                                color: kCustomGrey,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  branchUserPriviledgeFromJson(dataBundleNotifier.getCurrentBranch().userPriviledge) == BranchUserPriviledge.employee ? SizedBox(width: getProportionateScreenWidth(35)) : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                    child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/document.svg",
                          width: 25,
                        ),
                        onPressed: () async {
                          try{
                            context.loaderOverlay.show();

                            Response apiV1AppEventFindeventbybranchidClosedGet = await dataBundleNotifier.getSwaggerClient().apiV1AppEventFindeventbybranchidClosedGet(branchid: dataBundleNotifier.getCurrentBranch().branchId!.toInt());
                            if(apiV1AppEventFindeventbybranchidClosedGet.isSuccessful){
                              dataBundleNotifier.setClosedEventList(apiV1AppEventFindeventbybranchidClosedGet.body);

                              if(dataBundleNotifier.getListEventClosed().isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: kCustomBordeaux,
                                  content: Text('Ho riscontrato degli errori durante il recupero dei dati. Error: ' + apiV1AppEventFindeventbybranchidClosedGet.error.toString()),
                                ));
                              }else{
                                Navigator.pushNamed(context, EventManagerScreenClosed.routeName);
                              }
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 3),
                                backgroundColor: kCustomBordeaux,
                                content: Text('Ho riscontrato degli errori durante il recupero dei dati. Error: ' + apiV1AppEventFindeventbybranchidClosedGet.error.toString()),
                              ));
                            }
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 3),
                              backgroundColor: kCustomBordeaux,
                              content: Text('Ho riscontrato degli errori durante il recupero dei dati. Error: ' + e.toString()),
                            ));
                          }finally{
                            context.loaderOverlay.hide();
                          }


                        }),
                  ),
                  SizedBox(width: 5),
                ],
                elevation: 0,
              ),
              body: EventsBodyWidget(),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}