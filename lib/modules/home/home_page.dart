import 'package:flutter/material.dart';
import 'package:tutor/modules/agenda/agenda_page.dart';
import 'package:tutor/modules/dogwalker/dogwalkers/dogwalkers_page.dart';
import 'package:tutor/modules/home/home_controller.dart';
import 'package:tutor/modules/cachorro/meus_caes/meus_caes_page.dart';
import 'package:tutor/modules/passeio/meus_passeios/meus_passeios_page.dart';
import 'package:tutor/modules/ticket/meus_tickets/meus_tickets_page.dart';
import 'package:tutor/shared/auth/auth_controller.dart';
import 'package:tutor/shared/models/usuario_logado_model.dart';
import 'package:tutor/shared/themes/app_colors.dart';
import 'package:tutor/shared/widgets/bottom_navigation_bar/bottom_navigation_bar_widget.dart';
import 'package:tutor/shared/widgets/drawer/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = HomeController();
  final authController = AuthController();
  UsuarioLogadoModel _usuario = UsuarioLogadoModel();

  final pages = [
    MeusPasseiosPage(),
    DogwalkersPage(),
    AgendaPage(),
    MeusCaesPage(),
    MeusTicketsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: DrawerWidget(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: FutureBuilder(
            future: authController.obterSessao(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _usuario = snapshot.data as UsuarioLogadoModel;
                String fotoUrl = "";
                if (_usuario.fotoUrl != null && _usuario.fotoUrl!.isNotEmpty) {
                  fotoUrl = _usuario.fotoUrl!;
                } else {
                  fotoUrl =
                      "https://cdn4.iconfinder.com/data/icons/user-people-2/48/5-512.png";
                }
                return AppBar(
                  elevation: 0,
                  brightness: Brightness.dark,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: new Icon(Icons.list_sharp),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                "/perfil",
                              );
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.background,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                  image: NetworkImage(fotoUrl),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: AppColors.primary),
          ),
          child: ValueListenableBuilder(
            valueListenable: homeController.paginaAtual,
            builder: (context, value, child) {
              int index = value as int;
              return pages[index];
            },
          ),
        ),
        floatingActionButton: ValueListenableBuilder(
          valueListenable: homeController.paginaAtual,
          builder: (_, currentPage, __) {
            if (currentPage == 3 || currentPage == 4) {
              return FloatingActionButton(
                onPressed: () {
                  if (currentPage == 3) {
                    Navigator.pushReplacementNamed(context, "/cachorro/add");
                  }
                  if (currentPage == 4) {
                    Navigator.pushReplacementNamed(context, "/ticket/add");
                  }
                },
                child: Icon(Icons.add),
              );
            } else {
              return Container();
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBarWidget(
          paginaAtual: homeController.paginaAtual.value,
        ),
      ),
    );
  }
}
