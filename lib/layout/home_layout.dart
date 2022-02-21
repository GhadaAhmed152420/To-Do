import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class home_layout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, AppStates state){
        if(state is AppInsertDBState){
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, AppStates state){
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
          ),
          body: state is! AppGetDBLoadingState ? cubit.screens[cubit.currentIndex] : const Center(child: CircularProgressIndicator()),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(cubit.isBottomSheetShown){
                if(formKey.currentState!.validate()) {
                  cubit.insertToDB(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text);
                }
              }else{
                scaffoldKey.currentState!.showBottomSheet(
                      (context) => Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType:TextInputType.text ,
                            controller: titleController,
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Title must not be empty!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.title),
                              labelText: 'Task title',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: timeController,
                            onTap: (){
                              showTimePicker(context: context, initialTime: TimeOfDay.now())
                                  .then((value) {
                                timeController.text = value!.format(context).toString();
                                print(value.format(context));
                              });
                            },
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Time must not be empty!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.watch_later_outlined),
                              labelText: 'Task time',
                              border:OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: dateController,
                            onTap: (){
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-11-22'))
                                  .then((value) {
                                dateController.text = DateFormat.yMMMd().format(value!);
                                print(DateFormat.yMMMd().format(value));
                              });
                            },
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Date must not be empty!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              labelText: 'Task date',
                              border:OutlineInputBorder(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  elevation: 20.0,
                ).closed.then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                  titleController.text = '';
                  timeController.text = '';
                  dateController.text = '';
                });
                cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_circle_outline,
                ),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: 'Archived',
              ),
            ],
          ),
        );
      },
      ),
    );
  }

}


