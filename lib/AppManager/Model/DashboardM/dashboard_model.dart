class DashboardModel {
  final int? id;
  final String? name;
  final bool? isActive;
  final int? createdBy;
  final String? createdDate;
  final int? modifiedBy;
  final String? modifiedDate;

  DashboardModel({
    this.id,
    this.name,
    this.isActive,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'],
      createdBy: json['created_by'],
      createdDate: json['created_date'],
      modifiedBy: json['modified_by'],
      modifiedDate: json['modified_date'],
    );
  }
}