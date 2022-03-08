class ListProductType {
  int? value;
  String? name;

  ListProductType(this.value, this.name);

  static List<ListProductType> getListProductType() {
    return [
      ListProductType(1, 'โทรศัพท์มือถือ'),
      ListProductType(2, 'สมาร์ททีวี'),
      ListProductType(3, 'แท็บเล็ต'),
    ];
  }
}
