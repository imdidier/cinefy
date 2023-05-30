import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigator extends StatelessWidget {
  const CustomBottomNavigator({Key? key}) : super(key: key);

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;
    switch (location) {
      case '/':
        return 0;
      case '/favorites':
        return 1;
      case '/categories':
        return 2;
      default:
        return 0;
    }
  }

  void onItemTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/favorites');

        break;
      case 2:
        context.go('/');

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      onTap: (value) => onItemTab(context, value),
      currentIndex: getCurrentIndex(context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: 'Categorias',
        ),
      ],
    );
  }
}
