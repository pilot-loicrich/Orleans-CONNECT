import 'package:flutter/material.dart';

/// Palette de marque Orléans Connect.
///
/// Inspirée du logo : le bleu marine de la cathédrale Sainte-Croix,
/// l'orange chaleureux de la Loire au couchant, et un cyan de liaison.
abstract final class AppColors {
  // Couleurs primaires
  static const Color navy = Color(0xFF14294B); // Bleu marine (texte, barres)
  static const Color navyLight = Color(0xFF2A4A7C);
  static const Color orange = Color(0xFFE8792B); // Orange accent (actions)
  static const Color orangeSoft = Color(0xFFF4A259);
  static const Color cyan = Color(0xFF2EA6B8); // Cyan (liaison, mobilité)

  // Neutres
  static const Color ink = Color(0xFF1B2430);
  static const Color slate = Color(0xFF5B6B7F);
  static const Color mist = Color(0xFFEEF2F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F9FB);

  // Sémantiques
  static const Color success = Color(0xFF2E9E6B);
  static const Color warning = Color(0xFFE0A83B);
  static const Color danger = Color(0xFFD8543B);

  /// Dégradé signature (cyan → orange), repris du logo.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyan, orange],
  );
}
