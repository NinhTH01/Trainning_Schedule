import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ts_basecode/components/status_view/status_view.dart';
import 'package:ts_basecode/resources/gen/colors.gen.dart';

mixin BaseViewMixin {
  bool get resizeToAvoidBottomInset => false;

  bool get tapOutsideToDismissKeyBoard => false;

  bool get extendBodyBehindAppBar => false;

  Color? get backgroundColor => ColorName.white;

  bool get ignoreSafeAreaTop => false;

  bool get ignoreSafeAreaBottom => true;

  bool get canPop => true;

  String get screenName;

  BuildContext? get statusViewContext => null;

  /// For iOS status bar
  Brightness? get statusBarBrightness => Brightness.light;

  /// For Android status bar
  Brightness? get statusBarIconBrightness => Brightness.dark;

  Widget buildBody(BuildContext context);

  PreferredSizeWidget? buildAppBar(BuildContext context);

  Widget? buildFloatingActionButton(BuildContext context) => null;

  Widget? buildBottomNavigatorBar(BuildContext context) => null;

  Widget? buildBottomSheet(BuildContext context) => null;

  Widget buildView(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: statusBarBrightness,
        statusBarIconBrightness: statusBarIconBrightness,
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: buildAppBar(context),
      body: SafeArea(
        top: ignoreSafeAreaTop,
        bottom: ignoreSafeAreaBottom,
        child: PopScope(
          canPop: canPop,
          onPopInvoked: onPopInvoked,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (() {
              if (tapOutsideToDismissKeyBoard) {
                dismissKeyBoard(context);
              }
            }),
            child: tapOutsideToDismissKeyBoard
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: buildBody(context),
                  )
                : Stack(children: [
                    buildBody(context),
                    StatusView(
                      screenContext: statusViewContext,
                      viewHasSafeArea: !ignoreSafeAreaTop,
                    )
                  ]),
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: buildBottomNavigatorBar(context),
      bottomSheet: buildBottomSheet(context),
    );
  }

  void onPopInvoked(bool didPop) {}

  void dismissKeyBoard(BuildContext context) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}
