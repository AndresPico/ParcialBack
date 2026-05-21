import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/chat/presentation/chat_screen.dart';
import '../features/chat/presentation/inbox_screen.dart';
import '../features/home/presentation/home_shell.dart';
import '../features/home/presentation/market_home_screen.dart';
import '../features/maps/presentation/map_home_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/entrepreneur_dashboard_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/public_profile_screen.dart';
import '../features/reviews/presentation/create_review_screen.dart';
import '../features/reviews/presentation/reviews_screen.dart';
import '../features/services/presentation/create_service_screen.dart';
import '../features/services/presentation/edit_service_screen.dart';
import '../features/services/presentation/service_detail_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final isLoading = auth.isLoading;
      final session = auth.value;
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' || location == '/register';
      if (isLoading && location != '/splash') return '/splash';
      if (!isLoading && session == null && !isAuthRoute) return '/login';
      if (session != null && (isAuthRoute || location == '/splash')) {
        return session.role == 'ENTREPRENEUR' ? '/dashboard' : '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const MarketHomeScreen()),
          GoRoute(path: '/map', builder: (context, state) => const MapHomeScreen()),
          GoRoute(path: '/dashboard', builder: (context, state) => const EntrepreneurDashboardScreen()),
          GoRoute(path: '/inbox', builder: (context, state) => const InboxScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
      GoRoute(
        path: '/services/new',
        builder: (context, state) => const CreateServiceScreen(),
      ),
      GoRoute(
        path: '/services/:id',
        builder: (context, state) => ServiceDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/services/:id/edit',
        builder: (context, state) => EditServiceScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/profile/edit', builder: (context, state) => const EditProfileScreen()),
      GoRoute(
        path: '/entrepreneurs/:username',
        builder: (context, state) => PublicProfileScreen(username: state.pathParameters['username']!),
      ),
      GoRoute(
        path: '/chats/:id',
        builder: (context, state) => ChatScreen(chatId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/services/:id/reviews/new',
        builder: (context, state) => CreateReviewScreen(serviceId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/services/:id/reviews',
        builder: (context, state) => ReviewsScreen(serviceId: state.pathParameters['id']!),
      ),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen(authControllerProvider, (previous, next) => notifyListeners());
  }

  final Ref ref;
}
