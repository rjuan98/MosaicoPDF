// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String?> saveImageAsPdf(
  BuildContext context,
  bool isTestMode,
) async {
  try {
    // Encontra o widget do mosaico
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      print('Erro: Widget não encontrado');
      return null;
    }

    // Captura a imagem com qualidade alta
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      print('Erro: Falha ao capturar imagem');
      return null;
    }

    final bytes = byteData.buffer.asUint8List();

    // Cria PDF com qualidade alta
    final pdf = pw.Document();
    final pdfImage = pw.MemoryImage(bytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Image(
              pdfImage,
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ),
    );

    // Salva em uma pasta acessível
    final output = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${output.path}/mosaico_$timestamp.pdf');
    
    await file.writeAsBytes(await pdf.save());
    print('PDF salvo com sucesso em: ${file.path}');
    
    return file.path;
  } catch (e) {
    print('Erro ao gerar PDF: $e');
    return null;
  }
} 