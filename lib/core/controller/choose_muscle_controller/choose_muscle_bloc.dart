import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'choose_muscle_state.dart';

class ChooseMuscleBloc extends BlocBase<int> {
  ChooseMuscleBloc() : super(-1);
  void onChooseMuscleTapped(int index)=> emit(index);
  }

