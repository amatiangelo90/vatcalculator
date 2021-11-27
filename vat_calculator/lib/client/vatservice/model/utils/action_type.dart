import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';

class ActionType{
  // Creation actions
  static const String BRANCH_CREATION = 'CREAZIONE ATTIVITA';
  static const String SUPPLIER_CREATION = 'CREAZIONE FORNITORE';
  static const String SUPPLIER_ASSOCIATION = 'ASSOCIAZIONE FORNITORE';
  static const String STORAGE_CREATION = 'CREAZIONE MAGAZZINO';
  static const String EVENT_CREATION = 'CREAZIONE EVENTO';

  static const String ORDER_CREATION = 'CREAZIONE ORDINE';
  static const String DRAFT_ORDER_CREATION = 'CREAZIONE BOZZA ORDINE';
  static const String PROVIDER_CREATION = 'CREAZIONE PROVIDER FATTURAZIONE';
  static const String RECESSED_CREATION = 'CREAZIONE INCASSO';
  static const String PRODUCT_CREATION = 'CREAZIONE PRODOTTO';
  static const String ADD_PRODUCT_TO_STORAGE = 'AGGIUNTA PRODOTTO A MAGAZZINO';

  // Edit Actions
  static const String BRANCH_EDIT                     = 'MODIFICA ATTIVITA';
  static const String SUPPLIER_EDIT                   = 'MODIFICA FORNITORE';
  static const String STORAGE_EDIT                    = 'MODIFICA MAGAZZINO';
  static const String EVENT_EDIT                      = 'MODIFICA EVENTO';
  static const String ORDER_EDIT                      = 'MODIFICA ORDINE';
  static const String PRODUCT_EDIT                    = 'MODIFICA PRODOTTO';

  // Delete Actions
  static const String BRANCH_DELETE                   = 'CANCELLAZIONE ATTIVITA';
  static const String SUPPLIER_DELETE                 = 'CANCELLAZIONE FORNITORE';
  static const String STORAGE_DELETE                  = 'CANCELLAZIONE MAGAZZINO';
  static const String EVENT_DELETE                    = 'CANCELLAZIONE EVENTO';
  static const String ORDER_DELETE                    = 'CANCELLAZIONE ORDINE';
  static const String PROVIDER_DELETE                 = 'CANCELLAZIONE PROVIDER FATTURAZIONE';
  static const String PRODUCT_DELETE                  = 'CANCELLAZIONE PRODOTTO';
  static const String REMOVE_PRODUCT_FROM_STORAGE     = 'RIMOZIONE PRODOTTO DA MAGAZZINO';

  //LOAD/UNLOAD Storage
  static const String STORAGE_LOAD = 'CARICO PRODOTTO IN MAGAZZINO';
  static const String STORAGE_UNLOAD = 'SCARICO PRODOTTO DAL MAGAZZINO';

  //Send order
  static const String SENT_ORDER = 'ORDINE INVIATO';
  static const String RECEIVED_ORDER = 'ORDINE RICEVUTO';

  static Widget getIconWidget(String type){

    switch(type){
        case BRANCH_CREATION:
        break;
        case SUPPLIER_CREATION:
          return buildIconWidget('assets/icons/supplier.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.add_circle_outline,
            Colors.blue.shade900,);
        case SUPPLIER_ASSOCIATION:
          return buildIconWidget('assets/icons/supplier.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.compare_arrows_sharp,
            Colors.blue.shade900,);
        break;
        case STORAGE_CREATION:
        break;
        case EVENT_CREATION:
        break;
        case ORDER_CREATION:
        break;
        case DRAFT_ORDER_CREATION:
          return buildIconWidget('assets/icons/receipt.svg',
            Colors.yellow.shade700.withOpacity(0.9),
            Colors.yellow.withOpacity(0.2),
            Icons.edit,
            Colors.yellow.shade700,);
        case PROVIDER_CREATION:
        break;
        case RECESSED_CREATION:
        break;
        case PRODUCT_CREATION:
          return buildIconWidget('assets/icons/product.svg',
            Colors.orange.shade700.withOpacity(0.9),
            Colors.orange.withOpacity(0.2),
            Icons.add_circle_outline,
            Colors.green.shade900,);
        case ADD_PRODUCT_TO_STORAGE:
        break;
        case BRANCH_EDIT:
        break;
        case SUPPLIER_EDIT:
        break;
        case STORAGE_EDIT:
        break;
        case EVENT_EDIT:
        break;
        case ORDER_EDIT:
        break;
        case PRODUCT_EDIT:
        break;
        case BRANCH_DELETE:
        break;
        case SUPPLIER_DELETE:
        break;
        case STORAGE_DELETE:
        break;
        case EVENT_DELETE:
        break;
        case ORDER_DELETE:
          return buildIconWidget('assets/icons/receipt.svg',
            Colors.red.shade700.withOpacity(0.9),
            Colors.red.withOpacity(0.2),
            Icons.delete,
            kPinaColor,);
        case PROVIDER_DELETE:
        break;
        case PRODUCT_DELETE:
        break;
        case REMOVE_PRODUCT_FROM_STORAGE:
        break;
        case STORAGE_LOAD:
          return buildIconWidget('assets/icons/storage.svg',
            Colors.green.shade700.withOpacity(0.9),
            Colors.green.withOpacity(0.2),
            Icons.arrow_circle_up_outlined,
            Colors.green.shade900,);
        case STORAGE_UNLOAD:
          return buildIconWidget('assets/icons/storage.svg',
            Colors.redAccent.shade700.withOpacity(0.9),
            Colors.redAccent.withOpacity(0.4),
            Icons.arrow_circle_down_outlined,
            kPinaColor,);
        case SENT_ORDER:
          return buildIconWidget('assets/icons/receipt.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.message,
            Colors.blueAccent.shade700,);
      case RECEIVED_ORDER:
        return buildIconWidget('assets/icons/receipt.svg',
          Colors.green.shade700.withOpacity(0.9),
          Colors.green.withOpacity(0.2),
          Icons.check_circle_outline,
          Colors.green.shade900,);
      default:
        return buildIconWidget('assets/icons/question-mark.svg',
          Colors.black.withOpacity(0.9),
          Colors.black.withOpacity(0.2),
          Icons.clear,
          Colors.black,);
    }
  }

  static Widget buildIconWidget(String icon, Color iconColor, Color backgroundColor, IconData iconBanner, Color iconBannerColor) {
    return Stack(
      children: [
        Container(
          height: getProportionateScreenWidth(40),
          decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle
          ),
          width: getProportionateScreenWidth(50),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(icon, color: iconColor,),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Center(
            child: Icon(
              iconBanner,
              color: iconBannerColor,
              size: getProportionateScreenHeight(25),
            ),
          ),
        ),
      ],
    );
  }
}