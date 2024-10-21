part of 'layout_cubit.dart';


abstract class LayoutState {}

class LayoutInitial extends LayoutState {}

class LayoutChangeBottomNavBarState extends LayoutState {}

class AppCreateDatabaseState extends LayoutState {}
class AppGetLoadDatabaseState extends LayoutState {}

class AppGetDatabaseState extends LayoutState {}
class AppInsertDatabaseState extends LayoutState {}
class AppUpdateDatabaseState extends LayoutState {}
class AppDeleteDatabaseState extends LayoutState {}

class LayoutChangeThemeState extends LayoutState {}

class LayoutChangeLanguageState extends LayoutState {}