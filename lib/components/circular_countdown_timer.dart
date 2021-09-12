import 'dart:async';

import 'package:flutter/material.dart';

import 'custom_timer_painter.dart';

/// Create a Circular Countdown Timer.
class CircularCountDownTimer extends StatefulWidget {
  /// Filling Color for Countdown Widget.
  final Color fillColor;

  /// Filling Gradient for Countdown Widget.
  final Gradient? fillGradient;

  /// Ring Color for Countdown Widget.
  final Color ringColor;

  /// Ring Gradient for Countdown Widget.
  final Gradient? ringGradient;

  /// Background Color for Countdown Widget.
  final Color? backgroundColor;

  /// Background Gradient for Countdown Widget.
  final Gradient? backgroundGradient;

  /// This Callback will execute when the Countdown Pauses.
  final VoidCallback? onPause;

  /// This Callback will execute when the Countdown Pauses.
  final VoidCallback? onResume;

  /// This Callback will execute when the Countdown Ends.
  final VoidCallback? onComplete;

  /// This Callback will execute when the Countdown Starts.
  final VoidCallback? onStart;

  /// Countdown duration in Seconds.
  final int duration;

  /// Countdown initial elapsed Duration in Seconds.
  final int initialDuration;

  /// Width of the Countdown Widget.
  final double width;

  /// Height of the Countdown Widget.
  final double height;

  /// Border Thickness of the Countdown Ring.
  final double strokeWidth;

  /// Begin and end contours with a flat edge and no extension.
  final StrokeCap strokeCap;

  /// Text Style for Countdown Text.
  final TextStyle? textStyle;

  /// Format for the Countdown Text.
  final String? textFormat;

  /// Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
  final bool isReverse;

  /// Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
  final bool isReverseAnimation;

  /// Handles visibility of the Countdown Text.
  final bool isTimerTextShown;

  /// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
  final CountDownController? controller;

  /// Handles the timer start.
  final bool autoStart;

  final int delayDuration;

  const CircularCountDownTimer({
    required this.width,
    required this.height,
    required this.duration,
    required this.fillColor,
    required this.ringColor,
    this.backgroundColor,
    this.fillGradient,
    this.ringGradient,
    this.backgroundGradient,
    this.initialDuration = 0,
    this.isReverse = false,
    this.isReverseAnimation = false,
    this.onComplete,
    this.onStart,
    this.strokeWidth = 5.0,
    this.strokeCap = StrokeCap.butt,
    this.textStyle,
    Key? key,
    this.isTimerTextShown = true,
    this.autoStart = true,
    this.textFormat,
    this.controller,
    this.delayDuration = 0,
    this.onPause,
    this.onResume,
  })  : assert(initialDuration <= duration),
        super(key: key);

  @override
  CircularCountDownTimerState createState() => CircularCountDownTimerState();
}

class CircularCountDownTimerState extends State<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _countDownAnimation;

  AnimationController? _delayController;

  String get time {
    if (widget.isReverse && _controller!.isDismissed) {
      if (widget.textFormat == CountdownTextFormat.MM_SS) {
        return "00:00";
      } else if (widget.textFormat == CountdownTextFormat.SS) {
        return "00";
      } else if (widget.textFormat == CountdownTextFormat.S) {
        return "0";
      } else {
        return "00:00:00";
      }
    } else {
      final controller = _delayController?.isCompleted == true
          ? _controller!
          : _delayController!;
      final duration = controller.duration! * controller.value;

      final delayDuration = Duration(seconds: widget.delayDuration) - duration;
      final remainingDuration = Duration(seconds: widget.duration) - duration;
      final timeDuration =
          _delayController?.isCompleted == true ? remainingDuration : delayDuration;

      return _getTime(timeDuration);
    }
  }

  void _setAnimation() {
    if (widget.autoStart) {
      _delayController?.forward();
      widget.controller?._streamController.add(CountDownStatus.started);
    }
  }

  void _setAnimationDirection() {
    if (_controller != null &&
            (!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
      _countDownAnimation =
          Tween<double>(begin: 1, end: 0).animate(_controller!);
    }
  }

  void _setController() {
    widget.controller?._state = this;
    widget.controller?._isReverse = widget.isReverse;
    widget.controller?._initialDuration = widget.initialDuration;
    widget.controller?._duration = widget.duration;

    if (widget.initialDuration > 0 && widget.autoStart) {
      if (widget.isReverse) {
        _controller?.value = 1 - (widget.initialDuration / widget.duration);
      } else {
        _controller?.value = (widget.initialDuration / widget.duration);
      }

      widget.controller?.start();
    }
  }

  String _getTime(Duration duration) {
    // For HH:mm:ss format
    if (widget.textFormat == CountdownTextFormat.HH_MM_SS) {
      return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    // For mm:ss format
    else if (widget.textFormat == CountdownTextFormat.MM_SS) {
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    // For ss format
    else if (widget.textFormat == CountdownTextFormat.SS) {
      return (duration.inSeconds).toString().padLeft(2, '0');
    }
    // For s format
    else if (widget.textFormat == CountdownTextFormat.S) {
      return '${(duration.inSeconds)}';
    } else {
      // Default format
      return _defaultFormat(duration);
    }
  }

  String _defaultFormat(Duration duration) {
    if (duration.inHours != 0) {
      return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else if (duration.inMinutes != 0) {
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inSeconds % 60}';
    }
  }

  void _onStart() {
    widget.onStart?.call();
  }

  void _onComplete() {
    widget.onComplete?.call();
  }

  AnimationController _createCountDownController(Duration duration) =>
      AnimationController(
        vsync: this,
        duration: duration,
      );

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _delayController =
        _createCountDownController(Duration(seconds: widget.delayDuration));

    _controller =
        _createCountDownController(Duration(seconds: widget.duration));

    _controller?.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          _onStart();
          break;

        case AnimationStatus.reverse:
          _onStart();
          break;

        case AnimationStatus.dismissed:
          _onComplete();
          break;
        case AnimationStatus.completed:

          /// [AnimationController]'s value is manually set to [1.0] that's why [AnimationStatus.completed] is invoked here this animation is [isReverse]
          /// Only call the [_onComplete] block when the animation is not reversed.
          if (!widget.isReverse) _onComplete();
          break;
        default:
        // Do nothing
      }
    });

    _setAnimation();
    _setAnimationDirection();
    _setController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _delayController!,
        builder: (BuildContext context, Widget? child) {
          return AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) {
                return Align(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: CustomPaint(
                            painter: CustomTimerPainter(
                              animation: _countDownAnimation ?? _controller,
                              fillColor: widget.fillColor,
                              fillGradient: widget.fillGradient,
                              ringColor: widget.ringColor,
                              ringGradient: widget.ringGradient,
                              strokeWidth: widget.strokeWidth,
                              strokeCap: widget.strokeCap,
                              backgroundColor: widget.backgroundColor,
                              backgroundGradient: widget.backgroundGradient,
                            ),
                          ),
                        ),
                        widget.isTimerTextShown
                            ? Align(
                                alignment: FractionalOffset.center,
                                child: StreamBuilder<CountDownStatus>(
                                    stream: widget.controller?.status,
                                    builder: (context, snapshot) {
                                      final txtTime = snapshot.hasData &&
                                              snapshot.data !=
                                                  CountDownStatus.completed
                                          ? time
                                          : _getTime(Duration(
                                              seconds: widget.duration));

                                      return Text(
                                        txtTime,
                                        style: widget.textStyle ??
                                            const TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                      );
                                    }),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    _delayController?.dispose();
    super.dispose();
  }
}

enum CountDownStatus {
  delayed,
  started,
  paused,
  completed,
}

/// Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
class CountDownController {
  late CircularCountDownTimerState _state;
  late bool _isReverse;
  int? _initialDuration, _duration;
  final _streamController = StreamController<CountDownStatus>.broadcast();

  var currentStatus = CountDownStatus.completed;

  Stream<CountDownStatus> get status => _streamController.stream;

  /// This Method Starts the Countdown Timer
  void start() {
    _streamController.add(CountDownStatus.started);
    currentStatus = CountDownStatus.started;

    if (_state._delayController?.isCompleted == true ||
        _state._delayController?.isDismissed == true) {
      _state._delayController?.reset();
      _state._controller?.reset();
    }
    _state._delayController?.forward(from: 0);

    _state._delayController?.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
        case AnimationStatus.completed:
          _start();
          break;
      }
    });

    _state._controller?.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
        case AnimationStatus.completed:
          _streamController.add(CountDownStatus.completed);
          break;
      }
    });
  }

  void _start() {
    if (_isReverse) {
      _state._controller?.reverse(
          from:
              _initialDuration == 0 ? 1 : 1 - (_initialDuration! / _duration!));
    } else {
      _state._controller?.forward(
          from: _initialDuration == 0 ? 0 : (_initialDuration! / _duration!));
    }
  }

  /// This Method Pauses the Countdown Timer
  void pause() {
    _streamController.add(CountDownStatus.paused);
    currentStatus = CountDownStatus.paused;

    if (_state._delayController?.isCompleted == true) {
      _state._controller?.stop(canceled: false);
    } else {
      _state._delayController?.stop(canceled: false);
    }
  }

  /// This Method Resumes the Countdown Timer
  void resume() {
    _streamController.add(CountDownStatus.started);
    currentStatus = CountDownStatus.started;
    if (_isReverse) {
      _state._controller?.reverse(from: _state._controller!.value);
    } else {
      _state._controller?.forward(from: _state._controller!.value);
    }
  }

  /// This Method Restarts the Countdown Timer,
  /// Here optional int parameter **duration** is the updated duration for countdown timer
  void restart({int? duration}) {
    _streamController.add(CountDownStatus.started);
    currentStatus = CountDownStatus.started;

    _state._controller!.duration = Duration(
      seconds: duration ?? _state._controller!.duration!.inSeconds,
    );
    if (_isReverse) {
      _state._controller?.reverse(from: 1);
    } else {
      _state._controller?.forward(from: 0);
    }
  }

  /// This Method returns the **Current Time** of Countdown Timer i.e
  /// Time Used in terms of **Forward Countdown** and Time Left in terms of **Reverse Countdown**
  String getTime() {
    return _state
        ._getTime(_state._controller!.duration! * _state._controller!.value);
  }

  void dispose() {
    _streamController.close();
  }
}

class CountdownTextFormat {
  static const String HH_MM_SS = "HH:mm:ss";
  static const String MM_SS = "mm:ss";
  static const String SS = "ss";
  static const String S = "s";
}
