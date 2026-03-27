import 'package:flutter/material.dart';

import '../../../service/api/gemini_chat_service.dart' show GeminiChatService;

class GymChatScreen extends StatefulWidget {
  const GymChatScreen({super.key});

  @override
  State<GymChatScreen> createState() => _GymChatScreenState();
}

class _GymChatScreenState extends State<GymChatScreen> {
  final service = GeminiChatService();
  final controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool loading = false;

  Future<void> send() async {
    final text = controller.text.trim();
    if (text.isEmpty || loading) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      loading = true;
      controller.clear();
    });

    final reply = await service.send(text);

    setState(() {
      messages.add({"role": "bot", "text": reply});
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0F12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0F12),
        title: const Text("Gym & Nutrition Bot"),
        actions: [
          IconButton(
            onPressed: () {
              service.clear();
              setState(() => messages.clear());
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isUser = m["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF16351A) : const Color(0xFF12161B),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isUser ? const Color(0xFF66FF4D) : const Color(0xFF1E242C),
                      ),
                    ),
                    child: Text(
                      m["text"] ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text("...جاري الرد", style: TextStyle(color: Colors.white70)),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "اكتب سؤالك عن التمرين أو التغذية...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF12161B),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF1E242C)),
                        ),
                      ),
                      onSubmitted: (_) => send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: send,
                    icon: const Icon(Icons.send, color: Color(0xFF66FF4D)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}