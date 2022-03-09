import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vat_calculator/components/icon_custom.dart';

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
  static const String EXPENCE_CREATION = 'CREAZIONE SPESA';
  static const String PRODUCT_CREATION = 'CREAZIONE PRODOTTO';
  static const String ADD_PRODUCT_TO_STORAGE = 'AGGIUNTA PRODOTTO A MAGAZZINO';
  static const String EVENT_STORAGE_UNLOAD = 'SCARICO POSTAZIONE EVENTO';
  static const String EVENT_STORAGE_LOAD = 'CARICO POSTAZIONE EVENTO';

  // Edit Actions
  static const String BRANCH_EDIT                     = 'MODIFICA ATTIVITA';
  static const String SUPPLIER_EDIT                   = 'MODIFICA FORNITORE';
  static const String STORAGE_EDIT                    = 'MODIFICA MAGAZZINO';
  static const String EVENT_EDIT                      = 'MODIFICA EVENTO';
  static const String ORDER_EDIT                      = 'MODIFICA ORDINE';
  static const String PRODUCT_EDIT                    = 'MODIFICA PRODOTTO';
  static const String EXPENCE_UPDATE                  = 'MODIFICA SPESA';
  static const String RECESSED_UPDATE                 = 'MODIFICA INCASSO';

  // Delete Actions
  static const String BRANCH_DELETE                   = 'CANCELLAZIONE ATTIVITA';
  static const String SUPPLIER_DELETE                 = 'CANCELLAZIONE FORNITORE';
  static const String STORAGE_DELETE                  = 'CANCELLAZIONE MAGAZZINO';
  static const String EVENT_DELETE                    = 'CANCELLAZIONE EVENTO';
  static const String ORDER_DELETE                    = 'CANCELLAZIONE ORDINE';
  static const String PROVIDER_DELETE                 = 'CANCELLAZIONE PROVIDER FATTURAZIONE';
  static const String PRODUCT_DELETE                  = 'CANCELLAZIONE PRODOTTO';
  static const String EXPENCE_DELETE                  = 'CANCELLAZIONE SPESA';
  static const String REMOVE_PRODUCT_FROM_STORAGE     = 'RIMOZIONE PRODOTTO DA MAGAZZINO';
  static const String RECESSED_DELETE                 = 'CANCELLAZIONE INCASSO';

  //LOAD/UNLOAD Storage
  static const String STORAGE_LOAD = 'CARICO PRODOTTO IN MAGAZZINO';
  static const String STORAGE_UNLOAD = 'SCARICO PRODOTTO DAL MAGAZZINO';

  //Send order
  static const String SENT_ORDER = 'ORDINE INVIATO';
  static const String RECEIVED_ORDER = 'ORDINE RICEVUTO';

  //Update Privilege
  static const String UPDATE_PRIVILEGE = 'AGGIORNAMENTO PRIVILEGI UTENTE';

  static Widget getIconWidget(String type){

    switch(type){
        case BRANCH_CREATION:
        break;
        case SUPPLIER_CREATION:
          return CustomIcon.buildIconWidget(
              'assets/icons/supplier.svg',
              Colors.blue.shade700.withOpacity(0.9),
              Colors.blue.withOpacity(0.2),
              Icons.add_circle_outline,
              Colors.blue.shade900,
              SUPPLIER_CREATION);
        case SUPPLIER_ASSOCIATION:
          return CustomIcon.buildIconWidget('assets/icons/supplier.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.compare_arrows_sharp,
            Colors.blue.shade900,
              SUPPLIER_ASSOCIATION);
        case STORAGE_CREATION:
          return CustomIcon.buildIconWidget('assets/icons/storage.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.add_circle_outline,
            Colors.blue.shade900,
              STORAGE_CREATION);
        case EVENT_CREATION:
          return CustomIcon.buildIconWidget('assets/icons/party.svg',
              customGreenAccent,
              Colors.black.withOpacity(0.7),
              Icons.add_circle_outline,
              customGreenAccent,
              EVENT_CREATION);

        case UPDATE_PRIVILEGE:
          return CustomIcon.buildIconWidget('assets/icons/User.svg',
              Colors.deepPurpleAccent.shade700.withOpacity(0.9),
              Colors.deepPurpleAccent.withOpacity(0.2),
              Icons.edit_outlined,
              Colors.deepPurpleAccent,
              UPDATE_PRIVILEGE);
        case ORDER_CREATION:
        break;
        case DRAFT_ORDER_CREATION:
          return CustomIcon.buildIconWidget('assets/icons/receipt.svg',
            Colors.yellow.shade700,
            Colors.yellow.withOpacity(0.2),
            Icons.add_circle_outline,
              Colors.brown.withOpacity(0.9),
              DRAFT_ORDER_CREATION);
        case PROVIDER_CREATION:
        break;
        case RECESSED_CREATION:
          return CustomIcon.buildIconWidget('assets/icons/euro.svg',
              Colors.deepPurple.shade700.withOpacity(0.9),
              Colors.orange.withOpacity(0.2),
              Icons.edit,
              Colors.deepPurple.shade900,
              RECESSED_CREATION);
        case PRODUCT_CREATION:
          return CustomIcon.buildIconWidget('assets/icons/product.svg',
            Colors.orange.shade700.withOpacity(0.9),
            Colors.orange.withOpacity(0.2),
            Icons.add_circle_outline,
            Colors.green.shade900,PRODUCT_CREATION);
        case ADD_PRODUCT_TO_STORAGE:
          return CustomIcon.buildIconWidget('assets/icons/product.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.exit_to_app,
            Colors.blue.shade900,ADD_PRODUCT_TO_STORAGE);
        case BRANCH_EDIT:
        break;
        case SUPPLIER_EDIT:
          return CustomIcon.buildIconWidget('assets/icons/supplier.svg',
              Colors.yellow.shade700,
              Colors.yellow.withOpacity(0.2),
              Icons.edit,
              Colors.brown,
              SUPPLIER_EDIT);
        case STORAGE_EDIT:
        break;
        case EVENT_EDIT:
          return CustomIcon.buildIconWidget('assets/icons/party.svg',
              Colors.orange.shade300,
              Colors.yellow.withOpacity(0.2),
              Icons.edit,
              Colors.redAccent,
              EVENT_EDIT);
        case ORDER_EDIT:
        break;
        case PRODUCT_EDIT:
        break;
        case EXPENCE_DELETE:
        break;
        case EXPENCE_UPDATE:
        break;
        case BRANCH_DELETE:
        break;
        case SUPPLIER_DELETE:
          return CustomIcon.buildIconWidget('assets/icons/supplier.svg',
            Colors.red.shade700.withOpacity(0.9),
            Colors.red.withOpacity(0.2),
            Icons.highlight_remove_outlined,
            Colors.red.shade900,
              SUPPLIER_DELETE);
        case STORAGE_DELETE:
          return CustomIcon.buildIconWidget('assets/icons/storage.svg',
            Colors.red.shade700.withOpacity(0.9),
            Colors.red.withOpacity(0.2),
            Icons.highlight_remove_outlined,
            Colors.red.shade900,STORAGE_DELETE);
        case EVENT_DELETE:
        break;
        case ORDER_DELETE:
          return CustomIcon.buildIconWidget('assets/icons/receipt.svg',
            Colors.red.shade700.withOpacity(0.9),
            Colors.red.withOpacity(0.2),
            Icons.highlight_remove_outlined,
            kPinaColor,ORDER_DELETE);
          case EVENT_STORAGE_UNLOAD:
          return CustomIcon.buildIconWidget('assets/icons/party.svg',
            Colors.red.shade700.withOpacity(0.9),
            Colors.red.withOpacity(0.2),
            Icons.arrow_circle_down_sharp,
            kPinaColor, EVENT_STORAGE_UNLOAD);
          case EVENT_STORAGE_LOAD:
          return CustomIcon.buildIconWidget('assets/icons/party.svg',
              Colors.green.shade700.withOpacity(0.9),
            Colors.green.withOpacity(0.2),
            Icons.arrow_circle_up_outlined,
            Colors.green.shade700, EVENT_STORAGE_LOAD);
        case PROVIDER_DELETE:
          return CustomIcon.buildIconWidget('assets/icons/Parcel.svg',
            Colors.red.shade700.withOpacity(0.9),
            Colors.red.withOpacity(0.2),
            Icons.highlight_remove_outlined,
            Colors.red.shade900,PROVIDER_DELETE);
        case PRODUCT_DELETE:
          return CustomIcon.buildIconWidget('assets/icons/product.svg',
            Colors.redAccent.shade700.withOpacity(0.9),
            Colors.redAccent.withOpacity(0.2),
            Icons.highlight_remove_outlined,
            kPinaColor,PRODUCT_DELETE);
        case REMOVE_PRODUCT_FROM_STORAGE:
        break;
        case STORAGE_LOAD:
          return CustomIcon.buildIconWidget('assets/icons/storage.svg',
            Colors.green.shade700.withOpacity(0.9),
            Colors.green.withOpacity(0.2),
            Icons.arrow_circle_up_outlined,
            Colors.green.shade900,STORAGE_LOAD);
        case STORAGE_UNLOAD:
          return CustomIcon.buildIconWidget('assets/icons/storage.svg',
            Colors.redAccent.shade700.withOpacity(0.9),
            Colors.redAccent.withOpacity(0.4),
            Icons.arrow_circle_down_outlined,
            kPinaColor,STORAGE_UNLOAD);

          case SENT_ORDER:
          return CustomIcon.buildIconWidget('assets/icons/receipt.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.message,
            Colors.blueAccent.shade700,
              SENT_ORDER);

      case RECEIVED_ORDER:
        return CustomIcon.buildIconWidget('assets/icons/receipt.svg',
          Colors.green.shade700.withOpacity(0.9),
          Colors.green.withOpacity(0.2),
          Icons.check_circle_outline,
          Colors.green.shade900,
            RECEIVED_ORDER
        );
      default:
        return CustomIcon.buildIconWidget('assets/icons/question-mark.svg',
          Colors.black.withOpacity(0.9),
          Colors.black.withOpacity(0.2),
          Icons.highlight_remove_outlined,
          Colors.black,
          'Icona da creare');
    }
  }


}