import '../../../core/error/failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/result.dart';
import '../../coin/domain/coin_models.dart';
import '../coin_intelligence.dart';

/// Backend AI engine (product spec §6, §9, §12, §35). The client sends only the
/// **structured identification** — never the raw image — so the model explains
/// verified data rather than re-deriving it, which keeps cost and hallucination
/// down. Provider API keys live only on the server.
///
/// INTEGRATION POINT — enable by setting `API_BASE_URL`.
class HttpCoinIntelligenceService implements CoinIntelligenceService {
  HttpCoinIntelligenceService(this._api);

  final ApiClient _api;

  @override
  Future<Result<CoinIntelligence>> analyze(CoinIdentification id) async {
    try {
      final j = await _api.postJson('/analyze', {'coin': id.toAiContext()});
      final s = (j['selling'] as Map).cast<String, dynamic>();
      return Result.ok(CoinIntelligence(
        historicalContext: j['historical_context'] as String,
        valueAnalysis: j['value_analysis'] as String,
        rarityExplanation: j['rarity_explanation'] as String,
        conditionExplanation: j['condition_explanation'] as String,
        collectorInsights: j['collector_insights'] as String,
        sellingStrategy: SellingStrategy(
          estimatedSaleRange: s['estimated_sale_range'] as String,
          suggestedListPrice: s['suggested_list_price'] as String,
          minimumPrice: s['minimum_price'] as String,
          recommendedPlatforms: s['recommended_platforms'] as String,
          auctionAdvice: s['auction_advice'] as String,
          appraisalAdvice: s['appraisal_advice'] as String,
          cleaningWarning: s['cleaning_warning'] as String,
        ),
      ));
    } on Failure catch (f) {
      return Result.err(f);
    } catch (e) {
      return Result.err(UnknownFailure(cause: e));
    }
  }

  @override
  Future<Result<String>> ask({
    required CoinIdentification context,
    required List<AiMessage> history,
    required String question,
  }) async {
    try {
      final j = await _api.postJson('/assistant', {
        'coin': context.toAiContext(),
        'history': [
          for (final m in history)
            {'role': m.fromUser ? 'user' : 'assistant', 'text': m.text}
        ],
        'question': question,
      });
      return Result.ok(j['answer'] as String);
    } on Failure catch (f) {
      return Result.err(f);
    } catch (e) {
      return Result.err(UnknownFailure(cause: e));
    }
  }
}
