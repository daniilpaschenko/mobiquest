import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/tech_chip.dart';
import '../widgets/contact_tile.dart';
import '../widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenW =
        MediaQuery.of(context).size.width.clamp(0.0, 600.0);

    final double hPad = screenW * 0.05;
    final double sectionTitleSize = screenW * 0.042;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
              hPad, screenW * 0.05, hPad, screenW * 0.08),
          children: [
            // хедер
            HomeHeader(screenW: screenW),

            SizedBox(height: screenW * 0.07),

            // о приложении
            InfoCard(
              icon: Icons.info_outline_rounded,
              title: 'Зачем это приложение',
              body: 'MobiQuest создан как вспомогательный инструмент для '
                  'закрепления знаний по мобильной разработке — короткая '
                  'теория и практика по темам, чтобы освежить в памяти уже '
                  'изученный материал.\n\n'
                  'Это не самостоятельный курс: полноценно учиться по нему '
                  'не стоит. Используйте приложение как повторение того, '
                  'что уже разбирали по документации, курсам или на '
                  'практике — а не как единственный источник знаний.',
              screenW: screenW,
            ),

            SizedBox(height: screenW * 0.035),

            // приватность
            InfoCard(
              icon: Icons.lock_outline_rounded,
              title: 'Приватность прежде всего',
              body: 'Никакой регистрации и аккаунтов. Всё, что вы проходите '
                  '— имя профиля и накопленный опыт — хранится только '
                  'локально на вашем устройстве и никуда не отправляется. '
                  'Удалили приложение — удалили данные.',
              screenW: screenW,
            ),

            SizedBox(height: screenW * 0.07),

            // технологии
            Text(
              'На чём построено',
              style: TextStyle(
                fontSize: sectionTitleSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: screenW * 0.01),
            Text(
              'Кстати, по многим из этих технологий в приложении уже есть '
              'темы — так что заодно можно посмотреть, как оно устроено '
              'изнутри 👀',
              style: TextStyle(
                fontSize: screenW * 0.032,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            SizedBox(height: screenW * 0.035),
            Wrap(
              spacing: screenW * 0.025,
              runSpacing: screenW * 0.025,
              children: [
                TechChip(icon: Icons.flutter_dash_rounded, label: 'Flutter', screenW: screenW),
                TechChip(icon: Icons.code_rounded, label: 'Dart', screenW: screenW),
                TechChip(icon: Icons.account_tree_rounded, label: 'BLoC', screenW: screenW),
                TechChip(icon: Icons.alt_route_rounded, label: 'go_router', screenW: screenW),
                TechChip(icon: Icons.storage_rounded, label: 'Hive', screenW: screenW),
                TechChip(icon: Icons.cloud_outlined, label: 'Dio', screenW: screenW),
                TechChip(icon: Icons.inventory_2_outlined, label: 'GetIt / DI', screenW: screenW),
                TechChip(icon: Icons.architecture_rounded, label: 'Clean Architecture', screenW: screenW),
              ],
            ),

            SizedBox(height: screenW * 0.07),

            // контакты
            Text(
              'Автор',
              style: TextStyle(
                fontSize: sectionTitleSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: screenW * 0.01),
            Text(
              'Нашли баг или есть идея — пишите, буду рад обратной связи.',
              style: TextStyle(
                fontSize: screenW * 0.032,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            SizedBox(height: screenW * 0.035),
            ContactTile(
              icon: Icons.telegram_rounded,
              label: 'Telegram',
              value: '@daniil_paschenko',
              screenW: screenW,
            ),
            SizedBox(height: screenW * 0.025),
            ContactTile(
              icon: Icons.code_rounded,
              label: 'GitHub',
              value: 'github.com/daniilpaschenko',
              screenW: screenW,
            ),

            SizedBox(height: screenW * 0.05),

            Center(
              child: Text(
                'Сделано с ❤️ для тех, кто учит Flutter',
                style: TextStyle(
                  fontSize: screenW * 0.0275,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
