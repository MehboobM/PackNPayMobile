

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  String? pendingCount;
  String? settledCount;

  Pagination({this.total, this.page, this.limit, this.totalPages,this.pendingCount,this.settledCount,});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['total_pages'];

    pendingCount = json['pending_count'];
    settledCount = json['settled_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total_pages'] = this.totalPages;
    data['pending_count'] = this.pendingCount;
    data['settled_count'] = this.settledCount;
    return data;
  }
}
