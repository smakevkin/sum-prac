program goodies;
uses print,rasp,validate,perem;

var
  ini, outF, errorF: Text;
  s: string;
  i:integer;
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
    Inc(i);
    if i<=M then begin
      Inc(countGoods);
      readln(ini, s);
      check(s, countGoods);
      Writeln();
    end
    else begin 
      Writeln('Начиная с строки ',countGoods,' обработка проводится не будет. Обрабатывается максимум 100 строк.');
      Readln(ini);
    end;
  end;
  SortGoodsAscending(_goods, k);
  PrintGoodsArray(outF, _goods, k);
  PrintErrorArray(errorF, _not_goods, l);
  close(ini);
  close(outF);
  close(errorF);
end.