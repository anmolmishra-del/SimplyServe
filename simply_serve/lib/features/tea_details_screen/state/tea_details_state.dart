import 'package:simply_serve/features/tea_details_screen/models/tea_model.dart';

abstract class TeaDetailState {}

class TeaDetailInitial extends TeaDetailState {}

class TeaDetailLoaded extends TeaDetailState {
  final TeaModel tea;

  TeaDetailLoaded(this.tea);
}
