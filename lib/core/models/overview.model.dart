class Overview {
  Overview({
    this.activeSubscribersCount,
    this.activeTrialsCount,
    this.activeUsersCount,
    this.installsCount,
    this.mrr,
    this.revenue,
  });

  final double activeSubscribersCount;
  final double activeTrialsCount;
  final double activeUsersCount;
  final double installsCount;
  final double mrr;
  final double revenue;

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
        activeSubscribersCount: json["active_subscribers_count"] == null
            ? null
            : json["active_subscribers_count"],
        activeTrialsCount: json["active_trials_count"] == null
            ? null
            : json["active_trials_count"],
        activeUsersCount: json["active_users_count"] == null
            ? null
            : json["active_users_count"],
        installsCount:
            json["installs_count"] == null ? null : json["installs_count"],
        mrr: json["mrr"] == null ? null : json["mrr"].toDouble(),
        revenue: json["revenue"] == null ? null : json["revenue"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "active_subscribers_count":
            activeSubscribersCount == null ? null : activeSubscribersCount,
        "active_trials_count":
            activeTrialsCount == null ? null : activeTrialsCount,
        "active_users_count":
            activeUsersCount == null ? null : activeUsersCount,
        "installs_count": installsCount == null ? null : installsCount,
        "mrr": mrr == null ? null : mrr,
        "revenue": revenue == null ? null : revenue,
      };
}
