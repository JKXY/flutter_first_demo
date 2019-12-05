
class SisterImageBean {
  bool error;
  List<SisterImage> results;

  static SisterImageBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SisterImageBean sisterImageBeanBean = SisterImageBean();
    sisterImageBeanBean.error = map['error'];
    sisterImageBeanBean.results = List()..addAll(
      (map['results'] as List ?? []).map((o) => SisterImage.fromMap(o))
    );
    return sisterImageBeanBean;
  }

  Map toJson() => {
    "error": error,
    "results": results,
  };
}

class SisterImage {
  String Id;
  String createdAt;
  String desc;
  String publishedAt;
  String type;
  String url;
  bool used;
  String who;

  static SisterImage fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SisterImage resultsBean = SisterImage();
    resultsBean.Id = map['_id'];
    resultsBean.createdAt = map['createdAt'];
    resultsBean.desc = map['desc'];
    resultsBean.publishedAt = map['publishedAt'];
    resultsBean.type = map['type'];
    resultsBean.url = map['url'];
    resultsBean.used = map['used'];
    resultsBean.who = map['who'];
    return resultsBean;
  }

  Map toJson() => {
    "_id": Id,
    "createdAt": createdAt,
    "desc": desc,
    "publishedAt": publishedAt,
    "type": type,
    "url": url,
    "used": used,
    "who": who,
  };
}