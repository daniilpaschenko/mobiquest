enum AppSounds {
  fail('sounds/spongebob-fail.mp3'),
  success('sounds/success-well-done.mp3');

  final String path;
  const AppSounds(this.path);
}