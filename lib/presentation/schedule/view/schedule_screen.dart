import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../viewmodel/schedule_cubit.dart';
import '../viewmodel/schedule_state.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_error_view.dart';
import '../widgets/schedule_empty_view.dart';
import '../widgets/schedule_update_header.dart';
import '../widgets/zoomable_image_dialog.dart';
import '../../shared/widgets/closeable_banner_ad.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with WidgetsBindingObserver {
  var _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load schedules once on initialization using post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ScheduleCubit>().loadSchedules();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh data when app returns to foreground (but not on initial load)
    if (state == AppLifecycleState.resumed && !_isInitialLoad) {
      context.read<ScheduleCubit>().loadSchedules();
    }
    // Mark that initial load is complete after first lifecycle change
    if (_isInitialLoad) {
      _isInitialLoad = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: AutoSizeText(maxLines: 1, context.l10n.scheduleTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ScheduleCubit>().refreshSchedules();
            },
          ),
        ],
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading || state is ScheduleInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScheduleError) {
            return ScheduleErrorView(
              message: state.message,
              onRetry: () => context.read<ScheduleCubit>().loadSchedules(),
            );
          }

          // Handle both ScheduleLoaded and ScheduleRefreshing (which extends ScheduleLoaded)
          if (state is ScheduleLoaded) {
            if (state.schedules.isEmpty) {
              return const ScheduleEmptyView();
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () =>
                      context.read<ScheduleCubit>().refreshSchedules(),
                  child: CustomScrollView(
                    slivers: [
                      // Last update header
                      if (state.lastUpdated != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: ScheduleUpdateHeader(
                              lastUpdated: state.lastUpdated!,
                            ),
                          ),
                        ),

                      // Schedule list
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final schedule = state.schedules[index];
                            return ScheduleCard(
                              schedule: schedule,
                              onImageTap: () => ZoomableImageDialog.show(
                                context,
                                schedule.imageUrl,
                              ),
                            );
                          }, childCount: state.schedules.length),
                        ),
                      ),
                    ],
                  ),
                ),
                // Show loading indicator while refreshing
                if (state is ScheduleRefreshing)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: const CloseableBannerAd(),
    );
  }
}
