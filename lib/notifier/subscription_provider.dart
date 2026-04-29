import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/subscription_history.dart';
import '../repositry/subscription.dart';

final subscriptionHistoryProvider =
FutureProvider<List<SubscriptionHistoryModel>>((ref) async {
  final repo = SubscriptionRepository();
  return repo.getSubscriptionHistory();
});