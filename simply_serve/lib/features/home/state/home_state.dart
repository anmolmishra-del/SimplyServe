class TeaHomeState {
  final String selectedCategory;

  const TeaHomeState({this.selectedCategory = 'All'});

  TeaHomeState copyWith({String? selectedCategory}) {
    return TeaHomeState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
