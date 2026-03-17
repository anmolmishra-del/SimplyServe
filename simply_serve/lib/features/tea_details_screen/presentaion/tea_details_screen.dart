import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_serve/Core/constants/coffee_colors.dart';
import 'package:simply_serve/Core/constants/coffee_media_query.dart';
import 'package:simply_serve/features/tea_details_screen/cubit/tea_details_cubit.dart';
import 'package:simply_serve/features/tea_details_screen/state/tea_details_state.dart';

class TeaDetailPage extends StatelessWidget {
  const TeaDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    MQ.init(context);

    return BlocProvider(
      create: (_) => TeaDetailCubit()..loadTea(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<TeaDetailCubit, TeaDetailState>(
          builder: (context, state) {
            if (state is TeaDetailLoaded) {
              final tea = state.tea;

              return Column(
                children: [
                  // 🔝 Image
                  Container(
                    height: MQ.h * 0.28,
                    width: MQ.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(tea.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),

                  // 📄 Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(MQ.w * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tea.name,
                            style: TextStyle(
                              fontSize: MQ.w * 0.065,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tea.type,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: MQ.w * 0.04,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18,
                              ),
                              Text(
                                " ${tea.rating} ★  ${tea.reviews} Reviews",
                                style: TextStyle(fontSize: MQ.w * 0.035),
                              ),
                            ],
                          ),
                          Divider(),
                          const SizedBox(height: 16),
                          Text(
                            tea.description,
                            style: TextStyle(
                              fontSize: MQ.w * 0.04,
                              color: Colors.black87,
                            ),
                          ),

                          // Divider(),
                          const SizedBox(height: 20),
                          // 🟢 Buttons
                          SizedBox(
                            width: MQ.w,
                            height: MQ.h * 0.06,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Add to Cart"),
                            ),
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: MQ.w,
                            height: MQ.h * 0.055,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Brew Guide"),
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Text(
                            "Ingredients",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          const SizedBox(height: 12),

                          ...tea.ingredients.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(item),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
