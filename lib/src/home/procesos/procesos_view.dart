import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/buscar_procesos_view.dart';
import 'package:oportunidades_cce/src/home/mis_procesos_view.dart';
import 'package:oportunidades_cce/src/home/user/app_menu_button.dart';

class ProcesosView extends StatelessWidget {
  const ProcesosView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // leading: const Icon(Icons.description),
          title: const Text('Procesos'),
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
            MisProcesosView(),
            BuscarProcesosView(),
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
