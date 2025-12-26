import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/donation_banner.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/address_model.dart';
import '../../home/viewmodel/home_cubit.dart';
import '../viewmodel/settings_cubit.dart';
import '../viewmodel/settings_state.dart';
import '../models/address_action.dart';
import '../widgets/address_card.dart';
import '../widgets/empty_addresses_card.dart';
import '../widgets/theme_option.dart';
import '../widgets/dialogs/confirm_delete_address_dialog.dart';
import '../widgets/dialogs/confirm_disable_notifications_dialog.dart';
import '../helpers/donation_helper.dart';
import '../../push_notifications/cubit/push_notifications_cubit.dart';

/// Settings screen with app configuration and saved addresses
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial load
    context.read<SettingsCubit>().loadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Reload when app comes back from background
    if (state == AppLifecycleState.resumed) {
      context.read<SettingsCubit>().loadSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(maxLines: 1, context.l10n.settingsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.push(AppRouter.about),
            tooltip: context.l10n.tooltipInfo,
          ),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: Text(state.message, style: AppTextStyles.body),
            );
          }

          if (state is SettingsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // Donation banner (only if data available)
                if (state.donationInfo != null &&
                    state.donationInfo!.url.isNotEmpty)
                  DonationBanner(
                    onTap: () => DonationHelper.openDonationLink(
                      context,
                      state.donationInfo!,
                    ),
                  ),

                if (state.donationInfo != null &&
                    state.donationInfo!.url.isNotEmpty)
                  const SizedBox(height: AppSpacing.xl),

                // Addresses section
                _buildAddressesSection(context, state),

                const SizedBox(height: AppSpacing.xl),

                // Theme section
                _buildThemeSection(context, state),

                const SizedBox(height: AppSpacing.xl),

                // Notifications section
                _buildNotificationsSection(context),

                const SizedBox(height: AppSpacing.xxl),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAddressesSection(BuildContext context, SettingsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.l10n.settingsMyAddresses,
                style: AppTextStyles.heading3,
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                // Capture cubits before async gap
                final settingsCubit = context.read<SettingsCubit>();
                final homeCubit = context.read<HomeCubit>();

                await context.push(AppRouter.addressSearch);
                if (context.mounted) {
                  await settingsCubit.loadSettings();
                  // Refresh home screen data after adding new address
                  homeCubit.refreshAddresses();
                }
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.l10n.settingsAddAddress),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        if (state.addresses.isEmpty)
          const EmptyAddressesCard()
        else
          ...state.addresses.map((address) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: AddressCard(
                address: address,
                onAction: (action) =>
                    _handleAddressAction(context, action, address),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, SettingsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.settingsAppearance, style: AppTextStyles.heading3),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: Column(
            children: [
              ThemeOption(
                title: context.l10n.settingsThemeLight,
                icon: Icons.light_mode,
                isSelected: state.themeMode == 'light',
                onTap: () =>
                    context.read<SettingsCubit>().changeThemeMode('light'),
              ),
              const Divider(height: AppSpacing.lg),
              ThemeOption(
                title: context.l10n.settingsThemeDark,
                icon: Icons.dark_mode,
                isSelected: state.themeMode == 'dark',
                onTap: () =>
                    context.read<SettingsCubit>().changeThemeMode('dark'),
              ),
              const Divider(height: AppSpacing.lg),
              ThemeOption(
                title: context.l10n.settingsThemeSystem,
                icon: Icons.brightness_auto,
                isSelected: state.themeMode == 'system',
                onTap: () =>
                    context.read<SettingsCubit>().changeThemeMode('system'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.settingsNotifications, style: AppTextStyles.heading3),
        const SizedBox(height: AppSpacing.md),
        BlocBuilder<PushNotificationsCubit, PushNotificationsState>(
          builder: (context, pushState) {
            return AppCard(
              child: SwitchListTile(
                value: pushState.notificationsEnabled,
                onChanged: (value) async {
                  if (!value) {
                    final confirmed =
                        await ConfirmDisableNotificationsDialog.show(context);
                    if (confirmed && context.mounted) {
                      context
                          .read<PushNotificationsCubit>()
                          .toggleNotifications(false);
                    }
                  } else {
                    context.read<PushNotificationsCubit>().toggleNotifications(
                      true,
                    );
                  }
                },
                title: Text(context.l10n.settingsNotificationsEnable),
                subtitle: Text(context.l10n.settingsNotificationsDescription),
                secondary: const Icon(Icons.notifications),
                contentPadding: EdgeInsets.zero,
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleAddressAction(
    BuildContext context,
    AddressAction action,
    AddressModel address,
  ) {
    switch (action) {
      case AddressAction.edit:
        _editAddress(context, address);
        break;
      case AddressAction.delete:
        _deleteAddress(context, address.id, address.name);
        break;
    }
  }

  Future<void> _editAddress(BuildContext context, AddressModel address) async {
    // Capture cubits before async gap
    final settingsCubit = context.read<SettingsCubit>();
    final homeCubit = context.read<HomeCubit>();

    await context.push(AppRouter.addressSearch, extra: address);
    if (context.mounted) {
      await settingsCubit.loadSettings();
      // Refresh home screen data after address edit
      homeCubit.refreshAddresses();
    }
  }

  Future<void> _deleteAddress(
    BuildContext context,
    String addressId,
    String addressName,
  ) async {
    // Capture cubits before async gap
    final settingsCubit = context.read<SettingsCubit>();
    final homeCubit = context.read<HomeCubit>();

    final confirmed = await ConfirmDeleteAddressDialog.show(
      context,
      addressName,
    );

    if (confirmed && context.mounted) {
      await settingsCubit.deleteAddress(addressId);
      if (context.mounted) {
        homeCubit.refreshAddresses();
      }
    }
  }
}
