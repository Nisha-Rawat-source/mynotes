import 'package:flutter/widgets.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String text);

/*A controller class that holds functions to manage (close or update)
 the loading screen. */
@immutable
class LoadingScreenController {
  //A fixed variable that stores a function
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}

/*Overlay is a layer on top of the app screen used to show popups or loading
 screens; OverlayEntry is a small widget piece added or removed from that layer;
  Controller is an object that helps show, hide, or update the overlay easily 
  from anywhere in the app.basically to control thngs*/
