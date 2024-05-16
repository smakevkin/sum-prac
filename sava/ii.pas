program goodies;
uses print,rasp,validate,perem;

var
  ini, outF, errorF: Text;
  s: string;
  _goods: TGoodsList;
  _not_goods: TStringArray; { Use the defined type }
  
  checks: TGoods;

begin
  assign(ini, 'in.txt');
  assign(outF, 'out.txt');
  assign(errorF, 'error.txt');
  reset(ini);
  rewrite(outF);
  rewrite(errorF);
  while not eof(ini) do
  begin
    readln(ini, s);
    if check(s, checks) then
    begin
      inc(k);
      setGoods(_goods, k, checks);
    end
    else
    begin
      inc(l);
      _not_goods[l] := s;
    end;
  end;
  SortGoodsAscending(_goods, k);
  PrintGoodsArray(outF, _goods, k);
  PrintErrorArray(errorF, _not_goods, l);
  close(ini);
  close(outF);
  close(errorF);
end.