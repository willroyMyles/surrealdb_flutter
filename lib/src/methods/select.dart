// ignore_for_file: public_member_api_docs, sort_constructors_first

class Select {
  String table;
  String query;
  Function? execute;
  Function? transform;
  Select({this.table = '', this.query = '', this.execute, this.transform}) {
    query = "select * from $table";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'table': table,
      'query': query,
    };
  }

  factory Select.fromMap(Map<String, dynamic> map) {
    return Select(
      table: (map['table'] ?? '') as String,
      query: (map['query'] ?? '') as String,
    );
  }

  @override
  String toString() =>
      'Select(table: $table, query: $query, execute: $execute)';

  Future<Object?> get() async {
    var res = await execute!(query);
    if (transform != null) {
      return transform!(res[0]['result'][0]);
    }

    return res;
  }
}

extension SelectOptions on Select {
  Select where(String field, WhereEnum op, String value) {
    //if contains where, search and offset to last and increase where clause
    this.query += "where $field ${op.op} '$value'";
    return this;
  }

  Select groupBy(String field) {
    this.query += "group by $field";
    return this;
  }

  Select orderBy(String field, [bool asc = true]) {
    this.query += "order by $field, ${asc ? "asc" : "desc"}";
    return this;
  }
}

enum WhereEnum {
  LessThan("<"),
  GreaterThan(">"),
  Equal("=");

  final String op;
  const WhereEnum(this.op);
}
