import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  /*Every object of this class shares _shared (because it is static, meaning the 
  whole class has only one copy), which stores the object created by the private
 constructor. The factory constructor then provides _shared to the entire app. */

  // static = one copy for whole class, shared by all objects

  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  /*/* show() checks if a loading screen already exists.
   - If yes → it just updates the text using the controller.
   - If not → it calls showOverlay() to create a new loading screen.
   Basically, show() manages when to update or create the overlay. */
 */

  void show({
    required BuildContext context,
    required String text,
  }) {
    /*controller?.update(text) this line is calling the update function If
     controller is not null, call the function.If it is null, skip the call and
     If there is a controller (overlay already exists), call its update(text) function.
      Take the return value from that function.
      If there’s no controller, treat it as false (no overlay to update).*/

    if (controller?.update(text) ?? false) {
      return;
    }

    /*If controller exists and controller.update(text) returns true, the if condition becomes true.

That means: an overlay was already shown and its text was updated successfully → do nothing else, return.

If controller is null (no overlay) or update returns false, the condition is false.

That means: we must create a new overlay, so the function proceeds to call showOverlay().*/

    else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    //in this close is loadingscreencontroller function defined below
    controller?.close();
    controller = null;
  }

/*This function will return an object of type LoadingScreenController. */

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    /*Overlay.of(context) is a Flutter method that gives you the current overlay 
    layer for the given widget tree.Every screen in Flutter already has an Overlay
     (even if you don’t see it).You need this Overlay state to insert or remove OverlayEntries.

      Think of it like this:
      Term	Analogy
      Overlay	Transparent sheet on top of the screen
      OverlayEntry	Sticky note on the sheet
      Overlay.of(context)	Gives you the sheet so you can add/remove sticky notes */

    final state = Overlay.of(context);

    /* 
Intrinsic size = widget’s natural size based on content.
Overlay = full-screen layer for floating widgets (dialogs, menus, etc.).
It skips normal layout, fills the screen, and doesn’t measure children,
so it has no intrinsic size. OverlayState only manages entries, not layout.
*/

/*This method traverses down the widget tree to find the RenderObject that is 
attached to the widget’s context. */

/*// context.findRenderObject():
// Finds the RenderObject (the actual box drawn on screen)
// linked to this widget’s BuildContext.
// Usually cast to RenderBox to get size or position. 
context is basically a handle or reference to the location of a widget in the widget tree.
it knows your widget’s position, parent widgets, and more.
*/

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

/*by default OverlayEntry doesnot have parent scafold or material wideget so we
wrap it into material or scaffold so iit does not have horrible styling  */

    final overlay = OverlayEntry(
      builder: (context) {
        /*It’s like the foundation layer on which all other Material-style 
        widgets (like Buttons, Cards, AppBars, etc.) are built */

        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(

                /* BoxConstraints sets the minimum and maximum width and height
               that a widget is allowed to take */

                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                  maxHeight: size.height * 0.8,
                  minWidth: size.width * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),

                /* Padding adds empty space INSIDE the container from all sides.
                    Here, EdgeInsets.all(16.0) means 16 pixels of space on top, bottom,
                    left, and right — so the content (spinner & text) doesn’t touch
                    the container’s edges and looks properly spaced. */

                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  /*SingleChildScrollView is a scrollable widget that allows 
                  only one child widget inside it to be scrollable when it 
                  overflows (goes beyond the screen) */

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),

                        /*StreamBuilder is a special Flutter widget that listens
                         to a stream (a continuous flow of data) and rebuilds the 
                         UI every time the stream sends new data.
                        “Whenever there’s a new message in the stream, update the screen!” */

                        StreamBuilder(
                            stream: _text
                                .stream, //whenever chnages come listerrn and rebuilt
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data as String,
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return Container();
                              }
                            })
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );

/* this line the entire overlay (overlayentry) on state of overlay defined above as state*/
    state?.insert(overlay);

    /* Here the function returns an object of LoadingScreenController,
   which contains two functions: close() and update(). These functions
   help control (close or update) the loading screen from outside. */
    return LoadingScreenController(
      close: () {
        // Stops the StreamController from sending or receiving more data.
        _text.close();
        // Removes the overlay (loading popup) from the screen.
        overlay.remove();
        // Returns true to confirm that closing was successful.
        return true;
      },
      update: (text) {
        // Sends (adds) a new text value into the StreamController.
        // StreamBuilder listens to this and updates the loading message.
        _text.add(text);
        // Returns true to confirm the update was successful.
        return true;
      },
    );
  }
}
