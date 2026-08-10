import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/themes_bloc.dart';
import '../blocs/themes_event.dart';
import '../blocs/themes_state.dart';
import '../widgets/tag_filter_chip.dart';
import '../widgets/filter_toggle_button.dart';

class ThemesSearchSection extends StatelessWidget {
  const ThemesSearchSection({
    super.key,
    required this.screenW,
    required this.hPad,
    required this.state,
    required this.filtersExpanded,
    required this.onToggleFilters,
  });

  final double screenW;
  final double hPad;
  final ThemesLoaded state;
  final bool filtersExpanded;
  final VoidCallback onToggleFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, screenW * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск по темам или описанию...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenW * 0.03),
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
                FilterToggleButton(
                  expanded: filtersExpanded,
                  activeCount: state.selectedTags.length,
                  screenW: screenW,
                  onTap: onToggleFilters,
                ),
              ],
            ],
          ),
          if (state.availableTags.isNotEmpty)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: !filtersExpanded
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.only(top: screenW * 0.025),
                      child: Wrap(
                        spacing: screenW * 0.02,
                        runSpacing: screenW * 0.015,
                        children: state.availableTags.map((tag) {
                          final selected = state.selectedTags.contains(tag);
                          return TagFilterChip(
                            label: tag,
                            selected: selected,
                            screenW: screenW,
                            onTap: () {
                              final newTags = Set<String>.from(state.selectedTags);
                              if (selected) {
                                newTags.remove(tag);
                              } else {
                                newTags.add(tag);
                              }
                              context.read<ThemesBloc>().add(
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
    );
  }
}