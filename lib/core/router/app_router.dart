import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/directory/business_detail_screen.dart';
import '../../features/directory/directory_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/mobility/mobility_screen.dart';
import '../../features/news/news_detail_screen.dart';
import '../../features/news/news_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/recommendations/recommendations_screen.dart';

/// Configuration de navigation de l'application.
///
/// Une [StatefulShellRoute] conserve l'état de chaque onglet (fil, annuaire,
/// mobilité, pour vous) et affiche la barre de navigation commune. Les URLs
/// sont propres (ex. /directory/b1), ce qui fonctionne aussi sur le web.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/news',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/news',
                builder: (context, state) => const NewsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => NewsDetailScreen(
                      articleId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/directory',
                builder: (context, state) => const DirectoryScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => BusinessDetailScreen(
                      businessId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mobility',
                builder: (context, state) => const MobilityScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recommendations',
                builder: (context, state) => const RecommendationsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page introuvable : ${state.uri}')),
    ),
  );
}
