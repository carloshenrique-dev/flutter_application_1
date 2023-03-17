import 'package:flutter/material.dart';
import 'package:survicate_flutter_sdk/models/survicate_answer_model.dart';
import 'package:survicate_flutter_sdk/models/user_traits_model.dart';
import 'package:survicate_flutter_sdk/survicate_flutter_sdk.dart';

class Survicate extends StatefulWidget {
  const Survicate({super.key});

  @override
  State<Survicate> createState() => _SurvicateState();
}

class _SurvicateState extends State<Survicate> {
  late SurvicateFlutterSdk survicateFlutterSdk;
  String? surveyIdDisplayed;
  String? surveyIdAnswered;
  num? questionIdAnswered;
  SurvicateAnswerModel? answer;
  String? surveyIdClosed;
  String? surveyIdCompleted;

  @override
  void initState() {
    survicateFlutterSdk = SurvicateFlutterSdk();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Survicate Flutter SDK example app'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    survicateFlutterSdk.invokeEvent('SURVEY');
                  },
                  child: const Text('Invoke event SURVEY'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      survicateFlutterSdk.enterScreen('test');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text('Enter screen SCREEN'),
                ),
                ElevatedButton(
                  onPressed: () {
                    survicateFlutterSdk.leaveScreen('test');
                  },
                  child: const Text('Leave screen SCREEN'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    survicateFlutterSdk.setUserTraits(
                        UserTraitsModel(userId: '1', firstName: 'USER'));
                  },
                  child: const Text('Set userId = 1 and first name = USER'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      surveyIdDisplayed = null;
                      surveyIdAnswered = null;
                      questionIdAnswered = null;
                      answer = null;
                      surveyIdClosed = null;
                      surveyIdCompleted = null;
                    });
                    survicateFlutterSdk.reset();
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      surveyIdDisplayed = null;
                      surveyIdAnswered = null;
                      questionIdAnswered = null;
                      answer = null;
                      surveyIdClosed = null;
                      surveyIdCompleted = null;
                    });
                    survicateFlutterSdk.registerSurveyListeners(
                        callbackSurveyDisplayedListener: (surveyId) {
                      setState(() {
                        surveyIdDisplayed = surveyId;
                      });
                    }, callbackQuestionAnsweredListener:
                            (surveyId, questionId, answer) {
                      setState(() {
                        surveyIdAnswered = surveyId;
                        questionIdAnswered = questionId;
                        this.answer = answer;
                      });
                    }, callbackSurveyClosedListener: (surveyId) {
                      setState(() {
                        surveyIdClosed = surveyId;
                      });
                    }, callbackSurveyCompletedListener: (surveyId) {
                      setState(() {
                        surveyIdCompleted = surveyId;
                      });
                    });
                  },
                  child: const Text('Register survey activity listeners'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      surveyIdDisplayed = null;
                      surveyIdAnswered = null;
                      questionIdAnswered = null;
                      answer = null;
                      surveyIdClosed = null;
                      surveyIdCompleted = null;
                    });
                    survicateFlutterSdk.unregisterSurveyListeners();
                  },
                  child: const Text('Unregister survey activity listeners'),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                surveyIdDisplayed != null
                    ? Text('Last survey displayed id = $surveyIdDisplayed')
                    : const SizedBox(),
                surveyIdDisplayed != null
                    ? const SizedBox(
                        height: 5.0,
                      )
                    : const SizedBox(),
                questionIdAnswered != null
                    ? Text(
                        'Last question answered id = $questionIdAnswered from survey id = $surveyIdAnswered, answer type ${answer?.type}')
                    : const SizedBox(),
                questionIdAnswered != null
                    ? const SizedBox(
                        height: 5.0,
                      )
                    : const SizedBox(),
                surveyIdClosed != null
                    ? Text('Last survey closed id = $surveyIdClosed')
                    : const SizedBox(),
                surveyIdClosed != null
                    ? const SizedBox(
                        height: 5.0,
                      )
                    : const SizedBox(),
                surveyIdCompleted != null
                    ? Text('Last survey completed id = $surveyIdCompleted')
                    : const SizedBox(),
                surveyIdCompleted != null
                    ? const SizedBox(
                        height: 5.0,
                      )
                    : const SizedBox(),
              ],
            ),
          )),
    );
  }
}
