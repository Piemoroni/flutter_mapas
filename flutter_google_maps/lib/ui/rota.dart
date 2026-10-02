import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../widgets/menu_drawer.dart';
import '../main.dart';
import '../style/colors.dart';

class RotaScreen extends StatefulWidget {
  const RotaScreen({super.key});

  @override
  State<RotaScreen> createState() => _RotaScreenState();
}

class _RotaScreenState extends State<RotaScreen> {
  // ATENÇÃO: Insira sua chave da API do Google Maps no AndroidManifest.xml conforme as instruções do README.
  GoogleMapController? _mapController;
  LatLng? _posicaoAtual;
  LatLng? _posicaoDestino;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _carregandoRota = false;

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
    });
    _buscarRotaOsrm();
  }

  void _atualizarMarcadores() {
    _markers.clear();

    if (_posicaoAtual != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('origem'),
          position: _posicaoAtual!,
          infoWindow: const InfoWindow(title: 'Origem'),
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

  Future<void> _buscarRotaOsrm() async {
    if (_posicaoAtual == null || _posicaoDestino == null) return;

    setState(() => _carregandoRota = true);

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${_posicaoAtual!.longitude},${_posicaoAtual!.latitude};'
      '${_posicaoDestino!.longitude},${_posicaoDestino!.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List coordinates = data['routes'][0]['geometry']['coordinates'];

        List<LatLng> pontosRota = coordinates.map((c) {
          return LatLng(c[1].toDouble(), c[0].toDouble());
        }).toList();

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('rota_osrm'),
              points: pontosRota,
              color: Colors.blueAccent,
              width: 5,
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Erro ao buscar rota OSRM: $e');
    } finally {
      setState(() => _carregandoRota = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map traçar Rota'),
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
                  'Destino: ${_posicaoDestino != null ? "@${_posicaoDestino!.latitude.toStringAsFixed(6)}, ${_posicaoDestino!.longitude.toStringAsFixed(6)}" : "Clique no mapa"}',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _posicaoAtual == null
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
                if (_carregandoRota)
                  const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}