import 'dart:convert';
import 'dart:typed_data';

import 'package:bandas/Utils/clases_listas.dart';
import 'package:bandas/Utils/services.dart';
import 'package:bandas/Utils/utils.dart';
import 'package:bandas/api/environment.dart';
import 'package:bandas/paginas/estilos_banda.dart';
import 'package:bandas/paginas/inicio.dart';
import 'package:bandas/paginas/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../Utils/Mapas.dart';
import '../db/database_helper.dart';
//import '../login.dart';
//import 'package:get_version/get_version.dart';

class DrawerRecetas extends StatefulWidget {
 
  _DrawerRecetasState createState() => _DrawerRecetasState();
}

class _DrawerRecetasState extends State<DrawerRecetas> {
  @override
  final dbHelper = DatabaseHelper.instance;
  SharedPreferences? sharedPreferences;
  String? usuario = '';
  String? correo = '';
  String _platformVersion = 'Unknown';
  String _projectVersion = '';
  String _projectCode = '';
  String _projectAppID = '';
  String _projectName = '';
  List<Empleados> empleadosSync = [];
  List<Empleados> empleados = [];
  Image fotoEmpleado =
      Image(image: AssetImage("assets/imagenes/image_none.png"));

  String? tokenTelefono = "";
  String? modeloTelefono = "";
  int status_banda = Environment.GlogStatusBanda;
  int id_estilo=0;
  int id_programa=0;
  int id_fabrica=0;
  int id_usuario=0;
  int tiempo=0;

  String barcodeD = '';
  bool _isLoading = false;
  String codigobarras="";

  String rotuloBanda="Activar Banda";

   List<estilosBanda> contenedortodos = [];
  List<loteBanda> contenedorlotes = [];


 

  @override
  void initState() {
    //Environment.StatusBanda="";
    status_banda = Environment.GlogStatusBanda;
    id_estilo = Environment.GlogidEstilo;
    id_fabrica=Environment.GlogidFabrica;
    id_programa=Environment.GlogidPrograma;
    id_usuario=Environment.GlogidUsuario;
    tiempo=Environment.Glogtiempo;

    if(status_banda==1)
    rotuloBanda="Detener Banda";
    else
    rotuloBanda="Activar Banda";
    traerShared();
    traerEmpleadoLocal();
  }

  Future<Null> traerEmpleadoLocal() async {
    final dbHelper = DatabaseHelper.instance;
    var jsonResponse;
    final allRows = await dbHelper.getEmployees();
    String rawJson2 = '';
    empleadosSync.clear();
    if (allRows.length > 0) {
      for (var i = 0; i < allRows.length; i++) {
        rawJson2 = '{"id_usuario": ' +
            allRows[i].id_usuario.toString() +
            ',"nombre": "' +
            allRows[i].nombre.toString() +
            '","usuario": "' +
            allRows[i].usuario.toString() +
            '","correo": "' +
            allRows[i].correo.toString() +
            '","foto": ' +
            allRows[i].foto.toString() +
            '}';
        Map<String, dynamic> json = jsonDecode(rawJson2);
        String jsonClientes = jsonEncode(json);
        empleadosSync.add(Empleados.fromJason(json));
      }
      setState(() {
        empleados = empleadosSync;
        //fotoEmpleado= MemoryImage(empleados[0].foto);
      });
    }
  }
    void _getAppVersion() async {
	
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
	
  
	
      final version = packageInfo.version;
	
      
  
	
      setState(() {
	
        _platformVersion = version;
	
       
	
      });
	
    }

scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      //setState(() async {
      //String ç = "";
      if (barcode != "-1") {
        // se cancelo la operacion
        if (barcode.length == 6) {
          codigobarras = barcode;
          //grabar informacion
            EasyLoading.show(status: 'cargando...');
            Services.traerLoteBanda(int.parse(barcode),id_fabrica).then((usersFromServer) {
              EasyLoading.dismiss();
              setState(() {
                FocusScope.of(context).unfocus();
                new TextEditingController().clear();
                contenedorlotes = usersFromServer;
                
                if (contenedorlotes.length >0) {
                 /// dialogo confirmacion
                 /// 
                 if(int.parse(contenedorlotes[0].tiempo.toString())==0)
                 {
                    mostrarAlerta(context,"No hay tiempo capturado en el estilo!!", "Aviso");
                 }else
                 {
                        _displayLoteInputDialog(context, int.parse(contenedorlotes[0].id_estilo.toString()),
                      int.parse(contenedorlotes[0].id_fabrica.toString()),
                      int.parse(contenedorlotes[0].tiempo.toString()),
                      contenedorlotes[0].descripEstilo.toString(),
                      int.parse(contenedorlotes[0].id_programa.toString())
                      );
                 }
                 
                 
                }
                else{
                  ///no se encontro lote
                  mostrarAlerta(context,"No se encontro informacion el lote!!", "Aviso");
                }
              });
            });



        } else
        {
          mostrarAlerta(context,"El codigo no tiene la longitud correcta!", "Aviso");
        }
                
       
        
      }

      // });

    } on PlatformException {
      barcodeD = 'Failed to get platform version.';
    }

    ///buscar cliente localmente para traer datos del credito
    ///
  }
    Future<void> _displayLoteInputDialog(
      BuildContext context,
      int _id_estilo,
      int _id_fabrica,
      int _tiempo,
      String _descripEstilo,
      int _id_programa
      ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar envio de Estilo'),
            content: Text(_descripEstilo),
            // content: TextField(
            //   onChanged: (value) {
            //     setState(() {
            //       valueText = value;
            //     });
            //   },
            //   keyboardType: TextInputType.number,
            //   controller: _estiloEnviarBanda,
            //   decoration: InputDecoration(hintText: "Ingrese la Cantidad"),
            // ),
            actions: <Widget>[

         
                  OutlinedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("NO"),
                    //Icon(Icons.add_shopping_cart_outlined),
                  ],
                ),
                onPressed: () {

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    //padding: EdgeInsets.all(20),
                    fixedSize: Size(80, 30),
                    //backgroundColor: Colors.red,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    shadowColor: Colors.white,
                    side: BorderSide(color: Colors.red, width: 2),
                    shape: StadiumBorder())),
          
            
         
              OutlinedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("SI"),
                //Icon(Icons.add_shopping_cart_outlined),
              ],
            ),
            onPressed: () {
               //codeDialog = valueText;
                setState(() {
                   ///actualizar dato------------
                  actualizarEstiloBanda(int.parse(_id_estilo.toString()), int.parse(_id_fabrica.toString()),int.parse(_tiempo.toString()),int.parse(_id_programa.toString()), int.parse(status_banda.toString()),1, id_usuario);
                 });
              
               // if (int.parse(codeDialog.toString()) <= _existencia) {
                        //   mensajeError = "";
                        //   addTaskAndAmount(_id, int.parse(codeDialog), _precio,
                        //       _precio25, _precio26, _precio2);
                        // } else
                        //   mensajeError = "La Cantidad excede la Existencia!!";
              Navigator.pop(context);
              
            },
            style: ElevatedButton.styleFrom(
                //padding: EdgeInsets.all(20),
                fixedSize: Size(80, 30),
                //backgroundColor: Colors.green,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                shadowColor: Colors.green,
                side: BorderSide(color: Colors.green, width: 2),
                shape: StadiumBorder())),
          
            

              
              
            ],
          );
        });
  }

    Future<void> actualizarEstiloBanda(
    int _id_estilo,
    int _id_fabrica,
    int _tiempo,
    int _programa,
    int banda_activa,
    int id_proceso,
    int id_usuario

) async {

    int bandaActiva=0;
    if(banda_activa==1)
    bandaActiva=0;
    else
    bandaActiva=1;
    EasyLoading.show(status: 'cargando...');
    Services.actualizarEstilo(_id_estilo,_id_fabrica,id_usuario,_tiempo,id_proceso,_programa,bandaActiva).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        if (usersFromServer.length> 0)
        {
          contenedortodos = usersFromServer;
          ///Actulizar variables globales
         Environment.GlogStatusBanda=int.parse(contenedortodos[0].banda_activa.toString());

        status_banda=int.parse(contenedortodos[0].banda_activa.toString());
        // if(status_banda==0)
          
        //     mostrarAlerta(context,"Se ha detenido la Banda", "Aviso");
         
        //   else
        //   {
             
            mostrarAlerta(context,"Se ha enviado lote!!", "Aviso");
           
            
        //   }
          
        }
        else {
          mostrarAlerta(context,"Hubo un error artualizando", "Error");
        }
         Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => inicio()),
                          (Route<dynamic> route) => false);
                        
          });
        }
    );
  }
  Future<void> traerShared() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    sharedPreferences = await SharedPreferences.getInstance();
    String? usuarioShared = "";
    String? correoShared = "";
    usuarioShared = sharedPreferences?.getString("nombre");
    correoShared = sharedPreferences?.getString("correo");
    tokenTelefono = sharedPreferences?.getString("nombre");
    modeloTelefono = sharedPreferences?.getString("nombre");
    String platformVersion;
    try {
      platformVersion =version;
    } catch (e) {
      platformVersion = 'Failed to get platform version.';
    }

    String projectVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      projectVersion = version;
    } catch (e) {
      projectVersion = 'Failed to get project version.';
    }

    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = version;
    } catch (e) {
      projectCode = 'Failed to get build number.';
    }

    // String projectAppID;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   projectAppID = await GetVersion.appID;
    // } catch (e) {
    //   projectAppID = 'Failed to get app ID.';
    // }

    // String projectName;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   projectName = await GetVersion.appName;
    // } catch (e) {
    //   projectName = 'Failed to get app name.';
    // }

    setState(() {
      usuario = usuarioShared;
      correo = correoShared;

      _platformVersion = version;
      _projectVersion = version;
      _projectCode = projectCode;
      // _projectAppID = projectAppID;
      // _projectName = projectName;
    });
  }
  Future<void> _displayStopInputDialog(
      BuildContext context,
      int _id_estilo,
      int _id_fabrica,
      int _tiempo,
      String _descripEstilo,
      int _id_programa
      ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar'),
            //content: Text(_descripEstilo),
            // content: TextField(
            //   onChanged: (value) {
            //     setState(() {
            //       valueText = value;
            //     });
            //   },
            //   keyboardType: TextInputType.number,
            //   controller: _estiloEnviarBanda,
            //   decoration: InputDecoration(hintText: "Ingrese la Cantidad"),
            // ),
            actions: <Widget>[

         
                  OutlinedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("NO"),
                    //Icon(Icons.add_shopping_cart_outlined),
                  ],
                ),
                onPressed: () {

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    //padding: EdgeInsets.all(20),
                    fixedSize: Size(80, 30),
                    //backgroundColor: Colors.red,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    shadowColor: Colors.white,
                    side: BorderSide(color: Colors.red, width: 2),
                    shape: StadiumBorder())),
          
            
         
              OutlinedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("SI"),
                //Icon(Icons.add_shopping_cart_outlined),
              ],
            ),
            onPressed: () {
               //codeDialog = valueText;
                setState(() {
                   ///actualizar dato------------
                   actualizarEstiloBanda(id_estilo, int.parse(_id_fabrica.toString()),tiempo,int.parse(_id_programa.toString()), int.parse(status_banda.toString()),2, id_usuario);
                  
                  });

               // if (int.parse(codeDialog.toString()) <= _existencia) {
                        //   mensajeError = "";
                        //   addTaskAndAmount(_id, int.parse(codeDialog), _precio,
                        //       _precio25, _precio26, _precio2);
                        // } else
                        //   mensajeError = "La Cantidad excede la Existencia!!";
              //Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => inicio()),
                  (Route<dynamic> route) => false);
              
            },
            style: ElevatedButton.styleFrom(
                //padding: EdgeInsets.all(20),
                fixedSize: Size(80, 30),
                //backgroundColor: Colors.green,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                shadowColor: Colors.green,
                side: BorderSide(color: Colors.green, width: 2),
                shape: StadiumBorder())),
          
            

              
              
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.green.shade900,
        //       const Color(0xff196A7A),
        //       //Colors.greenAccent
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Color.fromARGB(255, 21, 73, 216),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: empleados.isEmpty
                              ? fotoEmpleado.image
                              : MemoryImage(empleados[0]
                                  .foto), //MemoryImage(empleados[0].foto),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Text(
                    usuario.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    correo.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Version ' + _projectVersion,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            // DrawerHeader(
            //   decoration: const BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(15),
            //       bottomRight: Radius.circular(15),
            //     ),
            //     image: DecorationImage(
            //       image: AssetImage("assets/imagenes/1.png"),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            //   child: Align(
            //     alignment: Alignment.bottomRight,
            //     child: IconButton(
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //       },
            //       icon: const CircleAvatar(
            //         backgroundColor: Colors.white,
            //         child: Icon(
            //           Icons.arrow_back,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     print('Menu Inicio');
                  //   },
                  //   child: const _ListitleWidget(
                  //     icon: Icons.home,
                  //     text: "Menu De Inicio",
                  //     iconColor: Color.fromARGB(255, 21, 73, 216),
                  //   ),
                  // ),
                  // const _ListitleWidget(
                  //   icon: Icons.favorite,
                  //   text: "RECETAS FAVORITAS",
                  //   iconColor: Color.fromARGB(255, 21, 73, 216),
                  //   //textColor: Colors.indigoAccent,
                  // ),
                  // const _ListitleWidget(
                  //   icon: Icons.play_circle,
                  //   text: "VIDEOS DE RECETAS",
                  //   iconColor: Color.fromARGB(255, 21, 73, 216),
                  //   //textColor: Colors.indigoAccent,
                  // ),
                  // const _ListitleWidget(
                  //   icon: Icons.share,
                  //   text: "COMPARTIR APP",
                  //   iconColor: Color.fromARGB(255, 21, 73, 216),
                  //   //textColor: Colors.indigoAccent,
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => inicio()),
                          (Route<dynamic> route) => false);
                        
                     
                    },
                    child:  
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 40,
                      
                      child:       Row(
                        children: [
                          
                          Icon(Icons.home, color: Colors.black,),
                         
                          Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text('Inicio',style: TextStyle( fontSize: 15.0,)))
                          
                         
                          
                        ],
                      ),
                    ),
                    )
                    
                   
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => EstilosBanda()),
                          (Route<dynamic> route) => false);
                        
                     
                    },
                    child:  
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 40,
                      
                      child:       Row(
                        children: [
                          
                          Icon(Icons.article, color: Colors.black,),
                         
                          Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text('Estilos',style: TextStyle( fontSize: 15.0,)))
                          
                         
                          
                        ],
                      ),
                    ),
                    )
                    
                    // _ListitleWidget(
                    //   icon: Icons.book,
                    //   text: rotuloBanda,
                    //   iconColor: Color.fromARGB(255, 21, 73, 216),
                    //   //textColor: Colors.purple,
                    // ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                        setState(() {
                              barcodeD = '';
                              _isLoading = false;
                            });
                            scanBarcode();
                    },
                    child:  
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 40,
                      // color: 
                      // status_banda==1
                      // ?
                      // Colors.red
                      // :
                      // Color.fromARGB(255, 13, 161, 45),
                      child:       Row(
                        children: [
                          
                          Icon(Icons.barcode_reader, color: Colors.black,),
                          
                          Padding(padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text('Leer Lote',style: TextStyle( fontSize: 15.0,)))
                          
                        ],
                      ),
                    ),
                    )
                    
                    // _ListitleWidget(
                    //   icon: Icons.book,
                    //   text: rotuloBanda,
                    //   iconColor: Color.fromARGB(255, 21, 73, 216),
                    //   //textColor: Colors.purple,
                    // ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (sharedPreferences != null) {
                        sharedPreferences?.remove('token');
                        sharedPreferences?.remove('nombre');
                        sharedPreferences?.remove('correo');
                        sharedPreferences?.remove('telefono');
                        sharedPreferences?.remove('usuario');
                        sharedPreferences?.remove('conexion');

                        BorrarSesion();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPage('token', 'modelo')),
                            (Route<dynamic> route) => false);
                      } else {
                        sharedPreferences?.remove('token');
                        sharedPreferences?.remove('nombre');
                        sharedPreferences?.remove('correo');
                        sharedPreferences?.remove('telefono');
                        sharedPreferences?.remove('usuario');
                        sharedPreferences?.remove('conexion');
                        //sharedPreferences?.clear();
                        BorrarSesion();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage(
                                    tokenTelefono.toString(),
                                    modeloTelefono.toString())),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: const _ListitleWidget(
                      icon: Icons.exit_to_app,
                      text: "CERRAR SESION",
                      iconColor: Color.fromARGB(255, 21, 73, 216),
                      //textColor: Colors.purple,
                    ),
                  )
                ],
              ),
            ),
            // const Align(
            //   alignment: Alignment.bottomCenter,
            //   child: ListTile(
            //     title: Center(
            //       child: Text(
            //         "Perugia 2022",
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.bold,
            //           fontStyle: FontStyle.italic,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  BorrarSesion() async {
    int regborrados = await dbHelper.deleteAll();
    if (regborrados == 0) {}
  }
}

class _ListitleWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  //final Color textColor;

  const _ListitleWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconColor,
    //required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 21, 73, 216),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
