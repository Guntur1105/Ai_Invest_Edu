/// Utility untuk membersihkan format markdown dari jawaban AI
class MarkdownCleaner {
  /// Membersihkan markdown agar jadi teks biasa yang rapi
  static String clean(String input) {
    String text = input;

    // 1. Hapus tabel markdown (| ... | ... |)
    text = text.replaceAll(RegExp(r'\|.*?\|'), '');
    text = text.replaceAll(RegExp(r'^\s*[-:]+\s*$', multiLine: true), '');

    // 2. Ganti <br>, <br/>, <br /> jadi newline
    text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // 3. Hapus bold (**teks** atau __teks__)
    text = text.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
    text = text.replaceAll(RegExp(r'__(.*?)__'), r'$1');

    // 4. Hapus italic (*teks* atau _teks_) — hati-hati agar tidak bentrok dengan bullet
    text = text.replaceAll(RegExp(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)'), r'$1');
    text = text.replaceAll(RegExp(r'(?<!_)_(?!_)(.+?)(?<!_)_(?!_)'), r'$1');

    // 5. Hapus heading (#, ##, ###)
    text = text.replaceAll(RegExp(r'^#{1,6}\s+', multiLine: true), '');

    // 6. Hapus code block ```...```
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), '');

    // 7. Hapus inline code `teks`
    text = text.replaceAll(RegExp(r'`([^`]*)`'), r'$1');

    // 8. Ganti bullet markdown (-, *, +) jadi titik bulat
    text = text.replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '• ');

    // 9. Hapus link markdown [teks](url) → teks
    text = text.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1');

    // 10. Hapus garis horizontal (---, ***, ___)
    text = text.replaceAll(RegExp(r'^\s*[-*_]{3,}\s*$', multiLine: true), '');

    // 11. Rapikan baris kosong berlebih
    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // 12. Trim spasi di setiap baris
    text = text
        .split('\n')
        .map((line) => line.trim())
        .join('\n');

    return text.trim();
  }
}