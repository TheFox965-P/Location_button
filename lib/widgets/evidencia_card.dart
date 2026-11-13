import 'dart:io';

import 'package:flutter/material.dart';

// CREACIÓN DE WIDGET PERSONALIZADO (ANGEL IVAN PINTOR FLORES):
// SEPARAMOS LA TARJETA DE EVIDENCIA EN SU PROPIO ARCHIVO DENTRO DE LA CARPETA 'widgets/'
// PARA CUMPLIR CON LA ARQUITECTURA LIMPIA Y REUTILIZAR CÓDIGO VISUAL.
class EvidenciaCard extends StatelessWidget {
  final String rutaImagen;
  final double latitud;
  final double longitud;
  final String fechaHoraExacta;

  const EvidenciaCard({
    super.key,
    required this.rutaImagen,
    required this.latitud,
    required this.longitud,
    required this.fechaHoraExacta,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(rutaImagen),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Datos de la Evidencia:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Text(' Latitud: $latitud', style: const TextStyle(fontSize: 16)),
            Text(
              ' Longitud: $longitud',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              ' Capturado el: $fechaHoraExacta',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
