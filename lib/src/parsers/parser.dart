import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/Reference.dart';

var exp = RegExp(r'([1-3]?[^\s]+[A-Za-z ]+[^\d ]?) ?(\d+)?:?(\d+)?-?(\d+)?');

Map<String, String> _parseString(String reference) {
  var match = exp.firstMatch(reference);
  if (match == null) return null;
  var thing = match.groups([0, 1, 2, 3, 4]);
  return {
    'reference': thing[0],
    'book': thing[1].trim(),
    'chapter': thing[2],
    'startVerse': thing[3],
    'endVerse': thing[4],
  };
}

/// Create a reference from a string
Reference parseReference(String stringReference) {
  var pr = _parseString(stringReference);
  if (pr == null) return Reference('');
  var book = Librarian.getBookNames(pr['book'])['name'] ?? pr['book'];
  var reference = Reference(
      book,
      pr['chapter'] == null ? null : int.parse(pr['chapter']),
      pr['startVerse'] == null ? null : int.parse(pr['startVerse']),
      pr['endVerse'] == null ? null : int.parse(pr['endVerse']));

  return reference;
}

Reference createReference(String book,
    [int chapter, int startVerse, int endVerse]) {
  book = Librarian.getBookNames(book)['name'] ?? book;
  return Reference(
      book, chapter = chapter, startVerse = startVerse, endVerse = endVerse);
}