import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/practice_question.dart';
import '../blocs/items_bloc.dart';
import '../blocs/items_event.dart';
import '../blocs/items_state.dart';
import '../widgets/result_view.dart';
import '../widgets/quiz_view.dart';
import '../widgets/shuffled_question.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../../../profile/presentation/blocs/profile_event.dart';
import '../../../profile/presentation/blocs/profile_state.dart';

import '../../../../injection.dart';
import '../../../../core/services/sound/app_sounds.dart';
import '../../../../core/services/sound/sound_interface.dart';

class ItemsPracticeScreen extends StatefulWidget {
  final String itemsId;
  final String itemsTitle;

  const ItemsPracticeScreen({
    super.key,
    required this.itemsId,
    required this.itemsTitle,
  });

  @override
  State<ItemsPracticeScreen> createState() => _ItemsPracticeScreenState();
}

class _ItemsPracticeScreenState extends State<ItemsPracticeScreen> {
  List<ShuffledQuestion> _questions = [];
  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  static const _rose = Color(0xFFE11D48);

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(LoadPractice(widget.itemsId));
  }

  // перемешиваем вопросы и варианты при получении данных
  void _initQuestions(List<PracticeQuestion> raw) {
    final shuffledList = List<PracticeQuestion>.from(raw)..shuffle(Random());
    _questions = shuffledList.map(ShuffledQuestion.from).toList();
  }

  void _select(int index, int correctIndex) {
    if (_answered) return;
    setState(() {
      _selected = index;
      _answered = true;
      if (index == correctIndex) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
    } else {

      if (_score != _questions.length) {
        sl<SoundInterface>().play(AppSounds.fail);
      } else {
        sl<SoundInterface>().play(AppSounds.success);
      }

      // тема пройдена — ProfileBloc сам решит, начислять ли опыт
      // (100% правильных + опыт по этой теме сегодня ещё не давали)
      context.read<ProfileBloc>().add(
            SubmitPracticeResult(
              itemsId: widget.itemsId,
              score: _score,
              total: _questions.length,
            ),
          );
      setState(() => _finished = true);
    }
  }

  void _restart() {
    context.read<ItemsBloc>().add(LoadPractice(widget.itemsId));
    setState(() {
      _questions = [];
      _current = 0;
      _selected = null;
      _answered = false;
      _score = 0;
      _finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenW =
        MediaQuery.of(context).size.width.clamp(0.0, 600.0);

    final double hPad = screenW * 0.05;
    final double titleSize = screenW * 0.05;
    final double questionSize = screenW * 0.04;
    final double bodySize = screenW * 0.033;
    final double tagSize = screenW * 0.026;
    final double cardRadius = screenW * 0.04;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: BlocBuilder<ItemsBloc, ItemsState>(
          builder: (context, state) {
            return switch (state) {
              ItemsLoading() => const Center(
                  child: CircularProgressIndicator(color: _rose),
                ),
              ItemsError(:final message) => Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              PracticeLoaded(:final questions) => Builder(
                  builder: (context) {
                    // инициализируем перемешанные вопросы один раз
                    if (_questions.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => _initQuestions(questions));
                      });
                      return const Center(
                        child: CircularProgressIndicator(color: _rose),
                      );
                    }
                    return _finished
                        ? BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, profileState) {
                              final earned = profileState is ProfileLoaded
                                  ? profileState.awardedPoints
                                  : null;
                              return ResultView(
                                score: _score,
                                total: _questions.length,
                                earnedExperience: earned,
                                screenW: screenW,
                                hPad: hPad,
                                titleSize: titleSize,
                                bodySize: bodySize,
                                tagSize: tagSize,
                                cardRadius: cardRadius,
                                onRestart: _restart,
                                onBack: () => Navigator.of(context).pop(),
                              );
                            },
                          )
                        : QuizView(
                            questions: _questions,
                            current: _current,
                            selected: _selected,
                            answered: _answered,
                            screenW: screenW,
                            hPad: hPad,
                            titleSize: titleSize,
                            questionSize: questionSize,
                            bodySize: bodySize,
                            tagSize: tagSize,
                            cardRadius: cardRadius,
                            itemsTitle: widget.itemsTitle,
                            onSelect: (i) =>
                                _select(i, _questions[_current].correctIndex),
                            onNext: _next,
                            onBack: () => Navigator.of(context).pop(),
                          );
                  },
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
