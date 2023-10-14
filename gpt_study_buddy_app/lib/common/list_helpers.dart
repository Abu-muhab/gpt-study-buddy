extension ListExtension<T> on List<T> {
  List<T> toUniqueList({required bool Function(T, T) equals}) {
    final List<T> uniqueList = <T>[];
    for (final T item in this) {
      if (!uniqueList.any((T element) => equals(item, element))) {
        uniqueList.add(item);
      }
    }
    return uniqueList;
  }
}
