import 'models.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTaskStateModel extends Model {
  final String token;

  AddTaskStateModel(this.token);

  CommonPageStatus _taskStatus = CommonPageStatus.READY;
  CommonPageStatus get taskStatus => _taskStatus;

  void taskAdd(String title, String desc, int reward, int time) {
    _taskStatus = CommonPageStatus.RUNNING;
    notifyListeners();
    http
        .post(
          "http://www.dashixiuxiu.cn/send_task",
          body: {
            "task_name": "$title",
            "task_desc": "$desc",
            "reward": "$reward",
            "token": "$token",
            "task_finish_time": "$time"
          },
        )
        .then((e) => e.body)
        .then(print)
        .catchError((e) => print)
        .whenComplete(this.notifyListeners);
  }
}
