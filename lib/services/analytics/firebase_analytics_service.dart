import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

/// Sends events to Firebase Analytics (Google Analytics for Firebase),
/// visible in the Firebase console and the linked GA4 property.
class FirebaseAnalyticsAdapter implements AnalyticsService {
  FirebaseAnalyticsAdapter([FirebaseAnalytics? analytics])
      : _analytics = analytics ?? FirebaseAnalytics.instance;
  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(AnalyticsEvent event,
      {Map<String, Object?>? params}) {
    return _analytics.logEvent(
      name: event.name,
      parameters: params?.map((k, v) => MapEntry(k, v as Object)),
    );
  }

  @override
  Future<void> setUserId(String? id) => _analytics.setUserId(id: id);

  @override
  Future<void> setUserProperty(String name, String? value) =>
      _analytics.setUserProperty(name: name, value: value);
}
