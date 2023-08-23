import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db_models/message.dart';

final chatMessageQueueProvider = StateProvider<Map<int, List<Message>>>((ref) {
  return {};
});
