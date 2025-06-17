import 'package:flutter/material.dart';
import 'package:negocio/controllers/Animacion/AnimacionfaltanMonedas.dart';
import 'package:negocio/db/db.dart';
import 'package:negocio/moneda.dart';
import 'package:provider/provider.dart';

class NegociosController {
  final DatabaseHelper dbHelper;
  NegociosController(this.dbHelper);
  final double restarMoneda = 5;
  Future<List<Map<String, dynamic>>> getNegocios() async {
    return await dbHelper.mostrarNegocios();
  }

  Future<bool> agregarNegocio(BuildContext context, String nombre) async {
    final monedaControl = Provider.of<MoneyProvider>(context, listen: false);
    if (monedaControl.moneda - restarMoneda <0) {
      mostrarAnimacionFaltanMonedas
      (context);
      return false;
    } else {
      monedaControl.restar(restarMoneda);
      await dbHelper.addNegocio(nombre);
      return true;
    }
  }

  Future<bool> editarNegocio(
      BuildContext context, int id, String nombre) async {
    final monedaControl = Provider.of<MoneyProvider>(context, listen: false);
    if (monedaControl.moneda - restarMoneda < 0) {
      mostrarAnimacionFaltanMonedas(context);
      return false;
    } else {
      monedaControl.restar(restarMoneda);
      await dbHelper.editNegocio(id, nombre);
      return true;
    }
  }

  Future<void> eliminarNegocio(int id) async {
    await dbHelper.eliminarNegocioYClienteYPagos(id);
  }

 
  
}
