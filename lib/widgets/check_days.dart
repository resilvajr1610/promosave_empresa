import '../Utils/export.dart';

class CheckDays extends StatelessWidget {
  final check;
  final onChanged;

  CheckDays({required this.check, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        activeColor: PaletteColor.primaryColor,
        value: check,
        onChanged:onChanged
    );
  }
}
