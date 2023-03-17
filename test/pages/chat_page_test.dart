import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/chat_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

class MockSpeechToText extends Mock implements stt.SpeechToText {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockSpeechToText mockSpeechToText;
  late MockHttpClient mockHttpClient;
  late ChatPage chatPage;
  group('ChatPage', () {
    setUp(() {
      mockSpeechToText = MockSpeechToText();
      mockHttpClient = MockHttpClient();
      chatPage = const ChatPage();
    });

    testWidgets('Widget should build', (tester) async {
      await tester.pumpWidget(chatPage);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    test('Should start listening', () async {
      when(() => mockSpeechToText.initialize(
            onStatus: any(named: 'onStatus'),
            onError: any(named: 'onError'),
          )).thenAnswer((_) async => true);

      //await chatPage._startListening();

      //expect(chatPage._isListening, isTrue);
      verify(() => mockSpeechToText.listen(onResult: any(named: 'onResult')));
    });

    test('Should stop listening', () async {
      // await chatPage._stopListening();

      //expect(chatPage._isListening, isFalse);
      //verify(chatPage._speech.stop());
    });

    test('Should send query', () async {
      final mockResponse = http.Response('{"items": []}', 200);

      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => mockResponse);

      //await chatPage._sendQuery();

      //expect(chatPage._isLoading, isFalse);
      //expect(chatPage.books.items, isNotNull);
      verify(() => mockHttpClient.get(any(), headers: any(named: 'headers')));
    });

    test('Should launch URL', () async {
      await launchUrl(Uri.parse('https://www.example.com'));
      verify(
          () async => await canLaunchUrl(Uri.parse('https://www.example.com')));
    });
  });
}
