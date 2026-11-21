import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/gemini_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late AnimationController _typingController;

  final List<String> _quickQuestions = [
    '🤒 Apa gejala demam berdarah?',
    '🤧 Bagaimana cara mencegah flu?',
    '🧠 Apa itu vertigo?',
    '💊 Pengobatan tipes apa saja?',
    '🫁 Gejala asma bronkial?',
    '🤔 Apa bedanya flu dan pilek?',
  ];

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    GeminiService.instance.initChat();

    // Pesan sambutan
    _messages.add(ChatMessage(
      text:
          'Halo! 👋 Saya asisten kesehatan virtual dari Sistem Pakar Penyakit Umum.\n\nSaya bisa membantu Anda memahami:\n• Gejala berbagai penyakit umum\n• Cara pengobatan & pencegahan\n• Informasi kesehatan umum\n\n⚠️ *Ingat: Saya bukan pengganti dokter. Gunakan fitur Diagnosa untuk hasil lebih akurat.*\n\nAda yang ingin Anda tanyakan?',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _typingController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final userMsg = text.trim();
    _controller.clear();

    setState(() {
      _messages
          .add(ChatMessage(text: userMsg, isUser: true, time: DateTime.now()));
      _isLoading = true;
    });
    _scrollToBottom();

    final response = await GeminiService.instance.sendMessage(userMsg);

    setState(() {
      _messages.add(
          ChatMessage(text: response, isUser: false, time: DateTime.now()));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _resetChat() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Percakapan'),
        content: const Text('Apakah Anda ingin memulai percakapan baru?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0)),
            onPressed: () {
              Navigator.pop(ctx);
              GeminiService.instance.resetChat();
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  text: 'Percakapan direset. 👋 Ada yang ingin ditanyakan?',
                  isUser: false,
                  time: DateTime.now(),
                ));
              });
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                  child: Text('🤖', style: TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Asisten Kesehatan AI',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text('Powered by Gemini',
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Reset Chat',
            onPressed: _resetChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // API Key warning banner
          if (!GeminiService.instance.isConfigured)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(
                            text: 'https://aistudio.google.com/app/apikey'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link disalin!')),
                        );
                      },
                      child: const Text(
                        'API Key belum diatur. Tap untuk salin link Google AI Studio',
                        style: TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[i]);
              },
            ),
          ),

          // Quick questions
          if (_messages.length <= 1)
            Container(
              height: 42,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _quickQuestions.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => _sendMessage(_quickQuestions[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF1565C0).withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _quickQuestions[i],
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF1565C0)),
                    ),
                  ),
                ),
              ),
            ),

          // Disclaimer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: const Text(
              '⚠️ AI bukan pengganti dokter profesional',
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 3,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Tanyakan sesuatu tentang kesehatan...',
                      hintStyle:
                          const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF0F4FF),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor:
                        _isLoading ? Colors.grey : const Color(0xFF1565C0),
                    elevation: 2,
                    onPressed: _isLoading
                        ? null
                        : () => _sendMessage(_controller.text),
                    child: Icon(
                      _isLoading
                          ? Icons.hourglass_top_rounded
                          : Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                  child: Text('🤖', style: TextStyle(fontSize: 16))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF1565C0) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${msg.time.hour.toString().padLeft(2, '0')}:${msg.time.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isUser ? Colors.white60 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                const Center(child: Text('🤖', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                3,
                (i) => AnimatedBuilder(
                  animation: _typingController,
                  builder: (_, __) {
                    final delay = i * 0.3;
                    final val =
                        (_typingController.value - delay).clamp(0.0, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          Colors.grey.shade300,
                          const Color(0xFF1565C0),
                          val,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
