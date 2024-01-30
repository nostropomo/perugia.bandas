import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:percent_indicator/percent_indicator.dart';

void mostrarAlerta(BuildContext context, String mensaje, String encabezado,
    [int fondo = 0]) {
  Color fondodialogo = Colors.white;
  switch (fondo) {
    case 0:
      fondodialogo = Colors.white;
      break;
    case 1:
      fondodialogo = Colors.red;
      break;
    case 2:
      fondodialogo = Colors.green;
      break;
  }
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: fondodialogo,
          title: Text(encabezado),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

void mostrarImagen(BuildContext context, String descripcion, String _imagen) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_imagen),
          content: AspectRatio(
            aspectRatio: 1,
            child: PinchZoom(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  descripcion,
                  fit: BoxFit.cover,
                ),
              ),
              resetDuration: const Duration(milliseconds: 1000),
              maxScale: 2.5,
            ),

            // ClipRRect(
            //   borderRadius: BorderRadius.circular(20),
            //   child: Image.network(
            //     descripcion,
            //     fit: BoxFit.cover,
            //   ),
            // ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

void mostrarImagenisometrico(
    BuildContext context, String? descripcion, Image? _imagen) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(descripcion!),
          content: AspectRatio(
            aspectRatio: 1,
            child: PinchZoom(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), child: _imagen),
              resetDuration: const Duration(milliseconds: 1000),
              maxScale: 2.5,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}







