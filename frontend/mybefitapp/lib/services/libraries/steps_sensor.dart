import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class StepTracker {
  int _steps = 0;
  AccelerometerEvent? _lastEvent;
  double _threshold = 20.0; // Adjust this value based on your needs
  late StreamSubscription<AccelerometerEvent> _subscription;

  void startTracking() {
    _subscription = accelerometerEvents.listen(_onAccelerometerEvent);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    if (_lastEvent != null) {
      final double deltaX = event.x - _lastEvent!.x;
      final double deltaY = event.y - _lastEvent!.y;
      final double deltaZ = event.z - _lastEvent!.z;

      final double acceleration =
          deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ;
      if (acceleration > _threshold) {
        _steps++;
      }
    }
    _lastEvent = event;
  }

  int get stepCount => _steps;

  void stopTracking() {
    _subscription.cancel();
  }
}
