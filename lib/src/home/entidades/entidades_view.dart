import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/buscar_entidades_view.dart';
import 'package:oportunidades_cce/src/home/mis_entidades_view.dart';
import 'package:oportunidades_cce/src/home/widgets/logout_button.dart';

class EntidadesView extends StatelessWidget {
  const EntidadesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entidades'),
          actions: const [LogoutButton()],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'SIGUIENDO'),
              Tab(text: 'BUSCAR'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MisEntidadesView(),
            BuscarEntidadesView(),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
