program goodies;
uses print,rasp,validate,perem;
var
  ini, outF, errorF: Text;
  k, l: integer;
  _goods: TGoodsList;
  _not_goods: TStringArray;
begin
  assign(ini, 'in.txt');
  assign(outF, 'out.txt');
  assign(errorF, 'error.txt');
  reset(ini);
  rewrite(outF);
  rewrite(errorF);
  read_file(ini,_goods,k,_not_goods,l);
  SortGoodsAscending(_goods, k);
  PrintGoodsArray(outF, _goods, k);
  PrintErrorArray(errorF, _not_goods, l);
  close(ini);
  close(outF);
  close(errorF);
end.