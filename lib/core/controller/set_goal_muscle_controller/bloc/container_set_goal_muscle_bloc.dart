import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'container_set_goal_muscle_state.dart';

class ContainerSetGoalMuscleBloc extends BlocBase<int>{
  ContainerSetGoalMuscleBloc() : super(-1);
  void onGoalTapped(int index)=> emit(index);
}

