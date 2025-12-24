import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../data/models/address_model.dart';
import '../viewmodel/address_search_cubit.dart';
import '../viewmodel/address_search_state.dart';
import 'address_field.dart';

/// Street selection field widget
class StreetField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController cityController;
  final FocusNode focusNode;
  final bool showDropdown;
  final AddressSearchLoaded state;
  final AddressModel? addressToEdit;
  final VoidCallback onDropdownChange;
  final VoidCallback? onSelectCallback;
  final VoidCallback? onClearCallback;
  final FocusNode houseFocusNode;

  const StreetField({
    super.key,
    required this.controller,
    required this.cityController,
    required this.focusNode,
    required this.showDropdown,
    required this.state,
    this.addressToEdit,
    required this.onDropdownChange,
    this.onSelectCallback,
    this.onClearCallback,
    required this.houseFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled =
        state.selectedCity != null ||
        (addressToEdit != null && cityController.text.isNotEmpty);

    return AddressField(
      controller: controller,
      focusNode: focusNode,
      icon: Icons.signpost,
      label: context.l10n.addressFieldStreet,
      hint: context.l10n.addressFieldStreetHint,
      disabledHint: context.l10n.addressFieldStreetDisabled,
      enabled: isEnabled,
      required: true,
      showDropdown: showDropdown && state.streets.isNotEmpty,
      suggestions: state.streets,
      onChanged: (value) async {
        // Capture cubit reference before async gap
        final cubit = context.read<AddressSearchCubit>();

        // Clear error on field change
        cubit.clearError();

        onDropdownChange();

        if (value.isNotEmpty && isEnabled) {
          // Ensure city is selected in state
          if (addressToEdit != null &&
              state.selectedCity == null &&
              cityController.text.isNotEmpty) {
            await cubit.selectCity(cityController.text);
          }
          cubit.searchStreets(value);
        }
      },
      onSelect: (street) {
        // Clear error on selection
        context.read<AddressSearchCubit>().clearError();

        controller.text = street;
        context.read<AddressSearchCubit>().selectStreet(street);
        onSelectCallback?.call();
        houseFocusNode.requestFocus();
      },
      onClear: () {
        controller.clear();
        context.read<AddressSearchCubit>().clearStreet();
        onClearCallback?.call();
      },
    );
  }
}
