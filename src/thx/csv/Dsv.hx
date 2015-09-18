package thx.csv;

class Dsv {
  public static function decode(csv : String, options : DsvDecodeOptions) : Array<Array<String>> {
    return [];
  }
  public static function encode(data : Array<Array<String>>, options : DsvEncodeOptions) : String {
    return "";
  }
}

typedef DsvEncodeOptions = {
  delimiter : String,
  quote : String,
  escapedQuote : String,
  newline : String
}

typedef DsvDecodeOptions = {
  delimiter : String,
  quote : String,
  escapedQuote : String,
  trimmed : Bool
}
