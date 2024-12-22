extension IterableExtension<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) fn) {
    var i = 0;
    return map((e) => fn(e, i++));
  }
}
