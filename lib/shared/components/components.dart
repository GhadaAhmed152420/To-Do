import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model,context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child:Text(
  
              '${model['time']}'
  
          ),
  
        ),
  
        const SizedBox(
  
          width: 20.0,
  
        ),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            crossAxisAlignment: CrossAxisAlignment.start,
  
            children: [
  
              Text(
  
                '${model['title']}',
  
                style: TextStyle(
  
                  fontWeight: FontWeight.bold,
  
                  fontSize:18.0,
  
                ),
  
              ),
  
              Text(
  
                '${model['date']}',
  
                style: TextStyle(
  
                  color: Colors.grey,
  
                ),
  
              ),
  
            ],
  
          ),
  
        ),
  
        SizedBox(
  
          width: 20.0,
  
        ),
  
        IconButton(
  
            icon: Icon(
  
              Icons.check_box,
  
              color: Colors.green[700],
  
            ),
  
            onPressed: (){
  
              AppCubit.get(context).updateGetData(status: 'done', id: model['id']);
  
            }),
  
        IconButton(
  
            icon: Icon(
  
              Icons.archive,
  
              color: Colors.black45,
  
            ),
  
            onPressed: (){
  
              AppCubit.get(context).updateGetData(status: 'archive', id: model['id']);
  
            }),
  
      ],
  
    ),
  
  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget tasksBuilder({
  required List<Map> tasks,
}) => tasks.isNotEmpty ?  ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
    separatorBuilder: (context, index) =>
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20.0,
          ),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[300],
          ),
        ),
    itemCount: tasks.length) :  Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Image(
        image: AssetImage('lib/images/add_task.png'),
        height: 300.0,
      ),
      SizedBox(
        height: 20.0,
      ),
      Text(
        'No tasks yet, Please add some tasks',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ],
  ),
);

