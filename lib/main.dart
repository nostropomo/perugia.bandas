import 'dart:async';

import 'package:bandas/paginas/inicio.dart';
import 'package:bandas/splash/splash_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    builder: EasyLoading.init(),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
   }



class _MyAppState extends State<MyApp> {
  SharedPreferences? sharedPreferences;
  static String token = "";
  late Timer _timer;

  void initState() {
    //traer_token();
    super.initState();

    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer.cancel();
      }
    });
    
  }

traer_token() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String tokenapp = "";
    String modeloDispositivo = "";
    //tokenapp = (await FirebaseMessaging.instance.getToken())!;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');

    setState(() {
      sharedPreferences.setString("tokenKey", tokenapp.toString());
      sharedPreferences.setString("modelo", androidInfo.model.toString());
      token = tokenapp;
      modeloDispositivo = androidInfo.model.toString();
    });
    print('Token Unico: $token');
  }

  @override
 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash",
      
      routes: {
        "splash": (_) => SplashScreen(),
        "inicio": (_) =>  inicio(),
        //"message": (_) => MessageScreen(),
        //"OrdenTrabajo": (_) => OrdenTrabajo(),
        //"OrdenServicio": (_) => OrdenServicio(),
        //"ProgramarServicios": (_) => ProgramarServicios(),
        //"InventarioPartes": (_) => InventarioPartes(),
        //"Inventario": (_) => EstilosPrincipal(),
        //"Tecnicos": (_) => Tecnicos(),
      },
    );
  }

}
  // This widget is the root of your application.
  


