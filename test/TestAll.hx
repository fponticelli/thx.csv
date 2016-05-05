import utest.UTest;
import utest.Assert;
import thx.csv.*;

class TestAll {
  public static function main() {
    UTest.run([new TestAll()]);
  }
  public function new() {}

  public function testEncode() {
    Assert.same('1997,Ford,E350', Csv.encode([["1997","Ford","E350"]]));
    Assert.same('1997,Ford,E350,"Super, luxurious truck"', Csv.encode([["1997","Ford","E350","Super, luxurious truck"]]));
    Assert.same('1997,Ford,E350,"Super, ""luxurious"" truck"', Csv.encode([["1997","Ford","E350",'Super, "luxurious" truck']]));
    Assert.same('1997,Ford,E350,"Go get one now\nthey are going fast"', Csv.encode([["1997","Ford","E350",'Go get one now\nthey are going fast']]));
  }

  public function testDecode() {
    Assert.same([], Csv.decode(''));
    Assert.same([["",""]], Csv.decode(','));
    Assert.same([["f",""]], Csv.decode('f,'));
    Assert.same([["","f"]], Csv.decode(',f'));
    Assert.same([["x","y"]], Csv.decode('x,y'));
    Assert.same([["",""],["",""]], Csv.decode(',\n,'));
    Assert.same([["",""],[""],["",""]], Csv.decode(',\n\n,'));
    Assert.same([["",""],[""],["",""]], Csv.decode(',\n""\n,'));
    Assert.same([["1997","Ford","E350"]], [["1997","Ford","E350"]]);
    Assert.same([["1997","Ford","E350"]], Csv.decode('1997,Ford,E350'));
    Assert.same([["1997","Ford","E350"]], Csv.decode('"1997","Ford","E350"'));
    Assert.same([["1997","Ford","E350","Super, luxurious truck"]], Csv.decode('1997,Ford,E350,"Super, luxurious truck"'));
    Assert.same([["1997","Ford","E350",'Super, "luxurious" truck']], Csv.decode('1997,Ford,E350,"Super, ""luxurious"" truck"'));
    Assert.same([["1997","Ford","E350",'Go get one now\nthey are going fast']], Csv.decode('1997,Ford,E350,"Go get one now\nthey are going fast"'));
  }

  public function testIssue20160125() {
    var s = '265671209,"Dynagreen Environmental Protection Group Co., Ltd.",1330,China,HKD,';
    var decoded = Csv.decode(s),
        encoded = Csv.encode(decoded);
    Assert.same([
      ['265671209','Dynagreen Environmental Protection Group Co., Ltd.','1330','China','HKD','']
      ], decoded);
    Assert.same('265671209,"Dynagreen Environmental Protection Group Co., Ltd.",1330,China,HKD,', encoded);
  }

  public function testTerminalComma() {
    var s = "Company ID,Name,Ticker,Country,Currency,
24085,1-800-Flowers.com Inc.,FLWS,United States,USD,";
    var decoded = Csv.decode(s),
        encoded = Csv.encode(decoded);
    Assert.same([
      ['Company ID','Name','Ticker','Country','Currency',''],
      ['24085','1-800-Flowers.com Inc.','FLWS','United States','USD','']
      ], decoded);
    Assert.same('Company ID,Name,Ticker,Country,Currency,
24085,1-800-Flowers.com Inc.,FLWS,United States,USD,', encoded);
  }

  public function testRoundtrip() {
    var s = 'Year,Make,Model,Description,Price
1997,Ford,E350,"ac, abs, moon",3000.00
1999,Chevy,"Venture ""Extended Edition""","",4900.00
1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
1996,Jeep,Grand Cherokee,"MUST SELL!
air, moon roof, loaded",4799.00';
    var decoded = Csv.decode(s),
        encoded = Csv.encode(decoded);
    Assert.same([
['Year','Make','Model','Description','Price'],
['1997','Ford','E350','ac, abs, moon','3000.00'],
['1999','Chevy','Venture "Extended Edition"','','4900.00'],
['1999','Chevy','Venture "Extended Edition, Very Large"','','5000.00'],
['1996','Jeep','Grand Cherokee','MUST SELL!\nair, moon roof, loaded','4799.00']
], decoded);
    Assert.same('Year,Make,Model,Description,Price
1997,Ford,E350,"ac, abs, moon",3000.00
1999,Chevy,"Venture ""Extended Edition""",,4900.00
1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
1996,Jeep,Grand Cherokee,"MUST SELL!
air, moon roof, loaded",4799.00', encoded);
  }

  public function testSemicolon() {
    var s = 'Year;Make;Model;Length
1997;Ford;E350;2,34
2000;Mercury;Cougar;2,38',
        encoded = Dsv.decode(s, { quote : '"', escapedQuote : '""', delimiter : ';', trimValues : false }),
        decoded = Dsv.encode(encoded, { quote : '"', escapedQuote : '""', delimiter : ';', newline : "\n" });
    Assert.equals(s, decoded);
  }

  public function testAutoTrim() {
    var s = '1997 , Ford, E350',
        encoded = Dsv.decode(s, { quote : '"', escapedQuote : '""', delimiter : ',', trimValues : true });
    Assert.same([['1997', 'Ford', 'E350']], encoded);
    encoded = Dsv.decode(s, { quote : '"', escapedQuote : '""', delimiter : ',', trimValues : false });
    Assert.same([['1997 ', ' Ford', ' E350']], encoded);
    Assert.same([["1997","Ford","E350"," Super, luxurious truck "]], Csv.decode('1997,Ford,E350," Super, luxurious truck "'));
  }

  public function testSurroundingWhitespaces() {
    Assert.same([["1997",' "Ford" ',"E350"]], Csv.decode('1997, "Ford" ,E350'));
  }

  public function testTsv() {
    Assert.same([["1997 "," Ford "," E350"]], Tsv.decode('1997 	 Ford 	 E350'));
  }
}
