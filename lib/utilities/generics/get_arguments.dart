import 'package:flutter/material.dart' show BuildContext, ModalRoute;

/*extension means include getargument in buildcontext class */

extension GetArguments on BuildContext {
  /*  T? getArguments<T> function of returntype T?  */
  T? getArguments<T>() {
    //variable which stores route of given context
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      //getting all the agrguments
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        //converting the argument object in given return type
        return args as T;
      }
    }

    // if argument is not present return null
    return null;
  }
}


/*extension GetArguments → Creates an extension to add new functionality to an existing class without modifying it.

on BuildContext → Specifies that this extension adds features to the BuildContext class (so we can call the method on context).

T? getArguments<T>() → Defines a method that can return any type T, or null if no arguments are found (? means nullable).

<T> after method name → Allows us to decide the type of argument we expect when calling the method (e.g., String, int, custom object).

final modalRoute = ModalRoute.of(this) → Gets the current route object for the given BuildContext (this means the current page's context).

if (modalRoute != null) → Checks if the route exists; if null, it means no route, so we can't fetch arguments.

final args = modalRoute.settings.arguments → Accesses the arguments stored in the route’s settings (data passed when navigating).

if (args != null && args is T) → Ensures arguments exist and also checks if they match the expected type T.

return args as T → Returns the arguments after converting (casting) them to the expected type T.

return null → Returns null if no arguments exist or type doesn’t match, preventing errors. */