import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/menu_drawer.dart';
import '../main.dart';
import '../style/colors.dart';

class LinhaScreen extends StatefulWidget {
  const LinhaScreen({super.key});

  @override
  State<LinhaScreen> createState() => _LinhaScreenState();
}

class _LinhaScreenState extends State<LinhaScreen> {
  GoogleMapController? _mapController;
  LatLng? _posicaoAtual;
  LatLng? _posicaoDestino;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _posicaoAtual = LatLng(position.latitude, position.longitude);
      _atualizarMarcadores();
    });

    if (_mapController != null && _posicaoAtual != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(_posicaoAtual!, 15));
    }
  }

  void _aoClicarNoMapa(LatLng ponto) {
    setState(() {
      _posicaoDestino = ponto;
      _atualizarMarcadores();
      _desenharLinha();
    });
  }

  void _atualizarMarcadores() {
    _markers.clear();

    if (_posicaoAtual != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('origem'),
          position: _posicaoAtual!,
          infoWindow: const InfoWindow(title: 'Origem (Seu local)'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (_posicaoDestino != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destino'),
          position: _posicaoDestino!,
          infoWindow: const InfoWindow(title: 'Destino'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  void _desenharLinha() {
    if (_posicaoAtual == null || _posicaoDestino == null) return;

    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('linha_reta'),
        points: [_posicaoAtual!, _posicaoDestino!],
        color: Colors.blueAccent,
        width: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map traçar linha'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, _) {
              return Switch(
                value: currentMode == ThemeMode.dark,
                activeColor: AppColors.verdeClaro,
                onChanged: (bool val) {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
        ],
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Container(
            color: Colors.amber[50],
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'Origem: ${_posicaoAtual != null ? "@${_posicaoAtual!.latitude.toStringAsFixed(3)}, ${_posicaoAtual!.longitude.toStringAsFixed(3)}" : "Carregando..."}',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
                Text(
                  'Destino: ${_posicaoDestino != null ? "@${_posicaoDestino!.latitude}, ${_posicaoDestino!.longitude}" : "Clique no mapa"}',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: _posicaoAtual == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _posicaoAtual!,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    onTap: _aoClicarNoMapa,
                    markers: _markers,
                    polylines: _polylines,
                    myLocationEnabled: true,
                  ),
          ),
          if (_posicaoDestino != null)
            Container(
              color: Colors.grey[850],
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: Text(
                'Latitude: ${_posicaoDestino!.latitude}, Longitude: ${_posicaoDestino!.longitude}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}