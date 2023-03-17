import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../models/books.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  BooksModel books = BooksModel();
  bool _isListening = false;
  bool _isLoading = false;
  String _text = '';

  String encrypt(String text, int shift) {
    String result = "";
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      if (charCode >= 65 && charCode <= 90) {
        // uppercase letters
        charCode = (charCode - 65 + shift) % 26 + 65;
      } else if (charCode >= 97 && charCode <= 122) {
        // lowercase letters
        charCode = (charCode - 97 + shift) % 26 + 97;
      }
      result += String.fromCharCode(charCode);
    }
    return result;
  }

  String decrypt(String text, int shift) {
    return encrypt(text,
        26 - shift); // decryption is just encryption with the opposite shift
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        setState(() {
          _isListening = status == 'listening';
        });
      },
      onError: (error) {
        log(error.errorMsg);
        throw Exception();
      },
    );

    if (available) {
      setState(() {
        _isListening = true;
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
            _controller.text = _text;
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _sendQuery() async {
    //replacing spaces for +
    String query = _controller.text.replaceAll(' ', '+');

    //remember to run: flutter run --dart-define apiKey=AIzaSyBZSwDSGUiFL1-ligjDrshE373nqYRKu0M to retrieve the api key
    const apiKey = String.fromEnvironment('apiKey');
    if (apiKey.isEmpty) {
      throw AssertionError('apiKey is not set');
    }

    //preparing url to call books api
    Uri url = Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey');

    setState(() {
      _isLoading = true;
    });

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data != null) {
        setState(() {
          books = BooksModel.fromJson(data);
          _isLoading = false;
        });
      }
    } else {
      log('Request failed with status: ${response.statusCode}.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _speech.stop();
  }

  @override
  void dispose() {
    super.dispose();
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Books search (Google Books API)"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 150,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Say something...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: _isListening ? _stopListening : _startListening,
                    backgroundColor: _isListening ? Colors.red : Colors.blue,
                    child: Icon(_isListening ? Icons.stop : Icons.mic),
                  ),
                  FloatingActionButton(
                    onPressed: _sendQuery,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_isLoading) const CircularProgressIndicator(),
              if (books.items != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: books.items!.map((item) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.volumeInfo!.previewLink!,
                            softWrap: true,
                          ),
                        ),
                        onTap: () => launchUrl(
                          Uri.parse(item.volumeInfo!.previewLink!),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              FloatingActionButton(onPressed: () {
                /*String originalText = "Hello, World!";
                int shift = 3;
                String encryptedText = encrypt(originalText, shift);
                String decryptedText = decrypt(encryptedText, shift);*/
              })
            ],
          ),
        ),
      ),
    );
  }
}
