import 'package:flutter/material.dart';
import 'package:tutor/modules/passeio/meus_passeios/meus_passeios_controller.dart';
import 'package:tutor/shared/enum/state_enum.dart';
import 'package:tutor/shared/themes/app_colors.dart';
import 'package:tutor/shared/themes/app_images.dart';
import 'package:tutor/shared/themes/app_text_styles.dart';
import 'package:tutor/shared/widgets/shimmer_list_tile/shimmer_list_tile.dart';

class MeusPasseiosListWidget extends StatefulWidget {
  const MeusPasseiosListWidget({Key? key}) : super(key: key);

  @override
  _MeusPasseiosListWidgetState createState() => _MeusPasseiosListWidgetState();
}

class _MeusPasseiosListWidgetState extends State<MeusPasseiosListWidget> {
  final controller = MeusPasseiosController();

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    await controller.buscarTodos();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: ValueListenableBuilder(
        valueListenable: controller.state,
        builder: (_, value, __) {
          StateEnum state = value as StateEnum;
          if (state == StateEnum.loading) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ShimmerListTileWidget();
                  },
                ),
              ),
            );
          } else if (state == StateEnum.success) {
            if (controller.passeios.isNotEmpty) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await controller.buscarTodos();
                    },
                    child: ListView.builder(
                      itemCount: controller.passeios.length,
                      itemBuilder: (context, index) {
                        Color colorStatus;
                        String status = controller.passeios[index].status!;

                        if (status == "Aceito") {
                          colorStatus = Colors.green;
                        } else if (status == "Recusado") {
                          colorStatus = AppColors.delete;
                        } else if (status == "Espera") {
                          colorStatus = Colors.amber;
                        } else if (status == "Andamento") {
                          colorStatus = Colors.teal;
                        } else {
                          colorStatus = Colors.black;
                        }

                        return Column(
                          children: [
                            Container(
                              color: AppColors.shape,
                              child: ListTile(
                                title: Text(
                                  controller.passeios[index].dogwalker!.nome!,
                                  style: TextStyles.buttonBoldGray,
                                ),
                                subtitle: Text.rich(
                                  TextSpan(
                                    text: "#" +
                                        controller.passeios[index].id!
                                            .toString() +
                                        " | ",
                                    children: [
                                      TextSpan(
                                        text:
                                            controller.passeios[index].status!,
                                      )
                                    ],
                                  ),
                                ),
                                leading: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      image:
                                          AssetImage(AppImages.logoDogwalker),
                                    ),
                                  ),
                                ),
                                trailing: Text(
                                  controller.getFormatedDate(
                                      controller.passeios[index].datahora!),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 13,
                              ),
                              child: Container(
                                width: size.width,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: colorStatus,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    child: Text(
                      "Você ainda não solicitou nenhum passeio.",
                      style: TextStyles.input,
                    ),
                  ),
                ),
              );
            }
          } else {
            return Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Ocorreu um problema inesperado.",
                      style: TextStyles.input,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        controller.buscarTodos();
                      },
                      icon: Icon(Icons.refresh_outlined),
                      label: Text("Tentar novamente"),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}