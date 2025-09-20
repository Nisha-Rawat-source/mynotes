import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An error occured',
    content: text,

    /*option builder is deffined for generic dialog for button creation*/
    optionBulider: () => {
      'OK': null,
    },
  );
}
