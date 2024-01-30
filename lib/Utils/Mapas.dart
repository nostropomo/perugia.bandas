import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class Empleados {
  int id_usuario;
  String nombre;
  String usuario;
  String correo;
  Uint8List foto;

  Empleados(this.id_usuario, this.nombre, this.usuario, this.correo, this.foto);

  Empleados.fromJason(Map<String, dynamic> json)
      : id_usuario = json['id_usuario'],
        nombre = json['nombre'],
        usuario = json['usuario'],
        correo = json['correo'],
        foto = _getImageBinary(json['foto']);
}

Uint8List _getImageBinary(dynamicList) {
  List<int> intList =
      dynamicList.cast<int>().toList(); //This is the magical line.
  Uint8List data = Uint8List.fromList(intList);
  return data;
}

class Tecnicos {
  int id_empleado;
  int no_empleado;
  String nombre;
  String horario;
  Uint8List foto;

  Tecnicos(
      this.id_empleado, this.no_empleado, this.nombre, this.horario, this.foto);

  Tecnicos.fromJason(Map<String, dynamic> json)
      : id_empleado = json['id_empleado'],
        no_empleado = json['no_empleado'],
        nombre = json['nombre'],
        horario = json['horario'],
        foto = base64Decode(json['foto']);
}

class TecnicosLocal {
  int id_empleado;
  int no_empleado;
  String nombre;
  String horario;
  Uint8List foto;

  TecnicosLocal(
      this.id_empleado, this.no_empleado, this.nombre, this.horario, this.foto);

  TecnicosLocal.fromJason(Map<String, dynamic> json)
      : id_empleado = json['id_empleado'],
        no_empleado = json['no_empleado'],
        nombre = json['nombre'],
        horario = json['horario'],
        foto = _getImageBinary(json['foto']);
}

class Maquinaria {
  String tipo_bien;
  String tipo_activo;
  int id_activo_fijo;
  String marca;
  String modelo;
  int id_bien_tipo;
  String descripcion;
  String no_serie;
  String status;
  Uint8List? foto;
  int cantidad;
  int garantia;
  int meses_garantia;
  String ubicacion;
  double costo;

  Maquinaria(
      this.tipo_bien,
      this.tipo_activo,
      this.id_activo_fijo,
      this.marca,
      this.modelo,
      this.id_bien_tipo,
      this.descripcion,
      this.no_serie,
      this.status,
      this.foto,
      this.cantidad,
      this.garantia,
      this.meses_garantia,
      this.ubicacion,
      this.costo);

  Maquinaria.fromJason(Map<String, dynamic> json)
      : tipo_bien = json['tipo_bien'],
        tipo_activo = json['tipo_activo'],
        id_activo_fijo = json['id_activo_fijo'],
        marca = json['marca'],
        modelo = json['modelo'],
        id_bien_tipo = json['id_bien_tipo'],
        descripcion = json['descripcion'],
        no_serie = json['no_serie'],
        status = json['status'],
        foto = json['foto'] != null ? base64Decode(json['foto']) : null,
        cantidad = json['cantidad'],
        garantia = json['garantia'],
        meses_garantia = json['meses_garantia'],
        ubicacion = json['ubicacion'],
        costo = json['costo'];
}
