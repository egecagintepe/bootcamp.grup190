import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// API Keyini buraya ekle (GÜVENLİ TUT!)
const String geminiApiKey = "AIzaSyA6Gsk92EaLnpWYUP2_Jgo-c9UqQzF-Oo8";

class AIAssistantScreen extends StatefulWidget {
  final String? initialQuestion; // ← Burası eklendi!
  const AIAssistantScreen({this.initialQuestion, super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final List<Message> messages = [];
  final TextEditingController inputController = TextEditingController();
  bool isLoading = false;

  final List<String> suggestedQuestions = [
    "Lisinopril’in yan etkileri nedir?",
    "Metformin’i yemekle alabilir miyim?",
    "Kan sulandırıcılarla ilaç etkileşimi?",
    "Tansiyon ilacını ne zaman almalıyım?"
  ];

  late GenerativeModel geminiModel;

  @override
  void initState() {
    super.initState();
    geminiModel = GenerativeModel(
      model: 'gemini-1.5-pro-latest', // ← DOĞRU MODEL ADI BU!
      apiKey: geminiApiKey,
    );

    messages.add(
      Message(
        id: '1',
        text:
            "Merhaba! Ben senin ilaç asistanınım. İlaçlar, yan etkiler ve ilaç etkileşimleri hakkında sana yardımcı olabilirim. Bana bir şey sorabilirsin!",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    // initialQuestion varsa otomatik olarak kullanıcı mesajı gibi ekle ve AI'ya sor
    if (widget.initialQuestion != null && widget.initialQuestion!.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 200), () {
        handleSendMessage(widget.initialQuestion!);
      });
    }
  }

  Future<void> handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(
        Message(
          id: DateTime.now().toString(),
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      isLoading = true;
    });

    inputController.clear();

    try {
      final content = [Content.text(text)];
      final response = await geminiModel.generateContent(content);

      setState(() {
        messages.add(
          Message(
            id: DateTime.now().toString(),
            text: response.text ?? "AI'dan cevap alınamadı.",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        messages.add(
          Message(
            id: DateTime.now().toString(),
            text: "Bir hata oluştu: $e",
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleSuggestedQuestion(String q) {
    handleSendMessage(q);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Assistant"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Align(
                      alignment: msg.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: msg.isUser ? Colors.blue[600] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.text,
                              style: TextStyle(
                                color: msg.isUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: msg.isUser
                                    ? Colors.blue[100]
                                    : Colors.grey[600],
                                fontSize: 11,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (messages.length == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    children: [
                      Text(
                        "Bunları da sorabilirsin:",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: suggestedQuestions.map((q) {
                          return ActionChip(
                            label: Text(q),
                            onPressed: () => handleSuggestedQuestion(q),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: inputController,
                        decoration: InputDecoration(
                          hintText: "İlaç veya yan etki hakkında bir şey sor...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: handleSendMessage,
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: isLoading
                            ? null
                            : () => handleSendMessage(inputController.text),
                      ),
                    )
                  ],
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}