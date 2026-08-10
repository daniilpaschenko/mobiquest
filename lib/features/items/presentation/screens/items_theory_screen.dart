import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/items_bloc.dart';
import '../blocs/items_event.dart';
import '../blocs/items_state.dart';
import '../widgets/theory_card.dart';
import '../widgets/theory_header.dart';
import '../widgets/theory_title.dart';
import '../widgets/theory_practice_button.dart';

class ItemsTheoryScreen extends StatefulWidget {
  final String itemsId;
  final String itemsTitle;

  const ItemsTheoryScreen({
    super.key,
    required this.itemsId,
    required this.itemsTitle,
  });

  @override
  State<ItemsTheoryScreen> createState() => _ItemsTheoryScreenState();
}

class _ItemsTheoryScreenState extends State<ItemsTheoryScreen> {
  // ListView recycling не потеряет состояние
  final Map<int, bool> _expanded = {};

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  @override
  void initState() {
    super.initState();
    context.read<ItemsBloc>().add(LoadTheory(widget.itemsId));
  }

  @override
  Widget build(BuildContext context) {
    final double screenW =
        MediaQuery.of(context).size.width.clamp(0.0, 600.0);

    final double hPad = screenW * 0.05;
    final double titleSize = screenW * 0.055;
    final double sectionTitleSize = screenW * 0.038;
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
              TheoryLoaded(:final sections) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // хедер
                    TheoryHeader(
                      hPad: hPad,
                      screenW: screenW,
                      tagSize: tagSize,
                      rose: _rose,
                      roseLight: _roseLight,
                      onBack: () => Navigator.of(context).pop(),
                    ),

                    // заголовок
                    TheoryTitle(
                      title: widget.itemsTitle,
                      hPad: hPad,
                      screenW: screenW,
                      titleSize: titleSize,
                    ),

                    // список карточек
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                            hPad, 0, hPad, screenW * 0.06),
                        itemCount: sections.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: screenW * 0.035),
                        itemBuilder: (context, index) => TheoryCard(
                          section: sections[index],
                          index: index,
                          expanded: _expanded[index] ?? false,
                          onToggle: () => setState(
                            () => _expanded[index] = !(_expanded[index] ?? false),
                          ),
                          cardRadius: cardRadius,
                          sectionTitleSize: sectionTitleSize,
                          bodySize: bodySize,
                          tagSize: tagSize,
                          screenW: screenW,
                        ),
                      ),
                    ),

                    // кнопка к практике
                    TheoryPracticeButton(
                      hPad: hPad,
                      screenW: screenW,
                      bodySize: bodySize,
                      cardRadius: cardRadius,
                      rose: _rose,
                      onPressed: () => context.go(
                        '/themes/items/${widget.itemsId}/practice',
                        extra: widget.itemsTitle,
                      ),
                    ),
                  ],
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
