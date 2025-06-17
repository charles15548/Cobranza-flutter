
import 'package:flutter/material.dart';
import 'package:negocio/controllers/Animacion/AnimacionfaltanMonedas.dart';
import 'package:negocio/db/db.dart';
import 'package:negocio/moneda.dart';
import 'package:provider/provider.dart';

class Pagoscontroller {
  final DatabaseHelper dbHelper;
  Pagoscontroller(this.dbHelper);
  final double restarMoneda = 4;

  Future<List<Map<String,dynamic>>> obtenerCuadricula() async{
    return await dbHelper.obtenerCuadricula();
  }
  Future<List<Map<String,dynamic>>> obtenerPagosPorClienteYAnioTodosLosMeses(int anio,int id) async{
    return await dbHelper.obtenerPagosPorClienteYAnioTodosLosMeses(anio,id);
  }


  

  Future<bool> agregarPagoPorCliente(BuildContext context, int mes, int anio, double monto, int clienteId) async {
    final monedaControl = Provider.of<MoneyProvider>(context, listen: false);
    if (monedaControl.moneda - restarMoneda <0) {
      mostrarAnimacionFaltanMonedas
      (context);
      return false;
    } else {
      monedaControl.restar(restarMoneda);
      await dbHelper.addPagosPorCliente(mes, anio, monto, clienteId);
      return true;
    } 
  }
   Future<bool> editarPagosPorCliente(BuildContext context,int idPago, double monto) async {
    final monedaControl = Provider.of<MoneyProvider>(context, listen: false);
    if (monedaControl.moneda - restarMoneda <0) {
      mostrarAnimacionFaltanMonedas
      (context);
      return false;
    } else {
      monedaControl.restar(restarMoneda);
      await dbHelper.updatePagosPorCliente(idPago, monto);
      return true;
    } 
  }
}