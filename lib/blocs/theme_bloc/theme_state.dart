part of 'theme_bloc.dart';

sealed class ThemeState extends Equatable {
  final ThemeData theme;
  const ThemeState({required this.theme});
  
  @override
  List<Object> get props => [theme];
}

final class ThemeDarkState extends ThemeState {
  const ThemeDarkState({required super.theme});
   @override
  List<Object> get props => [theme];
}
final class ThemeLightState extends ThemeState {
  const ThemeLightState({required super.theme});
   @override
  List<Object> get props => [theme];
}
