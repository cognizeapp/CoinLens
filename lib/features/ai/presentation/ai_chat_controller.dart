import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/failure.dart';
import '../../coin/domain/coin_models.dart';
import '../../../services/analytics/analytics_service.dart';
import '../ai_providers.dart';
import '../coin_intelligence.dart';

class AiChatState {
  const AiChatState({
    this.messages = const [],
    this.sending = false,
    this.error,
  });

  final List<AiMessage> messages;
  final bool sending;
  final Failure? error;

  AiChatState copyWith({
    List<AiMessage>? messages,
    bool? sending,
    Failure? error,
    bool clearError = false,
  }) =>
      AiChatState(
        messages: messages ?? this.messages,
        sending: sending ?? this.sending,
        error: clearError ? null : (error ?? this.error),
      );
}

/// The AI coin assistant (product spec §12). The controller already holds the
/// coin context, so the user never has to re-explain which coin they mean.
class AiChatController extends StateNotifier<AiChatState> {
  AiChatController(this._ref, this._coin) : super(const AiChatState());

  final Ref _ref;
  final CoinIdentification _coin;

  Future<void> send(String question) async {
    final q = question.trim();
    if (q.isEmpty || state.sending) return;

    state = state.copyWith(
      messages: [...state.messages, AiMessage(fromUser: true, text: q)],
      sending: true,
      clearError: true,
    );

    final result = await _ref.read(coinIntelligenceServiceProvider).ask(
          context: _coin,
          history: state.messages,
          question: q,
        );

    result.when(
      ok: (answer) {
        state = state.copyWith(
          messages: [
            ...state.messages,
            AiMessage(fromUser: false, text: answer),
          ],
          sending: false,
        );
        _ref.read(analyticsServiceProvider).logEvent(
            AnalyticsEvent.aiAnalysisCompleted,
            params: {'kind': 'assistant'});
      },
      err: (f) => state = state.copyWith(sending: false, error: f),
    );
  }
}

final aiChatControllerProvider = StateNotifierProvider.family<AiChatController,
    AiChatState, CoinIdentification>((ref, coin) {
  return AiChatController(ref, coin);
});
