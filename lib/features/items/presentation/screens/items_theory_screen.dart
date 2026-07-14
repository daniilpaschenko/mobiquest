import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/items_bloc.dart';
import '../blocs/items_event.dart';
import '../blocs/items_state.dart';
import '../widgets/theory_card.dart';

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
  //  ListView recycling не потеряет состояние
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
                    // ── Хедер ──────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad * 0.5, screenW * 0.02, hPad, screenW * 0.01),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: _rose,
                            iconSize: screenW * 0.05,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenW * 0.03,
                              vertical: screenW * 0.012,
                            ),
                            decoration: BoxDecoration(
                              color: _roseLight,
                              borderRadius:
                                  BorderRadius.circular(screenW * 0.05),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_stories_rounded,
                                    color: _rose, size: screenW * 0.038),
                                SizedBox(width: screenW * 0.015),
                                Text(
                                  'Теория',
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

                    // ── Заголовок ────────────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad, screenW * 0.01, hPad, screenW * 0.02),
                      child: Text(
                        widget.itemsTitle,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                      ),
                    ),

                    // ── Список карточек ──────────────────────────────
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

                    // ── Кнопка к практике ────────────────────────────
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          hPad, 0, hPad, screenW * 0.05),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => context.go(
                            '/themes/items/${widget.itemsId}/practice',
                            extra: widget.itemsTitle,
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: _rose,
                            padding: EdgeInsets.symmetric(
                                vertical: screenW * 0.038),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(cardRadius),
                            ),
                          ),
                          child: Text(
                            'Перейти к практике →',
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
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}