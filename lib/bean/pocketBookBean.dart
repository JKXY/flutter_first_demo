
class PocketBookList {
  final List<PocketBookBean> list;

  PocketBookList({
    this.list,
  });

  factory PocketBookList.fromJson(List<dynamic> parsedJson) {
    List<PocketBookBean> list = new List<PocketBookBean>();
    list = parsedJson.map((i)=>PocketBookBean.fromMap(i)).toList();
    return new PocketBookList(list: list);
  }
}



class PocketBookBean {
  int id;
  String date;
  String income;
  String expenditure;
  List<PocketBookRecord> record;


  static PocketBookBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PocketBookBean pocketBookBean = PocketBookBean();
    pocketBookBean.id =map['id'];
    pocketBookBean.date =map['date'];
    pocketBookBean.income = map['income'];
    pocketBookBean.expenditure = map['expenditure'];
    pocketBookBean.record =  List()..addAll(
        (map['record'] as List ?? []).map((o) => PocketBookRecord.fromMap(o))
    );
    return pocketBookBean;
  }


  Map<String, dynamic> toDbMap() {
    var map = new Map<String, dynamic>();
    map['date'] = date;
    map['income'] = income;
    map['expenditure'] = expenditure;
    return map;
  }

  Map toDbJson() => {
    "id" : id,
    "date" : date,
    "income" : income,
    "expenditure" : expenditure
  };
}


class PocketBookRecord{
  int id;
  int type;//类型 1：收入 2：支出
  String date;
  String money;
  String name;
  String remack;

  static PocketBookRecord fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PocketBookRecord dataBean = PocketBookRecord();
    dataBean.id = map['id'];
    dataBean.type = map['type'];
    dataBean.date = map['date'];
    dataBean.money = map['money'];
    dataBean.name = map['name'];
    dataBean.remack = map['remack'];
    return dataBean;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['type'] = type;
    map['date'] = date;
    map['money'] = money;
    map['name'] = name;
    map['remack'] = remack;
    return map;
  }

  Map toJson() => {
    "id" : id,
    "type" : type,
    "date" : date,
    "money" : money,
    "remack" : remack,
    "name" : name
  };
}








