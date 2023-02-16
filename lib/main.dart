import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'libro_screen.dart';
import 'libro.dart';

void main() {
  runApp(const Libri());
}

class Libri extends StatelessWidget {
  const Libri({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LibriScreen(),
    );
  }
}

class LibriScreen extends StatefulWidget {
  const LibriScreen({Key? key}) : super(key: key);

  @override
  State<LibriScreen> createState() => _LibriScreenState();
}

class _LibriScreenState extends State<LibriScreen> {
  // Rappresenta l'Icona di Ricerca in Alto a Destra
  Icon iconaRicerca = const Icon(Icons.search);
  // Rappresenta il title iniziale dell'AppBar
  Widget widgetRicerca = const Text('Google Books');
  // Stringa vuota che conterrà i Dati ricevuti
  String risultato = '';
  // Lista libri che conterrà un Elenco di Oggetti di tipo Libro
  List<Libro> libri = [];

  // Elemento che appare all'Inizio (Titolo del Libro)
  @override
  void initState() {
    cercaLibri('Flutter');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widgetRicerca,
        centerTitle: true,
        actions: [
          // Premendo sull'Icona di Ricerca, cambia il contenuto dell AppBar
          // Sostituendo il Titolo del libro Iniziale, con quello Inserito
          // Ottenendo così, un Nuovo body con il Titolo Inserito
          IconButton(
            onPressed: () {
              setState(() {
                if (iconaRicerca.icon == Icons.search) {
                  iconaRicerca = const Icon(Icons.cancel);
                  widgetRicerca = TextField(
                    onSubmitted: (testoRicerca) => cercaLibri(testoRicerca),
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                } else {
                  setState(() {
                    iconaRicerca = const Icon(Icons.search);
                    widgetRicerca = const Text('Google Books');
                  });
                }
              });
            },
            icon: iconaRicerca,
          )
        ],
      ),
      // Qui vengono mostrati a Schermo i Dati ottenuti
      body: ListView.builder(
        itemCount: libri.length,
        itemBuilder: (BuildContext context, int posizione) {
          return Card(
            elevation: 3,
            child: ListTile(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => LibroScreen(libro: libri[posizione]),
                );
                Navigator.push(context, route);
              },
              leading: (libri[posizione].immagineCopertina != '')
                  ? Image.network(libri[posizione].immagineCopertina)
                  : const FlutterLogo(),
              title: Text(libri[posizione].titolo),
              subtitle: Text(libri[posizione].autori),
            ),
          );
        },
      ),
    );
  }

  Future cercaLibri(String ricerca) async {
    // Parte iniziale Url  (Sito Web)
    const dominio = 'www.googleapis.com';
    // Parte centrale Url  (Argomento del Sito)
    const percorso = '/books/v1/volumes';
    // Parte finale Url  (Articolo Specifico Cercato)
    Map<String, dynamic> parametri = {'q': ricerca};
    // Unione dei Componenti per creare Url
    final Uri url = Uri.https(dominio, percorso, parametri);
    // In caso di Scarsa o Assente connessione ad Internt
    // Per evitare che l'App dia Errore, con try/catch, body rimane Vuoto
    try {
      // Chiamata all'url tramite il Metodo get, ottengo del Testo
      http.get(url).then((value) {
        // Prendo il contenuto di value (Testo) e lo Decodifico in JSON
        final valueJson = json.decode(value.body);
        // Seleziono 'items' che sono i Libri in formato JSON da visualizzare
        final libriMap = valueJson['items'];
        // Trasformo le mappe ottenute in un Insieme di libri
        libri = libriMap.map<Libro>((mappa) => Libro.fromMap(mappa)).toList();
        // Testo che rappresenta i Dati ottenuti in formato JSON
        setState(() {
          risultato = value.body;
          libri = libri;
        });
      });
    } catch (errore) {
      risultato = '';
    }
    // Testo che appare nell'attesa di ricevere Dati http
    setState(() {
      risultato = 'Richiesta in corso..';
    });
  }
}
