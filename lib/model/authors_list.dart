class AuthorsList {
  final List<Author> authors;
  AuthorsList(this.authors);

  factory AuthorsList.fromJson(Map<String, dynamic> json) {
    var list = json['authors'] as List;
    List<Author> authorList = list.map((e) => Author.fromJson(e)).toList();
    return AuthorsList(authorList);
  }
}

class Author {
  final String name;
  final String permalink;
  Author(this.name, this.permalink);

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(json['name'], json['permalink']);
  }
}
