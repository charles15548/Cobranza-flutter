import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:negocio/clientes.dart';
import 'package:negocio/controllers/NegociosController/negociosController.dart';
import 'package:negocio/db/db.dart';
import 'package:negocio/footer.dart';
import 'package:negocio/moneda.dart';
import 'package:negocio/mostrarMoneda.dart';
import 'package:provider/provider.dart';

class Negocios extends StatefulWidget {
  const Negocios({super.key});

  @override
  State<Negocios> createState() => _NegociosState();
}

class _NegociosState extends State<Negocios> {
  final TextEditingController nombreNegocio = TextEditingController();
  final dbHelper = DatabaseHelper();
  late final NegociosController negociosController;
  List<Map<String, dynamic>> listaNegocios = [];
  String editAdd = '';
  final money = MoneyProvider();

  @override
  void initState() {
    super.initState();
    negociosController = NegociosController(dbHelper);
    mostrarNegocios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            expandedHeight: 70,
            elevation: 0,
            title: Text('Cobranzas',
                style: TextStyle(
                    color: const Color.fromARGB(255, 27, 105, 251),
                    fontWeight: FontWeight.bold,
                    fontSize: 30)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 3.0),
                child: Mostrarmoneda(),
              )
            ],
          ),
          listaNegocios.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'Registra tu primer Negocio ',
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 93, 93, 93)),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final negocio = listaNegocios[index];
                    /*
                    return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Clientes(
                                    negocioId: negocio['id'],
                                    nombreNegocio: negocio['name']))),
                        child: SizedBox(
                            height: 110, child: mostrarCardNegocios(negocio)));
                            */
                      return Column(
                        children: [
                          ListTile(
                            minVerticalPadding: 25,
                            title: Text(
                              "d"
                            ),
                          )
                        ],
                      );

                  }, childCount: listaNegocios.length),
                ),
        ],
      ),
      bottomNavigationBar: AppFooter(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SizedBox(
          width: 90,
          height: 90,
          child: FloatingActionButton(
            onPressed: () {
              editAdd = 'Guardar';
              showNegocio(editAdd, 0);
            },
            backgroundColor: const Color.fromARGB(255, 66, 140, 250),
            tooltip: 'Agregar',
            shape: CircleBorder(),
            child: Icon(Icons.add,
                size: 40, color: const Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showAlertaEliminar(int idshow) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Se perderan los datos del negocio'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Regresar')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      eliminarNegocio(idshow);
                    },
                    child: Text('De acuerdo')),
              ],
            ));
  }

  void showNegocio(String editAdd, int id, {String? nombreActual}) {
    if (editAdd == 'Editar' && nombreActual != null) {
      nombreNegocio.text = nombreActual;
    } else {
      nombreNegocio.clear();
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('$editAdd Negocio'),
              content: TextField(
                controller: nombreNegocio,
                decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                maxLength: 70,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(70),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF5F6FA),
                    foregroundColor: Colors.black87,
                    minimumSize: Size(110, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (nombreNegocio.text.isNotEmpty) {
                        if (editAdd == 'Guardar' && id == 0) {
                          agregarNegocio(nombreNegocio.text.trim());
                        } else if (editAdd == 'Editar') {
                          editarNegocio(id, nombreNegocio.text.trim());
                        }
                      } else {
                        // Mostrar un mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('El nombre no puede estar vacío'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }

                      nombreNegocio.clear();
                    },
                    child: Text('Guardar')),
              ],
            ));
  }

  Widget mostrarCardNegocios(Map<String, dynamic> negocio) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: const Color.fromARGB(243, 255, 255, 255),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          SizedBox(width: 10),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 205, 227, 255),
            ),
            child: Center(
              child: Icon(
                Icons.business,
                color: const Color.fromARGB(255, 0, 12, 120),
                size: 32,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              child: Text(
                negocio['name'],
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                editAdd = 'Editar';
                showNegocio(editAdd, negocio['id'],
                    nombreActual: negocio['name']);
              } else if (value == 'delete') {
                showAlertaEliminar(negocio['id']);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
    );
  }

  /* CRUD NEGOCIO */

  Future<void> mostrarNegocios() async {
    final datos = await negociosController.getNegocios();
    if (mounted) {
      // Verifica que el widget siga montado
      setState(() {
        listaNegocios = datos;
      });
    }
  }

  agregarNegocio(String nombre) async {
    final ok = await negociosController.agregarNegocio(context, nombre);
    if (ok) mostrarNegocios();
  }

  void editarNegocio(int id, String nombre) async {
    final ok = await negociosController.editarNegocio(context, id, nombre);
    if (ok) mostrarNegocios();
  }

  void eliminarNegocio(int id) async {
    await negociosController.eliminarNegocio(id);
    mostrarNegocios();
  }
}
