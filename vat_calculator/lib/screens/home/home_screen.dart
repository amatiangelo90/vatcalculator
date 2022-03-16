import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:vat_calculator/components/loader_overlay_widget.dart';
import 'package:vat_calculator/models/databundlenotifier.dart';
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