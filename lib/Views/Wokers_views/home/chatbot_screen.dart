import 'package:flutter/material.dart';
import 'package:home_services/Utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userMessage = _controller.text;
    setState(() {
      _messages.add({'sender': 'user', 'message': userMessage});
      _isTyping = true; // Start typing indicator
    });
    _controller.clear();

    // Call the ChatGPT API
    String responseMessage = await _fetchChatGPTResponse(userMessage);
    setState(() {
      _messages.add({'sender': 'chatbot', 'message': responseMessage});
      _isTyping = false; // Stop typing indicator
    });
  }

  Future<String> _fetchChatGPTResponse(String message) async {
    final response = await http.post(
      Uri.parse(
          'https://api.openai.com/v1/chat/completions'), // Replace with your ChatGPT API endpoint
      headers: {
        'Authorization':
            'Bearer sk-None-G3hb1bpPWfSpWhATBpL4T3BlbkFJgjV5srW4wKXTaI5k7In0', // Add your API key here
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo', // Specify your model
        'messages': [
          {'role': 'user', 'content': message},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chatbot',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appColor,
      ),
      body: Container(
        color: Colors.white, // Main screen white background
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(
                    sender: _messages[index]['sender']!,
                    message: _messages[index]['message']!,
                  );
                },
              ),
            ),
            if (_isTyping) _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
      {required String sender, required String message}) {
    bool isUserMessage = sender == 'user';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isUserMessage ? AppColors.appColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isUserMessage ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _sendMessage();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: AppColors.appColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 8),
          Text(
            'Chatbot is typing...',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
