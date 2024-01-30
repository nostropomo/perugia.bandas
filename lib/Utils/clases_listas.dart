import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

class estiloList {
  String? marca;
  String? material;
  String? color;
  int? id_estilo;
  String? descripcion;
  String? linea;
  int? tiene_foto;
  String? descripEstilo;
  String? foto;
  int? id;

  estiloList(
      {this.marca,
      this.material,
      this.color,
      this.id_estilo,
      this.descripcion,
      this.linea,
      this.tiene_foto,
      this.descripEstilo,
      this.foto,
      this.id});
  Map toJson() => {
        'marca': marca,
        'material': material,
        'color': color,
        'id_estilo': id_estilo,
        'descripcion': descripcion,
        'lines': linea,
        'tiene_foto': tiene_foto,
        'descripEstilo': descripEstilo,
        'foto': foto,
        'id': id
      };
  estiloList.fromJason(Map<String, dynamic> json)
      : marca = json['marca'],
        material = json['material'],
        color = json['color'],
        id_estilo = json['id_estilo'],
        descripcion = json['descripcion'],
        linea = json['linea'],
        tiene_foto = json['tiene_foto'],
        descripEstilo = json['descripEstilo'],
        foto = json['foto'],
        id = json['id'];
}
class diagramasList {
  String? tipo;
  Image? imagen;
  String? estilo;
  diagramasList({this.tipo, this.imagen, this.estilo});
  Map toJson() => {
        'tipo': tipo,
        'imagen': imagen,
        'estilo': estilo,
      };
  diagramasList.fromJason(Map<String, dynamic> json)
      : tipo = json['tipo'],
        imagen = Image.memory(base64Decode(json['imagen'])),
        estilo = json['estilo'];
}
class cargaEstiloList {
  String? pieza;
  int? id;
  double? cantidad;
  String? material;
  int? id_material;
  String? unidad;
  int? corrida;
  int? id_estilo;
  int? asignado;
  int? lineatallas;
  int? capturado_linea_talla;
  int? tiene_sub_productos;
  double? rendimiento;

  cargaEstiloList(
      {this.pieza,
      this.id,
      this.cantidad,
      this.material,
      this.id_material,
      this.unidad,
      this.corrida,
      this.id_estilo,
      this.asignado,
      this.lineatallas,
      this.capturado_linea_talla,
      this.tiene_sub_productos,
      this.rendimiento});
  Map toJson() => {
        'pieza': pieza,
        'id': id,
        'cantidad': cantidad,
        'material': material,
        'id_material': id_material,
        'unidad': unidad,
        'corrida': corrida,
        'id_estilo': id_estilo,
        'asignado': asignado,
        'lineatallas': lineatallas,
        'capturado_linea_talla': capturado_linea_talla,
        'tiene_sub_productos': tiene_sub_productos,
        'rendimiento': rendimiento
      };
  cargaEstiloList.fromJason(Map<String, dynamic> json)
      : pieza = json['pieza'],
        id = json['id'],
        cantidad = json['cantidad'],
        material = json['material'],
        id_material = json['id_material'],
        unidad = json['unidad'],
        corrida = json['corrida'],
        id_estilo = json['id_estilo'],
        asignado = json['asignado'],
        lineatallas = json['lineatallas'],
        capturado_linea_talla = json['capturado_linea_talla'],
        tiene_sub_productos = json['tiene_sub_productos'],
        rendimiento = json['rendimiento'];
}
class estilosBanda {
  int? id_estilo;
  String? estilo;
  String? alternativa;
  String? fabrica;
  double? tiempo;
  int? trabajadores;
  String? programa;
  int? id_programa;
  int? banda_activa;

  estilosBanda(
      {
      this.id_estilo,
      this.estilo,
      this.alternativa,
      this.fabrica,
      this.tiempo,
      this.trabajadores,
      this.programa,
      this.id_programa,
      this.banda_activa
      });
  Map toJson() => {
        'id_estilo': id_estilo,
        'estilo': estilo,
        'alternativa': alternativa,
        'fabrica': fabrica,
        'tiempo': tiempo,
        'trabajadores': trabajadores,
        'programa': programa,
        'id_programa': id_estilo,
        'banda_activa': banda_activa,
      };
  estilosBanda.fromJason(Map<String, dynamic> json)
      : id_estilo = json['id_estilo'],
        estilo = json['estilo'],
        alternativa = json['alternativa'],
        fabrica = json['fabrica'],
        tiempo = json['tiempo'],
        trabajadores = json['trabajadores'],
        programa = json['programa'],
        id_programa = json['id_programa'],
        banda_activa =  int.parse(json['banda_activa'].toString())
        ; 
}
class loteBanda {
  int? id_programa;
  int? id_estilo;
  String? descripEstilo;
  int? tiempo;
  String? programa;
  int? id_fabrica;
  

  loteBanda(
      {
      this.id_programa,
      this.id_estilo,
      this.descripEstilo,
      this.tiempo,
      this.programa,
      this.id_fabrica,

      });
  Map toJson() => {
        'id_programa': id_programa,
        'id_estilo': id_estilo,
        'descripEstilo': descripEstilo,
        'tiempo': tiempo,
        'programa': programa,
        'id_fabrica': id_fabrica,

      };
  loteBanda.fromJason(Map<String, dynamic> json)
      : id_programa = json['id_programa'],
        id_estilo = json['id_estilo'],
        descripEstilo = json['descripEstilo'],
        tiempo = json['tiempo'],
        programa = json['programa'],
        id_fabrica = json['id_fabrica']
        
        ; 
}
class sesiones {
  final int? id;
  final String? usuario;
  final String? nombre;
  final String? correo;
  final String? telefono;
  final String? fechasesion;
  final String? token;
  final int? status;
  final int? fabrica;

  sesiones(
      {this.id,
      this.usuario,
      this.nombre,
      this.correo,
      this.telefono,
      this.fechasesion,
      this.token,
      this.status,
      this.fabrica
      });
}