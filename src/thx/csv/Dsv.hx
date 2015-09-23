package thx.csv;

using thx.Strings;

class Dsv {
  public static function decode(dsv : String, options : DsvDecodeOptions) : Array<Array<String>> {
    if(null == options.quote) options.quote = '"';
    if(null == options.escapedQuote) options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
    if(null == options.trimValues) options.trimValues = false;
    if(null == options.trimEmptyLines) options.trimEmptyLines = true;
    if(options.trimEmptyLines)
      dsv = dsv.trimChars('\n\r');
    var result = dsv == "" ? [] : parse(dsv, options.delimiter, options.quote, options.escapedQuote);
    if(options.trimValues) {
      for(row in result)
        for(i in 0...row.length)
          row[i] = row[i].trim();
    }
    return result;
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

  static function parse(s : String, delimiter : String, quote : String, escapedQuote : String) : Array<Array<String>> {
    var result = [],
        pos = 0,
        len = s.length,
        delimiterLength = delimiter.length,
        quoteLength = quote.length,
        escapedQuoteLength = escapedQuote.length,
        buffer = new StringBuf(),
        row = [];

    function pushCell() {
      row.push(buffer.toString());
      buffer = new StringBuf();
    }

    function pushBuffer(char : String) {
      buffer.add(char);
    }

    function pushRow() {
      result.push(row);
      row = [];
    }

    var loopWithinQuotes = null, loop = null;

    loopWithinQuotes = function() {
      while(pos < len) {
        if(s.substring(pos, pos + escapedQuoteLength) == escapedQuote) {
          pushBuffer(quote);
          pos += escapedQuoteLength;
        } else if(s.substring(pos, pos + quoteLength) == quote) {
          pos += quoteLength;
          var next = s.substring(pos, pos + 1);
          while(next == " " || (delimiter != "\t" && next == "\t")) {
            ++pos;
            next = s.substring(pos, pos + 1);
          }
          loop();
        } else {
          pushBuffer(s.substring(pos, pos + 1));
          ++pos;
        }
        //break; // TODO REMOVE
      }
    }
    loop = function() {
      var t;
      while(pos < len) {
        if(s.substring(pos, pos + quoteLength) == quote) {
          if(buffer.length > 0) {
            var s = buffer.toString().trim();
            if(s.length > 0) {
              continue;
            }
            buffer = new StringBuf();
          }
          pos += quoteLength;
          loopWithinQuotes();
        } else if(s.substring(pos, pos + delimiterLength) == delimiter) {
          pushCell();
          pos += delimiterLength;
        } else {
          t = s.substring(pos, pos + 2);
          if(t == '\n\r' || t == '\r\n') {
            pos += 2;
            pushCell();
            pushRow();
            continue;
          }
          t = s.substring(pos, pos + 1);
          if(t == '\n' || t == '\r') {
            ++pos;
            pushCell();
            pushRow();
            continue;
          }
          pushBuffer(s.substring(pos, pos + 1));
          ++pos;
        }
      }
    }
    loop();
    pushCell();
    pushRow();

    return result;
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
  ?trimValues : Bool,
  ?trimEmptyLines : Bool
}
