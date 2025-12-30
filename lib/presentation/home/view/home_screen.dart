import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/router/app_router.dart';
import '../viewmodel/home_cubit.dart';
import '../viewmodel/home_state.dart';
import '../widgets/address_card.dart';
import '../../settings/viewmodel/settings_cubit.dart';
import '../../settings/viewmodel/settings_state.dart';
import '../../shared/widgets/closeable_banner_ad.dart';

/// Main home screen displaying power status for saved addresses
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load data and check donation dialog after frame is built to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeCubit>().loadData();
        _checkAndShowDonationDialog();
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
    // Refresh data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      context.read<HomeCubit>().onAppResumed();
    }
  }

  Future<void> _checkAndShowDonationDialog() async {
    // Wait for initialization to complete
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final homeCubit = context.read<HomeCubit>();
    final donationUrl = await homeCubit.checkAndGetDonationUrl();

    if (donationUrl != null && mounted) {
      _showDonationDialog(donationUrl);
      await homeCubit.markDonationDialogShown();
    }
  }

  void _showDonationDialog(String donationUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryYellow.withValues(alpha: 0.1),
                AppColors.primaryBlue.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Donation jar image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/image/donat_mono.jpeg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.coffee,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            context.l10n.donationDialogTitle,
                            style: AppTextStyles.heading2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      context.l10n.donationDialogMessage,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.slateGray,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: AppColors.slateGray),
                            ),
                            child: Text(
                              context.l10n.later,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.slateGray,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Capture localization before async gap
                              final l10n = context.l10n;
                              final messenger = ScaffoldMessenger.of(context);

                              Navigator.pop(context);
                              final uri = Uri.parse(donationUrl);
                              try {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                if (mounted) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.errorOpeningLink),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryYellow,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.favorite, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.support,
                                  style: AppTextStyles.body.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) {
            // Refresh when addresses list changes in Settings
            if (previous is SettingsLoaded && current is SettingsLoaded) {
              return previous.addresses != current.addresses;
            }
            return false;
          },
          listener: (context, state) {
            // Refresh HomeScreen when addresses are changed in SettingsScreen
            context.read<HomeCubit>().refreshAddresses();
          },
        ),
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (previous, current) {
            // Notify Settings when addresses change in Home
            if (previous is HomeLoaded && current is HomeLoaded) {
              final prevIds = previous.addresses
                  .map((a) => a.address.id)
                  .toList();
              final currIds = current.addresses
                  .map((a) => a.address.id)
                  .toList();
              return prevIds.toString() != currIds.toString();
            }
            return false;
          },
          listener: (context, state) {
            // Notify SettingsCubit about address changes (including reordering)
            context.read<SettingsCubit>().syncAddressesOrder();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(maxLines: 1, 'ProСвітло'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<HomeCubit>().refresh(),
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeError) {
              return _buildError(context, state.message);
            }

            if (state is HomeLoaded) {
              if (state.addresses.isEmpty) {
                return _buildNoAddresses(context);
              }

              return RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().refresh(),
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.addresses.length + 1,
                  proxyDecorator: (child, index, animation) {
                    // Remove default Material container and keep original card styling
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Transform.scale(scale: 1.02, child: child);
                      },
                      child: child,
                    );
                  },
                  onReorder: (oldIndex, newIndex) async {
                    // Don't allow reordering the "Add Address" button
                    if (oldIndex == state.addresses.length ||
                        newIndex == state.addresses.length + 1) {
                      return;
                    }
                    await context.read<HomeCubit>().reorderAddresses(
                      oldIndex,
                      newIndex,
                    );
                    // Settings screen will auto-refresh when user navigates to it
                  },
                  itemBuilder: (context, index) {
                    if (index == state.addresses.length) {
                      return _buildAddAddressButton(context);
                    }

                    final addressWithStatus = state.addresses[index];
                    final isExpanded = state.expandedAddressIds.contains(
                      addressWithStatus.address.id,
                    );

                    return AddressCard(
                      key: ValueKey(addressWithStatus.address.id),
                      addressWithStatus: addressWithStatus,
                      isExpanded: isExpanded,
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: const CloseableBannerAd(),
      ),
    );
  }

  /// Error state widget
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: context.l10n.retry,
              onPressed: () => context.read<HomeCubit>().loadData(),
            ),
          ],
        ),
      ),
    );
  }

  /// No addresses state widget
  Widget _buildNoAddresses(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.slateGray100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_off,
                size: 48,
                color: AppColors.slateGray,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              context.l10n.homeNoAddressesTitle,
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.homeNoAddressesDescription,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              text: context.l10n.homeAddAddress,
              icon: Icons.add_location,
              onPressed: () async {
                // Capture cubits before async gap
                final homeCubit = context.read<HomeCubit>();
                final settingsCubit = context.read<SettingsCubit>();

                await context.push(AppRouter.addressSearch);
                if (mounted) {
                  homeCubit.refreshAddresses();
                  settingsCubit.refreshSettings();
                }
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  /// Add address button widget
  Widget _buildAddAddressButton(BuildContext context) {
    return Padding(
      key: const ValueKey('add_address_button'),
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: OutlinedButton.icon(
        onPressed: () async {
          // Capture cubits before async gap
          final homeCubit = context.read<HomeCubit>();
          final settingsCubit = context.read<SettingsCubit>();

          await context.push(AppRouter.addressSearch);
          if (mounted) {
            homeCubit.refreshAddresses();
            settingsCubit.refreshSettings();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(
          context.l10n.homeAddOneMoreAddress,
          textAlign: TextAlign.center,
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(
            color: AppColors.primaryBlue.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
      ),
    );
  }
}
