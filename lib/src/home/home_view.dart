import 'package:flutter/material.dart';
import 'package:oportunidades_cce/src/home/entidades/entidades_view.dart';
import 'package:oportunidades_cce/src/home/mis_oportunidades_view.dart';
import 'package:oportunidades_cce/src/home/procesos/procesos_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MisOportunidadesView(),
          ProcesosView(),
          EntidadesView(),
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
            icon: Icon(Icons.auto_awesome),
            label: 'Oportunidades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Procesos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Entidades',
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
