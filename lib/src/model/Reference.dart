import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/Verse.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

import 'package:reference_parser/src/util/VerseEnum.dart';

/// A general BibleReference, can contain all [ReferenceType]
class Reference extends BibleReference {
  @override
  final String reference;

  /// The chapter number in this reference.
  ///
  /// Defaults to 1.
  final int chapter;

  /// The first verse number found in this reference.
  ///
  /// Defaults to 1.
  final int startVerseNumber;

  /// The [Verse] object representing the first verse in the reference.
  ///
  /// Returns the verse object of the first verse in the chapter if
  /// [startVerse] is not specified.
  /// Returns the verse object of the first verse in the book if
  /// [chapter] is not specified.
  /// Returns [null] if neither are specified.
  final Verse startVerse;

  /// The last verse number found in this reference.
  final int endVerseNumber;

  /// The [Verse] object representing the last verse in the reference.
  ///
  /// Returns the verse object of the last verse in the chapter if
  /// [endVerse] is not specified.
  /// Returns the verse object of the last verse in the book if
  /// [chapter] is not specified.
  /// Returns [null] if neither are specified.
  final Verse endVerse;

  /// The type of reference. Either VERSE, RANGE, CHAPTER, or BOOK
  @override
  final ReferenceType referenceType;

  /// Whether the reference is within the bible.
  @override
  final bool isValid;

  Reference(book, [chp, svn, evn])
      : chapter = chp ?? 1,
        startVerseNumber = svn ?? 1,
        startVerse = svn != null
            ? Verse(book, chp, svn)
            : chp != null
                ? Verse(book, chp, 1)
                : Verse(book, 1, 1),
        endVerseNumber = evn ?? svn ?? Librarian.getLastVerseNumber(book, chp),
        endVerse = evn != null
            ? Verse(book, chp, evn)
            : svn != null
                ? Verse(book, chp, svn)
                : Librarian.getLastVerse(book, chp),
        reference = Librarian.createReferenceString(book, chp, svn, evn),
        referenceType = Librarian.identifyReferenceType(book, chp, svn, evn),
        isValid = Librarian.verifyVerse(book, chp, svn) &&
            Librarian.verifyVerse(book, chp, evn),
        super(book);
}
