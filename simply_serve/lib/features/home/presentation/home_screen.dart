import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_serve/features/home/cubit/home_cubit.dart';
import 'package:simply_serve/features/home/state/home_state.dart';
import 'package:simply_serve/features/tea_details_screen/presentaion/tea_details_screen.dart';

class TeaHomeScreen extends StatelessWidget {
  const TeaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeaHomeCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8F6),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(),
                const SizedBox(height: 16),
                _SearchBar(),
                const SizedBox(height: 14),
                _CategoryTabs(),
                const SizedBox(height: 20),
                _TeaList(),
                const SizedBox(height: 24),
                _PopularTeas(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Discover Teas",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.favorite, color: Colors.white),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search teas...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final categories = const ['All', 'Green', 'Black', 'Herbal'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeaHomeCubit, TeaHomeState>(
      builder: (context, state) {
        return Row(
          children: categories.map((cat) {
            final isSelected = cat == state.selectedCategory;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) =>
                    context.read<TeaHomeCubit>().changeCategory(cat),
                selectedColor: Colors.green,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TeaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TeaCard(
          title: "Matcha Bliss",
          subtitle: "Green Tea • 4.4 ★ 230 Reviews",
          image: "assets/images/green.png",
        ),
        SizedBox(height: 14),
        _TeaCard(
          title: "Earl Grey Classic",
          subtitle: "Black Tea • 4.7 ★ 180 Reviews",
          image: "assets/images/block.png",
        ),
      ],
    );
  }
}

class _TeaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const _TeaCard({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TeaDetailPage()),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 160,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularTeas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Teas",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _PopularItem("Chamomile\nCalm", "assets/images/yellow.png"),
            SizedBox(width: 4),
            _PopularItem("Jasmine\nDelight", "assets/images/image.png"),
            SizedBox(width: 4),
            _PopularItem("Minty\nFresh", "assets/images/menthi.png"),
          ],
        ),
      ],
    );
  }
}

class _PopularItem extends StatelessWidget {
  final String title;
  final String image;
  const _PopularItem(this.title, this.image);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
