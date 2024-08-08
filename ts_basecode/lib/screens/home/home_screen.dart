import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ts_basecode/components/base_view/base_view.dart';
import 'package:ts_basecode/router/app_router.dart';
import 'package:ts_basecode/screens/home/home_view_model.dart';

final _provider = StateNotifierProvider.autoDispose((ref) => HomeViewModel());

@RoutePage()
class HomeScreen extends BaseView {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();

  @override
  String get screenName => HomeRoute.name;
}

class _HomeViewState extends BaseViewState<HomeScreen, HomeViewModel> {
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return const Text("1");
  }

  @override
  // TODO: implement screenName
  String get screenName => HomeRoute.name;

  @override
  // TODO: implement viewModel
  HomeViewModel get viewModel => ref.read(_provider.notifier);

  // @override
  // // TODO: implement viewModel
  // OnboardingViewModel get viewModel => ref.read(_provider.notifier);
}
