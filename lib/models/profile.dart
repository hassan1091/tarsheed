class Profile {
  final String? uid;
  final String? name;
  final bool isSafeMode;

  Profile({this.uid, this.name, this.isSafeMode = false});

  Map<String, dynamic> toJson() => {'name': name, 'is_safe_mode': isSafeMode};
}
