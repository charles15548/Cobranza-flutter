import 'package:flutter/material.dart';
import 'package:negocio/negocios.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Negocios()),
                );
              },
              icon: Icon(Icons.storefront,size: 29,),
              tooltip: 'Inicio',
            ),
            SizedBox(
              width: 40,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings,size: 29,),
              tooltip: 'Configuración',
            )
          ],
        ));
  }
}
