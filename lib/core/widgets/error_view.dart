import 'package:cloudinary_mobile_uploader/core/error/failure.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.failure, this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(failure.icon,size: 32,color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 18),
        Text(failure.message, textAlign: TextAlign.center),
        if(onRetry !=null) ...[
          const SizedBox(height:8),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ]
      ],
    );
  }
}
