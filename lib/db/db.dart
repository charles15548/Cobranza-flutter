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

      await db.execute('''
          CREATE TABLE numeroMes(
            id INTEGER PRIMARY KEY,
            mes TEXT
          )
        ''');

      await db.rawInsert('''
          INSERT INTO numeroMes(id, mes)
          VALUES
            (1,"Ene"),
            (2,"Feb"),
            (3,"Mar"),
            (4,"Abr"),
            (5,"May"),
            (6,"Jun"),
            (7,"Jul"),
            (8,"Ago"),
            (9,"Sep"),
            (10,"Oct"),
            (11,"Nov"),
            (12,"Dic")
      
          ''');
    }, version: 4);
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

  Future<void> editNegocio(int id, String nombre) async {
    final db = await opendatabase();

    final value = {
      'name': nombre,
    };

    await db.update('negocios', value, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNegocio(int id) async {
    final db = await opendatabase();
    await db.delete('negocios', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> eliminarNegocioYClienteYPagos(int idNegocio) async {
    final db = await opendatabase();

    final clientes = await db.query(
      'clientes',
      columns: ['id'],
      where: 'negocio_id = ?',
      whereArgs: [idNegocio],
    );

    // recorremos los clientes
    for (var cliente in clientes) {
      final idCliente = cliente['id'] as int;
      await eliminarClienteYPagos(idCliente);
    }

   
    await db.delete('negocios', where: 'id = ?', whereArgs: [idNegocio]);
  }

  /*

    --  CRUD CLIENTE  --
         
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

  Future<void> editClientes(String nombre, int id) async {
    final db = await opendatabase();
    final values = {
      'nombre': nombre,
    };
    await db.update('clientes', values, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> eliminarClienteYPagos(int idCliente) async {
    final db = await opendatabase();
    await db.delete(
      'pagos',
      where: 'cliente_id = ?',
      whereArgs: [idCliente],
    );
    await db.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [idCliente],
    );
  }

  /*

    -- CRUD PAGOS --

  */

  Future<List<Map<String, dynamic>>> obtenerPagosPorClienteYAnio(
      int mesId, int anio, int clienteId) async {
    final db = await opendatabase();

    return await db.rawQuery('''
    SELECT id, mes, monto
    FROM pagos
    WHERE 
      mes = ? AND
      anio = ? AND
      cliente_id = ? 
  ''', [mesId, anio, clienteId]);
  }

  Future<List<Map<String, dynamic>>> obtenerPagosPorClienteYAnioTodosLosMeses(
      int anio, int clienteId) async {
    final db = await opendatabase();

    return await db.rawQuery('''
    SELECT id, mes, monto
    FROM pagos
    WHERE 
      anio = ? AND
      cliente_id = ? 
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

  Future<void> updatePagosPorCliente(int idPago, double monto) async {
    final db = await opendatabase();
    final values = {
      'monto': monto,
    };
    await db.update('pagos', values, where: 'id = ?', whereArgs: [idPago]);
  }

  /* CUADRICULA MES */

  Future<List<Map<String, dynamic>>> obtenerCuadricula() async {
    final db = await opendatabase();
    final data = await db.query('numeroMes');
    return data;
  }
}
