class Optional<T> {
  T value;
  boolean hasValue;
  
  public Optional() {
    hasValue = false;
  }
  
  public Optional(T v) {
    hasValue = true;
    value = v;
  }
}
