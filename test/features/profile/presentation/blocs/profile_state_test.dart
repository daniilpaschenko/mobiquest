import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/features/profile/domain/entities/user_profile.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_state.dart';

void main() {
  const guest = UserProfile(name: 'Гость', experience: 0);
  const alex = UserProfile(name: 'Alex', experience: 15);

  group('ProfileLoaded', () {
    test('awardedPoints is null by default', () {
      expect(const ProfileLoaded(guest).awardedPoints, isNull);
    });

    group('copyWith', () {
      test('replaces the profile and keeps awardedPoints', () {
        const state = ProfileLoaded(guest, awardedPoints: 5);

        final updated = state.copyWith(profile: alex);

        expect(updated.profile, alex);
        expect(updated.awardedPoints, 5);
      });

      test('keeps the profile and replaces awardedPoints', () {
        const state = ProfileLoaded(guest);

        final rewarded = state.copyWith(awardedPoints: 5);

        expect(rewarded.profile, guest);
        expect(rewarded.awardedPoints, 5);
      });

      test('keeps both fields when called without arguments', () {
        const state = ProfileLoaded(alex, awardedPoints: 5);

        expect(state.copyWith().profile, alex);
        expect(state.copyWith().awardedPoints, 5);
      });

      test('cannot reset awardedPoints back to null', () {
        const state = ProfileLoaded(alex, awardedPoints: 5);

        final updated = state.copyWith(awardedPoints: null);

        expect(updated.awardedPoints, 5);
      });

      test('does not mutate the original state', () {
        const state = ProfileLoaded(guest, awardedPoints: 5);

        state.copyWith(profile: alex, awardedPoints: 10);

        expect(state.profile, guest);
        expect(state.awardedPoints, 5);
      });
    });
  });

  group('state hierarchy', () {
    test('every state is a ProfileState', () {
      expect(const ProfileInitial(), isA<ProfileState>());
      expect(const ProfileLoading(), isA<ProfileState>());
      expect(const ProfileLoaded(guest), isA<ProfileState>());
      expect(const ProfileError('boom'), isA<ProfileState>());
    });

    test('states of different types are not equal', () {
      // важно для bloc-а: одинаковые по типу состояния сравниваются полями,
      // а ProfileInitial и ProfileLoading различаются только типом
      expect(const ProfileInitial(), isNot(const ProfileLoading()));
      expect(const ProfileError('a'), isNot(const ProfileError('b')));
    });
  });
}
