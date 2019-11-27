
class TodoBeanList {
  final List<TodoBean> list;

  TodoBeanList({
    this.list,
  });

  factory TodoBeanList.fromJson(List<dynamic> parsedJson) {
    List<TodoBean> list = new List<TodoBean>();
    list = parsedJson.map((i)=>TodoBean.fromMap(i)).toList();
    return new TodoBeanList(list: list);
  }
}

class TodoBean {
  int id;
  int type;//类型 1：已完成 2：未完成
  String date;
  String name;


  static TodoBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    TodoBean pocketBookBean = TodoBean();
    pocketBookBean.id =map['id'];
    pocketBookBean.type =map['type'];
    pocketBookBean.date =map['date'];
    pocketBookBean.name = map['name'];
    return pocketBookBean;
  }


  Map<String, dynamic> toDbMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['type'] = type;
    map['date'] = date;
    map['name'] = name;
    return map;
  }

  Map toDbJson() => {
    "type" : type,
    "date" : date,
    "name" : name
  };
}