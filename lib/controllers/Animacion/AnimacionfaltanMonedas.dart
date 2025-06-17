
  import 'package:flutter/material.dart';

void mostrarAnimacionFaltanMonedas(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        builder: (context) {
          Future.delayed(Duration(seconds: 4), () {
            Navigator.of(context).pop();
          });
          return Stack(children: [
            TweenAnimationBuilder(
              tween: Tween(begin: Offset(-1, 0), end: Offset(0.9, 0)),
              duration: Duration(seconds: 3),
              curve: Curves.easeInOut,
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(
                      offset.dx * MediaQuery.of(context).size.width / 2,
                      2), // se traslada en X, 2 en Y
                  child: child,
                );
              },
              child: Image.asset(
                'assets/img/click.png',
                width: 70,
                height: 70,
              ),
            ),
          ]);
        });
  }