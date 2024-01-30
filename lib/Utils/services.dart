import 'dart:convert';

import 'package:bandas/Utils/clases_listas.dart';
import 'package:http/http.dart' as http;
import '../api/environment.dart';
import '../db/database_helper.dart';
import 'Mapas.dart';


class Services {
  static Future<List<TecnicosLocal>> tecnicosLocalmap() async {
    final dbHelper = DatabaseHelper.instance;
    List<TecnicosLocal> _tecnicos = [];
    String rawJson2 = '';
    final allRows = await dbHelper.tecnicosLocalmap();
    if (allRows.length > 0) {
      for (var i = 0; i < allRows.length; i++) {
        rawJson2 = '{"id_empleado": ' +
            allRows[i].id_empleado.toString() +
            ',"no_empleado": ' +
            allRows[i].no_empleado.toString() +
            ',"nombre": "' +
            allRows[i].nombre.toString() +
            '","horario": "' +
            allRows[i].horario.toString() +
            '","foto": ' +
            allRows[i].foto.toString() +
            '}';
        Map<String, dynamic> json = jsonDecode(rawJson2);
        String jsonClientes = jsonEncode(json);
        _tecnicos.add(TecnicosLocal.fromJason(json));
      }
    }

    List<TecnicosLocal> list = _tecnicos;
    return list;
  }

  


  Future<List<Empleados>> empleadosLocal() async {
    final dbHelper = DatabaseHelper.instance;
    List<Empleados> _users = [];
    String rawJson2 = '';
    final allRows = await dbHelper.getEmployees();
    if (allRows.length > 0) {
      for (var i = 0; i < allRows.length; i++) {
        // ignore: prefer_interpolation_to_compose_strings
        rawJson2 = '{"id_usuario": ' +
            allRows[i].id_usuario.toString() +
            ',"nombre": "' +
            allRows[i].nombre.toString() +
            '","usuario": "' +
            allRows[i].usuario.toString() +
            '","correo": "' +
            allRows[i].correo.toString() +
            '","foto": "' +
            allRows[i].foto.toString() +
            '"}';
        Map<String, dynamic> json = jsonDecode(rawJson2);
        String jsonClientes = jsonEncode(json);
        _users.add(Empleados.fromJason(json));
      }
    }

    List<Empleados> list = _users;
    return list;
  }

  static Future<List<estilosBanda>> traerEstilos(int _idFabrica) async {
    String mensajedetalle = "";
    String conexion = "0";
    String estilosEncontrados = "";
    String mensajeTextoCodigo = "";
    String _url = Environment.API_DELIVERY;
    

    List<estilosBanda> _contenedor = [];
    bool activarGrabar = false;
   
    
      var jsonResponse;
      //String datosD = jsonEncode(expenseList);
      //var bodyData = json.encode({"estilo": title});
      try {
        var response = await http.post(Uri.parse('$_url/fabricaBanda?_idFabrica='+ _idFabrica.toString()),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            //body: bodyData
            );
        if (response.statusCode == 201 || response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          if (jsonResponse != null) {
            if (jsonResponse['result'] == 1) {
              for (var jsonUser in jsonResponse['data']) {
                _contenedor.add(estilosBanda.fromJason(jsonUser));
              }
              estilosEncontrados =
                  "Encontrados: " + _contenedor.length.toString();
              //activarGrabar = true;
            } else {
              //activarGrabar = false;
              mensajedetalle = "Hubo un error en el servidor";
              estilosEncontrados = "Encontrados: 0";
            }
            return _contenedor;
          } else {
            throw Exception("Error");
          }
        } else {
          throw Exception("Error");
        }
      } catch (e) {
        throw Exception("Error");
      }
    

    ///fin consulta en linea codigo ----------------------
  }
  static Future<List<loteBanda>> traerLoteBanda(int _idEstilo, int _idFabrica) async {
    String mensajedetalle = "";
    String conexion = "0";
    String estilosEncontrados = "";
    String mensajeTextoCodigo = "";
    String _url = Environment.API_DELIVERY;
    

    List<loteBanda> _contenedor = [];
    bool activarGrabar = false;
   
    
      var jsonResponse;
      //String datosD = jsonEncode(expenseList);
      //var bodyData = json.encode({"estilo": title});
      try {
        var response = await http.post(Uri.parse('$_url/lecturaLoteBanda?_codigo=' + _idEstilo.toString() + '&_idFabrica='+_idFabrica.toString()),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            //body: bodyData
            );
        if (response.statusCode == 201 || response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          if (jsonResponse != null) {
            if (jsonResponse['result'] == 1) {
              for (var jsonUser in jsonResponse['data']) {
                _contenedor.add(loteBanda.fromJason(jsonUser));
              }
              
              //activarGrabar = true;
            } else {
              //activarGrabar = false;
              mensajedetalle = "Hubo un error en el servidor";
              
            }
            return _contenedor;
          } else {
            throw Exception("Error");
          }
        } else {
          throw Exception("Error");
        }
      } catch (e) {
        throw Exception("Error");
      }
    

    ///fin consulta en linea codigo ----------------------
  }
  static Future<List<estilosBanda>> traerEstilosBanda(int _idFabrica) async {
    String mensajedetalle = "";
    String conexion = "0";
    String estilosEncontrados = "";
    String mensajeTextoCodigo = "";
    String _url = Environment.API_DELIVERY;
    

    List<estilosBanda> _contenedor = [];
    bool activarGrabar = false;
   
    
      var jsonResponse;
      //String datosD = jsonEncode(expenseList);
      //var bodyData = json.encode({"estilo": title});
      try {
        var response = await http.post(Uri.parse('$_url/EstilosBandasProduccionfabricas?_idFabrica='+_idFabrica.toString()),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            //body: bodyData
            );
        if (response.statusCode == 201 || response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          if (jsonResponse != null) {
            if (jsonResponse['result'] == 1) {
              for (var jsonUser in jsonResponse['data']) {
                _contenedor.add(estilosBanda.fromJason(jsonUser));
              }
              estilosEncontrados =
                  "Encontrados: " + _contenedor.length.toString();
              //activarGrabar = true;
            } else {
              //activarGrabar = false;
              mensajedetalle = "Hubo un error en el servidor";
              estilosEncontrados = "Encontrados: 0";
            }
            return _contenedor;
          } else {
            throw Exception("Error");
          }
        } else {
          throw Exception("Error");
        }
      } catch (e) {
        throw Exception("Error");
      }
    

    ///fin consulta en linea codigo ----------------------
  }

static Future<List<estilosBanda>> traerBanda(int _idfabrica) async {
    String mensajedetalle = "";
    String conexion = "0";
    String estilosEncontrados = "";
    String mensajeTextoCodigo = "";
    String _url = Environment.API_DELIVERY;
    

    List<estilosBanda> _contenedor = [];
    bool activarGrabar = false;
   
    
      var jsonResponse;
      //String datosD = jsonEncode(expenseList);
      //var bodyData = json.encode({"estilo": title});
      try {
        var response = await http.post(Uri.parse('$_url/fabricaBanda?_idFabrica='+ _idfabrica.toString()),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            //body: bodyData
            );
        if (response.statusCode == 201 || response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          if (jsonResponse != null) {
            if (jsonResponse['result'] == 1) {
              for (var jsonUser in jsonResponse['data']) {
                _contenedor.add(estilosBanda.fromJason(jsonUser));
              }
              estilosEncontrados =
                  "Encontrados: " + _contenedor.length.toString();
              //activarGrabar = true;
            } else {
              //activarGrabar = false;
              mensajedetalle = "Hubo un error en el servidor";
              estilosEncontrados = "Encontrados: 0";
            }
            return _contenedor;
          } else {
            throw Exception("Error");
          }
        } else {
          throw Exception("Error");
        }
      } catch (e) {
        throw Exception("Error");
      }
    

    ///fin consulta en linea codigo ----------------------
  }


static Future<List<estilosBanda>> actualizarEstilo(int _id_estilo,int _id_fabrica,  int _id_usuario, int _tiempo, int _id_proceso, int _programa, int _banda_activa) async {
    
    int proceso = 1;
    String mensajedetalle = "";
    String mensajeTextoCodigo = "";
    String estilosEncontrados = "";
    // 7005,3,0
    String _url = Environment.API_DELIVERY;

    List<estilosBanda> _contenedor = [];
    bool activarGrabar = false;
   
    
      var jsonResponse;
      //String datosD = jsonEncode(expenseList);
      var bodyData = json.encode({
        'id_fabrica': _id_fabrica,
        'id_estilo': _id_estilo,
          'id_usuario': _id_usuario,
          'tiempo': _tiempo,
          'proceso': _id_proceso,
          'id_programa': _programa,
          'banda_activa': _banda_activa,
        });
      
        var response = await http.post(Uri.parse('$_url/EstilosActualizaBandas'),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json"
            },
            body: bodyData
            );
        if (response.statusCode == 201 || response.statusCode == 200) {
          jsonResponse = json.decode(response.body);
          if (jsonResponse != null) {
            if (jsonResponse['result'] == 1) {
              for (var jsonUser in jsonResponse['data']) {
                _contenedor.add(estilosBanda.fromJason(jsonUser));
              }
            
            } else {
              //activarGrabar = false;
              mensajedetalle = "Hubo un error en el servidor";
              estilosEncontrados = "Encontrados: 0";
            }
            return _contenedor;
          } else {
            throw Exception("Error");
          }
        } else {
          throw Exception("Error");
        }
      
    

    ///fin consulta en linea codigo ----------------------
  }

}
