import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:xml/xml.dart';

class LocalExtractDataSource {
  static String extract(String mimeType, Uint8List bytes) {
    try {
      switch (mimeType) {
        case 'application/msword':
          return _parseDocx(bytes);
        case 'application/vnd.ms-powerpoint':
          return _parsePptx(bytes);
        default:
          throw Exception("Unsupported mimeType for extraction: $mimeType");
      }
    } catch (e) {
      throw Exception('Failed to extract document: $e');
    }
  }

  static String _parseDocx(Uint8List bytes) {
    return docxToText(bytes);
  }

  static String _parsePptx(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final buffer = StringBuffer();

    final slideFiles = archive
        .where((f) =>
            f.isFile &&
            f.name.startsWith('ppt/slides/slide') &&
            f.name.endsWith('.xml') &&
            !f.name.contains('slideLayout') &&
            !f.name.contains('slideMaster'))
        .toList()
      ..sort((a, b) {
        final numA = int.tryParse(
                RegExp(r'slide(\d+)\.xml').firstMatch(a.name)?.group(1) ?? '0') ??
            0;
        final numB = int.tryParse(
                RegExp(r'slide(\d+)\.xml').firstMatch(b.name)?.group(1) ?? '0') ??
            0;
        return numA.compareTo(numB);
      });

    for (final file in slideFiles) {
      try {
        final rawBytes = file.content is Uint8List
            ? file.content as Uint8List
            : Uint8List.fromList(file.content as List<int>);

        final xmlString = utf8.decode(rawBytes);
        final document = XmlDocument.parse(xmlString);
        final textNodes = document.findAllElements('a:t');

        for (final node in textNodes) {
          buffer.write('${node.innerText} ');
        }

        buffer.write('\n\n--- Next Slide ---\n\n');
      } catch (e) {
        buffer.writeln('[Slide parse error for ${file.name}: $e]');
      }
    }

    return buffer.toString().trim();
  }
}