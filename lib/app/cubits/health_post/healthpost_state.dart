part of 'health_post_cubit.dart';

enum ListStatus { initial, loading, success, error }

class HealthPostState extends Equatable {
  final ListStatus listStatus;
  final bool hasMoreHealthPost;
  final List<HealthPost> healthPosts;
  final String? listError;

  const HealthPostState({
    this.listStatus = ListStatus.initial,
    this.hasMoreHealthPost = true,
    this.healthPosts = const [],
    this.listError,
  });

  HealthPostState copyWith({
    ListStatus? listStatus,
    bool? hasMoreHealthPost,
    List<HealthPost>? healthPosts,
    String? listError,
  }) {
    return HealthPostState(
      listStatus: listStatus ?? this.listStatus,
      hasMoreHealthPost: hasMoreHealthPost ?? this.hasMoreHealthPost,
      healthPosts: healthPosts ?? this.healthPosts,
      listError: listError,
    );
  }

  @override
  List<Object?> get props => [
    listStatus,
    hasMoreHealthPost,
    healthPosts,
    listError,
  ];
}
