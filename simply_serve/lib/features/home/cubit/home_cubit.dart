import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_serve/features/home/state/home_state.dart';

class TeaHomeCubit extends Cubit<TeaHomeState> {
  TeaHomeCubit() : super(const TeaHomeState());

  void changeCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}
