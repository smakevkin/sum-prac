unit validate;
interface
uses perem;
function check(s: string; var checks: TGoods): boolean;
implementation
function check(s: string; var checks: TGoods): boolean;
var
  lolxd1, lolxd2, lolxd3, lolxd4, lolxd5, lolxd6: integer;
begin
  Val(Copy(s, 1, 6), checks.barcode, lolxd1);
  checks.product := s[8:28];
  Val(Copy(s, 29, 6), checks.ProviderCode, lolxd2);
  Val(Copy(s, 36, 2), checks.date.day, lolxd3);
  checks.date.month := s[39:41];
  Val(Copy(s, 43, 4), checks.date.year, lolxd4);
  Val(Copy(s, 48, 4), checks.amount, lolxd5);
  Val(Copy(s, 53, 8), checks.price, lolxd6);
  if (lolxd1 = 0) and (lolxd2 = 0) and (lolxd3 = 0) and (lolxd4 = 0) and (lolxd5 = 0) and (lolxd6 = 0) and
     (pos('|', checks.product) = 0) and
     (pos('|', checks.date.month) = 0) and
     (checks.barcode >= 111111) and (checks.barcode <= 999999) and
     (checks.ProviderCode >= 111111) and (checks.ProviderCode <= 999999) and
     (checks.date.day >= 1) and (checks.date.day <= 31) and
     (checks.amount >= 1) and (checks.amount <= 9999) and
     (checks.price >= 0.01) and (checks.price <= 99999.99) then
    check := True
  else
    check := False;
end;
begin
  
end.