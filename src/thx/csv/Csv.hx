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
  };
  public inline static function decode(csv : String) : Array<Array<String>>
    return Dsv.decode(csv, decodeOptions);

  public inline static function encode(data : Array<Array<String>>) : String
    return Dsv.encode(data, encodeOptions);
}
