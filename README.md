# thx.csv
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/fponticelli/thx.core?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Build Status](https://travis-ci.org/fponticelli/thx.csv.svg?branch=master)](https://travis-ci.org/fponticelli/thx.csv)

CSV decoder (parser) and encoder (writer)

## usage

```haxe
var s = 'Year,Make,Model,Description,Price
1997,Ford,E350,"ac, abs, moon",3000.00
1999,Chevy,"Venture ""Extended Edition""","",4900.00
1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
1996,Jeep,Grand Cherokee,"MUST SELL!
air, moon roof, loaded",4799.00';

var decoded = Csv.decode(s),
    encoded = Csv.encode(decoded);
trace(decoded); // Array<Array<String>>
trace(encoded);
```

[live sample](http://try.thx-lib.org/#913a7)

## install

```
haxelib install thx.csv
```
