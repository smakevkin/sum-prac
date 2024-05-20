program goodies;
uses print,rasp,validate,perem;

var
  ini, outF, errorF: Text;
  s: string;
  countGoods:integer;
begin
  assign(ini, 'in.txt');
  assign(outF, 'out.txt');
  assign(errorF, 'error.txt');
  reset(ini);
  rewrite(outF);
  rewrite(errorF);
  while not eof(ini) do
  begin
    Inc(countGoods);
    readln(ini, s);
    check(s, countGoods);
  end;
  SortGoodsAscending(_goods, k);
  PrintGoodsArray(outF, _goods, k);
  PrintErrorArray(errorF, _not_goods, l);
  close(ini);
  close(outF);
  close(errorF);
end.