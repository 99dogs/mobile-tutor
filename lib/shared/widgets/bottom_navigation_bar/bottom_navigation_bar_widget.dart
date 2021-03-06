import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tutor/modules/home/home_controller.dart';
import 'package:tutor/shared/themes/app_colors.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int paginaAtual;
  const BottomNavigationBarWidget({Key? key, required this.paginaAtual})
      : super(key: key);

  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: homeController.paginaAtual,
      builder: (context, value, child) {
        return BottomNavigationBar(
          iconSize: 28,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Passeios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search_outlined),
              label: 'Dog walkers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_outlined),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets_outlined),
              label: 'Cachorros',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.receipt),
              label: 'Tickets',
            ),
          ],
          currentIndex: homeController.paginaAtual.value,
          selectedItemColor: AppColors.delete,
          onTap: homeController.mudarDePagina,
        );
      },
    );
  }
}
