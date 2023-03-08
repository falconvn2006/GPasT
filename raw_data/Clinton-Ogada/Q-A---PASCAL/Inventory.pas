Program Inventory(input,output);
{*The program is to calculate the current inventory cost, the optimal inventory cost and the saving if the optimal lot-size is used... written by Clinton Ogada v.1 2/20/2023*}
{*Cs is the unit storage cost per time*}
{*Cd is the cost delivery*}
{*q is the number of times in each delivery (the lot size) *}
{*r is the rate at which the item is sold(the demand rate)*}
const Cs = 1000;
const Cd = 1000;
var
S,C1,C,Co,q,qo,r: Real;
begin
  writeln ('Enter the lot size:');
   Readln (q);
    writeln ('Enter the rate of demand of the item:');
   Readln (r);
    C:= (((Cs*q)/2) + ((Cd * r)/q));
   writeln('The curent inventory cost  is:', C :0:2);
   qo:= (Sqrt((2*Cd*r)/Cs));
       C1:= (((Cs*qo)/2) + ((Cd * r)/qo));
       Writeln('The optimal inventory cost  is:', C1 :0:2);
       S:= C - C1;
       Writeln('The saving is:', S :0:2);
  readln
end.
