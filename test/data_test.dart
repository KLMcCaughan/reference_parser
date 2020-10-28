import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:test/test.dart';

void main() {
  test('Retrieves correct book number', () {
    //test full book name
    var bookNumber = Librarian.findBook('genesis');
    expect(bookNumber, 1);
    //test osis book name
    bookNumber = Librarian.findBook('1cor');
    expect(bookNumber, 46);
    //test variant book name
    bookNumber = Librarian.findBook('psalm');
    expect(bookNumber, 19);
  });
  test('Returns null for nonexistent books', () {
    var bookNumber = Librarian.findBook('joe');
    expect(bookNumber, null);
  });
  test('Librarian checks book validity correctly', () {
    expect(Librarian.checkBook('joe'), false);
    expect(Librarian.checkBook('1cor'), true);
    expect(Librarian.checkBook('Genesis'), true);
    expect(Librarian.checkBook('jn'), true);
  });
  test('Librarian returns correct book names', () {
    var names = Librarian.getBookNames(1);
    expect(names['osis'], 'Gen');
    expect(names['abbr'], 'GEN');
    expect(names['name'], 'Genesis');
    expect(names['short'], 'Gn');

    names = Librarian.getBookNames('1 Corinthians');
    expect(names['osis'], '1Cor');
    expect(names['abbr'], '1CO');
    expect(names['name'], '1 Corinthians');
    expect(names['short'], '1 Cor');

    names = Librarian.getBookNames('');
    expect(names.length, equals(0));
  });
  test('Librarian correctly verifies verses', () {
    expect(Librarian.verifyVerse(1), true, reason: 'First book should exist');
    expect(Librarian.verifyVerse(33), true, reason: 'Middle book should exist');
    expect(Librarian.verifyVerse(66), true, reason: 'Last book should exist');
    expect(Librarian.verifyVerse(67), false,
        reason: '67th book does not exist');
    expect(Librarian.verifyVerse(-1), false,
        reason: 'Negative books do not exist');

    expect(Librarian.verifyVerse(33, 1), true,
        reason: 'Book and chapter should exist');

    expect(Librarian.verifyVerse(33, 8), false,
        reason: 'Book and chapter should not exist');

    expect(Librarian.verifyVerse(33, 1, 1), true,
        reason: 'Book, chapter, and verse should exist');

    expect(Librarian.verifyVerse(33, 1, 16), true,
        reason: 'Book, chapter, and ending verse should exist');

    expect(Librarian.verifyVerse(33, 1, 17), false,
        reason: 'Verse should not exist');

    expect(Librarian.verifyVerse('John', 1, 1), true,
        reason: 'String book references should work');
  });
  test('Librarian correctly fetches last verses numbers', () {
    expect(Librarian.getLastVerseNumber('John'), equals(25));
  });
  test('Librarian correctly creates ReferenceType', () {
    expect(Librarian.identifyReferenceType('John'), equals(ReferenceType.BOOK));
    expect(Librarian.identifyReferenceType('John', 1),
        equals(ReferenceType.CHAPTER));
    expect(Librarian.identifyReferenceType('Joe', 2, 4),
        equals(ReferenceType.VERSE));
    expect(Librarian.identifyReferenceType('Joe', 2, 4, 5),
        equals(ReferenceType.RANGE));
  });
  test('Librarian correctly creates last verse objects', () {
    var verse = Librarian.getLastVerse('John');
    expect(verse.book, equals('John'));
    expect(verse.chapter, equals(21));
    expect(verse.verseNumber, equals(25));
    expect(verse.referenceType, equals(ReferenceType.VERSE));

    verse = Librarian.getLastVerse('Ps');
    expect(verse.book, equals('Psalms'));
    expect(verse.chapter, equals(150));
    expect(verse.verseNumber, equals(6));
    expect(verse.referenceType, equals(ReferenceType.VERSE));

    verse = Librarian.getLastVerse('Gen', 2);
    expect(verse.book, equals('Genesis'));
    expect(verse.chapter, equals(2));
    expect(verse.verseNumber, equals(25));
    expect(verse.referenceType, equals(ReferenceType.VERSE));
  });
}
