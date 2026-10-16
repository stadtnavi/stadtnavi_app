import 'package:flutter/material.dart';
import 'package:async_executor/async_executor.dart';
import 'package:rive/rive.dart';
import 'package:trufi_core/base/widgets/alerts/fetch_error_handler.dart';

import 'package:trufi_core/base/widgets/screen/screen_helpers.dart';

AsyncExecutor customAsyncExecutor = AsyncExecutor(
  loadingMessage: (
    BuildContext context,
  ) async {
    return await showTrufiDialog(
      context: context,
      barrierDismissible: false,
      onWillPop: false,
      builder: (context) {
        return const _LoadingAnimation();
      },
    );
  },
  errorMessage: (BuildContext context, dynamic error) async {
    return await onFetchError(context, error);
  },
);

class _LoadingAnimation extends StatefulWidget {
  const _LoadingAnimation();

  @override
  State<_LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<_LoadingAnimation> {
  late final SingleAnimationPainter _painter = SingleAnimationPainter(
    'Trufi Drive',
  );
  File? _file;
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    final file = await File.asset(
      'assets/images/loading.riv',
      riveFactory: Factory.flutter,
    );
    if (!mounted) {
      file?.dispose();
      return;
    }
    setState(() {
      _file = file;
      _artboard = file?.defaultArtboard();
    });
  }

  @override
  void dispose() {
    _painter.dispose();
    _artboard?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final artboard = _artboard;
    if (artboard == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return RiveArtboardWidget(artboard: artboard, painter: _painter);
  }
}
