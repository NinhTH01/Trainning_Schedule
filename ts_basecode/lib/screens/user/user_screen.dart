import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/providers/global_running_status_manager_provider.dart';
import 'package:ts_basecode/data/providers/shared_preferences_repository_provider.dart';
import 'package:ts_basecode/data/services/global_map_manager/global_running_status_state.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/user/user_state.dart';
import 'package:ts_basecode/screens/user/user_view_model.dart';
import 'package:ts_basecode/utilities/constants/app_constants.dart';
import 'package:ts_basecode/utilities/constants/app_text_styles.dart';

final _provider = StateNotifierProvider.autoDispose<UserViewModel, UserState>(
  (ref) => UserViewModel(
    sharedPreferencesRepository: ref.watch(sharedPreferencesRepositoryProvider),
  ),
);

@RoutePage()
class UserScreen extends BaseView {
  const UserScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserScreen();
}

class _UserScreen extends BaseViewState<UserScreen, UserViewModel> {
  final listName = [
    AppConstants.userName,
    AppConstants.altUserName,
  ];

  @override
  void onInitState() async {
    super.onInitState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onInitState());
  }

  Future<void> _onInitState() async {
    try {
      await viewModel.onInitData();
    } catch (e) {
      handleError(e);
    }
  }

  @override
  BuildContext get statusViewContext => context;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  UserState get state => ref.watch(_provider);

  GlobalRunningStatusState get globalMapState =>
      ref.watch(globalRunningStatusManagerProvider);

  @override
  bool get ignoreSafeAreaTop => true;

  @override
  String get screenName => UserRoute.name;

  @override
  UserViewModel get viewModel => ref.read(_provider.notifier);

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: listName.length,
        itemBuilder: (BuildContext context, int index) {
          return OutlinedButton(
            onPressed: () {
              viewModel.setUsername(listName[index]);
            },
            child: Text(
              listName[index],
              style: AppTextStyles.s16w400.copyWith(
                color: state.username == listName[index]
                    ? ColorName.blue
                    : ColorName.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
