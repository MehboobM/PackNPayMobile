

class CountsModel {
  int? total;
  int? pending;
  int? inProgress;
  int? settled;
  int? cancelled;

  CountsModel(
      {this.total,
        this.pending,
        this.inProgress,
        this.settled,
        this.cancelled});

  CountsModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pending = json['pending'];
    inProgress = json['in_progress'];
    settled = json['settled'];
    cancelled = json['cancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['pending'] = this.pending;
    data['in_progress'] = this.inProgress;
    data['settled'] = this.settled;
    data['cancelled'] = this.cancelled;
    return data;
  }
}