import 'package:flutter/material.dart';
import 'libro.dart';

class LibroScreen extends StatelessWidget {
  final Libro libro;
  const LibroScreen({required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titolo),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.network(libro.immagineCopertina),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Scritto da ${libro.autori}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Editore: ${libro.editore}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(libro.descrizione),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
