import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/providers/sqflite_provider.dart';
import 'package:ts_basecode/data/repositories/storage/event/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => EventRepositoryImpl(
    ref.watch(sqfliteProvider),
  ),
);
