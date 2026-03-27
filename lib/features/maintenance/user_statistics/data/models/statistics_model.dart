
class StatisticsModel {
    bool success;
    Data data;

    StatisticsModel({
        required this.success,
        required this.data,
    });

    factory StatisticsModel.fromJson(Map<String, dynamic> json) => StatisticsModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    int totalRequests;
    int pendingRequests;
    int acceptedRequests;
    int completedRequests;
    int cancelledRequests;

    Data({
        required this.totalRequests,
        required this.pendingRequests,
        required this.acceptedRequests,
        required this.completedRequests,
        required this.cancelledRequests,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRequests: json["total_requests"],
        pendingRequests: json["pending_requests"],
        acceptedRequests: json["accepted_requests"],
        completedRequests: json["completed_requests"],
        cancelledRequests: json["cancelled_requests"],
    );

    Map<String, dynamic> toJson() => {
        "total_requests": totalRequests,
        "pending_requests": pendingRequests,
        "accepted_requests": acceptedRequests,
        "completed_requests": completedRequests,
        "cancelled_requests": cancelledRequests,
    };
}
