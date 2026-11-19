class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imageBase64; // ⬅️ FITUR BARU: Menyimpan gambar di history

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.imageBase64,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// Service global untuk menyimpan riwayat chat (STATIC)
class ChatHistoryService {
  // Langsung static, tidak pakai singleton pattern
  static final List<ChatSession> sessions = [];
  static ChatSession? activeSession;

  /// Buat sesi baru
  static ChatSession createSession({String title = "Percakapan Baru"}) {
    final session = ChatSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      messages: [],
    );
    sessions.insert(0, session);
    activeSession = session;
    return session;
  }

  /// Hapus sesi
  static void deleteSession(String id) {
    sessions.removeWhere((s) => s.id == id);
    if (activeSession?.id == id) {
      activeSession = sessions.isNotEmpty ? sessions.first : null;
    }
  }

  /// Hapus semua sesi
  static void clearAll() {
    sessions.clear();
    activeSession = null;
  }

  /// Update judul sesi dari pesan pertama user
  static void updateTitleFromMessage(String message) {
    if (activeSession == null) return;
    if (activeSession!.messages.length <= 1 &&
        activeSession!.title == "Percakapan Baru") {
      final short = message.length > 30
          ? "${message.substring(0, 30)}..."
          : message;
      final idx = sessions.indexWhere((s) => s.id == activeSession!.id);
      if (idx != -1) {
        final updated = ChatSession(
          id: activeSession!.id,
          title: short,
          messages: activeSession!.messages,
          createdAt: activeSession!.createdAt,
        );
        sessions[idx] = updated;
        activeSession = updated;
      }
    }
  }
}