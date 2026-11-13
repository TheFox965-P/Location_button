import 'package:geolocator/geolocator.dart';

class LocationService {
  // LÓGICA AGREGADA (ANGEL IVAN PINTOR FLORES):
  // SE VALIDA QUE EL GPS ESTÉ ENCENDIDO Y SE PIDEN LOS PERMISOS NECESARIOS.
  Future<Position?> obtenerUbicacion() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();

    if (!servicioHabilitado) {
      throw Exception(
        'El servicio de GPS está desactivado. Enciéndelo, por favor.',
      );
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw Exception(
        'Los permisos están denegados permanentemente en la configuración del teléfono.',
      );
    }

    // SI TODO ESTÁ CORRECTO, DEVUELVE LAS COORDENADAS EXACTAS
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
