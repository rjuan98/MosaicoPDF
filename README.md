# 📸 MosaicoPDF - Gerador de Mosaicos em PDF

[![Flutter](https://img.shields.io/badge/Flutter-3.19.5-blue?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen)]()

Aplicativo completo desenvolvido em Flutter que permite capturar fotos, montar mosaicos dinâmicos e exportar como PDF - solução técnica alternativa para o desafio proposto.

```dart
// Exemplo de código principal
void main() {
  runApp(
    MaterialApp(
      home: PhotoMosaicApp(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black87,
      ),
    ),
  );
}
🚀 Funcionalidades Implementadas
Funcionalidade	Status	Descrição
📷 Captura de fotos	✅	Acesso à câmera do dispositivo
🧩 Mosaico dinâmico	✅	Layout adaptável para fotos verticais/horizontais
📄 Geração de PDF	✅	Exportação do mosaico como documento PDF
💾 Armazenamento local	✅	Salvamento do PDF no dispositivo
🚦 Validação de botões	✅	Controles inteligentes baseados no estado
💬 Feedback visual	✅	Mensagens de progresso e resultado
🧩 Componentes Principais
1. Tela Principal (home_screen.dart)
Gerencia o estado das fotos capturadas

Exibe o mosaico dinâmico usando ImageCollageWidget

Contém botões de ação flutuantes

2. Gerador de PDF (pdf_generator.dart)
Future<Uint8List> generatePdfFromWidget(Widget widget) async {
  final screenshotController = ScreenshotController();
  final image = await screenshotController.captureFromWidget(widget);
  
  final pdf = pw.Document();
  pdf.addPage(pw.Page(
    build: (pw.Context context) => pw.Center(
      child: pw.Image(pw.MemoryImage(image)),
  ));
  
  return pdf.save();
}
3. Gerenciador de Mosaico (mosaic_manager.dart)
Analisa orientação das imagens (vertical/horizontal)

Calcula layout ótimo para o mosaico

Utiliza algoritmo de disposição adaptativa

⚙️ Como Executar Localmente
# 1. Clonar repositório
git clone https://github.com/rjuan98/MosaicoPDF.git

# 2. Acessar diretório
cd MosaicoPDF

# 3. Instalar dependências
flutter pub get

# 4. Executar aplicativo
flutter run
📦 Dependências Críticas
Pacote	Versão	Finalidade
camera	^1.2.13	Captura de fotos
image_collage	^0.0.3	Criação de mosaicos
screenshot	^1.3.0	Captura de widgets
pdf	^3.10.4	Geração de PDF
path_provider	^2.1.1	Armazenamento local
⁉️ Por que não no FlutterFlow?
O desenvolvimento no FlutterFlow encontrou limitações intransponíveis com:

Integração de pacotes nativos:

Impossibilidade de usar image_collage_widget

Falhas na integração com screenshot

Manipulação dinâmica complexa:

Dificuldade em implementar layout adaptativo

Limitações no tratamento de orientação de imagens

Geração de PDF avançada:

Restrições na captura de widgets complexos

Problemas com serialização para PDF

✅ Solução Técnica Adotada
// Implementação do mosaico dinâmico
ImageCollage(
  images: capturedImages,
  showGrid: true,
  gridColor: Colors.blueAccent.withOpacity(0.5),
  imageRadius: 12.0,
  imageFit: BoxFit.cover,
),
💼 Considerações Finais
Esta implementação em Flutter puro demonstra plena capacidade técnica para resolver o desafio proposto, superando as limitações encontradas no FlutterFlow. O código está organizado, documentado e pronto para avaliação.

"Dado as limitações técnicas da plataforma, optei por demonstrar minha capacidade através de uma implementação completa em Flutter puro, onde pude atender todos os requisitos do desafio sem restrições."
