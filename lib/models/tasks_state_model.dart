import 'models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksStateModel extends BaseModel {
  CommonPageStatus _status = CommonPageStatus.READY;
  CommonPageStatus get taskStatus => _status;
  List _taskList = [];
  List get taskList => _taskList;

  void tasksLoadMore(String token) {
    _status = CommonPageStatus.READY;
    notifyListeners();
    http
        .post("http://www.dashixiuxiu.cn/query_crowdfunding_tasks", body: {
          "task_status": "0",
          "token": "$token",
        })
        .then((e) => e.body)
        .then(json.decode)
        .then((e) {
          _taskList.addAll(e['crowdfunding_tasks_list']);
          if (e['crowdfunding_tasks_list'].length == 0) {
            _status = CommonPageStatus.DONE;
          } else {
            _status = CommonPageStatus.DONE;
          }
        })
        .catchError((e) => _status = CommonPageStatus.ERROR)
        .whenComplete(this.notifyListeners);
  }
}
