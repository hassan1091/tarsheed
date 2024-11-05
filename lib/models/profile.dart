class Profile {
  final String? uid;
  final String? name;

  Profile({this.uid, this.name});

  Map<String, dynamic> toJson() => {'name': name};
}
