package thx.csv;

class Tsv {
  static var encodeOptions = {
    delimiter : '\t',
    quote : '"',
    escapedQuote : '""',
    newline : "\n"
  };
  static var decodeOptions = {
    delimiter : '\t',
    quote : '"',
    escapedQuote : '""',
    trimValues : false,
    trimEmptyLines : true
  };
  public inline static function decode(csv : String) : Array<Array<String>>
    return Dsv.decode(csv, decodeOptions);

  public static function decodeObjects(tsv : String) : Array<{}>
    return Dsv.arrayToObjects(decode(tsv));

  public inline static function encode(data : Array<Array<String>>) : String
    return Dsv.encode(data, encodeOptions);

  public static function encodeObjects(data : Array<{}>) : String
    return Dsv.encodeObjects(data, encodeOptions);
}
