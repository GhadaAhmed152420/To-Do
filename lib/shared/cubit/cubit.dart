import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
  late Database db;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDB(){
   openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created!');
        db.execute('CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)').then((value) {
          print('table created!');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (db) {
        getDataFromDB(db);
        print('database opened!');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDBState());
   });
  }

  insertToDB({
    required String title,
    required String time,
    required String date,
  })async {
    await db.transaction((txn)async{
      txn.rawInsert('INSERT INTO tasks(title, time, date, status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('$value inserted successfully!');
        getDataFromDB(db);
        emit(AppInsertDBState());
      }).catchError((error){
        print('error when inserting data ${error.toString()}');
      });
      return null;
    });
  }
  void getDataFromDB(db){
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDBLoadingState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });

      emit(AppGetDBrState());
    });

  }

  updateGetData({
    required String status,
    required int id,
  })async{
    db.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id ]).then((value) {
          getDataFromDB(db);
          emit(AppUpdateDBState());
    });
  }

  deleteData({
    required int id,
  })async{
    db.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
      .then((value) {
        getDataFromDB(db);
      emit(AppDeleteDBState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,
}){
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}