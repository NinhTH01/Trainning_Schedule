import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_dialog/native_dialog.dart';

final nativeDialogProvider = Provider<NativeDialog>((ref) => NativeDialog());
