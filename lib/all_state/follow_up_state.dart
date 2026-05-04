

class FollowUpState {
  final bool isLoading;
  final String? error;

  FollowUpState({
    this.isLoading = false,
    this.error,
  });

  FollowUpState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return FollowUpState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}