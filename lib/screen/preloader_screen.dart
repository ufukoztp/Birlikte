import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///App prelaoder section
class Preloader extends ModalRoute<void> {

  var message = "";

  Preloader(message) {
    this.message = message;
  }

  updateText(message) {
    this.message = message;
    changedExternalState();
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  onBackPressed(cxt) {}

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return new WillPopScope(
      child: Material(
          type: MaterialType.transparency,
          // make sure that the overlay content is not cut off
          child: SafeArea(
            child: _buildOverlayContent(context, message),
          )),
      // ignore: missing_return
      onWillPop: () {
       return onBackPressed(context);
      },
    );
  }

  Widget _buildOverlayContent(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SpinKitPumpingHeart(
            color:  Color(0xff517BED),
            size: 60,
            duration: Duration(seconds: 1),
          ),
          Visibility(
            visible: message.length > 0 ? true : false,
            child: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Center(
                child: Text(message,
                    style:TextStyle(
                        color: Color(0xff517BED),
                        fontSize: 15.0,
                        fontFamily: 'MontserratBold'
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}