import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'constants/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.home, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(const NavigationState(NavbarItem.home, 0));
        break;
      case NavbarItem.calendar:
        emit(const NavigationState(NavbarItem.calendar, 1));
        break;
      case NavbarItem.settings:
        emit(const NavigationState(NavbarItem.settings, 2));
        break;
    }
  }
}
