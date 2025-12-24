import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../data/models/address_model.dart';
import '../viewmodel/address_search_cubit.dart';
import '../viewmodel/address_search_state.dart';
import 'address_field.dart';

/// House selection field widget
class HouseField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController cityController;
  final TextEditingController streetController;
  final FocusNode focusNode;
  final bool showDropdown;
  final AddressSearchLoaded state;
  final AddressModel? addressToEdit;
  final VoidCallback onDropdownChange;
  final VoidCallback? onSelectCallback;
  final FocusNode nameFocusNode;

  const HouseField({
    super.key,
    required this.controller,
    required this.cityController,
    required this.streetController,
    required this.focusNode,
    required this.showDropdown,
    required this.state,
    this.addressToEdit,
    required this.onDropdownChange,
    this.onSelectCallback,
    required this.nameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled =
        state.selectedStreet != null ||
        (addressToEdit != null && streetController.text.isNotEmpty);

    return AddressField(
      controller: controller,
      focusNode: focusNode,
      icon: Icons.home,
      label: context.l10n.addressFieldHouse,
      hint: context.l10n.addressFieldHouseHint,
      disabledHint: context.l10n.addressFieldHouseDisabled,
      enabled: isEnabled,
      required: true,
      showDropdown: showDropdown && state.houses.isNotEmpty,
      suggestions: state.houses,
      onChanged: (value) async {
        // Capture cubit reference before async gap
        final cubit = context.read<AddressSearchCubit>();

        // Clear error on field change
        cubit.clearError();

        onDropdownChange();

        if (value.isNotEmpty && isEnabled) {
          // Ensure city and street are selected in state
          if (addressToEdit != null &&
              state.selectedCity == null &&
              cityController.text.isNotEmpty) {
            await cubit.selectCity(cityController.text);
          }
          if (addressToEdit != null &&
              state.selectedStreet == null &&
              streetController.text.isNotEmpty) {
            await cubit.selectStreet(streetController.text);
          }
          cubit.searchHouses(value);
        }
      },
      onSelect: (house) {
        // Clear error on selection
        context.read<AddressSearchCubit>().clearError();

        controller.text = house;
        onSelectCallback?.call();
        // Focus on name field after house selection
        nameFocusNode.requestFocus();
      },
      onClear: () {
        controller.clear();
      },
    );
  }
}
