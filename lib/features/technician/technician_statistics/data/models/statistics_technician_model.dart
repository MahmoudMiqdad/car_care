class StatisticsTechnicianModel {
  final bool success;
  final StatisticsTechnicianDataModel data;

  const StatisticsTechnicianModel({
    required this.success,
    required this.data,
  });

  factory StatisticsTechnicianModel.fromJson(Map<String, dynamic> json) {
    return StatisticsTechnicianModel(
      success: json['success'] == true,
      data: StatisticsTechnicianDataModel.fromJson(
        (json['data'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.toJson(),
      };
}

class StatisticsTechnicianDataModel {
  final int totalJobs;
  final int assignedJobs;
  final int inProgressJobs;
  final int completedJobs;
  final int totalQuotations;
  final int pendingQuotations;
  final int acceptedQuotations;
  final int totalEarnings;
  final String averageRating; // يبقى String مثل الكيان عندك
  final int totalRatings;

  const StatisticsTechnicianDataModel({
    required this.totalJobs,
    required this.assignedJobs,
    required this.inProgressJobs,
    required this.completedJobs,
    required this.totalQuotations,
    required this.pendingQuotations,
    required this.acceptedQuotations,
    required this.totalEarnings,
    required this.averageRating,
    required this.totalRatings,
  });

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  factory StatisticsTechnicianDataModel.fromJson(Map<String, dynamic> json) {
    return StatisticsTechnicianDataModel(
      totalJobs: _toInt(json['total_jobs']),
      assignedJobs: _toInt(json['assigned_jobs']),
      inProgressJobs: _toInt(json['in_progress_jobs']),
      completedJobs: _toInt(json['completed_jobs']),
      totalQuotations: _toInt(json['total_quotations']),
      pendingQuotations: _toInt(json['pending_quotations']),
      acceptedQuotations: _toInt(json['accepted_quotations']),
      totalEarnings: _toInt(json['total_earnings']),
      averageRating: (json['average_rating'] ?? '0').toString(), 
      totalRatings: _toInt(json['total_ratings']),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_jobs': totalJobs,
        'assigned_jobs': assignedJobs,
        'in_progress_jobs': inProgressJobs,
        'completed_jobs': completedJobs,
        'total_quotations': totalQuotations,
        'pending_quotations': pendingQuotations,
        'accepted_quotations': acceptedQuotations,
        'total_earnings': totalEarnings,
        'average_rating': averageRating,
        'total_ratings': totalRatings,
      };
}