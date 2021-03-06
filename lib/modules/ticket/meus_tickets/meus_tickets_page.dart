import 'package:flutter/material.dart';
import 'package:tutor/modules/ticket/meu_saldo_tile/meu_saldo_tile_widget.dart';
import 'package:tutor/modules/ticket/meus_tickets_list/meus_tickets_list_widget.dart';
import 'package:tutor/shared/widgets/title_page_widget/title_page_widget.dart';

class MeusTicketsPage extends StatefulWidget {
  const MeusTicketsPage({Key? key}) : super(key: key);

  @override
  _MeusTicketsPageState createState() => _MeusTicketsPageState();
}

class _MeusTicketsPageState extends State<MeusTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: Column(
        children: [
          TitlePageWidget(
            title: "Meus tickets",
          ),
          MeuSaldoTileWidget(),
          MeusTicketsListWidget(),
        ],
      ),
    );
  }
}
