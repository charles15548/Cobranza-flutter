
import 'package:flutter/material.dart';
import 'package:negocio/controllers/Animacion/AnimacionfaltanMonedas.dart';
import 'package:negocio/db/db.dart';
import 'package:negocio/moneda.dart';
import 'package:provider/provider.dart';

class Clientescontroller {
  final DatabaseHelper dbHelper;
  Clientescontroller(this.dbHelper);
  final double restarMoneda = 5;

  Future<List<Map<String,dynamic>>> getClientes(int negocioId) async{
    return await dbHelper.mostrarClientesPorNegocio(negocioId);
  }

  Future<bool> agregarClientePorNegocio(BuildContext context, String nombre, int negocioId) async {
    final monedaControl = Provider.of<MoneyProvider>(context, listen: false);
    if (monedaControl.moneda - restarMoneda <0) {
      mostrarAnimacionFaltanMonedas
      (context);
      return false;
    } else {
      monedaControl.restar(restarMoneda);
      await dbHelper.addClientesPorNegocio(nombre, negocioId);
      return true;
    }

    
  }
  Future<bool> editarCliente(BuildContext context, int id, String nombre) async{
    final monedaControl = Provider.of<MoneyProvider>(context, listen: false);
    if (monedaControl.moneda - restarMoneda < 0) {
      mostrarAnimacionFaltanMonedas
      (context);
      return false;
    } else {
      monedaControl.restar(restarMoneda);
      await dbHelper.editClientes(nombre, id);
      return true;
    }
  }
  Future<void> eliminarClienteYPagos(int id)async{
    await dbHelper.eliminarClienteYPagos(id);
  }
}