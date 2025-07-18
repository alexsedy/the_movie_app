import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';

class ErrorWithRetryWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetryPressed;

  const ErrorWithRetryWidget({
    super.key,
    required this.errorMessage,
    required this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPaddingH60V16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: AppSpacing.p12,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ElevatedButton(
            onPressed: onRetryPressed,
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }
}
