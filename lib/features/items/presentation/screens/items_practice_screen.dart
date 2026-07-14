import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/practice_question.dart';
import '../blocs/items_bloc.dart';
import '../blocs/items_event.dart';
import '../blocs/items_state.dart';
import '../widgets/option_tile.dart';
import '../widgets/result_view.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';
import '../../../profile/presentation/blocs/profile_event.dart';
import '../../../profile/presentation/blocs/profile_state.dart';

// вопрос с перемешанными вариантами и пересчитанным correctIndex
class _ShuffledQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const _ShuffledQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory _ShuffledQuestion.from(PracticeQuestion q) {
    final correctAnswer = q.options[q.correctIndex];
    final shuffled = List<String>.from(q.options)..shuffle(Random());
    return _ShuffledQuestion(
      question: q.question,
      options: shuffled,
      correctIndex: shuffled.indexOf(correctAnswer),
      explanation: q.explanation,
    );
  }
}

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
  List<_ShuffledQuestion> _questions = [];
  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  static const _rose = Color(0xFFE11D48);
/*   static const _roseLight = Color(0xFFFFF1F2);
  static const _green = Color(0xFF16A34A);
  static const _greenLight = Color(0xFFF0FDF4); */

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(LoadPractice(widget.itemsId));
  }

  // Перемешиваем вопросы и варианты при получении данных
  void _initQuestions(List<PracticeQuestion> raw) {
    final shuffledList = List<PracticeQuestion>.from(raw)..shuffle(Random());
    _questions = shuffledList.map(_ShuffledQuestion.from).toList();
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
                    // Инициализируем перемешанные вопросы один раз
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
                        : _QuizView(
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

// ── Квиз ─────────────────────────────────────────────────────────────────────

class _QuizView extends StatelessWidget {
  final List<_ShuffledQuestion> questions;
  final int current;
  final int? selected;
  final bool answered;
  final double screenW;
  final double hPad;
  final double titleSize;
  final double questionSize;
  final double bodySize;
  final double tagSize;
  final double cardRadius;
  final String itemsTitle;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);
  static const _green = Color(0xFF16A34A);
  static const _greenLight = Color(0xFFF0FDF4);

  const _QuizView({
    required this.questions,
    required this.current,
    required this.selected,
    required this.answered,
    required this.screenW,
    required this.hPad,
    required this.titleSize,
    required this.questionSize,
    required this.bodySize,
    required this.tagSize,
    required this.cardRadius,
    required this.itemsTitle,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final q = questions[current];
    final isCorrect = selected == q.correctIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Хедер ──────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(
              hPad * 0.5, screenW * 0.02, hPad, screenW * 0.01),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: _rose,
                iconSize: screenW * 0.05,
                onPressed: onBack,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenW * 0.03,
                  vertical: screenW * 0.012,
                ),
                decoration: BoxDecoration(
                  color: _roseLight,
                  borderRadius: BorderRadius.circular(screenW * 0.05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded,
                        color: _rose, size: screenW * 0.038),
                    SizedBox(width: screenW * 0.012),
                    Text(
                      'Практика',
                      style: TextStyle(
                        color: _rose,
                        fontSize: tagSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Заголовок + счётчик ─────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(
              hPad, screenW * 0.01, hPad, screenW * 0.025),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  itemsTitle,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                '${current + 1} / ${questions.length}',
                style: TextStyle(
                  fontSize: tagSize,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // ── Прогресс-бар ────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.04),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenW * 0.015),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                  begin: 0, end: (current + 1) / questions.length),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: screenW * 0.015,
                backgroundColor: const Color(0x33FDA4AF),
                valueColor: const AlwaysStoppedAnimation<Color>(_rose),
              ),
            ),
          ),
        ),

        // ── Вопрос + варианты ───────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Карточка вопроса
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
                  child: Text(
                    q.question,
                    style: TextStyle(
                      fontSize: questionSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                      height: 1.4,
                    ),
                  ),
                ),

                SizedBox(height: screenW * 0.04),

                // Варианты
                ...List.generate(
                  q.options.length,
                  (i) => Padding(
                    padding: EdgeInsets.only(bottom: screenW * 0.025),
                    child: OptionTile(
                      label: q.options[i],
                      index: i,
                      selected: selected == i,
                      answered: answered,
                      isCorrect: i == q.correctIndex,
                      bodySize: bodySize,
                      tagSize: tagSize,
                      screenW: screenW,
                      cardRadius: cardRadius,
                      onTap: () => onSelect(i),
                    ),
                  ),
                ),

                // Пояснение
                if (answered)
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenW * 0.04),
                      decoration: BoxDecoration(
                        color: isCorrect ? _greenLight : _roseLight,
                        borderRadius: BorderRadius.circular(cardRadius),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0xFF86EFAC)
                              : const Color(0xFFFDA4AF),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isCorrect
                                ? Icons.check_circle_rounded
                                : Icons.info_rounded,
                            color: isCorrect ? _green : _rose,
                            size: screenW * 0.045,
                          ),
                          SizedBox(width: screenW * 0.025),
                          Expanded(
                            child: Text(
                              q.explanation,
                              style: TextStyle(
                                fontSize: bodySize,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ── Кнопка Далее ────────────────────────────────────────────
        if (answered)
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.05),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(
                  backgroundColor: _rose,
                  padding:
                      EdgeInsets.symmetric(vertical: screenW * 0.038),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(cardRadius),
                  ),
                ),
                child: Text(
                  current < questions.length - 1
                      ? 'Следующий вопрос'
                      : 'Завершить тест',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: bodySize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}