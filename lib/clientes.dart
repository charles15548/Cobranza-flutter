import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:negocio/anuncioBanner.dart';
import 'package:negocio/controllers/ClientesController/clientesController.dart';
import 'package:negocio/db/db.dart';
import 'package:negocio/footer.dart';
import 'package:negocio/mostrarMoneda.dart';
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
  late final Clientescontroller clientescontroller;
  @override
  void initState() {
    super.initState();
    clientescontroller = Clientescontroller(dbHelper);
    cargarClientes();
  }

  /*    ---    CARGAR    ---  */
  Future<void> cargarClientes() async {
    final datos = await clientescontroller.getClientes(widget.negocioId);
    if (mounted) {
      setState(() {
        listaClientes = datos;
      });
    }
  }

  /*    ---    AGREGAR    ---  */
  agregarClientesPorNegocio(String nombre) async {
    final ok = await clientescontroller.agregarClientePorNegocio(
      context,
      nombre,
      widget.negocioId,
    );
    if (ok) cargarClientes();
//    nombreCliente.clear();
  }

  /*    ---    EDITAR    ---  */
  void editarCliente(int id, String nombre) async {
    final ok = await clientescontroller.editarCliente(context, id, nombre);

    if (ok) cargarClientes();
  }

  /*    ---    ELIMINAR    ---  */
  void eliminarClienteYPagos(int id) async {
    await clientescontroller.eliminarClienteYPagos(id);
    cargarClientes();
  }

  void showAgregarEditarCliente(int id, String nombreActual) {
    nombreCliente.text = nombreActual;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: nombreCliente,
          decoration: InputDecoration(labelText: 'Nombre del Cliente'),
          maxLength: 60,
          inputFormatters: [LengthLimitingTextInputFormatter(70)],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (nombreCliente.text.isNotEmpty) {
                  if (id == 0) {
                    agregarClientesPorNegocio(nombreCliente.text.trim());
                  } else if (id > 0) {
                    editarCliente(id, nombreCliente.text.trim());
                  }
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

  void showEliminarCliente(int id, String cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Cliente'),
        content: Text('¿Estás seguro de eliminar a ${cliente}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
              onPressed: () {
                eliminarClienteYPagos(id);
                Navigator.pop(context);
              },
              child: Text('Si, Eliminar'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('${widget.nombreNegocio} - Cobranzas'),
      ),*/
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          expandedHeight: 70,
          backgroundColor: const Color.fromARGB(
              255, 26, 66, 97), 
          elevation: 0,
          title: Text( widget.nombreNegocio,style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22
                             )),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 3.0),
              child: Mostrarmoneda(),
            )
          ],
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 27, 105, 251),
                    Color.fromARGB(255, 65, 160, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        listaClientes.isEmpty
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No hay clientes registrados',
                    style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 118, 118, 118)),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final cliente = listaClientes[index];

                  return Column(
                    children: [
                      ListTile(
                        minVerticalPadding: 25,
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 36, 163, 236),
                          radius: 28,
                          child: Text(
                            cliente['nombre']
                                .toString()
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        title: Text(
                          cliente['nombre'],
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              showAgregarEditarCliente(
                                  cliente['id'], cliente['nombre']);
                            } else if (value == 'delete') {
                              showEliminarCliente(
                                  cliente['id'], cliente['nombre']);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(
                                value: 'delete', child: Text('Eliminar')),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Pagos(
                              clienteId: cliente['id'],
                              clienteNombre: cliente['nombre'],
                              negocioId: cliente['negocio_id'],
                            ),
                          ),
                        ),
                      ),
                      if (index < listaClientes.length - 1)
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.grey[300],
                        )
                    ],
                  );
                }, childCount: listaClientes.length),
              ),
      ]),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Anunciobanner(idAnuncio: 'ca-app-pub-3503326553540884/1480397739'),
          //Anunciobanner(idAnuncio: 'ca-app-pub-3940256099942544/6300978111'), prueba
          SizedBox(height: 15),

          AppFooter(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 150),
        child: SizedBox(
          width: 90,
          height: 90,
          child: FloatingActionButton(
            onPressed: () {
              showAgregarEditarCliente(0, '');
            },
            backgroundColor: const Color.fromARGB(255, 66, 140, 250),
            shape: CircleBorder(),
            child: Icon(Icons.add,
                size: 40, color: const Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
