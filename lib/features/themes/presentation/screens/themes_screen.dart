import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../themes/presentation/widgets/themes_empty_state.dart';
import '../blocs/themes_bloc.dart';
import '../blocs/themes_event.dart';
import '../blocs/themes_state.dart';
import '../widgets/items_card.dart';
import '../widgets/themes_header.dart';
import '../widgets/themes_search_section.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemesHeader(screenW: screenW, hPad: hPad),
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
                        ThemesSearchSection(
                          screenW: screenW,
                          hPad: hPad,
                          state: state,
                          filtersExpanded: _filtersExpanded,
                          onToggleFilters: () => setState(() {
                            _filtersExpanded = !_filtersExpanded;
                          }),
                        ),
                        // карточки
                        Expanded(
                          child: state.items.isEmpty
                              ? ThemesEmptyState(
                                screenW: screenW,
                                hasAnyItems: state.allItems.isNotEmpty,
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