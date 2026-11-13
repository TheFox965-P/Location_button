import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// IMPORTAMOS NUESTROS SERVICIOS INDEPENDIENTES
import '../services/location_service.dart';
import '../services/camera_service.dart';

// AGREGADO (ANGEL IVAN PINTOR FLORES): IMPORTAMOS EL NUEVO WIDGET SEPARADO
import '../widgets/evidencia_card.dart';

class EvidenciaScreen extends StatefulWidget {
  const EvidenciaScreen({super.key});

  @override
  State<EvidenciaScreen> createState() => _EvidenciaScreenState();
}

class _EvidenciaScreenState extends State<EvidenciaScreen> {
  final LocationService _locationService = LocationService();
  final CameraService _cameraService = CameraService();

  // VARIABLES DE ESTADO PARA GUARDAR LA EVIDENCIA (ANGEL IVAN PINTOR FLORES)
  bool _cargando = false;
  String? _rutaImagen;
  double? _latitud;
  double? _longitud;
  String? _fechaHoraExacta;
  String? _errorMensaje;

  // FLUJO INTEGRADO ASÍNCRONO: GPS -> CÁMARA -> PANTALLA
  Future<void> _registrarEvidenciaAsincrona() async {
    setState(() {
      _cargando = true;
      _errorMensaje = null;
    });

    try {
      // 1. OBTENER UBICACIÓN GPS
      Position? posicion = await _locationService.obtenerUbicacion();

      // 2. SI EL GPS ES EXITOSO, ABRIR LA CÁMARA INMEDIATAMENTE
      if (posicion != null) {
        final foto = await _cameraService.tomarFotografia();

        // 3. SI SE TOMÓ LA FOTO, GUARDAR TODOS LOS DATOS EN EL ESTADO DE LA PANTALLA
        if (foto != null) {
          setState(() {
            _latitud = posicion.latitude;
            _longitud = posicion.longitude;
            _rutaImagen =
                foto.path; // SE ACCEDE A .path COMO APRENDIMOS ANTERIORMENTE

            // FORMATEAMOS LA HORA EXACTA DEL REGISTRO
            DateTime ahora = DateTime.now();
            _fechaHoraExacta =
                "${ahora.day}/${ahora.month}/${ahora.year} a las ${ahora.hour}:${ahora.minute.toString().padLeft(2, '0')}";
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMensaje = e.toString();
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Evidencias'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_cargando)
                const CircularProgressIndicator()
              else if (_errorMensaje != null)
                Text(
                  _errorMensaje!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                )
              else if (_rutaImagen != null &&
                  _latitud != null &&
                  _longitud != null &&
                  _fechaHoraExacta != null)
                // CAMBIO APLICADO (ANGEL IVAN PINTOR FLORES):
                // SE LLAMA AL WIDGET AISLADO EN LUGAR DE TENER TODO EL CÓDIGO VISUAL AQUÍ,
                // CUMPLIENDO AL 100% CON LA SEPARACIÓN DE CARPETAS (WIDGETS Y SCREENS).
                EvidenciaCard(
                  rutaImagen: _rutaImagen!,
                  latitud: _latitud!,
                  longitud: _longitud!,
                  fechaHoraExacta: _fechaHoraExacta!,
                )
              else
                const Text(
                  'Presiona el botón para capturar tu ubicación y tomar una foto de evidencia.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

              const SizedBox(height: 30),

              // EL BOTÓN PRINCIPAL QUE DETONA TODO EL FLUJO
              ElevatedButton.icon(
                onPressed: _cargando ? null : _registrarEvidenciaAsincrona,
                icon: const Icon(Icons.add_a_photo, size: 24),
                label: const Text(
                  'Registrar Evidencia',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
