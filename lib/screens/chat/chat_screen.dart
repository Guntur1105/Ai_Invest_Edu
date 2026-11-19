import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // ⬅️ Import image picker
import '../../services/gemini_service.dart';
import '../../services/markdown_cleaner.dart';
import '../../services/chat_history_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  
  // State untuk menyimpan gambar yang akan dikirim
  String? _selectedImageBase64;
  Uint8List? _selectedImageBytes; 

  @override
  void initState() {
    super.initState();
    if (ChatHistoryService.activeSession == null) {
      ChatHistoryService.createSession();
    }
  }

  List<ChatMessage> get _messages =>
      ChatHistoryService.activeSession?.messages ?? [];

  // ================= FUNGSI PILIH GAMBAR =================
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Kompres agar tidak terlalu besar
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageBase64 = base64Encode(bytes);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageBase64 = null;
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    // Bisa kirim jika ada teks ATAU ada gambar
    if ((text.isEmpty && _selectedImageBase64 == null) || _isLoading) return;

    if (ChatHistoryService.activeSession == null) {
      ChatHistoryService.createSession();
    }

    // Simpan data sebelum di-clear
    final imageToSend = _selectedImageBase64;
    final textToSend = text.isEmpty && imageToSend != null 
        ? "Tolong analisis gambar ini." 
        : text;

    setState(() {
      ChatHistoryService.activeSession!.messages.add(
        ChatMessage(
          text: textToSend, 
          isUser: true,
          imageBase64: imageToSend, // Simpan gambar di history
        ),
      );
      _isLoading = true;
      _selectedImageBytes = null; // Reset preview
      _selectedImageBase64 = null;
    });

    _controller.clear();
    _scrollToBottom();
    ChatHistoryService.updateTitleFromMessage(textToSend);

    try {
      final reply = await GeminiService.sendMessage(
        textToSend, 
        base64Image: imageToSend, // Kirim gambar ke API
      );
      final cleaned = MarkdownCleaner.clean(reply);

      setState(() {
        ChatHistoryService.activeSession!.messages.add(
          ChatMessage(text: cleaned, isUser: false),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        ChatHistoryService.activeSession!.messages.add(
          ChatMessage(
            text: "Maaf, terjadi kesalahan saat memproses gambar/teks.",
            isUser: false,
          ),
        );
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startNewChat() {
    setState(() {
      ChatHistoryService.createSession();
    });
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  void _loadSession(ChatSession session) {
    setState(() {
      ChatHistoryService.activeSession = session;
    });
    Navigator.pop(context);
    _scrollToBottom();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF7F8FA),
      drawer: _buildHistoryDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff1F2937),
        elevation: 0.5,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
          tooltip: "Kembali ke Dashboard",
        ),
        title: const Row(
          children: [
            SizedBox(width: 4),
            Icon(Icons.smart_toy_rounded, color: Color(0xff16A34A), size: 24),
            SizedBox(width: 8),
            Text(
              "AI InvestEdu",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xff1F2937),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Riwayat Chat",
            icon: const Icon(Icons.history_rounded),
            onPressed: _openDrawer,
          ),
          IconButton(
            tooltip: "Chat Baru",
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: _startNewChat,
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
            ),
            if (_isLoading) _buildTypingIndicator(),
            
            // ⬇️ PREVIEW GAMBAR SEBELUM DIKIRIM ⬇️
            if (_selectedImageBytes != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.white,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _selectedImageBytes!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Text("Gambar siap dikirim", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  // ================= MODERN INPUT BAR (Dengan Tombol Gambar) =================
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ⬇️ TOMBOL UPLOAD GAMBAR ⬇️
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: const Color(0xffF3F4F6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.add_photo_alternate_outlined, color: Color(0xff4B5563)),
              onPressed: _isLoading ? null : _pickImage,
              tooltip: "Unggah Gambar",
            ),
          ),
          const SizedBox(width: 8),
          
          // Kolom Ketik
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                maxLines: 5,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: "Tanyakan investasi atau kirim gambar...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Tombol Kirim
          Container(
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: const Color(0xff16A34A),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff16A34A).withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff16A34A), Color(0xff22C55E)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff16A34A).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 55,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Ada yang bisa dibantu?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kirim teks atau unggah gambar (seperti grafik saham / screenshot aplikasi investasi) untuk dianalisis AI.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff16A34A), Color(0xff22C55E)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff16A34A).withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),

          Flexible(
            child: isUser
                ? _buildUserText(msg)
                : _AnimatedAIMessage(text: msg.text),
          ),

          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xffE5E7EB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xff4B5563),
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  // Bubble User (bisa menampilkan gambar)
  Widget _buildUserText(ChatMessage msg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff16A34A),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Jika ada gambar, tampilkan
          if (msg.imageBase64 != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(
                base64Decode(msg.imageBase64!),
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          if (msg.imageBase64 != null && msg.text.isNotEmpty)
            const SizedBox(height: 8),
          // Teks
          SelectableText(
            msg.text,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff16A34A), Color(0xff22C55E)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xff16A34A),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "AI sedang menganalisis...",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryDrawer() {
    return Drawer(
      backgroundColor: const Color(0xffF7F8FA),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff16A34A), Color(0xff22C55E)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Riwayat Chat",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1F2937),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  _startNewChat();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff16A34A), Color(0xff22C55E)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff16A34A).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 12),
                      Text(
                        "Chat Baru",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ChatHistoryService.sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Belum ada riwayat chat",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: ChatHistoryService.sessions.length,
                      itemBuilder: (context, index) {
                        final session = ChatHistoryService.sessions[index];
                        final isActive =
                            ChatHistoryService.activeSession?.id == session.id;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Material(
                            color: isActive
                                ? const Color(0xffDCFCE7)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => _loadSession(session),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 18,
                                      color: isActive
                                          ? const Color(0xff16A34A)
                                          : Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            session.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: isActive
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                              color: isActive
                                                  ? const Color(0xff166534)
                                                  : const Color(0xff374151),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${session.messages.length} pesan",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                      ),
                                      color: Colors.grey.shade500,
                                      onPressed: () {
                                        setState(() {
                                          ChatHistoryService.deleteSession(session.id);
                                          if (ChatHistoryService.activeSession == null) {
                                            ChatHistoryService.createSession();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (ChatHistoryService.sessions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Hapus Semua Riwayat?"),
                        content: const Text(
                          "Semua percakapan akan dihapus permanen.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                ChatHistoryService.clearAll();
                                ChatHistoryService.createSession();
                              });
                              Navigator.pop(ctx);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Hapus",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                  label: const Text(
                    "Hapus Semua",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// WIDGET ANIMASI JAWABAN AI
// =====================================================================
class _AnimatedAIMessage extends StatefulWidget {
  final String text;

  const _AnimatedAIMessage({required this.text});

  @override
  State<_AnimatedAIMessage> createState() => _AnimatedAIMessageState();
}

class _AnimatedAIMessageState extends State<_AnimatedAIMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: SelectableText(
            widget.text,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.6,
              color: Color(0xff1F2937),
            ),
          ),
        ),
      ),
    );
  }
}