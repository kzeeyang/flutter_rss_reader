bool isAtomUrl(String url) {
  if (url.toLowerCase().endsWith('.xml') ||
      url.toLowerCase().endsWith('.atom')) {
    return true;
  }
  return false;
}
