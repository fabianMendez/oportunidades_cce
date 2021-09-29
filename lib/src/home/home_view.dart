import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/buscar_entidades_view.dart';
import 'package:oportunidades_cce/src/home/buscar_procesos_view.dart';
import 'package:oportunidades_cce/src/home/mis_entidades_view.dart';
import 'package:oportunidades_cce/src/home/mis_oportunidades_view.dart';
import 'package:oportunidades_cce/src/home/mis_procesos_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MisOportunidadesView(),
          BuscarProcesosView(),
          MisProcesosView(),
          BuscarEntidadesView(),
          MisEntidadesView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Buscar entidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Mis entidades',
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
