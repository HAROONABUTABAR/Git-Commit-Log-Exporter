extension ListIndexedMap<T> on List<T> {
  Iterable<R> mapIndexed<R>(R Function(int index, T element) f) {
    final length = this.length;
    final result = <R>[];
    for (int i = 0; i < length; i++) {
      result.add(f(i, this[i]));
    }
    return result;
  }
}
