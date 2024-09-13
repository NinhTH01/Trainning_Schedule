import 'package:ts_basecode/components/base_view/base_view_model.dart';
import 'package:ts_basecode/data/repositories/storage/shared_preferences/shared_preferences_repository.dart';
import 'package:ts_basecode/screens/race/race_state.dart';

class RaceViewModel extends BaseViewModel<RaceState> {
  RaceViewModel({
    required this.sharedPreferencesRepository,
  }) : super(const RaceState());

  final SharedPreferencesRepository sharedPreferencesRepository;

  Future<void> onInitData() async {
    String currentUsername = await sharedPreferencesRepository.getUsername();

    state = state.copyWith(
      username: currentUsername,
    );
  }

  Future<void> setUsername(String username) async {
    await sharedPreferencesRepository.setUsername(value: username);
    state = state.copyWith(
      username: username,
    );
  }
}
