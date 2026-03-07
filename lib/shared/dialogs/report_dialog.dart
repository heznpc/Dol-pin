import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({super.key, required this.targetName});
  final String targetName;

  static Future<Map<String, String>?> show(
      BuildContext context, String targetName) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => ReportDialog(targetName: targetName),
    );
  }

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String? _reason;
  final _descController = TextEditingController();

  static const reasons = [
    ('scam', 'Scam / Fraud'),
    ('counterfeit', 'Counterfeit Item'),
    ('inappropriate', 'Inappropriate Content'),
    ('other', 'Other'),
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Report ${widget.targetName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a reason:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: reasons.map((r) {
                  final (value, label) = r;
                  return GestureDetector(
                    onTap: () => setState(() => _reason = value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Radio<String>(value: value),
                          Text(label),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Additional details (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _reason != null
              ? () => Navigator.pop(context, {
                    'reason': _reason!,
                    'description': _descController.text,
                  })
              : null,
          child: const Text('Report'),
        ),
      ],
    );
  }
}
