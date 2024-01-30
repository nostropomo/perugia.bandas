import 'dart:convert';
import 'dart:io' as Io;
import 'package:bandas/main.dart';
import 'package:connectivity/connectivity.dart';
import '../api/environment.dart';
import '../paginas/inicio.dart';

import 'package:masked_text/masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:get_version/get_version.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/menu.dart';
import '../Utils/utils.dart';
import '../db/database_helper.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  final String token;
  final String modeloDispositivo;
  LoginPage(this.token, this.modeloDispositivo);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  List<Menu> menu = [];
  String _platformVersion = 'Unknown';
  String _projectVersion = '';
  String _projectCode = '';
  String _projectAppID = '';
  String _projectName = '';
  SharedPreferences? sharedPreferences;
  String tokenTelefono = "";
  String _url = Environment.API_DELIVERY;
  final dbHelper = DatabaseHelper.instance;
  PackageInfo? packageInfo;

  @override
  initState() {
    super.initState();
    //CheckStatus();
  }

  @override
  Widget build(BuildContext context) {
    //traerVersion();
    getPackage();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    // ScreenUtil().instance = ScreenUtil.getInstance()..init(context);
    // ScreenUtil().instance =
    //     ScreenUtil(width: 750, height: 1200, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Container(
                height: 70,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/imagenes/PERUGIAERPTrans.png'),
                                    fit: BoxFit.contain))))
                  ],
                )),
            Container(
                width: 300,
                height: 300,
                child: Stack(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Login',
                            style: TextStyle(
                                color: Color.fromRGBO(49, 39, 79, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        //SizedBox(
                        //  height: 10,
                        //),
                        Container(
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ]),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: textSection(),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 60),
                        //   child: buttonSection(),
                        // )
                      ],
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? tokenKey = "";
    String? modeloTelefono = "";
    if (sharedPreferences.getString("tokenKey") != "" ||
        sharedPreferences.getString("tokenKey") != null) {
      tokenKey = sharedPreferences.getString("tokenKey").toString();
    }
    if (sharedPreferences.getString("modelo") != "" ||
        sharedPreferences.getString("modelo") != null) {
      modeloTelefono = sharedPreferences.getString("modelo").toString();
    }

    //'usuario': email,
    try {
      Map data = {
        'pasword': pass,
        'tokentelefono': tokenKey,
        'modelo': modeloTelefono,
      };
      var jsonResponse;
      var response =
          await http.post(Uri.parse('$_url/loginBandas'), body: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonResponse = json.decode(response.body);
        List data2;

        if (jsonResponse != null) {
          if (jsonResponse['result'] == 1) {
            //data2 = jsonResponse['data'];
            sharedPreferences.setString(
                "token", jsonResponse["id_usuario"].toString());
            menu.clear();
            // for (var jsonUser in jsonResponse['data']) {
            //   menu.add(Menu.fromJason(jsonUser));
            // }
            // var s = json.encode(jsonResponse['data']);

            // sharedPreferences.setString("menu", s);

            setState(() {
              _isLoading = true;
            });

            ////  grabar en base de datos local-----------------------paint
            int totalRegistros = await dbHelper.getCount();

            int regborrados = await dbHelper.deleteAll();

            if (regborrados == 0) {
              // final allRows = await dbHelper.queryAllRows();
              // print('query all rows:');
              // allRows.forEach((row) => print(row));
              Map<String, dynamic> row = {
                DatabaseHelper.columnId:
                    int.parse(jsonResponse["id_usuario"].toString()),
                DatabaseHelper.columnUsuario:
                    jsonResponse["usuario"].toString(),
                DatabaseHelper.columnNombre: jsonResponse["nombre"].toString(),
                DatabaseHelper.columnCorreo: jsonResponse["correo"].toString(),
                DatabaseHelper.columnTelefono: "",
                DatabaseHelper.columnFechasesion:
                    DateTime.parse(jsonResponse['limiteSesion']).toString(),
                DatabaseHelper.columnTokenTelefono: widget.token.toString(),
                DatabaseHelper.columnfotoEmpleado:
                    base64Decode(jsonResponse["foto"]),
                DatabaseHelper.columnStatusSesion: 1,
                DatabaseHelper.columnFabrica: int.parse(jsonResponse["id_fabrica"].toString()),
              };
              final id = await dbHelper.insert(row);
              print('inserted row id: $id');
            }

            sharedPreferences.setString(
                "token", jsonResponse["id_usuario"].toString());
            sharedPreferences.setString(
                "nombre", jsonResponse["nombre"].toString());
            sharedPreferences.setString(
                "correo", jsonResponse["correo"].toString());
            sharedPreferences.setString("telefono", "");
            sharedPreferences.setString(
                "usuario", jsonResponse["usuario"].toString());
            sharedPreferences.setString("conexion", "1");
            sharedPreferences.setString(
                "tokentelefono", widget.token.toString());
            sharedPreferences.setString(
                "id_fabrica", jsonResponse["id_fabrica"].toString());

            ///-------------------------------------------------------

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => MyApp()),
                (Route<dynamic> route) => false);
          } else {
            mostrarAlerta(context, 'Error de login', 'Login incorrecto');
            setState(() {
              emailController.text = "";
              passwordController.text = "";
              _isLoading = false;
            });
            print(response.body);
          }
        }
      } else {
        setState(() {
          emailController.text = "";
          passwordController.text = "";
          _isLoading = false;
        });
        print(response.body);
      }
    } on Exception catch (e) {
      mostrarAlerta(context, 'Error de Red', 'No hay acceso a Red');
    }
  }

  Container buttonSection() {
    return Container(
      width: 330,
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(50),
      //   color: Color.fromRGBO(49, 39, 79, 1),
      //),
      child: ElevatedButton(
        onPressed: emailController.text == "" || passwordController.text == ""
            ? null
            : () {
                setState(() {
                  _isLoading = true;
                });
                signIn(emailController.text, passwordController.text);
              },
        //elevation: 0.0,
        //color: Colors.blueGrey,
        child: Text("Ingresar", style: TextStyle(color: Colors.white70)),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final FocusNode _usuarioFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _botonFocus = FocusNode();
  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          // MaskedTextField(

          //    controller: passwordController,
          //       mask: "******",
          //       maxLength: 6,
          //       keyboardType: TextInputType.number,

          // ),
          TextFormField(
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            controller: passwordController,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            autofocus: true,
            focusNode: _passwordFocus,
            onFieldSubmitted: (_) {
              _fieldFocusChange(context, _passwordFocus, _botonFocus);
            },
            obscureText: true,
            style: TextStyle(fontSize: 24, color: Colors.black),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.black),
              hintText: "[0-9]",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              hintStyle: TextStyle(color: Color.fromARGB(255, 179, 199, 240)),
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Version ' + _projectVersion,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(height: 15.0),
          // OutlinedButton.icon(
          //   onPressed: () {
          //     emailController.text == "" || passwordController.text == ""
          //         ? null
          //         : () {
          //             setState(() {
          //               _isLoading = true;
          //             });
          //             signIn(emailController.text, passwordController.text);
          //           };
          //   },
          //   icon: Icon(Icons.login, size: 25),
          //   label: Text("INGRESAR"),
          // )
          ElevatedButton(
            onPressed: passwordController.text == ""
                ? null
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    signIn(emailController.text, passwordController.text);
                  },
            focusNode: _botonFocus,
            //elevation: 0.0,
            //color: Colors.blueGrey,
            child: Text("Ingresar", style: TextStyle(color: Colors.white70)),
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(5.0)),
          ),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      //child: Image.asset("assets/icon/encar_logo.jpg"),
      child: Text("PERUGIA VENTAS",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blue, fontSize: 40.0, fontWeight: FontWeight.bold)),
    );
  }

  void getPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo!.appName;
    String packageName = packageInfo!.packageName;
    String version = packageInfo!.version;
    String buildNumber = packageInfo!.buildNumber;
    print(
        "App Name : ${appName}, App Package Name: ${packageName},App Version: ${version}, App build Number: ${buildNumber}");
    setState(() {
      _platformVersion = packageInfo!.version;
      _projectVersion = packageInfo!.version;
      _projectCode = packageInfo!.version;
      _projectAppID = packageInfo!.version;
      _projectName = packageInfo!.version;
    });
  }

  // traerVersion() async {
  //   String version = "";

  //   try {
  //     version = await GetVersion.projectVersion;
  //   } on PlatformException {
  //     version = 'Failed to get project version.';
  //   }
  //   setState(() {
  //     _platformVersion = version;
  //     _projectVersion = version;
  //     _projectCode = version;
  //     _projectAppID = version;
  //     _projectName = version;
  //   });
  // }
}
