import 'package:google_maps_flutter/google_maps_flutter.dart';

class PontoRota {
  final String titulo;
  final LatLng coordenada;

  PontoRota({
    required this.titulo,
    required this.coordenada,
  });
}