import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/set_profile_name.dart';
import '../../domain/usecases/register_practice_result.dart';
import 'profile_event.dart';
import 'profile_state.dart';

// Singleton-bloc: живёт на уровне всего приложения (регистрируется как
// registerLazySingleton в injection.dart и предоставляется один раз в
// main.dart), т.к. и экран практики, и экран профиля должны видеть
// один и тот же актуальный профиль.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final SetProfileName _setProfileName;
  final RegisterPracticeResult _registerPracticeResult;

  ProfileBloc({
    required this._getProfile,
    required this._setProfileName,
    required this._registerPracticeResult,
  }) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<ChangeProfileName>(_onChangeProfileName);
    on<SubmitPracticeResult>(_onSubmitPracticeResult);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      final profile = await _getProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onChangeProfileName(
    ChangeProfileName event,
    Emitter<ProfileState> emit,
  ) async {
    final trimmed = event.name.trim();
    if (trimmed.isEmpty) return;

    await _setProfileName(trimmed);

    final current = state;
    if (current is ProfileLoaded) {
      emit(current.copyWith(profile: current.profile.copyWith(name: trimmed)));
    } else {
      emit(ProfileLoaded(await _getProfile()));
    }
  }

  Future<void> _onSubmitPracticeResult(
    SubmitPracticeResult event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await _registerPracticeResult(
      itemsId: event.itemsId,
      score: event.score,
      total: event.total,
    );

    emit(ProfileLoaded(
      result.profile,
      awardedPoints: result.awarded ? result.pointsAwarded : null,
    ));
  }
}
