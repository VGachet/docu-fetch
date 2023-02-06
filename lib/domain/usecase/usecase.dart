abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

abstract class SimpleUseCase<Type> {
  Future<Type> call();
}
