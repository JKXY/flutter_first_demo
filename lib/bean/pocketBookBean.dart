
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
  String date;
  double income;
  double expenditure;
  List<PocketBookRecord> record;


  static PocketBookBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PocketBookBean pocketBookBean = PocketBookBean();
    pocketBookBean.date =map['date'];
    pocketBookBean.income = map['income'];
    pocketBookBean.expenditure = map['expenditure'];
    pocketBookBean.record =  List()..addAll(
        (map['record'] as List ?? []).map((o) => PocketBookRecord.fromMap(o))
    );
    return pocketBookBean;
  }
}


class PocketBookRecord{
  int type;//类型 1：收入 2：支出
  String date;
  double money;
  String name;

  static PocketBookRecord fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    PocketBookRecord dataBean = PocketBookRecord();
    dataBean.type = map['type'];
//    dataBean.date = map['date'];
    dataBean.money = map['money'];
    dataBean.name = map['name'];
    return dataBean;
  }
}








