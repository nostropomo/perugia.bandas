
import 'dart:async';
import 'dart:convert';
import 'package:bandas/Utils/services.dart';
import 'package:bandas/Utils/utils.dart';
import 'package:bandas/api/environment.dart';
import 'package:bandas/db/database_helper.dart';
import 'package:bandas/paginas/estilos_banda.dart';
import 'package:bandas/paginas/login.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/clases_listas.dart';
import '../Utils/global.dart';
import 'menu_lateral.dart';

class inicio extends StatefulWidget{
@override
_inicioState createState() => _inicioState();
  
}
class _inicioState extends State<inicio> {
  List<estilosBanda> contenedortodos = [];
  List<loteBanda> contenedorlotes = [];
  //List<estilosBanda> contenedor = [];
  var _controllerTiempo= 1;
  late Timer _timer;
  bool _visibleBarcode=true;
  var _popupMenuItemIndex = 0;
  int statusBanda=0;
  int idFabrica=0;
  int idUsuario=0;
  final dbHelper = DatabaseHelper.instance;
  String barcodeD = '';
  bool _isLoading = false;
  String codigobarras="";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

@override
  void initState() {
    _controllerTiempo= 0;
    checkPrefs();
    //traerAlternativas();
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer.cancel();
      }
    });
    
  }

  Future<void> checkPrefs() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    final allRows = await dbHelper.queryAllRowsu();
    if (allRows.length == 0) {
      Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage(
                                    '',
                                    '')),
                            (Route<dynamic> route) => false);
    }else{
    sharedPreferences.setString("id_fabrica", allRows[0].fabrica.toString());
    idFabrica=int.parse(allRows[0].fabrica.toString());
    idUsuario=int.parse(allRows[0].id.toString());
    //// traer banda activa
    EasyLoading.show(status: 'cargando...');
    Services.traerEstilos(idFabrica).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        contenedortodos = usersFromServer;
        _controllerTiempo=double.parse(contenedortodos[0].tiempo.toString()).toInt();
        statusBanda=int.parse(contenedortodos[0].banda_activa.toString());

        Environment.GlogStatusBanda=int.parse(contenedortodos[0].banda_activa.toString());
        Environment.GlogidEstilo=int.parse(contenedortodos[0].id_estilo.toString());
        Environment.GlogidPrograma=int.parse(contenedortodos[0].id_programa.toString());
        Environment.GlogidFabrica=int.parse(contenedortodos[0].fabrica.toString());
        Environment.GlogidUsuario=idUsuario;
        Environment.Glogtiempo=int.parse(double.parse(contenedortodos[0].tiempo.toString()).toInt().toString());
        // if (contenedor.length == 0) {
        //   estilosEncontrados = "0";
        // } else {
        //   estilosEncontrados =  contenedor.length.toString();
        // }
      });
    });


    }
  }


  _onMenuItemSelected(int value) {
    final trip = contenedortodos;
    setState(() {
      _popupMenuItemIndex = value;
    });

    setState(() {
     ///actualizar dato------------
     if (value==1)
      {
        _displayStopInputDialog(context,int.parse(contenedortodos[0].id_estilo.toString()), int.parse(contenedortodos[0].fabrica.toString()),int.parse(_controllerTiempo.toString()),contenedortodos[0].alternativa.toString(), int.parse(contenedortodos[0].id_programa.toString()));
        // actualizarEstiloBanda(int.parse(contenedortodos[0].id_estilo.toString()), int.parse(contenedortodos[0].fabrica.toString()),0,int.parse(contenedortodos[0].id_programa.toString()), int.parse(contenedortodos[0].banda_activa.toString()),2);
      }else if (value==2)
      {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  EstilosBanda()),
            );
      }else if(value==3)
      {

                            setState(() {
                              barcodeD = '';
                              _isLoading = false;
                            });
                            scanBarcode();
      }
     
     }
     );

    // if (value == 1) {
    //   mostrarAlerta(context,"Opcion :", value.toString());
    // } else {
    //   mostrarAlerta(context,"Opcion :", value.toString());
    // }
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
            Services.traerLoteBanda(int.parse(barcode),idFabrica).then((usersFromServer) {
              EasyLoading.dismiss();
              setState(() {
                FocusScope.of(context).unfocus();
                new TextEditingController().clear();
                contenedorlotes = usersFromServer;
                
                if (contenedorlotes.length >0) {
                 /// dialogo confirmacion
                 /// 
                 _displayLoteInputDialog(context, int.parse(contenedorlotes[0].id_estilo.toString()),
                 int.parse(contenedorlotes[0].id_fabrica.toString()),
                 int.parse(contenedorlotes[0].tiempo.toString()),
                 contenedorlotes[0].descripEstilo.toString(),
                 int.parse(contenedorlotes[0].id_programa.toString())
                 );
                 
                }
              });
            });



        } 
                
       
        
      }

      // });

    } on PlatformException {
      barcodeD = 'Failed to get platform version.';
    }

    ///buscar cliente localmente para traer datos del credito
    ///
  }





  Future<void> traerAlternativas() async {
    EasyLoading.show(status: 'cargando...');
    Services.traerEstilos(idFabrica).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        contenedortodos = usersFromServer;
        _controllerTiempo=double.parse(contenedortodos[0].tiempo.toString()).toInt();
        statusBanda=int.parse(contenedortodos[0].banda_activa.toString());
        // if (contenedor.length == 0) {
        //   estilosEncontrados = "0";
        // } else {
        //   estilosEncontrados =  contenedor.length.toString();
        // }
      });
    });
  }

  Future<void> actualizarEstiloBanda(
    int _id_estilo,
    int _id_fabrica,
    int _tiempo,
    int _programa,
    int banda_activa,
    int id_proceso

) async {

    int bandaActiva=0;
    if(banda_activa==1)
    bandaActiva=0;
    else
    bandaActiva=1;
    EasyLoading.show(status: 'cargando...');
    Services.actualizarEstilo(_id_estilo,_id_fabrica,idUsuario,_controllerTiempo,id_proceso,_programa,bandaActiva).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        if (usersFromServer.length> 0)
        {
          contenedortodos = usersFromServer;
          _controllerTiempo=double.parse(contenedortodos[0].tiempo.toString()).toInt();
        statusBanda=int.parse(contenedortodos[0].banda_activa.toString());
        if(statusBanda==0)
          if(id_proceso==1)
          {
            mostrarAlerta(context,"Se ha enviado el tiempo", "Aviso");
          }else{
            mostrarAlerta(context,"Se ha detenido la Banda", "Aviso");
          }
          else
          {
             if(id_proceso==2)
             {
              mostrarAlerta(context,"Se ha activado la Banda", "Aviso");
             }
            
          }
          
        }
        else {
          mostrarAlerta(context,"Hubo un error artualizando", "Error");
        }
         
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return 
        
    Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: DrawerRecetas(),
      appBar: AppBar(
          backgroundColor: Constants.backprimary,
          title: Text('Bandas'),
          actions: [
          PopupMenuButton(
            onSelected: (value) {
            _onMenuItemSelected(value as int);
          },
          itemBuilder: (ctx) => [
           _buildPopupMenuItem('Detener Banda', Icons.stop_circle_outlined, 1, statusBanda),
            //_buildPopupMenuItem('Estilos', Icons.article, 2,statusBanda),
            //_buildPopupMenuItem('Leer Lote', Icons.barcode_reader, 3,statusBanda),
           
          ],
        )
        ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,
           onRefresh: () async{
              _controllerTiempo= 0;
                  checkPrefs();
            return Future<void>.delayed(const Duration(seconds: 3));

           },
           child: 
             ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: contenedortodos.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildTripCard(context, index)), ),


                  
      
                    bottomNavigationBar:
                    
                    ConstrainedBox(
                      
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Container(
                            color: 
                             statusBanda==0?
                         Color.fromARGB(255, 255, 34, 4)
                         :Color.fromARGB(255, 13, 161, 45),
                            child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                              <Widget>[
                                Container(
                                  height: 40,
                                  child: statusBanda==0?
                                  Text("Banda detenida", style: TextStyle( fontSize: 25.0,color: Colors.white)
                                    )
                                    :
                                    Text("Banda activa", style: TextStyle( fontSize: 25.0,color: Colors.white)
                                    ),
                                )
                                
                                ],
                            ),
                            
                          ),
                        )
                    // Container(
                    // height: 65,
                    
                    // //margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                    // child: 
                    // Row(
                      
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //   Container(
                    //     width: 250,
                    //     //constraints: BoxConstraints(minWidth: 250, maxWidth: 1000),
                    //     color:
                    //     statusBanda==0?
                    //     Color.fromARGB(255, 255, 34, 4)
                    //     :Color.fromARGB(255, 13, 161, 45),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         statusBanda==0?
                    //         Text("Banda detenida", style: TextStyle( fontSize: 20.0,color: Colors.white)
                    //         )
                    //         :
                    //         Text("Banda activa", style: TextStyle( fontSize: 20.0,color: Colors.white)
                    //         ),
                    //         ],
                    //     ),
                    //   ),
                    //   ],
                    //   ),
                    // ),
    );
    
  }


  Widget buildTripCard(BuildContext context, int index) {
    final trip = contenedortodos[index];
    return Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 0),
        child: Column(
          children: <Widget>[
            
              
//             ListView(
//                   padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[


                         Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    
                    height: 30,
                    child: Text(
                                  'Fabrica ' + trip.fabrica.toString(),
                                  style: new TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                    
                  )
                  ],
              ),

              Row(
                children: <Widget>[
                  Container(
                    height: 20
                  )
                  ],
              ),
                      
                      
                      Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Programa :',
                                  style: new TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                         Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  trip.programa.toString() ,
                                  style: new TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                                    
                        ],
                      ),

                      
                      

                        Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  trip.alternativa.toString(),
                                  style: new TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                                    
                        ],
                      ),
                        Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('ID -' +
                                  trip.id_estilo.toString() ,
                                  style: new TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Vel. actual: ' +
                                  trip.tiempo.toString(),
                                  style: new TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                                    
                        ],
                      ),

                        Row(
                        children: <Widget>[
                          Container(
                            height: 10
                          )
                          ],
                      ),
                      // Row(
                      // children: <Widget>[
                      //   Expanded(
                      //     flex: 4,
                      //     child: Padding(
                      //       padding: EdgeInsets.all(3.0),
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text('Velocidad actual: ' +
                      //             trip.tiempo.toString(),
                      //             style: new TextStyle(
                      //                 fontSize: 20.0,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                        
                                    
                      //   ],
                      // ),
                            Row(
                          children: <Widget>[
                            Container(
                              height: 20
                            )
                            ],
                        ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                
                                height: 30,
                                child: Text(
                                              'Ajustar Velocidad',
                                              style: new TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                
                              )
                              ],
                          ),

                          CartStepperInt(
                          value:   _controllerTiempo ,
                          size: 60,
                          style: CartStepperStyle(
                            foregroundColor: Colors.black87,
                            activeForegroundColor: Colors.black87,
                            activeBackgroundColor: Colors.white,
                            border: Border.all(color: Colors.grey),
                            radius: const Radius.circular(8),
                            elevation: 0,
                            buttonAspectRatio: 1.5,
                          ),
                          didChangeCount: (count) {
                            setState(() {
                              _controllerTiempo = count;
                            });
                          },
                        ),
                  

//               //-------------------------control incremento de numero
//             //  QuantityInput(
//             //       //label: 'Simple int input',
//             //       iconColor: Colors.white,
//             //       minValue: 0,
//             //       maxValue: 60,
//             //       //decoration: ,
//             //       buttonColor: Color.fromARGB(255, 63, 116, 214),
//             //       value: _controllerTiempo,
//             //       onChanged: (value) => setState(() => _controllerTiempo = int.parse(value.replaceAll(',', ''))),
                 
//             //     ),

                      
                       
                      Row(
                        children: <Widget>[
                          Container(
                            height: 50
                          )
                          ],
                      ),
                          Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                height: 60,
                                width: 250,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                  ),
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 63, 116, 214),
                                    fixedSize: Size.fromWidth(100),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  child: Text("Aplicar",
                                      style: new TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                      ),
                                        onPressed: () {
                                          setState(() {
                                            ///actualizar dato------------
                                            _displayTextInputDialog(context,int.parse(trip.id_estilo.toString()), int.parse(trip.fabrica.toString()),int.parse(_controllerTiempo.toString()),trip.alternativa.toString(), int.parse(trip.id_programa.toString()));
                                            //actualizarEstiloBanda(int.parse(trip.id_estilo.toString()), int.parse(trip.fabrica.toString()),0,int.parse(trip.id_programa.toString()), int.parse(trip.banda_activa.toString()),1);
                                          });
                                      },

                                    ) ,
                                  ),
                                ]
                          ),


                          
  
          ],
        ));
  }
Future<void> _displayTextInputDialog(
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
            title: Text('Confirmar envio de tiempo'),
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
                  actualizarEstiloBanda(int.parse(_id_estilo.toString()), int.parse(_id_fabrica.toString()),0,int.parse(_id_programa.toString()), int.parse(statusBanda.toString()),1);
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
                  actualizarEstiloBanda(int.parse(_id_estilo.toString()), int.parse(_id_fabrica.toString()),0,int.parse(_id_programa.toString()), int.parse(statusBanda.toString()),1);
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
                   actualizarEstiloBanda(int.parse(_id_estilo.toString()), int.parse(_id_fabrica.toString()),0,int.parse(_id_programa.toString()), int.parse(statusBanda.toString()),2);
                 
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



 }
 
 
PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position, int _statusBanda) {
    return PopupMenuItem(
      
      value: position,
      child:  
            position==1?
            Container(
              height: 40,
            color: 
            _statusBanda==1
            ?
            Colors.red
            :
            Color.fromARGB(255, 13, 161, 45),
            child:       Row(
              children: [
                
                Icon(iconData, color: Colors.black,),
                _statusBanda==1
                ?
                Text('Desactivar Banda')
                :
                Text('Activar Banda'),
                
              ],
            ),
          )
          :
            Row(
              children: [
                
                Icon(iconData, color: Colors.black,),
                Text(title),
                
              ],
            ),
    );
  }