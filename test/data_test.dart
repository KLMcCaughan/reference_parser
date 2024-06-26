import 'package:reference_parser_ssai/src/data/Librarian.dart';
import 'package:reference_parser_ssai/src/util/VerseEnum.dart';
import 'package:test/test.dart';

void main() {
  test('Retrieves correct book number', () {
    //test full book name
    var bookNumber = Librarian.findBookNumber('genesis');
    expect(bookNumber, equals(1), reason: 'Genesis is the first book');

    //test osis book name
    bookNumber = Librarian.findBookNumber('1cor');
    expect(bookNumber, equals(46), reason: '1cor is the 46th book');

    //test variant book name
    bookNumber = Librarian.findBookNumber('psalm');
    expect(bookNumber, equals(19), reason: 'Psalm(s) is the 19th book');
  });

  test('Returns null for nonexistent books', () {
    var bookNumber = Librarian.findBookNumber('joseph');
    expect(bookNumber, equals(null),
        reason: 'Joseph is not a book in the bible');
  });

  test('Librarian checks book validity correctly', () {
    expect(Librarian.checkBook('joseph'), equals(false),
        reason: 'Joseph is an invalid book');

    expect(Librarian.checkBook('1cor'), equals(true),
        reason: '1cor is a valid book');

    expect(Librarian.checkBook('Genesis'), equals(true),
        reason: 'Genesis is a vlid book');

    expect(Librarian.checkBook('jn'), equals(true),
        reason: 'jn is a valid book');
  });

  test('Librarian returns correct book names', () {
    var names = Librarian.getBookNames(1);
    expect(names['osis'], equals('Gen'));
    expect(names['abbr'], equals('GEN'));
    expect(names['name'], equals('Genesis'));
    expect(names['short'], equals('Gn'));

    names = Librarian.getBookNames('1 Corinthians');
    expect(names['osis'], equals('1Cor'));
    expect(names['abbr'], equals('1CO'));
    expect(names['name'], equals('1 Corinthians'));
    expect(names['short'], equals('1 Cor'));

    names = Librarian.getBookNames('');
    expect(names.length, equals(0));
  });

  test('Librarian correctly verifies verses', () {
    expect(Librarian.verifyReference(1), equals(true),
        reason: 'First book should exist');

    expect(Librarian.verifyReference(33), equals(true),
        reason: 'Middle book should exist');

    expect(Librarian.verifyReference(66), equals(true),
        reason: 'Last book should exist');

    expect(Librarian.verifyReference(67), equals(false),
        reason: '67th book does not exist');

    expect(Librarian.verifyReference(-1), equals(false),
        reason: 'Negative books do not exist');

    expect(Librarian.verifyReference(33, 1), equals(true),
        reason: 'Book and chapter should exist');

    expect(Librarian.verifyReference(33, 8), equals(false),
        reason: 'Book and chapter should not exist');

    expect(Librarian.verifyReference(33, 1, 1), equals(true),
        reason: 'Book, chapter, and verse should exist');

    expect(Librarian.verifyReference(33, 1, 16), equals(true),
        reason: 'Book, chapter, and ending verse should exist');

    expect(Librarian.verifyReference(33, 1, 17), equals(false),
        reason: 'Verse should not exist');

    expect(Librarian.verifyReference('John', 1, 1), equals(true),
        reason: 'String book references should work');

    expect(Librarian.verifyReference(33, 1, 17, null, 18), equals(false),
        reason: 'Verse should not exist');

    expect(Librarian.verifyReference('John', 1, 1, 1, 2), equals(true),
        reason: 'String book references should work');
  });

  test('Librarian correctly fetches last verse and chapter numbers', () {
    expect(Librarian.getLastVerseNumber('John'), equals(25));
    expect(Librarian.getLastChapterNumber('John'), equals(21));
  });

  test('Librarian correctly fetches last verse and chapter numbers', () {
    expect(Librarian.getLastVerseNumber('Genesis', 3), equals(24));
  });

  test('Librarian correctly creates ReferenceType', () {
    expect(Librarian.identifyReferenceType('John'), equals(ReferenceType.BOOK));

    expect(Librarian.identifyReferenceType('John', 1),
        equals(ReferenceType.CHAPTER));

    expect(Librarian.identifyReferenceType('Joeseph', 2, 4),
        equals(ReferenceType.VERSE));

    expect(Librarian.identifyReferenceType('Joeseph', 2, 4, 5),
        equals(ReferenceType.CHAPTER_RANGE));
  });

  test('Librarian correctly creates last verse objects', () {
    var verse = Librarian.getLastVerse('John')!;
    expect(verse.book, equals('John'));
    expect(verse.chapterNumber, equals(21));
    expect(verse.verseNumber, equals(25));
    expect(verse.referenceType, equals(ReferenceType.VERSE));

    verse = Librarian.getLastVerse('Ps')!;
    expect(verse.book, equals('Psalms'));
    expect(verse.chapterNumber, equals(150));
    expect(verse.verseNumber, equals(6));
    expect(verse.referenceType, equals(ReferenceType.VERSE));

    verse = Librarian.getLastVerse('Gen', 2)!;
    expect(verse.book, equals('Genesis'));
    expect(verse.chapterNumber, equals(2));
    expect(verse.verseNumber, equals(25));
    expect(verse.referenceType, equals(ReferenceType.VERSE));
  });

  test('Librarian correctly creates last chapter objects', () {
    var chapter = Librarian.getLastChapter('Gen')!;
    expect(chapter.book, equals('Genesis'));
    expect(chapter.chapterNumber, equals(50));
    expect(chapter.referenceType, equals(ReferenceType.CHAPTER));
  });

  test('Librarian creates correct reference strings', () {
    expect(Librarian.createReferenceString('John', 2), equals('John 2'));
    expect(Librarian.createReferenceString('John', 2, 3), equals('John 2:3'));
    expect(Librarian.createReferenceString('John', 2, 3, 4),
        equals('John 2:3 - 4:13'));
    expect(Librarian.createReferenceString('John', 2, 3, 4, 5),
        equals('John 2:3 - 4:5'));
    expect(Librarian.createReferenceString('John', 2, null, 4, 5),
        equals('John 2:1 - 4:5'));
    expect(Librarian.createReferenceString('John', 2, null, 4),
        equals('John 2-4'));
  });

  test('Librarian correctly verifies references', () {
    expect(Librarian.verifyReference(1), equals(true),
        reason: 'First book should exist');

    expect(Librarian.verifyReference(66), equals(true),
        reason: 'Last book should exist');

    expect(Librarian.verifyReference(67), equals(false),
        reason: '67th book does not exist');

    expect(Librarian.verifyReference(-1), equals(false),
        reason: 'Negative books do not exist');

    expect(Librarian.verifyReference(33, 1), equals(true),
        reason: 'Book and chapter should exist');

    expect(Librarian.verifyReference(33, -1), equals(false),
        reason: 'Negative chapters do not exist');

    expect(Librarian.verifyReference(33, 8), equals(false),
        reason: 'Book and chapter should not exist');

    expect(Librarian.verifyReference(33, 1, 1), equals(true),
        reason: 'Book, chapter, and verse should exist');

    expect(Librarian.verifyReference(33, 1, 16), equals(true),
        reason: 'Book, chapter, and ending verse should exist');

    expect(Librarian.verifyReference(33, 1, 17), equals(false),
        reason: 'Reference should not exist');

    expect(Librarian.verifyReference('John', 1, 1), equals(true),
        reason: 'String book references should work');

    expect(Librarian.verifyReference('John', 1, null, 1), equals(true),
        reason: 'Multi chapter references should work');

    expect(
        Librarian.verifyReference('John', null, null, null, 5), equals(false),
        reason: 'End verses require a starting verse or ending chapter');

    expect(Librarian.verifyReference('John', 1, null, 2, 5), equals(true),
        reason:
            'Ending verse + chapter can have a starting chapter without a starting verse');
  });
}
