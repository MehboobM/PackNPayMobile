
class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  String? pendingCount;
  String? settledCount;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.pendingCount,
    this.settledCount,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '');
    page = json['page'] is int ? json['page'] : int.tryParse(json['page']?.toString() ?? '');
    limit = json['limit'] is int ? json['limit'] : int.tryParse(json['limit']?.toString() ?? '');
    totalPages = json['total_pages'] is int ? json['total_pages'] : int.tryParse(json['total_pages']?.toString() ?? '');

    // Safely convert counts to String as they might come as int from API
    pendingCount = json['pending_count']?.toString();
    settledCount = json['settled_count']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    data['total_pages'] = totalPages;
    data['pending_count'] = pendingCount;
    data['settled_count'] = settledCount;
    return data;
  }
}
