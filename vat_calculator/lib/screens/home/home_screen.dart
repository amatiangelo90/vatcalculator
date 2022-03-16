import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/client/vatservice/model/utils/privileges.dart';
import 'package:vat_calculator/components/common_drawer.dart';
import 'package:vat_calculator/components/coustom_bottom_nav_bar.dart';
import 'package:vat_calculator/components/fab/fab_widget.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
import 'package:vat_calculator/screens/event/component/event_create_screen.dart';
import 'package:vat_calculator/screens/orders/components/screens/order_creation/order_create_screen.dart';
import 'package:vat_calculator/screens/registration_provider/fatture_provider_registration.dart';
import 'package:vat_calculator/screens/vat_calculator/aruba/aruba_home_screen.dart';
import 'package:vat_calculator/screens/vat_calculator/fatture_in_cloud/fatture_in_cloud_home_screen.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<DataBundleNotifier>(
      builder: (context, dataBundleNotifier, child) {
        return LoaderOverlay(
          useDefaultLoading: false,
          overlayOpacity: 0.9,
          overlayWidget: const LoaderOverlayWidget(message: 'Caricamento dati...',),
          child: Container(
            child: const HomePageBody(),
          ),
        );
      },
    );
  }
}