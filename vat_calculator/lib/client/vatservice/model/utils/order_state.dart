import 'package:flutter/material.dart';
import 'package:vat_calculator/components/icon_custom.dart';

class OrderState{
  static const String DRAFT = 'BOZZA';
  static const String SENT = 'INVIATO';
  static const String INCOMING = 'IN ARRIVO';
  static const String READ = 'LETTO';
  static const String ACCEPTED = 'ACCETTATO';
  static const String REFUSED = 'RIFIUTATO';
  static const String ARCHIVED = 'ARCHIVIATO';
  static const String RECEIVED_ARCHIVED = 'RICEVUTO E ARCHIVIATO';
  static const String NOT_RECEIVED_ARCHIVED = 'NON RICEVUTO E ARCHIVIATO';
  static const String REFUSED_ARCHIVED = 'RIFIUTATO E ARCHIVIATO';

  static getIconWidget(String status) {

    switch(status){
      case SENT:
        return CustomIcon.buildIconWidget('assets/icons/receipt.svg',
            Colors.blue.shade700.withOpacity(0.9),
            Colors.blue.withOpacity(0.2),
            Icons.message,
            Colors.blueAccent.shade700,
            SENT);
        case INCOMING:
        return CustomIcon.buildIconWidget('assets/icons/receipt.svg',
            Colors.green.shade700.withOpacity(0.9),
            Colors.green.withOpacity(0.2),
            Icons.arrow_back,
            Colors.green.shade700,
            INCOMING);
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