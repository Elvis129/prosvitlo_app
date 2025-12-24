import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/localizations_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/address_model.dart';
import '../viewmodel/address_search_cubit.dart';
import '../viewmodel/address_search_state.dart';
import '../widgets/instruction_banner.dart';
import '../widgets/error_banner.dart';
import '../widgets/city_field.dart';
import '../widgets/street_field.dart';
import '../widgets/house_field.dart';
import '../widgets/name_field.dart';

class AddressSearchScreen extends StatefulWidget {
  final AddressModel? addressToEdit;

  const AddressSearchScreen({super.key, this.addressToEdit});

  @override
  State<AddressSearchScreen> createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseController = TextEditingController();
  late final _nameController = TextEditingController();

  final _cityFocusNode = FocusNode();
  final _streetFocusNode = FocusNode();
  final _houseFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();

  bool _showCityDropdown = false;
  bool _showStreetDropdown = false;
  bool _showHouseDropdown = false;

  @override
  void initState() {
    super.initState();

    // Set default name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.addressToEdit == null && _nameController.text.isEmpty) {
        _nameController.text = context.l10n.addressNameDefault;
      }
    });

    // If editing existing address, prefill fields
    if (widget.addressToEdit != null) {
      _cityController.text = widget.addressToEdit!.city;
      _streetController.text = widget.addressToEdit!.street;
      _houseController.text = widget.addressToEdit!.house;
      _nameController.text = widget.addressToEdit!.name;

      // Load data and set city context
      final cubit = context.read<AddressSearchCubit>();
      cubit.loadInitialData();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await cubit.selectCity(widget.addressToEdit!.city);
        if (!mounted) return;
        await cubit.selectStreet(widget.addressToEdit!.street);
      });
    } else {
      context.read<AddressSearchCubit>().loadInitialData();
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _houseController.dispose();
    _nameController.dispose();
    _cityFocusNode.dispose();
    _streetFocusNode.dispose();
    _houseFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.addressSearchTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<AddressSearchCubit, AddressSearchState>(
        listener: (context, state) {
          if (state is AddressSearchSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.addressSearchSaved)),
            );
            context.pop();
          }
        },
        child: BlocBuilder<AddressSearchCubit, AddressSearchState>(
          builder: (context, state) {
            if (state is AddressSearchLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AddressSearchSaving) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppSpacing.md),
                    Text(context.l10n.addressSearchSaving),
                  ],
                ),
              );
            }

            if (state is AddressSearchLoaded) {
              return _buildCascadeSelection(context, state);
            }

            if (state is AddressSearchError) {
              // Fallback for critical errors (e.g., failed to load initial data)
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        state.message,
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AddressSearchCubit>().loadInitialData();
                        },
                        child: Text(context.l10n.retry),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildCascadeSelection(
    BuildContext context,
    AddressSearchLoaded state,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instruction banner
          const InstructionBanner(),
          const SizedBox(height: AppSpacing.xl),

          // 1. City selection
          _buildCityField(context, state),
          const SizedBox(height: AppSpacing.lg),

          // 2. Street selection (enabled only after city is selected)
          _buildStreetField(context, state),
          const SizedBox(height: AppSpacing.lg),

          // 3. House selection (enabled after street is selected)
          _buildHouseField(context, state),
          const SizedBox(height: AppSpacing.lg),

          // 4. Address name (enabled after house is selected)
          _buildNameField(context, state),

          // Error message or save button
          if (state.selectedCity != null &&
              state.selectedStreet != null &&
              _houseController.text.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            if (state.errorMessage != null)
              ErrorBanner(message: state.errorMessage!)
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.addressNameRequired),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      return;
                    }

                    // Save address with entered name
                    await _saveAddress(context, state, name);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(context.l10n.addressSearchSaveButton),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveAddress(
    BuildContext context,
    AddressSearchLoaded state,
    String name,
  ) async {
    // Comprehensive validation
    if (_cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.addressValidationCity),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_streetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.addressValidationStreet),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_houseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.addressValidationHouse),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (state.selectedCity == null || state.selectedStreet == null) {
      return;
    }

    // Call selectHouse to get full address information
    final cubit = context.read<AddressSearchCubit>();
    await cubit.selectHouse(_houseController.text);

    if (!mounted) return;

    final currentState = cubit.state;
    if (currentState is AddressSearchNeedName) {
      // If editing, delete old address first
      if (widget.addressToEdit != null) {
        await cubit.deleteAddress(widget.addressToEdit!.id);
        if (!mounted) return;
      }

      // Save with entered name
      await cubit.saveAddressWithName(currentState.address, name);
    }
  }

  // Build city selection field
  Widget _buildCityField(BuildContext context, AddressSearchLoaded state) {
    return CityField(
      controller: _cityController,
      showDropdown: _showCityDropdown,
      state: state,
      addressToEdit: widget.addressToEdit,
      streetFocusNode: _streetFocusNode,
      onSelectCallback: () {
        setState(() {
          _showCityDropdown = false;
          _streetController.clear();
          _houseController.clear();
          _showStreetDropdown = false;
          _showHouseDropdown = false;
        });
      },
      onClearCallback: () {
        setState(() {
          _cityController.clear();
          _streetController.clear();
          _houseController.clear();
          _showCityDropdown = false;
          _showStreetDropdown = false;
          _showHouseDropdown = false;
        });
      },
      onDropdownChange: () {
        setState(() {
          _showCityDropdown = _cityController.text.isNotEmpty;
          // If user started editing city, reset street and house
          if (widget.addressToEdit != null &&
              _cityController.text != widget.addressToEdit!.city) {
            _streetController.clear();
            _houseController.clear();
            context.read<AddressSearchCubit>().clearCity();
          }
          _streetController.clear();
          _houseController.clear();
          _showStreetDropdown = false;
          _showHouseDropdown = false;
        });
      },
    );
  }

  // Build street selection field
  Widget _buildStreetField(BuildContext context, AddressSearchLoaded state) {
    return StreetField(
      controller: _streetController,
      cityController: _cityController,
      focusNode: _streetFocusNode,
      showDropdown: _showStreetDropdown,
      state: state,
      addressToEdit: widget.addressToEdit,
      houseFocusNode: _houseFocusNode,
      onSelectCallback: () {
        setState(() {
          _showStreetDropdown = false;
          _houseController.clear();
          _showHouseDropdown = false;
        });
      },
      onClearCallback: () {
        setState(() {
          _streetController.clear();
          _houseController.clear();
          _showStreetDropdown = false;
          _showHouseDropdown = false;
        });
      },
      onDropdownChange: () {
        setState(() {
          _showStreetDropdown = _streetController.text.isNotEmpty;
          // If user started editing street, reset house
          if (widget.addressToEdit != null &&
              _streetController.text != widget.addressToEdit!.street) {
            _houseController.clear();
          }
          _houseController.clear();
          _showHouseDropdown = false;
        });
      },
    );
  }

  // Build house selection field
  Widget _buildHouseField(BuildContext context, AddressSearchLoaded state) {
    return HouseField(
      controller: _houseController,
      cityController: _cityController,
      streetController: _streetController,
      focusNode: _houseFocusNode,
      showDropdown: _showHouseDropdown,
      state: state,
      addressToEdit: widget.addressToEdit,
      nameFocusNode: _nameFocusNode,
      onSelectCallback: () {
        setState(() {
          _showHouseDropdown = false;
        });
      },
      onDropdownChange: () {
        setState(() {
          _showHouseDropdown = _houseController.text.isNotEmpty;
        });
      },
    );
  }

  // Build name field
  Widget _buildNameField(BuildContext context, AddressSearchLoaded state) {
    return NameField(
      controller: _nameController,
      focusNode: _nameFocusNode,
      onChanged: (value) {
        setState(() {}); // Redraw to update button state
      },
    );
  }
}
