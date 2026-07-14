import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/themes_bloc.dart';
import '../blocs/themes_event.dart';
import '../blocs/themes_state.dart';
import '../widgets/items_card.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  static const _rose = Color(0xFFE11D48);

  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<ThemesBloc>().add(const LoadItems());
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width.clamp(0.0, 600.0);

    final double hPad = screenW * 0.05;
    final double titleSize = screenW * 0.06;
    final double subtitleSize = screenW * 0.032;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // хедер
            Padding(
              padding: EdgeInsets.fromLTRB(
                hPad,
                screenW * 0.05,
                hPad,
                screenW * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Темы',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: screenW * 0.01),
                  Text(
                    'Выбери тему — изучи теорию, а затем проверь знания!',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenW * 0.03),
            // список
            Expanded(
              child: BlocBuilder<ThemesBloc, ThemesState>(
                builder: (context, state) {
                  return switch (state) {
                    ThemesLoading() || ThemesInitial() => const Center(
                      child: CircularProgressIndicator(color: _rose),
                    ),
                    ThemesError(:final message) => Center(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    ThemesLoaded() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // поиск и теги
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            hPad,
                            0,
                            hPad,
                            screenW * 0.02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText:'Поиск по темам или описанию...',
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                            ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF9FAFB),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            screenW * 0.03,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: screenW * 0.03,
                                          horizontal: screenW * 0.03,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        context.read<ThemesBloc>().add(
                                          FilterItems(
                                            query: value,
                                            selectedTags: state.selectedTags,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (state.availableTags.isNotEmpty) ...[
                                    SizedBox(width: screenW * 0.02),
                                    _FilterToggleButton(
                                      expanded: _filtersExpanded,
                                      activeCount: state.selectedTags.length,
                                      screenW: screenW,
                                      onTap: () => setState(() {
                                        _filtersExpanded = !_filtersExpanded;
                                      }),
                                    ),
                                  ],
                                ],
                              ),
                              // выдвижной список тегов
                              if (state.availableTags.isNotEmpty)
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  alignment: Alignment.topCenter,
                                  child: !_filtersExpanded
                                      ? const SizedBox.shrink()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                            top: screenW * 0.025,
                                          ),
                                          child: Wrap(
                                            spacing: screenW * 0.02,
                                            runSpacing: screenW * 0.015,
                                            children: state.availableTags.map((
                                              tag,
                                            ) {
                                              final selected = state
                                                  .selectedTags
                                                  .contains(tag);
                                              return _TagFilterChip(
                                                label: tag,
                                                selected: selected,
                                                screenW: screenW,
                                                onTap: () {
                                                  final newTags =
                                                      Set<String>.from(
                                                        state.selectedTags,
                                                      );
                                                  if (selected) {
                                                    newTags.remove(tag);
                                                  } else {
                                                    newTags.add(tag);
                                                  }
                                                  context
                                                      .read<ThemesBloc>()
                                                      .add(
                                                        FilterItems(
                                                          query: state.query,
                                                          selectedTags: newTags,
                                                        ),
                                                      );
                                                },
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                ),
                            ],
                          ),
                        ),
                        // карточки
                        Expanded(
                          child: state.items.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.folder_open_rounded,
                                        size: screenW * 0.15,
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                      SizedBox(height: screenW * 0.03),
                                      Text(
                                        state.allItems.isEmpty
                                            ? 'Темы пока не добавлены'
                                            : 'Ничего не найдено',
                                        style: TextStyle(
                                          fontSize: subtitleSize,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    hPad,
                                    0,
                                    hPad,
                                    screenW * 0.06,
                                  ),
                                  itemCount: state.items.length,
                                  separatorBuilder: (_, _) =>
                                      SizedBox(height: screenW * 0.035),
                                  itemBuilder: (context, index) {
                                    final item = state.items[index];
                                    return ItemsCard(
                                      item: item,
                                      screenW: screenW,
                                      onTheory: () => context.go(
                                        '/themes/items/${item.id}/theory',
                                        extra: item.title,
                                      ),
                                      onPractice: () => context.go(
                                        '/themes/items/${item.id}/practice',
                                        extra: item.title,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// кнопка-тоггл для фильтров
class _FilterToggleButton extends StatelessWidget {
  final bool expanded;
  final int activeCount;
  final double screenW;
  final VoidCallback onTap;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const _FilterToggleButton({
    required this.expanded,
    required this.activeCount,
    required this.screenW,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasActive = activeCount > 0;

    return Material(
      color: hasActive ? _rose : _roseLight,
      borderRadius: BorderRadius.circular(screenW * 0.03),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenW * 0.03),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03,
            vertical: screenW * 0.03,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: screenW * 0.045,
                color: hasActive ? Colors.white : _rose,
              ),
              if (hasActive) ...[
                SizedBox(width: screenW * 0.012),
                Text(
                  '$activeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: screenW * 0.03,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// чип тега

class _TagFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final double screenW;
  final VoidCallback onTap;

  static const _rose = Color(0xFFE11D48);
  static const _roseLight = Color(0xFFFFF1F2);

  const _TagFilterChip({
    required this.label,
    required this.selected,
    required this.screenW,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _rose : _roseLight,
      borderRadius: BorderRadius.circular(screenW * 0.03),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenW * 0.03),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03,
            vertical: screenW * 0.018,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  Icons.check_rounded,
                  size: screenW * 0.032,
                  color: Colors.white,
                ),
                SizedBox(width: screenW * 0.01),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: screenW * 0.028,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}