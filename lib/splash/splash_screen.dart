import 'package:bandas/paginas/inicio.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var d = const Duration(seconds: 3);
    Future.delayed(d, () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return  inicio();
        },
      ), (route) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/imagenes/splash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: ListTile(
                title: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(55.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
