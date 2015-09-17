import utest.UTest;
import utest.Assert;
import thx.csv.Csv;

class TestAll {
  public static function main() {
    UTest.run([new TestAll()]);
  }
  public function new() {}

  public function testParse() {
    Assert.same(["1997","Ford","E350"], Csv.parse('1997,Ford,E350'));
    Assert.same(["1997","Ford","E350"], Csv.parse('"1997","Ford","E350"'));
    Assert.same(["1997","Ford","E350","Super, luxurious truck"], Csv.parse('1997,Ford,E350,"Super, luxurious truck"'));
    Assert.same(["1997","Ford","E350",'Super, "luxurious" truck'], Csv.parse('1997,Ford,E350,"Super, ""luxurious"" truck"'));
    Assert.same(["1997","Ford","E350",'Go get one now\nthey are going fast'], Csv.parse('1997,Ford,E350,"Go get one now\nthey are going fast"'));

//comma, semicolon, or tab

// Year,Make,Model,Description,Price
// 1997,Ford,E350,"ac, abs, moon",3000.00
// 1999,Chevy,"Venture ""Extended Edition""","",4900.00
// 1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
// 1996,Jeep,Grand Cherokee,"MUST SELL!
// air, moon roof, loaded",4799.00

// Year;Make;Model;Length
// 1997;Ford;E350;2,34
// 2000;Mercury;Cougar;2,38
  }

// AUTO TRIM
// 1997, Ford, E350
// not same as
// 1997,Ford,E350

// NO TRIM
//Assert.same(["1997","Ford","E350"," Super, luxurious truck "], Csv.parse('1997,Ford,E350," Super, luxurious truck "'));

// REMOVE WHITESPACES AROUND QUOTES
// 1997, "Ford" ,E350

//https://en.wikipedia.org/wiki/Delimiter-separated_values
//DSV, TSV
}
