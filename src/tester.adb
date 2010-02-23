with Ada.Integer_Text_Io;  use Ada.Integer_Text_Io;
with Bit_Volume;           use Bit_Volume;

with Ada.Text_Io; use Ada.Text_Io;


procedure Tester is
   Bvt,b2 : Bit_Volume_Type;

   type A is mod 2**64;
begin
   Bvt :=   Make(Integer'Last);
   B2 :=   Make(Integer'Last);

   Set_Index(Bvt,797,1);
   -- Put(bvt);
   --  Put(5);
   B2 := not Bvt;

   Put( Ones (B2));








end Tester;

