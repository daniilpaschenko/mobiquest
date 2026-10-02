import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_name_card.dart';
import '../widgets/profile_experience_card.dart';
import '../widgets/profile_experience_hint.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _rose = Color(0xFFE11D48);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width.clamp(0.0, 600.0);
    final hPad = screenW * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(hPad),
                  child: Text(
                    'Не удалось загрузить профиль',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _rose, fontSize: screenW * 0.04),
                  ),
                ),
              );
            }

            if (state is! ProfileLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: _rose),
              );
            }

            final profile = state.profile;

            return Padding(
              padding: EdgeInsets.fromLTRB(hPad, screenW * 0.04, hPad, hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(screenW: screenW),
                  SizedBox(height: screenW * 0.06),
                  ProfileNameCard(
                    screenW: screenW,
                    name: profile.name,
                  ),
                  SizedBox(height: screenW * 0.04),
                  ProfileExperienceCard(
                    screenW: screenW,
                    experience: profile.experience,
                  ),
                  SizedBox(height: screenW * 0.04),
                  ProfileExperienceHint(screenW: screenW),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}