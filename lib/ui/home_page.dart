import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/blocs/tasks_cubit.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/navigation/constants/nav_bar_items.dart';
import 'package:flutter_onenote/navigation/navigation_cubit.dart';
import 'package:flutter_onenote/ui/calendar_tab.dart';
import 'package:flutter_onenote/ui/home_tab.dart';
import 'package:flutter_onenote/ui/settings_tab.dart';
import 'package:flutter_onenote/ui/widgets/bottom_sheet_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _renderShowModal() {
      return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const BottomSheetWidget();
        },
      );
    }

    return BlocProvider(
        create: (BuildContext context) => NavigationCubit(),
        child: Builder(builder: (context) {
          return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                floatingActionButton: FloatingActionButton(
                  elevation: 0,
                  onPressed: _renderShowModal,
                  child: Icon(
                    Icons.add_rounded,
                    size: 30.sp,
                  ),
                ),
                bottomNavigationBar:
                    BlocBuilder<NavigationCubit, NavigationState>(
                        builder: (context, state) {
                  return BottomNavigationBar(
                    onTap: (index) {
                      if (index == 0) {
                        BlocProvider.of<NavigationCubit>(context)
                            .getNavBarItem(NavbarItem.home);
                      } else if (index == 1) {
                        BlocProvider.of<NavigationCubit>(context)
                            .getNavBarItem(NavbarItem.calendar);
                      } else if (index == 2) {
                        BlocProvider.of<NavigationCubit>(context)
                            .getNavBarItem(NavbarItem.settings);
                      }
                    },
                    currentIndex: state.index,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.task),
                        label: 'Tasks',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today),
                        label: 'Calendar',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  );
                }),
                body: BlocBuilder<NavigationCubit, NavigationState>(
                    builder: (context, state) {
                  if (state.navbarItem == NavbarItem.home) {
                    return HomeTab();
                  } else if (state.navbarItem == NavbarItem.calendar) {
                    return const CalendarTab();
                  } else if (state.navbarItem == NavbarItem.settings) {
                    return const SettingsTab();
                  }
                  return Container();
                })),
          );
        }));
  }
}
