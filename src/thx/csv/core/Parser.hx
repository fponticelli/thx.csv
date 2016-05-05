package thx.csv.core;

using thx.Strings;

class Parser {
  var delimiter : String;
  var quote : String;
  var escapedQuote : String;

  public function new(delimiter : String, quote : String, escapedQuote : String) {
    this.delimiter = delimiter;
    this.quote = quote;
    this.escapedQuote = escapedQuote;
  }

  var result : Array<Array<String>>;
  var pos : Int;
  var len : Int;
  var delimiterLength : Int;
  var quoteLength : Int;
  var escapedQuoteLength : Int;
  var buffer : StringBuf;
  var row : Array<String>;
  var s : String;
  public function parse(s : String) : Array<Array<String>> {
    this.s = s;
    result = [];
    pos = 0;
    len = s.length;
    delimiterLength = delimiter.length;
    quoteLength = quote.length;
    escapedQuoteLength = escapedQuote.length;
    buffer = new StringBuf();
    row = [];

    try {
      loop();
    } catch(e : Dynamic) {
      throw new thx.Error('unable to parse at pos $pos: ${Std.string(e)}');
    }
    pushCell();
    pushRow();

    return result;
  }

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

  inline function loop() {
    var t;
    while(pos < len) {
      if(s.substring(pos, pos + quoteLength) == quote && buffer.length == 0) {
        pos += quoteLength;
        // loopWithinQuotes
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
            break;
          } else {
            pushBuffer(s.substring(pos, pos + 1));
            ++pos;
          }
        }
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
}
