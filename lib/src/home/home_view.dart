import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/buscar_procesos_view.dart';
import 'package:oportunidades_cce/src/home/mis_oportunidades_view.dart';
import 'package:oportunidades_cce/src/home/mis_procesos_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MisOportunidadesView(),
          BuscarProcesosView(),
          MisProcesosView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Mis oportunidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar procesos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Mis procesos',
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
