import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/data/services/sqflite_manager/sqflite_manager.dart';

final sqfliteProvider = Provider((ref) => SqfliteManager());
