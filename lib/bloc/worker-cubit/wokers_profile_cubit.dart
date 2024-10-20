import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_services/Repositories/worker_profiles_repo.dart';

import 'wokers_profile_state.dart';

class WokersProfileCubit extends Cubit<WokersProfileState> {
  WokersProfileCubit() : super(WokersProfileInitial());

  WorkerProfilesRepo workerProfilesRepo = WorkerProfilesRepo();

  Future<void> createWorkersProfile({
    required String name,
    required String category,
    required String contactInfo,
    required String address,
    required String experience,
    required String bio,
    required String profilePicture,
  }) async {
    emit(WokersProfileLoading());
    try {
      var profile = await workerProfilesRepo.createWorkerProfile(
        name: name,
        category: category,
        contactInfo: contactInfo,
        address: address,
        experience: experience,
        bio: bio,
        profilePic: profilePicture,
      );
      emit(WokersProfileProfileCreatedState(wokersProfile: profile!));
    } on Exception catch (e) {
      emit(WorkerProfileErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> updateWorkersProfile({
    String? name,
    String? category,
    String? contactInfo,
    String? address,
    String? experience,
    String? bio,
  }) async {
    emit(WokersProfileLoading());
    try {
      var updateProfile = await workerProfilesRepo.updateWorkerProfile(
          name: name,
          category: category,
          contactInfo: contactInfo,
          experience: experience,
          bio: bio);
      emit(WorkerprofileUpdatedState(wokersProfile: updateProfile!));
    } catch (e) {
      emit(WorkerProfileErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> getProfileById(String workerId) async {
    emit(WokerSingleProfileLoading());
    try {
      var profile = await workerProfilesRepo.getWorkerById(workerId);
      emit(WokersProfileProfileFetchedState(wokersProfile: profile!));
    } on Exception catch (e) {
      emit(WorkerProfileErrorState(errorMessage: e.toString()));
    }
  }
}
