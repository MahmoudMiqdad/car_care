
class StatisticsTechnicianModel {
    bool success;
    Data data;

    StatisticsTechnicianModel({
        required this.success,
        required this.data,
    });

    factory StatisticsTechnicianModel.fromJson(Map<String, dynamic> json) => StatisticsTechnicianModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    int totalJobs;
    int assignedJobs;
    int inProgressJobs;
    int completedJobs;
    int totalQuotations;
    int pendingQuotations;
    int acceptedQuotations;
    int totalEarnings;
    String averageRating;
    int totalRatings;

    Data({
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

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalJobs: json["total_jobs"],
        assignedJobs: json["assigned_jobs"],
        inProgressJobs: json["in_progress_jobs"],
        completedJobs: json["completed_jobs"],
        totalQuotations: json["total_quotations"],
        pendingQuotations: json["pending_quotations"],
        acceptedQuotations: json["accepted_quotations"],
        totalEarnings: json["total_earnings"],
        averageRating: json["average_rating"],
        totalRatings: json["total_ratings"],
    );

    Map<String, dynamic> toJson() => {
        "total_jobs": totalJobs,
        "assigned_jobs": assignedJobs,
        "in_progress_jobs": inProgressJobs,
        "completed_jobs": completedJobs,
        "total_quotations": totalQuotations,
        "pending_quotations": pendingQuotations,
        "accepted_quotations": acceptedQuotations,
        "total_earnings": totalEarnings,
        "average_rating": averageRating,
        "total_ratings": totalRatings,
    };
}
