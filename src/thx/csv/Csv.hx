package thx.csv;

class Csv {
  static var encodeOptions = {
    delimiter : ',',
    quote : '"',
    escapedQuote : '""',
    newline : "\n"
  };
  static var decodeOptions = {
    delimiter : ',',
    quote : '"',
    escapedQuote : '""',
    trimValues : false,
    trimEmptyLines : true
  };
  public inline static function decode(csv : String) : Array<Array<String>>
    return Dsv.decode(csv, decodeOptions);

  public static function decodeObjects(csv : String) : Array<Dynamic<String>>
    return Dsv.arrayToObjects(decode(csv));

  public inline static function encode(data : Array<Array<String>>) : String
    return Dsv.encode(data, encodeOptions);

  public static function encodeObjects(data : Array<Dynamic<String>>) : String
    return Dsv.encodeObjects(data, encodeOptions);
}
