import 'package:flutter/material.dart';
import 'package:generics_components_flutter/generics_components_flutter.dart';

class UnitDropdownField extends StatelessWidget {
  final String? selectedUnit;
  final Function(String?) onChanged;
  final Size sizeScreen;

  const UnitDropdownField({
    super.key,
    required this.selectedUnit,
    required this.onChanged,
    required this.sizeScreen,
  });

  static const List<String> unitOptions = ['kg (quilograms)', 'l (litros)', 'g (gramas)', 'dz (dezenas)'];

  @override
  Widget build(BuildContext context) {
    return DropdownField(
      sizeScreen: sizeScreen,
      hint: 'Unidade',
      hintColor: const Color(0xFFD5C1A1),
      textColor: const Color(0xFFD5C1A1),
      borderColor: const Color(0xFF4CAF50),
      fillColor: Colors.transparent,
      iconColor: const Color(0xFFD5C1A1),
      labelColor: const Color(0xFF4CAF50),
      dropdownColor: Colors.grey[900],
      opcoesDeSelecao: unitOptions,
      value: selectedUnit,
      onChanged: onChanged,
    );
  }
}
