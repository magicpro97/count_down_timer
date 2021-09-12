import 'package:count_down_timer/screens/setting_page.dart';
import 'package:flutter/material.dart';

import '../components/circular_countdown_timer.dart';
import '../constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final countDownController = CountDownController();
  int duration = k30;

  @override
  void dispose() {
    countDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () async {
                  countDownController.pause();
                  final result = await Navigator.pushNamed(context, '/setting');

                  if (result != null) {
                    setState(() {
                      duration = result as int;
                    });
                  }
                },
                icon: const Icon(Icons.settings),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    width: 270,
                    height: 270,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          right: 0,
                          top: 0,
                          child: TimeLabel(
                            value: duration,
                            color: kTimerColor,
                          ),
                        ),
                        CircularCountDownTimer(
                          width: 200,
                          height: 200,
                          duration: duration,
                          fillColor: kTimerColor,
                          ringColor: Colors.white,
                          controller: countDownController,
                          backgroundColor: kRingColor,
                          textStyle: textStyle.copyWith(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                          delayDuration: 3,
                          autoStart: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  StreamBuilder<CountDownStatus>(
                      stream: countDownController.status,
                      builder: (_, snapshot) {
                        VoidCallback? action;
                        String textButton = txtStart;

                        switch (snapshot.data) {
                          case CountDownStatus.delayed:
                            action = null;
                            break;
                          case CountDownStatus.started:
                            action = countDownController.pause;
                            textButton = txtStop;
                            break;
                          case CountDownStatus.paused:
                            action = countDownController.start;
                            textButton = txtStart;
                            break;
                          case CountDownStatus.completed:
                            textButton = txtStart;
                            action = countDownController.start;
                            break;
                          default:
                            textButton = txtStart;
                            action = countDownController.start;
                        }

                        return ElevatedButton(
                          onPressed: action,
                          style: ElevatedButton.styleFrom(
                            primary: kButtonColor,
                            onPrimary: kButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(
                              width: 1.0,
                              color: kBorderColor,
                            ),
                            fixedSize: const Size(200, 48),
                          ),
                          child: Text(
                            textButton,
                            style: textStyle,
                          ),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
