// Modello base di Libro con i suoi componenti
class Libro {
  // late serve per ovviare al null,
  // indicando che verrà assegnato un valore a breve
  late String id;
  late String titolo;
  late String autori;
  late String descrizione;
  late String editore;
  late String immagineCopertina;

  Libro({
    required this.id,
    required this.titolo,
    required this.autori,
    required this.descrizione,
    required this.editore,
    required this.immagineCopertina,
  });

  // Vengono indicati quali sono i Dati di cui abbiamo bisogno
  Libro.fromMap(Map<String, dynamic> mappa) {
    id = mappa['id'];
    titolo = mappa['volumeInfo']['title'];
    autori = mappa['volumeInfo']['authors'] == null
        ? ''
        : mappa['volumeInfo']['authors'].toString();
    descrizione = mappa['volumeInfo']['description'] == null
        ? ''
        : mappa['volumeInfo']['description'].toString();
    editore = mappa['volumeInfo']['publisher'] == null
        ? ''
        : mappa['volumeInfo']['publisher'].toString();
    // Non tutti i Libri su Google Books hanno un'Immagine di Copertina
    // Per evitare che l'App dia Errore, con try/catch, immagineCopertina rimane Vuota
    try {
      immagineCopertina = mappa['volumeInfo']['imageLinks'] == null
          ? ''
          : mappa['volumeInfo']['imageLinks']['smallThumbnail'].toString();
    } catch (errore) {
      immagineCopertina = '';
    }
  }
}
