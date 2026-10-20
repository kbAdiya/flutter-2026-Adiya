class Profile {
  const Profile({required this.name, required this.group});

  final String name;
  final String group;

  const Profile.empty() : name = '', group = '';

  Profile copyWith({String? name, String? group}) {
    return Profile(name: name ?? this.name, group: group ?? this.group);
  }
}
