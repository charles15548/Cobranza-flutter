import 'package:flutter/material.dart';
import 'package:negocio/db.dart';
import 'package:negocio/pagos.dart';

class Clientes extends StatefulWidget {
  final int negocioId;
  final String nombreNegocio;
  const Clientes(
      {super.key, required this.negocioId, required this.nombreNegocio});
  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  TextEditingController nombreCliente = TextEditingController();
  List<Map<String, dynamic>> listaClientes = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    cargarClientes();
  }

  void cargarClientes() async {
    final data = await dbHelper.mostrarClientesPorNegocio(widget.negocioId);
    setState(() {
      listaClientes = data;
    });
  }

  void agregarClientesPorNegocio(String nombre) async {
    await dbHelper.addClientesPorNegocio(
      nombre,
      widget.negocioId,
    );
    cargarClientes();
    //cargarPagosPorclientePorAnio();
    nombreCliente.clear();
  }

  void showAgregarCliente() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: nombreCliente,
          decoration: InputDecoration(labelText: 'Nombre del Cliente'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
              onPressed: () {
                if (nombreCliente.text.isNotEmpty) {
                  agregarClientesPorNegocio(nombreCliente.text.trim());
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El nombre no puede estar vacío'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Text('Guardar'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cliente de ${widget.nombreNegocio}'),
      ),
      body: ListView.builder(
        itemCount: listaClientes.length,
        itemBuilder: (context, index) {
          final cliente = listaClientes[index];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Pagos(
                      clienteId: cliente['id'],
                      negocioId: cliente['negocio_id'],
                       ))),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(cliente['nombre']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAgregarCliente,
        child: Icon(Icons.add),
      ),
    );
  }
}
