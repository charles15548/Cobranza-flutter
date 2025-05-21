import 'package:flutter/material.dart';
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
  void initState(){
    super.initState();
    cargarPagosPorclientePorAnio();
    
  }
  int? mesValue;
  int? anioValue;
  double? montoValue;

  List<Map<String, dynamic>> listaPagos = [];
  final dbHelper = DatabaseHelper();

/*
  void mostrarPagosPorClientes() async {
    final data = await dbHelper.mostrarPagosPorCliente(widget.clienteId);
    listaPagos = data;

  }
*/
  void agregarPagoPorCliente(int mes, int anio, double monto) async {
    await dbHelper.addPagosPorCliente(mes, anio, monto, widget.clienteId);
    cargarPagosPorclientePorAnio();
    
  }

   void cargarPagosPorclientePorAnio() async {  // se cambio los datos
    final data = await dbHelper.obtenerPagosPorClienteYAnio(2025,widget.clienteId);
    setState(() {
      listaPagos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cliente de ${widget.clienteId}'),
      ),
      body: ListView.builder(
        itemCount: listaPagos.length,
        itemBuilder: (context, index) {
          final pagos = listaPagos[index];
          return ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('${pagos}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAgregarPago,
        child: Icon(Icons.payment),
      ),
    );
  }

  void showAgregarPago() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value){
              mesValue = int.tryParse(value);
            },
            decoration: InputDecoration(labelText: 'Mes'),
          ),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value){
              anioValue = int.tryParse(value);
            },
            decoration: InputDecoration(labelText: 'Año'),
          ),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value){
              montoValue = double.tryParse(value);
            },
            decoration: InputDecoration(labelText: 'Monto'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        ElevatedButton(
            onPressed: () {
              if(mesValue != null && anioValue != null && montoValue != null){
                agregarPagoPorCliente(mesValue!, anioValue!, montoValue!);
              }
              Navigator.pop(context);
            },
            child: Text('Guardar'))
      ],
      ));
  }
}
