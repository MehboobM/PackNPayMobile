import 'package:flutter/material.dart';
import 'package:pack_n_pay/screens/setting_helpsupport/widget/terms&condition.dart';
import 'package:pack_n_pay/utils/m_font_styles.dart';

class TermsConditionsCard extends StatelessWidget {
  final String title;
  final String terms;
  final ValueChanged<String> onSaved;

  const TermsConditionsCard({
    super.key,
    required this.title,
    required this.terms,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title, style: TextStyles.f14w600Gray9),
        subtitle: Text(
          terms.isEmpty ? "Add terms & conditions" : terms,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.edit),
        onTap: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (_) =>
                TermsConditionsDialog(initialText: terms),
          );

          if (result != null) {
            onSaved(result);
          }
        },
      ),
    );
  }
}