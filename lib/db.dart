import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> opendatabase() async {
    final databasepath = await getDatabasesPath();
    var path = join(databasepath, 'Cobranza.db');
    //await deleteDatabase(path);
    return openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE negocios(
            id INTEGER PRIMARY KEY, 
            name TEXT
            )
        ''');

      await db.execute('''
          CREATE TABLE clientes(
            id INTEGER PRIMARY KEY,
            nombre TEXT,
            monto DOUBLE,
            negocio_id INTEGER,
            FOREIGN KEY (negocio_id) REFERENCES negocios(id)
          )
        ''');
      await db.execute('''
          CREATE TABLE pagos(
            id INTEGER PRIMARY KEY,
            mes INTEGER,
            anio INTEGER,
            monto DOUBLE,
            cliente_id INTEGER,
            FOREIGN KEY (cliente_id) REFERENCES clientes(id)
          )
        ''');
    }, version: 3);
  }

  /*

    --  CRUD NEGOCIO  --
         
  */

  Future<List<Map<String, dynamic>>> mostrarNegocios() async {
    final db = await opendatabase();
    final data = await db.query('negocios');
    return data;
  }

  Future<void> addNegocio(String nombre) async {
    final db = await opendatabase();

    final value = {
      'name': nombre,
    };

    await db.insert('negocios', value,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /*

    --  CRUD NEGOCIO  --
         
  */

  Future<List<Map<String, dynamic>>> mostrarClientesPorNegocio(
      int negocioId) async {
    final db = await opendatabase();
    final data = await db
        .query('clientes', where: 'negocio_id=?', whereArgs: [negocioId]);
    return data;
  }

  Future<void> addClientesPorNegocio(String nombre, int negocioId) async {
    final db = await opendatabase();
    final values = {
      'nombre': nombre,
      'negocio_id': negocioId,
    };
    await db.insert('clientes', values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /*

    -- CRUD PAGOS --

  */


/*

    SELECT clientes.id, clientes.nombre, clientes.negocio_id, pagos.mes, pagos.monto
    FROM clientes
    LEFT JOIN pagos ON pagos.cliente_id = clientes.id AND pagos.anio = ?
    WHERE clientes.negocio_id = ? AND
    clientes.id = ?
    ORDER BY clientes.id, pagos.mes

  */

  Future<List<Map<String, dynamic>>> obtenerPagosPorClienteYAnio(
      int anio, int clienteId) async {
    final db = await opendatabase();

    return await db.rawQuery('''
    SELECT id, mes, monto
    FROM pagos
    WHERE 
      anio = ? AND
      cliente_id = ? 
    ORDER BY anio, mes
  ''', [anio, clienteId]);
    
  }

  Future<void> addPagosPorCliente(
      int mes, int anio, double monto, int clienteId) async {
    final db = await opendatabase();
    final values = {
      'mes': mes,
      'anio': anio,
      'monto': monto,
      'cliente_id': clienteId,
    };
    await db.insert('pagos', values,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
