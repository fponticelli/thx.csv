package thx.csv;

class Tsv {
  static var encodeOptions = {
    delimiter : '\t',
    quote : '"',
    escapedQuote : '""'
  };
  static var decodeOptions = {
    delimiter : '\t',
    quote : '"',
    escapedQuote : '""',
    trimmed : false
  };
  public inline static function decode(csv : String) : Array<Array<String>>
    return Dsv.decode(csv, decodeOptions);

  public inline static function encode(data : Array<Array<String>>) : String
    return Dsv.encode(data, encodeOptions);
}
