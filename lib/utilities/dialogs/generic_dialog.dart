import 'package:flutter/material.dart';

typedef DialogOptionBulider<T> = Map<String, T?> Function();
/*typdef is typedefination here it is defining a definition of function with name 
DialogOptionBulider<T> which returns a function of type Map<String, T?>
we are building this type def for button which will have text as it name and 
particular type of vlaue thats why we use map*/

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBulider optionBulider,
}) {
  /*option is map which is calling a function optionBulider which have map
  key and value asign to variable this is of type string for button name
  and dynamic for return value this us beign assign in function implemetation
  in other dialog*/
  final options = optionBulider();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop;
                }
              },
              child: Text(optionTitle),
            );
          }).toList());

      /*options.keys →

options is a Map like { "Yes": true, "No": false }

.keys gives → "Yes", "No" (button names).

.map((optionTitle) { ... }) →

For each button name (optionTitle), we will create a TextButton.

final value = options[optionTitle]; →

Looks up the value for the current button name.

For "Yes" → value = true, for "No" → value = false.

TextButton(...) →

Creates a button with optionTitle as its text.

onPressed →

Runs when the button is clicked.

If value is not null → Close dialog and return the value using Navigator.pop(value).

If value is null → Just close the dialog without returning anything.

.toList() →

Because map() gives us an Iterable, we convert it into a List of buttons. */
    },
  );
}


/*generics let you write reusable code that can work with different data types without rewriting it for each type.

Think of it like a template:

Instead of fixing the type (like int or String),

You keep it flexible using a placeholder like <T> (T stands for "Type").
When creating objects, we decide what type T will be (int, String, etc.). */