import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orbital_spa/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  /// Creates a singleton
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text
  }) {
    if (controller?.update(text) ?? false) {
      // Controller updates successfully as there is already a controller
      // Do nothing
      return;
    } else {
      controller = showOverlay(
        context: context, 
        text: text
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    // Find out current available size
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                // Loading screen can only take up 80 percent of the available size
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container();
                          }
                        }
                      )
                    ],
                  )
                ),
              )
            ),
          ),
        );
      }
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      }, 
      update: (text) {
        _text.add(text);
        return true;
      }
    );
  }
}
