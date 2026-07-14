import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';
import '../blocs/profile_state.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  Future<void> _editName(BuildContext context, String currentName) async {
    final controller = TextEditingController(
      text: currentName == 'Гость' ? '' : currentName,
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
    final double screenW =
        MediaQuery.of(context).size.width.clamp(0.0, 600.0);

    final double hPad = screenW * 0.05;
    final double titleSize = screenW * 0.06;
    final double nameSize = screenW * 0.05;
    final double bodySize = screenW * 0.033;
    final double cardRadius = screenW * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is! ProfileLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: _rose),
              );
            }

            final profile = state.profile;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                  hPad, screenW * 0.04, hPad, hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Профиль',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: screenW * 0.06),

                  // ── Карточка имени ─────────────────────────────
                  Container(
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
                                profile.name,
                                style: TextStyle(
                                  fontSize: nameSize,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              SizedBox(height: screenW * 0.01),
                              GestureDetector(
                                onTap: () =>
                                    _editName(context, profile.name),
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
                  ),

                  SizedBox(height: screenW * 0.04),

                  // ── Карточка опыта ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenW * 0.05),
                    decoration: BoxDecoration(
                      color: _roseLight,
                      borderRadius: BorderRadius.circular(cardRadius),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: screenW * 0.13,
                          height: screenW * 0.13,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.bolt_rounded,
                            color: _rose,
                            size: screenW * 0.07,
                          ),
                        ),
                        SizedBox(width: screenW * 0.04),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profile.experience}',
                              style: TextStyle(
                                fontSize: nameSize * 1.1,
                                fontWeight: FontWeight.w800,
                                color: _rose,
                              ),
                            ),
                            Text(
                              'очков опыта',
                              style: TextStyle(
                                fontSize: bodySize,
                                color: _rose,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenW * 0.04),

                  Text(
                    'Опыт даётся за первое полностью правильное прохождение практики по теме в течение дня. '
                    'В других случаях опыт не начисляется.',
                    style: TextStyle(
                      fontSize: bodySize,
                      color: Colors.grey.shade500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
