import 'dart:async';

import 'package:uuid/uuid.dart';

//
class TimerHelper {
  final _uuid = const Uuid();
  late final _timers = <String, Timer>{};

  /// Creates a new timer.
  String setTimer(
    Duration duration,
    void Function() callback, {
    bool immediate = false,
  }) {
    final id = _uuid.v1();
    final timer = Timer(duration, callback);
    if (immediate) callback();
    _timers[id] = timer;
    return id;
  }

  /// Creates a new repeating timer.
  String setPeriodicTimer(
    Duration duration,
    void Function(Timer) callback, {
    bool immediate = false,
  }) {
    final id = _uuid.v1();
    final timer = Timer.periodic(duration, callback);
    if (immediate) callback.call(timer);
    _timers[id] = timer;
    return id;
  }

  /// Cancels timer by id.
  void cancelTimer(String id) {
    final timer = _timers.remove(id);
    return timer?.cancel();
  }

  /// Cancels all timers.
  void cancelAllTimers() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }

  /// Whether has a timer.
  bool get hasTimers => _timers.isNotEmpty;
}
