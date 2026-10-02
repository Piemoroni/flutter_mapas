import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'menu_drawer.dart';

class RotaScreen extends StatefulWidget {
  const RotaScreen({super.key});

  @override
  State<RotaScreen> createState() => _RotaScreenState();
}

class _RotaScreenState extends State<RotaScreen> {
  final MapController _mapController = MapController();

  LatLng? _pontoOrigem;
  LatLng? _pontoDestino;

  @override
  void initState() {
    super.initState();
    _obterLocalizacao();
  }

  // Obtém GPS e coordenadas da localização atual
  Future<void> _obterLocalizacao() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _pontoOrigem = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_pontoOrigem!, 16.0);
      }
    } catch (e) {
      debugPrint('Erro ao obter GPS: $e');
    }
  }

  // Ao tocar no mapa, atualiza a posição do destino
  void _aoTocarNoMapa(TapPosition tapPosition, LatLng ponto) {
    setState(() {
      _pontoDestino = ponto;
    });
  }

  String _formatarCoordenada(LatLng? ponto) {
    if (ponto == null) return '';
    return '@${ponto.latitude.toStringAsFixed(6)}, ${ponto.longitude.toStringAsFixed(6)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map traçar linha'),
        backgroundColor: const Color(0xFF5D4037), // Marrom escuro
        foregroundColor: Colors.white,
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          // Painel Superior em Tons de Marrom
          Container(
            color: const Color(0xFFD7CCC8), // Bege/Marrom suave
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              children: [
                Text(
                  'Origem: ${_formatarCoordenada(_pontoOrigem)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3E2723), // Texto marrom bem escuro
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Destino: ${_formatarCoordenada(_pontoDestino)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF3E2723),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Mapa com a linha
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _pontoOrigem ?? const LatLng(-22.713, -46.818),
                initialZoom: 16.0,
                onTap: _aoTocarNoMapa,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (_pontoOrigem != null && _pontoDestino != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [_pontoOrigem!, _pontoDestino!],
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (_pontoOrigem != null)
                      Marker(
                        point: _pontoOrigem!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
                      ),
                    if (_pontoDestino != null)
                      Marker(
                        point: _pontoDestino!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}