String urlHost(String url) {
  String host;
  List<String> str = url.split("/");
  host = str[0] + "//" + str[2];
  return host;
}
