import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bandas/Utils/clases_listas.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Utils/Mapas.dart';

class DatabaseHelper {
  static final _databaseName = "perugia_mantto.db";
  static final _databaseVersion = 1;
  static final table = 'sesiones';
  static final columnId = 'id';
  static final columnUsuario = 'usuario';
  static final columnNombre = 'nombre';
  static final columnCorreo = 'correo';
  static final columnTelefono = 'telefono';
  static final columnFechasesion = 'fechasesion';
  static final columnTokenTelefono = 'tokenTelefono';
  static final columnfotoEmpleado = 'foto';
  static final columnStatusSesion = 'status';
  static final columnFabrica = 'fabrica';

  static final tablemensajes = 'mensajes';
  static final columnIdTipoMensaje = 'idTipo';
  static final columnFechaMensaje = 'fechaMensaje';
  static final columnTituloMensaje = 'titulo';
  static final columnSubTituloMensaje = 'subTitulo';
  static final columnDetalleMensaje = 'detalleMensaje';
  static final columnBajaMensaje = 'baja';

  static final tabletecnicos = 'tecnicos';
  static final columnIdempleado = 'idEmpleado';
  static final columnNoEmpleado = 'noEmpleado';
  static final columnNombreEmpleado = 'nombre';
  static final columnHorarioEmpleado = 'horario';
  static final columnFotoTecnico = 'foto';

  static final tablemaquinaria = 'maquinaria';
  static final columnTipoBien = 'tipo_bien';
  static final columnTipoActivo = 'tipo_activo';
  static final columnIdActivoFijo = 'id_activo_fijo';
  static final columnMarca = 'marca';
  static final columnModelo = 'modelo';
  static final columnIdBienTipo = 'id_bien_tipo';
  static final columnDescripcion = 'descripcion';
  static final columnNoSerie = 'no_serie';
  static final columnStatus = 'status';
  static final columnFotoMaquinaria = 'foto';
  static final columnCantidad = 'cantidad';
  static final columnGarantia = 'garantia';
  static final columnMesesGarantia = 'meses_garantia';
  static final columnUbicacion = 'ubicacion';
  static final columnCosto = 'costo';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    //Directory documentsDirectory = (await getExternalStorageDirectory())!;
    Directory documentsDirectory = (await getApplicationDocumentsDirectory())!;

    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tablemaquinaria (
            $columnTipoBien TEXT NOT NULL,
            $columnTipoActivo TEXT NOT NULL,
            $columnIdActivoFijo INTEGER NOT NULL,
            $columnMarca TEXT NOT NULL,
            $columnModelo TEXT NOT NULL,
            $columnIdBienTipo INTEGER NOT NULL,
            $columnDescripcion TEXT NOT NULL,
            $columnNoSerie TEXT NOT NULL,
            $columnStatus TEXT NOT NULL,
            $columnFotoMaquinaria BLOB,
            $columnCantidad INTEGER NOT NULL,
            $columnGarantia INTEGER NOT NULL,
            $columnMesesGarantia INTEGER NOT NULL,
            $columnUbicacion TEXT NOT NULL,
            $columnCosto REAL NOT NULL
            
           

          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tabletecnicos (
            $columnIdempleado INTEGER ,
            $columnNoEmpleado INTEGER ,
            $columnNombreEmpleado TEXT NOT NULL,
            $columnHorarioEmpleado TEXT NOT NULL,
            $columnFotoTecnico BLOB
            
           

          )
          ''');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table (
            $columnId INTEGER ,
            $columnUsuario TEXT NOT NULL,
            $columnNombre TEXT NOT NULL,
            $columnCorreo TEXT NOT NULL,
            $columnTelefono TEXT NOT NULL,
            $columnFechasesion DATETIME NOT NULL,
            $columnTokenTelefono TEXT NOT NULL,
            $columnfotoEmpleado BLOB,
            $columnStatusSesion INTEGER,
            $columnFabrica INTEGER 
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $tablemensajes (
            $columnIdTipoMensaje INTEGER NOT NULL ,
            $columnFechaMensaje DATETIME  NOT NULL,
            $columnTituloMensaje TEXT  NOT NULL,
            $columnSubTituloMensaje TEXT  NOT NULL,
            $columnDetalleMensaje TEXT NOT NULL,
            $columnBajaMensaje INTEGER NOT NULL 
          )
          ''');
  }

  Future<int> insertMensaje(Map<String, dynamic> row) async {
    Database db = (await instance.database)!;
    return await db.insert(tablemensajes, row);
  }

  Future<int> getCount() async {
    //database connection
    Database db = (await this.database)!;
    var x = await db.rawQuery('SELECT COUNT (*) from $table');
    int count = Sqflite.firstIntValue(x)!;
    return count;
  }

  Future<int> deleteAll() async {
    Database db = (await instance.database)!;
    var y = await db.delete(table);
    var x = await db.rawQuery('SELECT COUNT (*) from $table');
    int count = Sqflite.firstIntValue(x)!;
    return count;
  }

  Future<int> deleteAllTecnicos() async {
    Database db = (await instance.database)!;
    var y = await db.delete(tabletecnicos);
    var x = await db.rawQuery('SELECT COUNT (*) from $tabletecnicos');
    int count = Sqflite.firstIntValue(x)!;
    return count;
  }

  Future<int> deleteAllMaquinaria() async {
    Database db = (await instance.database)!;
    var y = await db.delete(tablemaquinaria);
    var x = await db.rawQuery('SELECT COUNT (*) from $tablemaquinaria');
    int count = Sqflite.firstIntValue(x)!;
    return count;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = (await instance.database)!;
    return await db.insert(table, row);
  }

  Future<int> insertTecnicos(Map<String, dynamic> row) async {
    Database db = (await instance.database)!;
    return await db.insert(tabletecnicos, row);
  }

  Future<int> insertMaquinaria(Map<String, dynamic> row) async {
    Database db = (await instance.database)!;
    return await db.insert(tablemaquinaria, row);
  }

  Future<List<Map<String, dynamic>>> traerEmpleadoMap() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  Future<List<Empleados>> getEmployees() async {
    Database db = (await instance.database)!;
    List<Map> list = await db.rawQuery('SELECT * FROM sesiones');
    List<Empleados> employees = [];
    for (int i = 0; i < list.length; i++) {
      employees.add(new Empleados(list[i]["id"], list[i]["nombre"],
          list[i]["usuario"], list[i]["correo"], list[i]["foto"]));
    }
    print(employees.length);
    return employees;
  }

  Future<List<Tecnicos>> tecnicosLocalmap() async {
    Database db = (await instance.database)!;
    List<Map> list = await db.rawQuery('SELECT * FROM tecnicos');
    List<Tecnicos> _tenicos = [];
    for (int i = 0; i < list.length; i++) {
      _tenicos.add(new Tecnicos(list[i]["idEmpleado"], list[i]["noEmpleado"],
          list[i]["nombre"], list[i]["horario"], list[i]["foto"]));
    }

    return _tenicos;
  }

  Future<List<sesiones>> queryAllRowsu() async {
    // Get a reference to the database.
    final Database? db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!.query(table);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return sesiones(
          id: maps[i]['id'],
          usuario: maps[i]['usuario'],
          nombre: maps[i]['nombre'],
          correo: maps[i]['correo'],
          telefono: maps[i]['telefono'],
          fechasesion: maps[i]['fechasesion'],
          fabrica: maps[i]['fabrica']);
    });
  }
}
