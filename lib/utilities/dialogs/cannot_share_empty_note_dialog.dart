import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: "Sharing",
    content: "you cannot share an empty note!",
    optionBulider: () => {
      'ok': null,
    },
  );
}
