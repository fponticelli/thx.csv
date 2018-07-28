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
    var result = dsv == "" ? [] : new thx.csv.core.Parser(options.delimiter, options.quote, options.escapedQuote).parse(dsv);
    if(options.trimValues) {
      for(row in result)
        for(i in 0...row.length)
          row[i] = row[i].trim();
    }
    return result;
  }

  public static function decodeObjects(dsv : String, options : DsvDecodeOptions) : Array<Dynamic<String>>
    return arrayToObjects(decode(dsv, options));

  public static function arrayToObjects(arr : Array<Array<String>>) : Array<Dynamic<String>> {
    var columns = arr[0];
    if(null == columns)
      return [];
    var result = [],
        len = columns.length,
        row,
        ob:Dynamic<String>;
    for(r in 1...arr.length) {
      ob = {};
      row = arr[r];
      for(i in 0...len) {
        Reflect.setField(ob, columns[i], row[i]);
      }
      result.push(ob);
    }
    return result;
  }

  public static function encode(data : Array<Array<String>>, options : DsvEncodeOptions) : String {
    if(null == options.quote) options.quote = '"';
    if(null == options.escapedQuote) options.escapedQuote = options.quote == '"' ? '""' : '\\${options.quote}';
    if(null == options.newline) options.newline = '\n';

    return data.map(function(row) {
      return row.map(function(cell) {
        return if(cell == null)
         ''
        else if(requiresQuotes(cell, options.delimiter, options.quote))
          applyQuotes(cell, options.quote, options.escapedQuote);
        else
          cell;
      }).join(options.delimiter);
    }).join(options.newline);
  }

  public static function encodeObjects(data : Array<Dynamic<String>>, options : DsvEncodeOptions) : String
    return encode(objectsToArray(data, []), options);

  public static function objectsToArray(objects : Array<Dynamic<String>>, ?columns : Array<String>) : Array<Array<String>> {
    if(null == columns)
      return objectsToArray(objects, []);
    var map = new Map(),
        result = [columns],
        collector,
        row;
    for(i in 0...columns.length) {
      map.set(columns[i], i);
    }
    for(object in objects) {
      collector = [];
      row = [];
      for(field in Reflect.fields(object)) {
        var index = map.get(field);
        if(null == index) {
          collector.push(field);
        } else {
          row[index] = Reflect.field(object, field);
        }
      }
      if(collector.length > 0) {
        // restarts with the new columns
        return objectsToArray(objects, columns.concat(collector));
      } else {
        result.push(row);
      }
    }
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
