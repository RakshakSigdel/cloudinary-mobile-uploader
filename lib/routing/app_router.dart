import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/providers/cloudinary_config_provider.dart';
import 'package:cloudinary_mobile_uploader/features/cloudinary_config/presentation/screens/config_screen.dart';
import 'package:cloudinary_mobile_uploader/features/image_upload/presentation/screens/upload_screen.dart';
import 'package:cloudinary_mobile_uploader/features/upload_history/presentation/screens/history_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  AppRoutes._();

  static const config = '/config';
  static const upload = '/upload';
  static const history = '/history';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.upload,

    redirect: (context, state) {
      final configState = ref.watch(cloudinaryConfigProvider);

      if (configState.isLoading) return null;

      final isConfigured = configState.valueOrNull != null;
      final goingToConfig = state.matchedLocation == AppRoutes.config;

      if (!isConfigured && !goingToConfig) return AppRoutes.config;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.config,
        builder: (context, state) => const ConfigScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.upload,
        builder: (context, state) => UploadScreen(),
      ),
    ],
  );
});
