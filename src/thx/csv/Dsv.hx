package thx.csv;

using thx.Strings;

class Dsv {
  public static function decode(csv : String, options : DsvDecodeOptions) : Array<Array<String>> {
    if(null == options.quote) options.quote = '"';
    if(null == options.escapedQuote) options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
    if(null == options.trimmed) options.trimmed = false;
    return [];
  }
  public static function encode(data : Array<Array<String>>, options : DsvEncodeOptions) : String {
    if(null == options.quote) options.quote = '"';
    if(null == options.escapedQuote) options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
    if(null == options.newline) options.newline = '\n';

    return data.map(function(row) {
      return row.map(function(cell) {
        if(requiresQuotes(cell, options.delimiter, options.quote))
          return applyQuotes(cell, options.quote, options.escapedQuote);
        else
          return cell;
      }).join(options.delimiter);
    }).join(options.newline);
  }

  static function requiresQuotes(value : String, delimiter : String, quote : String) {
    return value.contains(delimiter) || value.contains(quote) || value.contains('\n') || value.contains('\r');
  }

  static function applyQuotes(value : String, quote : String, escapedQuote : String) {
    value = value.replace(quote, escapedQuote);
    return '$quote$value$quote';
  }
}

typedef DsvEncodeOptions = {
  delimiter : String,
  ?quote : String,
  ?escapedQuote : String,
  ?newline : String
}

typedef DsvDecodeOptions = {
  delimiter : String,
  ?quote : String,
  ?escapedQuote : String,
  ?trimmed : Bool
}
