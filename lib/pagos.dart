import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:negocio/db.dart';

class Pagos extends StatefulWidget {
  final int clienteId;
  final int negocioId;
  const Pagos({super.key, required this.clienteId, required this.negocioId});

  @override
  State<Pagos> createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  @override
  void initState() {
    super.initState();
    // cargarPagosPorclientePorAnio();
    cargarMesesCuadricula();
  }

  int anioValue = DateTime.now().year;
  double? montoValue;
  

  List<Map<String, dynamic>> listaMeses = [];
  Map<int, double> pagosPorMes = {};
  Map<int, int> listapagos = {};

  final dbHelper = DatabaseHelper();

/*
  METODOS CRUD
  CARGAR


  void cargarMesesCuadricula() async {
    final data = await dbHelper.obtenerCuadricula();
    final Map<int, double> tempPagos = {};
    final Map<int, int> listPagosInterno = {};

    for (var mes in data) {
      final pagos = await dbHelper.obtenerPagosPorClienteYAnio(
          mes['id'], anioValue, widget.clienteId);

      double valorMes = 0.0;
      valorMes = pagos.isNotEmpty ? pagos[0]['monto'] : 0.0;
      int pagoId = pagos.isNotEmpty ? pagos[0]['id'] : 0;

      tempPagos[mes['id']] = valorMes;
      listPagosInterno[mes['id']] = pagoId;
    }

    setState(() {
      listaMeses = data;
      pagosPorMes = tempPagos;
      listapagos = listPagosInterno;
    });
  }
*/
  void cargarMesesCuadricula()async
  {
    final data = await dbHelper.obtenerCuadricula();
    final pagosDelAnio = await dbHelper.obtenerPagosPorClienteYAnioTodosLosMeses(anioValue, widget.clienteId);
  
    final Map<int, double> tempPagos={};
    final Map<int, int> listPagosInterno ={};

    final Map<int, Map<String, dynamic>> pagosPorMesId = {
      for (var pago in pagosDelAnio) pago['mes'] as int: pago
    };

    for( var mes in data){
      final pago = pagosPorMesId[mes['id']];
      double valorMes = pago != null ? (pago['monto']?? 0.0):0.0;
      int pagoId = pago != null ?(pago['id']?? 0): 0;

      tempPagos[mes['id']] = valorMes;
      listPagosInterno[mes['id']] = pagoId;

    }
    setState(() {
      listaMeses = data;
      pagosPorMes = tempPagos;
      listapagos = listPagosInterno;
    });
  }
  

  // CREAR
  void agregarPagoPorCliente(int mes, int anio, double monto) async {
    await dbHelper.addPagosPorCliente(mes, anio, monto, widget.clienteId);
    // cargarPagosPorclientePorAnio();
    cargarMesesCuadricula();
  }

  // ACTUALIZAR
  void actualizarPagoPorCliente(int idPago, double monto) async {
    await dbHelper.updatePagosPorCliente(idPago, monto);
    // cargarPagosPorclientePorAnio();
    cargarMesesCuadricula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volver'),
      ),
      body:   Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed:menosAnio, icon: Icon(Icons.arrow_left, size: 28)),
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
                      contentPadding: EdgeInsets.zero
                    ),
                    keyboardType: TextInputType.number,
                    readOnly: true,
                  ),
                ),
                IconButton(onPressed:masAnio, icon: Icon(Icons.arrow_right, size: 28))
              ],
            ),
            ),
          Expanded( 
            child: Padding(
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                itemCount: listaMeses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  // logica para obtener datos
                  final mes = listaMeses[index];
                  final idPago = listapagos[mes['id']] ?? 0;
                  // Busca el pago correspondiente a este mes
                  final monto = pagosPorMes[mes['id']] ?? 0.0;
          
                  return GestureDetector(
                    onTap: () =>
                        showAgregarEditarPago(mes['id'], mes['mes'], monto, idPago),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: monto > 0
                                ? [
                                    Colors.lightBlue.shade600,
                                    Colors.lightBlue.shade700
                                  ]
                                : [Colors.grey.shade400, Colors.grey.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.attach_money,
                                  color: Colors.white, size: 21),
                              SizedBox(width: 1),
                              //---------  monto   ----------
                              Text(
                                monto.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
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
    );
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
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  montoValue = double.tryParse(value);
                },
                decoration: InputDecoration(labelText: 'Monto'),
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
                        } else {
                          actualizarPagoPorCliente(idPago, montoValue!);
                        }
                      }
                    },
                    child: Text('Guardar'))
              ],
            ));
  }
 void masAnio(){
  setState(() {
    
  anioValue = anioValue+1;
  cargarMesesCuadricula();
  });
 }
 void menosAnio(){
  setState(() {
     anioValue = anioValue-1;
     cargarMesesCuadricula();
  });
 
 }
}
