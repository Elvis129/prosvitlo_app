import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../cubit/push_notifications_cubit.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_empty_view.dart';
import '../widgets/notification_error_view.dart';
import '../widgets/notification_unavailable_view.dart';
import '../../shared/widgets/closeable_banner_ad.dart';

/// Push notifications history screen
class PushNotificationsScreen extends StatelessWidget {
  const PushNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(maxLines: 1, context.l10n.pushNotificationsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PushNotificationsCubit>().loadNotifications();
            },
          ),
        ],
      ),
      body: BlocBuilder<PushNotificationsCubit, PushNotificationsState>(
        builder: (context, state) {
          if (state.status == PushNotificationsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PushNotificationsStatus.unavailable) {
            return const NotificationUnavailableView();
          }

          if (state.status == PushNotificationsStatus.error) {
            return NotificationErrorView(
              message: context.l10n.errorLoadingNotifications(
                state.errorMessage ?? '',
              ),
              onRetry: () =>
                  context.read<PushNotificationsCubit>().loadNotifications(),
            );
          }

          if (state.notifications.isEmpty) {
            return const NotificationEmptyView();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<PushNotificationsCubit>().loadNotifications();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCard(notification: notification);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
            ),
          );
        },
      ),
      bottomNavigationBar: const CloseableBannerAd(),
    );
  }
}
