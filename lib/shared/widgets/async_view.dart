import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Enveloppe standard pour afficher le résultat d'un [Future] : gère les
/// états chargement / erreur / vide de façon cohérente dans toute l'app.
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    required this.future,
    required this.builder,
    this.emptyMessage = 'Rien à afficher pour le moment.',
    this.isEmpty,
    super.key,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final String emptyMessage;
  final bool Function(T data)? isEmpty;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: AppColors.orange),
            ),
          );
        }
        if (snapshot.hasError) {
          return _Message(
            icon: Icons.error_outline,
            text: 'Une erreur est survenue.\n${snapshot.error}',
          );
        }
        final data = snapshot.data as T;
        if (isEmpty?.call(data) ?? false) {
          return _Message(icon: Icons.inbox_outlined, text: emptyMessage);
        }
        return builder(context, data);
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.slate),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.slate),
            ),
          ],
        ),
      ),
    );
  }
}
