import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';

class ProfileNameCard extends StatelessWidget {
  const ProfileNameCard({
    super.key,
    required this.screenW,
    required this.name,
  });

  final double screenW;
  final String name;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  Future<void> _editName(BuildContext context) async {
    final controller = TextEditingController(
      text: name == 'Гость' ? '' : name,
    );

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ваше имя'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Введите имя'),
          inputFormatters: [LengthLimitingTextInputFormatter(16)],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && context.mounted) {
      context.read<ProfileBloc>().add(ChangeProfileName(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardRadius = screenW * 0.04;
    final nameSize = screenW * 0.05;
    final bodySize = screenW * 0.033;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenW * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenW * 0.15,
            height: screenW * 0.15,
            decoration: const BoxDecoration(
              color: _roseLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: _rose,
              size: screenW * 0.08,
            ),
          ),
          SizedBox(width: screenW * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: nameSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: screenW * 0.01),
                GestureDetector(
                  onTap: () => _editName(context),
                  child: Text(
                    'Изменить имя',
                    style: TextStyle(
                      fontSize: bodySize,
                      color: _rose,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}