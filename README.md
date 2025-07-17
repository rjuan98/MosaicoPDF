# 📸 MosaicoPDF - Gerador de Mosaicos em PDF

[![Flutter](https://img.shields.io/badge/Flutter-3.19.5-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)]()

Aplicativo Flutter para capturar fotos, criar mosaicos dinâmicos e exportar como PDF. Desenvolvido como alternativa ao desafio técnico devido a limitações do FlutterFlow.

## Funcionalidades

- ✅ Captura de fotos com câmera
- ✅ Mosaico dinâmico (vertical/horizontal)
- ✅ Geração de PDF
- ✅ Armazenamento local
- ✅ Validação de botões inteligente
- ✅ Feedback visual

## Como Executar

```bash
git clone https://github.com/rjuan98/MosaicoPDF.git
cd MosaicoPDF
flutter pub get
flutter run

Dependências Principais
yaml
dependencies:
  camera: ^1.2.13
  image_collage: ^0.0.3
  screenshot: ^1.3.0
  pdf: ^3.10.4
  path_provider: ^2.1.1

Solução Técnica
dart
// Mosaico dinâmico
ImageCollage(
  images: capturedImages,
  showGrid: true,
  imageFit: BoxFit.cover,
)

// Geração de PDF
final image = await screenshotController.captureFromWidget(mosaic);
pdf.addPage(pw.Page(build: (pw.Context context) {
  return pw.Center(child: pw.Image(pw.MemoryImage(image));
});

Considerações Finais
Implementação completa em Flutter puro que atende todos os requisitos do desafio, superando limitações do FlutterFlow com pacotes nativos e geração de PDF.
