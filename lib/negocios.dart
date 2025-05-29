import 'package:flutter/material.dart';
import 'package:negocio/clientes.dart';
import 'package:negocio/db.dart';

class Negocios extends StatefulWidget {
  const Negocios({super.key});

  @override
  State<Negocios> createState() => _NegociosState();
}

class _NegociosState extends State<Negocios> {
  final TextEditingController nombreNegocio = TextEditingController();
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> listaNegocios = [];

  @override
  void initState() {
    super.initState();
    mostrarNegocios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('COBRANZAS'),
          centerTitle: true,),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // dos por fila
                  crossAxisSpacing: 2,
                  mainAxisExtent: 100,
                ),
                itemCount: listaNegocios.length,
                itemBuilder: (context, index) {
                  final negocio = listaNegocios[index];

                  return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => Clientes(
                                  negocioId: negocio['id'],
                                  nombreNegocio: negocio['name']))),
                      child: mostrarCardNegocios(negocio));
                }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.storefront),
                tooltip: 'Inicio',
              ),
              SizedBox(
                width: 40,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings),
                tooltip: 'Configuración',
              )
            ],
          )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: SizedBox(
          width: 90,
          height: 75,
          
          child: FloatingActionButton(
            onPressed: () {
              showNegocio();
            },
            child: Icon(Icons.add, size: 40),

            tooltip: 'Agregar',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void agregarNegocio(String nombre) async {
    await dbHelper.addNegocio(nombre);
    mostrarNegocios();
  }

  void mostrarNegocios() async {
    final datos = await dbHelper.mostrarNegocios();
    try {
      if (mounted) {
        // Verifica que el widget siga montado
        setState(() {
          listaNegocios = datos;
        });
      }
    } catch (e) {
      print('Error al cargar negocios: $e');
      if (mounted) {
        setState(() {
          listaNegocios = [];
        });
      }
    }
  }

  void showNegocio() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Agregar Negocio'),
              content: TextField(
                controller: nombreNegocio,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (nombreNegocio.text.isNotEmpty) {
                        agregarNegocio(nombreNegocio.text.trim());
                      } else {
                        // Mostrar un mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('El nombre no puede estar vacío'),
                            duration: Duration(seconds: 2),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          negocio['name'],
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
