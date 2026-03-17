import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_serve/Core/constants/coffee_assets.dart';
import 'package:simply_serve/features/tea_details_screen/models/tea_model.dart';
import 'package:simply_serve/features/tea_details_screen/state/tea_details_state.dart';

class TeaDetailCubit extends Cubit<TeaDetailState> {
  TeaDetailCubit() : super(TeaDetailInitial());

  void loadTea() {
    emit(
      TeaDetailLoaded(
        TeaModel(
          name: "Matcha Bliss",
          type: "Green Tea",
          description:
              "A smooth and vibrant Japanese green tea with a rich, creamy flavor.",
          rating: 4.8,
          reviews: 230,
          image: AppImages.green,
          ingredients: [
            "Matcha Powder",
            "Boosts Energy",
            "Rich in Antioxidants",
            "Improves Focus",
          ],
        ),
      ),
    );
  }
}
