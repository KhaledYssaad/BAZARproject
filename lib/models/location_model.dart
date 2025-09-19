class Location {
  String name;
  double long;
  double lat;

  Location(this.name, this.lat, this.long);
}

class FakeData {
  static List<Location> fakeLocation = [
    Location("test1", 41.233, 41.334),
  ];
}
