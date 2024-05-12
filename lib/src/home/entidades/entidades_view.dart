import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/buscar_entidades_view.dart';
import 'package:oportunidades_cce/src/home/mis_entidades_view.dart';
import 'package:oportunidades_cce/src/home/user/app_menu_button.dart';

class EntidadesView extends StatelessWidget {
  const EntidadesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entidades'),
          actions: const [
            AppMenuButton(),
          ],
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
