import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out',
    optionBulider: () => {
      'cancel': false,
      'log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
//explore more about dialog