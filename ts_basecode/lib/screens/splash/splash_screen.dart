import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/data/services/shared_preferences/shared_preferences_manager.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/splash/splash_view_model.dart';

final _provider = StateNotifierProvider.autoDispose(
  (ref) => SplashViewModel(),
);

/// Screen code: A_01
@RoutePage()
class SplashScreen extends BaseView {
  const SplashScreen({super.key});

  @override
  BaseViewState<SplashScreen, SplashViewModel> createState() =>
      _SplashViewState();
}

class _SplashViewState extends BaseViewState<SplashScreen, SplashViewModel> {
  @override
  void initState() {
    super.initState();
    _initState();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: Image.asset('assets/images/icon.jpg'),
          ),
          const Text(
            "Training Schedule",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 200,
          )
        ],
      ),
    );
  }

  @override
  SplashViewModel get viewModel => ref.read(_provider.notifier);

  @override
  String get screenName => SplashRoute.name;

  Future<void> _initState() async {
    final onboarding = await SharedPreferencesManager.getOnboarding();
    Future.delayed(const Duration(seconds: 1), () async {
      if (onboarding) {
        await AutoRouter.of(context).pushNamed("/home");
      } else {
        await AutoRouter.of(context).pushNamed("/onboarding");
      }
    });
  }
}
