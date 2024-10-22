class WokersProfileState {}

final class WokersProfileInitial extends WokersProfileState {}

final class WokersProfileLoading extends WokersProfileState {}

final class WokerSingleProfileLoading extends WokersProfileState {}

final class WokersProfileProfileFetchedState extends WokersProfileState {
  final Map<String, dynamic> wokersProfile;
  WokersProfileProfileFetchedState({required this.wokersProfile});
}

final class WokersAllProfileProfileFetchState extends WokersProfileState {
  final List<Map<String, dynamic>> wokersProfile;
  WokersAllProfileProfileFetchState({required this.wokersProfile});
}

final class WokersProfileProfileCreatedState extends WokersProfileState {
  final Map<String, dynamic> wokersProfile;
  WokersProfileProfileCreatedState({required this.wokersProfile});
}

final class WorkerprofileUpdatedState extends WokersProfileState {
  final Map<String, dynamic> wokersProfile;
  WorkerprofileUpdatedState({required this.wokersProfile});
}

final class WorkerProfileErrorState extends WokersProfileState {
  final String errorMessage;
  WorkerProfileErrorState({required this.errorMessage});
}
