import 'package:caixinha/logic/load_status.dart';
import 'package:caixinha/ui/widgets/error_state.dart';
import 'package:flutter/material.dart';

class StatusGate extends StatelessWidget {
  const StatusGate({
    super.key,
    required this.status,
    required this.onRetry,
    required this.builder,
    this.errorMessage,
  });

  final LoadStatus status;
  final String? errorMessage;
  final VoidCallback onRetry;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      LoadStatus.loading => const Center(child: CircularProgressIndicator()),
      LoadStatus.error => ErrorState(
          message: errorMessage ?? 'Não foi possível concluir a operação.',
          onRetry: onRetry,
        ),
      LoadStatus.ready => builder(context),
    };
  }
}
