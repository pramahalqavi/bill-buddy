class Constants {
  static const appDatabaseName = "app_database.db";

  static const priceRegex = r"[0-9]{1,3}((\s)?[.,]{1}(\s)?[0-9]{3})*((.|,)[0-9]{1,2})?";
  static const subtotalRegex = r"[Ss][Uu][Bb]\s?[Tt][Oo][Tt][Aa][Ll]";
  static const totalRegex = r"[Tt][Oo][Tt][Aa][Ll]";
  static const taxRegex = r"([Tt][Aa][Xx])|([Pp][Bb]\s?1?)|([Hh][Ss][Tt])|([Gg][Ss][Tt])";
  static const serviceRegex = r"[Ss][Ee][Rr][Vv][Ii][Cc][Ee]";
  static const discountRegex = r"[Dd][Ii][Ss][Cc][Oo][Uu][Nn][Tt]";
  static const qtyRegex = r"[0-9]{1,3}\s?[Xx]?|[Xx]?\s?[0-9]{1,3}";
  static const qtyNumberRegex = r"[0-9]{1,3}";
  static const itemNameRegex = r"[a-zA-Z\s]{3,}";
  static const currencyRegex = r"[Rr][Pp]|$|[Ii][Dd][Rr]|[Uu][Ss][Dd]";

  static const loadingOpacity = 0.5;
}