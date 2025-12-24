import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../data/models/address_model.dart';
import '../viewmodel/address_search_cubit.dart';
import '../viewmodel/address_search_state.dart';
import 'address_field.dart';

/// City selection field widget
class CityField extends StatelessWidget {
  final TextEditingController controller;
  final bool showDropdown;
  final AddressSearchLoaded state;
  final AddressModel? addressToEdit;
  final VoidCallback onDropdownChange;
  final VoidCallback? onSelectCallback;
  final VoidCallback? onClearCallback;
  final FocusNode streetFocusNode;

  const CityField({
    super.key,
    required this.controller,
    required this.showDropdown,
    required this.state,
    this.addressToEdit,
    required this.onDropdownChange,
    this.onSelectCallback,
    this.onClearCallback,
    required this.streetFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return AddressField(
      controller: controller,
      icon: Icons.location_city,
      label: context.l10n.addressFieldCity,
      hint: context.l10n.addressFieldCityHint,
      disabledHint: '',
      enabled: true,
      required: true,
      showDropdown: showDropdown && state.cities.isNotEmpty,
      suggestions: state.cities,
      onChanged: (value) {
        // Clear error on field change
        context.read<AddressSearchCubit>().clearError();

        onDropdownChange();

        if (value.isNotEmpty) {
          context.read<AddressSearchCubit>().searchCities(value);
        }
      },
      onSelect: (city) {
        // Clear error on selection
        context.read<AddressSearchCubit>().clearError();

        controller.text = city;
        context.read<AddressSearchCubit>().selectCity(city);
        onSelectCallback?.call();
        streetFocusNode.requestFocus();
      },
      onClear: () {
        controller.clear();
        context.read<AddressSearchCubit>().clearCity();
        onClearCallback?.call();
      },
    );
  }
}
