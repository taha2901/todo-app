import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/features/archieve/archieve.dart';
import 'package:todo/features/done/done.dart';
import 'package:todo/features/home/ui/home.dart';
part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  static LayoutCubit get(context) => BlocProvider.of(context);

  late final List<Widget> screens;
  List<Map> tasks = [];
  Database? database;

  bool isDark = false; // إضافة خاصية لتخزين حالة الوضع

  LayoutCubit() : super(LayoutInitial()) {
    screens = [
      const HomeScreen(),
      const DoneScreen(),
      const ArchieveScreen(),
    ];
  }

  int currentIndex = 0;

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(LayoutChangeBottomNavBarState());
  }

  List<String> titles = [
    'Home',
    'Done',
    'Archieve',
  ];

  List<BottomNavigationBarItem> getBottomItems() {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Iconsax.home),
        label: titles[0],
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.done),
        label: titles[1],
      ),
      BottomNavigationBarItem(
        icon: const Icon(Iconsax.archive),
        label: titles[2],
      ),
    ];
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        debugPrint('Database created');
        await database
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
        )
            .then((value) {
          debugPrint('Table created');
        }).catchError((error) {
          debugPrint('Error When Creating Table: ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        debugPrint('Database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database?.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")');
    }).then((value) {
      debugPrint('Inserted Successfully');
      emit(AppInsertDatabaseState());
      getDataFromDatabase(database!);
    }).catchError((error) {
      debugPrint('Error When Inserting New Record: ${error.toString()}');
    });
  }

  void getDataFromDatabase(database) {
    tasks = [];
    // emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        tasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateData({required String status, required int id}) {
    database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database!);
    });
  }

  void deleteData({required int id}) {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database!);
    });
  }

  // void toggleTheme() {
  //   isDark = !isDark; // تبديل حالة الوضع
  //   emit(LayoutChangeThemeState()); // أرسل حالة جديدة لتحديث الواجهة
  // }

 

  void toggleTheme() {
    isDark = !isDark;
    emit(LayoutChangeThemeState());
  }

  ThemeData getTheme() {
    return isDark ? ThemeData.dark() : ThemeData.light();
  }

  Future<List<Map>> searchTasks(String query) async {
    final List<Map> results = await database!.rawQuery(
      'SELECT * FROM tasks WHERE title LIKE ?',
      ['%$query%'], // البحث عن المهام التي تحتوي على النص المدخل
    );
    return results;
  }

  void updateTask({
    required int id,
    required String title,
    required String time,
    required String date,
  }) {
    database?.rawUpdate(
        'UPDATE tasks SET title = ?, time = ?, date = ? WHERE id = ?',
        [title, time, date, id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database!); // تحديث عرض البيانات بعد التعديل
    });
  }

  void deleteDataById({required int id}) {
    database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database!); // إعادة تحميل البيانات بعد الحذف
    });
  }
}
