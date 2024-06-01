import 'package:characters/characters.dart';

String transliterateFrenchToAscii(String fr) {
  var ascii = fr.characters
    .replaceAll('À'.characters, 'A'.characters).replaceAll('à'.characters, 'a'.characters)
    .replaceAll('Â'.characters, 'A'.characters).replaceAll('â'.characters, 'a'.characters)
    .replaceAll('Ä'.characters, 'A'.characters).replaceAll('ä'.characters, 'a'.characters)
    .replaceAll('Æ'.characters, 'AE'.characters).replaceAll('æ'.characters, 'ae'.characters)
    .replaceAll('Ç'.characters, 'C'.characters).replaceAll('ç'.characters, 'c'.characters)
    .replaceAll('È'.characters, 'E'.characters).replaceAll('è'.characters, 'e'.characters)
    .replaceAll('É'.characters, 'E'.characters).replaceAll('é'.characters, 'e'.characters)
    .replaceAll('Ê'.characters, 'E'.characters).replaceAll('ê'.characters, 'e'.characters)
    .replaceAll('Ë'.characters, 'E'.characters).replaceAll('ë'.characters, 'e'.characters)
    .replaceAll('Î'.characters, 'I'.characters).replaceAll('î'.characters, 'i'.characters)
    .replaceAll('Ï'.characters, 'I'.characters).replaceAll('ï'.characters, 'i'.characters)
    .replaceAll('Ô'.characters, 'O'.characters).replaceAll('ô'.characters, 'o'.characters)
    .replaceAll('Ö'.characters, 'O'.characters).replaceAll('ö'.characters, 'o'.characters)
    .replaceAll('Œ'.characters, 'OE'.characters).replaceAll('œ'.characters, 'oe'.characters)
    .replaceAll('Ù'.characters, 'U'.characters).replaceAll('ù'.characters, 'u'.characters)
    .replaceAll('Û'.characters, 'U'.characters).replaceAll('û'.characters, 'u'.characters)
    .replaceAll('Ü'.characters, 'U'.characters).replaceAll('ü'.characters, 'u'.characters)
    .replaceAll('Ÿ'.characters, 'Y'.characters).replaceAll('ÿ'.characters, 'y'.characters);
  return ascii.toString();
}

String sentenceToCamelCase(String src) {
  var s = src.replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ').toLowerCase();
  var split = s.split(' ');
  if(split.isEmpty) return '';
  var ret = split.removeAt(0);
  for(var w in split) {
    if(w.isNotEmpty) ret += '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
  }
  return ret;
}