import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:negocio/anuncioBanner.dart';
import 'package:negocio/controllers/PagosController/pagosController.dart';
import 'package:negocio/db/db.dart';
import 'package:negocio/moneda.dart';
import 'package:negocio/mostrarMoneda.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class Pagos extends StatefulWidget {
  final int clienteId;
  final String clienteNombre;
  final int negocioId;

  const Pagos(
      {super.key,
      required this.clienteId,
      required this.clienteNombre,
      required this.negocioId});

  @override
  State<Pagos> createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  int anioValue = DateTime.now().year;
  double? montoValue;

  List<Map<String, dynamic>> listaMeses = [];
  Map<int, double> pagosPorMes = {};
  Map<int, int> listapagos = {};
  late final Pagoscontroller pagoscontroller;

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    pagoscontroller = Pagoscontroller(dbHelper);
    cargarMesesCuadricula();
  }

/* METODOS CRUD CARGAR


*/
  void cargarMesesCuadricula() async {
    final data = await pagoscontroller.obtenerCuadricula();
    final pagosDelAnio = await pagoscontroller
        .obtenerPagosPorClienteYAnioTodosLosMeses(anioValue, widget.clienteId);

    final Map<int, double> tempPagos = {};
    final Map<int, int> listPagosInterno = {};

    final Map<int, Map<String, dynamic>> pagosPorMesId = {
      for (var pago in pagosDelAnio) pago['mes'] as int: pago
    };

    for (var mes in data) {
      final pago = pagosPorMesId[mes['id']];
      double valorMes = pago != null ? (pago['monto'] ?? 0.0) : 0.0;
      int pagoId = pago != null ? (pago['id'] ?? 0) : 0;

      tempPagos[mes['id']] = valorMes;
      listPagosInterno[mes['id']] = pagoId;
    }
    if (mounted) {
      setState(() {
        listaMeses = data;
        pagosPorMes = tempPagos;
        listapagos = listPagosInterno;
      });
    }
  }

  // CREAR
  void agregarPagoPorCliente(int mes, int anio, double monto) async {
    final ok = await pagoscontroller.agregarPagoPorCliente(
        context, mes, anio, monto, widget.clienteId);

    if (ok) cargarMesesCuadricula();
  }

  // ACTUALIZAR
  void actualizarPagoPorCliente(int idPago, double monto) async {
    final ok =
        await pagoscontroller.editarPagosPorCliente(context, idPago, monto);

    if (ok) cargarMesesCuadricula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 3.0),
              child: Mostrarmoneda(),
            )
          ],
          title: Text(widget.clienteNombre),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: menosAnio,
                      icon: Icon(Icons.arrow_left, size: 28)),
                  Container(
                    width: 100,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          hintText: anioValue.toString(),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero),
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                      onPressed: masAnio,
                      icon: Icon(Icons.arrow_right, size: 28))
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: GridView.builder(
                  itemCount: listaMeses.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    // logica para obtener datos
                    final mes = listaMeses[index];
                    final idPago = listapagos[mes['id']] ?? 0;
                    // Busca el pago correspondiente a este mes
                    final monto = pagosPorMes[mes['id']] ?? 0.0;

                    return GestureDetector(
                      onTap: () => showAgregarEditarPago(
                          mes['id'], mes['mes'], monto, idPago),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: monto > 0
                                  ? [
                                      Colors.lightBlue.shade600,
                                      Colors.lightBlue.shade700
                                    ]
                                  : [
                                      Colors.grey.shade400,
                                      Colors.grey.shade700
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.attach_money,
                                color: Colors.white, size: 21),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //---------  monto   ----------
                                Text(
                                  monto > 99999
                                      ? monto.toStringAsFixed(0)
                                      : monto.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (monto < 99999)
                                        ? 28
                                        : (monto < 999999)
                                            ? 24
                                            : 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month,
                                    color: Colors.white, size: 15),
                                SizedBox(height: 3),
                                Text(mes['mes'],
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white70))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            Anunciobanner(idAnuncio: 'ca-app-pub-3503326553540884/4820268139'));
  }

  void showAgregarEditarPago(
      int mes, String mesNombre, double monto, int idPago) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('$mesNombre: $monto'),
              content: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  LengthLimitingTextInputFormatter(7),
                ],
                onChanged: (value) {
                  montoValue = double.tryParse(value);
                },
                decoration: InputDecoration(labelText: 'Monto'),
                maxLength: 7,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cerrar')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (idPago == 0 && montoValue != null) {
                        agregarPagoPorCliente(mes, anioValue, montoValue!);
                      } else if (idPago != 0) {
                        if (montoValue == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Ingrese un monto válido (solo números)'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else{
                          actualizarPagoPorCliente(idPago, montoValue!);
                        } 
                      }
                    },
                    
                    child: Text('Guardar'))
              ],
            ));
  }

  void masAnio() {
    setState(() {
      anioValue = anioValue + 1;
      cargarMesesCuadricula();
    });
  }

  void menosAnio() {
    setState(() {
      anioValue = anioValue - 1;
      cargarMesesCuadricula();
    });
  }
}
