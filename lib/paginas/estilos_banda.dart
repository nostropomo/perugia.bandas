

import 'package:bandas/Utils/clases_listas.dart';
import 'package:bandas/Utils/utils.dart';
import 'package:bandas/main.dart';
import 'package:bandas/paginas/inicio.dart';
import 'package:bandas/paginas/menu_lateral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/global.dart';
import '../Utils/services.dart';

class EstilosBanda extends StatefulWidget {
  @override
  _EstilosBandaState createState() => _EstilosBandaState();
}

class _EstilosBandaState extends State<EstilosBanda> {
  int idFabrica=0;
 List<estilosBanda> contenedor = [];
late bool loading;
String estilosEncontrados='';
String _estiloEnviarBanda = '';


@override
  void initState() {
    //users = [];
    loading = true;
    checkPrefs();
  
    
    super.initState();
  }

  

  Future<void> checkPrefs() async {
    SharedPreferences sharedPreferences;
    sharedPreferences = await SharedPreferences.getInstance();
    idFabrica=int.parse(sharedPreferences.getString("id_fabrica").toString());
    //// traer banda activa
    EasyLoading.show(status: 'cargando...');
    Services.traerEstilosBanda(idFabrica).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        contenedor = usersFromServer;
        if (contenedor.length == 0) {
          estilosEncontrados = "Encontrados: 0";
        } else {
          estilosEncontrados = "Encontrados: " + contenedor.length.toString();
        }
      });
    });



    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerRecetas(),
      appBar: AppBar(
        backgroundColor: Constants.backprimary,
        title: Text("Estilos liberados en Banda"),
      ),
      //drawer: DrawerRecetas(),
      body:
      Column(
          children: <Widget>[
            Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    
                    height: 25,
                    child: Text(
                                  'Fabrica ' + idFabrica.toString(),
                                  style: new TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                    
                  )
                  ],
              ),
              Expanded(
            child: Card(
              child: ListView.builder(
                  padding: EdgeInsets.all(3.0),
                  itemCount: contenedor.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildTripCard(context, index)),
            ),
          ),

            Row(children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total: ' + estilosEncontrados.toString(),
                    style: TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '   ',
                    style: TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
          ]),
          Row(
            children: [
              Container(
                height: 40,
              )
            ],
          )
             ],
      ),
      
    );
  }

  // Widget buildTripCard(BuildContext context, int index) {
  //   final trip = contenedor[index];
  //    return Padding(
  //     padding: EdgeInsets.fromLTRB(1, 1, 1, 0),
  //     child: Column(
  //       children: <Widget>[
  //           Card(
  //             color: Colors.white,
  //             child: Column(
  //               children: <Widget>[
  //                  Row(
  //                   children: <Widget>[
  //                     Expanded(
  //                     flex: 1,
  //                     child: Padding(
  //                       padding: EdgeInsets.all(3.0),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Text(
  //                             trip.estilo.toString(),
  //                             style: new TextStyle(
  //                                 fontSize: 18.0,
  //                                 fontWeight: FontWeight.normal),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
                      
  //                   ],
  //                  )
  //                 ]
  //             ),
  //           ),
  //           ],
  //     ),
      
  //    );
  // }
  Widget buildTripCard(BuildContext context, int index) {
    final trip = contenedor[index];
    return Padding(
        padding: EdgeInsets.fromLTRB(1, 1, 1, 0),
        child: Column(
          children: <Widget>[
            Card(
              color: 
              
              double.parse(trip.tiempo.toString())>0?
              Colors.lightBlue.shade100
              :Color.fromARGB(255, 238, 169, 160),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                trip.alternativa .toString(),
                                style: new TextStyle(
                                    fontSize: 16.0,
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
                        child: 
                        Container(
                          height: 25,
                          child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Programa :  ' + trip.programa .toString(),
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        )
                        
                      ),
                      // Expanded(
                      //   flex: 2,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(3.0),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Text(
                      //           'Tiempo: ',
                      //           style: new TextStyle(
                      //               fontSize: 12.0,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                      // ,
                      // Expanded(
                      //   flex: 2,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(3.0),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Text(
                      //           trip.tiempo.toString(),
                      //           style: new TextStyle(
                      //               fontSize: 14.0,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                                  
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      // Expanded(
                      //   flex: 4,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(3.0),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Text(
                      //           '',
                      //           style: new TextStyle(
                      //               fontSize: 18.0,
                      //               fontWeight: FontWeight.normal),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                     

                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Tiempo: ',
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                      ,
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                trip.tiempo.toString(),
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 3,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(3.0),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Text(
                      //           'Personal: ',
                      //           style: new TextStyle(
                      //               fontSize: 12.0,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   flex: 2,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(3.0),
                      //     child: Column(
                      //       mainAxisSize: MainAxisSize.min,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         Text(
                      //            trip.trabajadores.toString(),
                      //           style: new TextStyle(
                      //               fontSize: 14.0,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //  double.parse(trip.tiempo.toString())>0?
                      // Expanded(
                      //   flex: 2,
                      //   child:
                      //   Padding(
                      //     padding: EdgeInsets.all(3.0),
                      //     child:
                      //       Container(
                      //         height: 40,
                      //         width: 40,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Colors.blue,
                      //           ),
                      //           shape: BoxShape.circle,
                      //           color: Colors.blue,
                      //         ),
                      //         child: 
                      //         IconButton(
                      //           icon: Icon(Icons.edit),
                      //           iconSize: 20,
                      //           tooltip: "Editar Tiempo",
                      //           onPressed: (() {
                      //             // Navigator.push(
                      //             //   context, MaterialPageRoute(builder: (context) => CreateUser( )));
                      //           setState(() {});
                      //           }),
                      //         ),
                      //       ),
                      //   ),
                      // )
                      // :
                      // Container(),

                      double.parse(trip.tiempo.toString())>0?
                      Expanded(
                        flex: 2,
                        child:
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child:
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.schedule_send),
                                iconSize: 20,
                                tooltip: "Enviar a Banda",
                                onPressed: (() {
                                          setState(() {
                                            _estiloEnviarBanda = trip.id_estilo.toString();
                                            _displayTextInputDialog(
                                              context,
                                              int.parse( trip.id_estilo.toString()),
                                              int.parse(trip.fabrica.toString()),
                                              int.parse(double.parse(trip.tiempo.toString()).toInt().toString()),
                                              trip.estilo.toString(),
                                              int.parse(trip.id_programa.toString())
                                              );

                                  });
                                  
                                }),
                              ),
                            ),
                        ),
                      )
                      : 
                      Container(),
                      
                      



                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
  Future<void> actualizarEstiloBanda(
    int _id_estilo,
    int _id_fabrica,
    int _tiempo,
    int _id_programa

) async {
    EasyLoading.show(status: 'cargando...');
    Services.actualizarEstilo(_id_estilo,_id_fabrica,1,_tiempo,1,_id_programa,1).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        contenedor = usersFromServer;
         if (contenedor.length > 0) {
          mostrarAlerta(context,"Se actualizo la alternativa en la Banda", "Actualizado");
        //   estilosEncontrados = "0";
        // } else {
        //   estilosEncontrados =  contenedor.length.toString();
         }
      });
    });
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
            title: Text('Seguro que desea enviar a Banda?'),
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
                  actualizarEstiloBanda(_id_estilo,_id_fabrica,_tiempo,_id_programa);
                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (BuildContext context) => inicio()),
                                    (Route<dynamic> route) => false);
                 });
              
               // if (int.parse(codeDialog.toString()) <= _existencia) {
                        //   mensajeError = "";
                        //   addTaskAndAmount(_id, int.parse(codeDialog), _precio,
                        //       _precio25, _precio26, _precio2);
                        // } else
                        //   mensajeError = "La Cantidad excede la Existencia!!";
              
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(builder: (BuildContext context) => inicio()),
              //   (Route<dynamic> route) => false);
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



    Future<void> traerAlternativas(int _idFabrica) async {
    EasyLoading.show(status: 'cargando...');
    Services.traerEstilosBanda(_idFabrica).then((usersFromServer) {
      EasyLoading.dismiss();
      setState(() {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        contenedor = usersFromServer;
        if (contenedor.length == 0) {
          estilosEncontrados = "Encontrados: 0";
        } else {
          estilosEncontrados = "Encontrados: " + contenedor.length.toString();
        }
      });
    });
  }

}