import 'package:flutter/material.dart';
import 'package:negocio/moneda.dart';
import 'package:provider/provider.dart';

class Mostrarmoneda extends StatelessWidget {
  final void Function()? onTap;
  const Mostrarmoneda({Key? key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final moneda = Provider.of<MoneyProvider>(context);
    return GestureDetector(
      onTap: () {
        Provider.of<MoneyProvider>(context, listen: false)
            .showAnuncioRecompenza(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/cobrar.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 4),
            Text(
              moneda.moneda.toStringAsFixed(1),
              style: TextStyle(
                color: const Color.fromARGB(255, 251, 109, 0),
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.add_circle, color: Colors.amber[800], size: 22),
          ],
        ),
      ),
    );
  }
}
