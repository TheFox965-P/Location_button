import 'package:image_picker/image_picker.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  // LÓGICA AGREGADA (ANGEL IVAN PINTOR FLORES):
  // ABRE LA CÁMARA NATIVA DEL DISPOSITIVO Y RETORNA LA FOTOGRAFÍA TOMADA.
  Future<XFile?> tomarFotografia() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }
}
