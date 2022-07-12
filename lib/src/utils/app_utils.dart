import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sogo_flutter/src/widgets/error_message.dart';


class AppUtils {
  static void showToast(String? text, {Color color = Colors.red, bool isLong = false}) {
    if (text == null) return;
    Fluttertoast.showToast(
        msg: text,
        toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  static Future<dynamic> openBottomSheet({required BuildContext context, required Widget child, double cornerRadius = 30.0}) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius)),
        ),
        builder: (context) {
          return child;
        });
  }

  static void showMessage(
      {required BuildContext context, required String title, required String message, VoidCallback? onOk}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: ErrorMessagePopup(title: title, message: message, onOk: onOk,),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static late ConfettiController _controllerCenter;

  static void showCustomDialog({required BuildContext context, required Widget dialogBox, bool withConfetti = false}) {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: dialogBox,
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                numberOfParticles: 30,
                blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
                emissionFrequency: 0.01,
                shouldLoop: false, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        anim.addStatusListener((status) {
          if(status == AnimationStatus.completed){
            if(_controllerCenter.state == ConfettiControllerState.stopped && withConfetti){
              _controllerCenter.play();
            }
          }
          if(status == AnimationStatus.reverse){
            if(_controllerCenter.state == ConfettiControllerState.playing){
              _controllerCenter.stop();
            }
          }
        });
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}