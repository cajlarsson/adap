with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Strings;                        use Ada.Strings;
with Ada.Strings.Fixed;                  use Ada.Strings.Fixed;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Characters;                     use Ada.Characters;


with Misc;                               use Misc;
with Packets;                            use Packets;
with Part_Types;                         use Part_Types;


procedure Grafics is

   type Full_Part_Array is array (Integer range <>) of Full_Part;
   type FP_A is access Full_Part_Array;

   procedure Drawz(Sträng : String) is

   begin

      Put_Line(Sträng);

   end Drawz;

   procedure Pussel(Lösis, Del : Full_Part; Frame : Integer) is

      Putty : Unbounded_String;

   begin
      for I in 1.. Dimensions(Lösis).Y loop
         Putty := To_Unbounded_String("[");
         for J in 1.. Dimensions(Lösis).X loop
            --Put_Line("J");
            Putty:= Putty & To_String(Integer(Index(Lösis,J,I,Frame)));
         end loop;
         if I mod Dimensions(Del).Y = 1 and
           (I+1)/Dimensions(Del).Y <= Dimensions(Del).Z  then

            Putty:=  Putty & "](";

         elsif (I+1)/Dimensions(Del).Y <= Dimensions(Del).Z  then

            Putty:= Putty & "][";

         else

           Putty:= Putty & "]";

         end if;
         for K in 1.. Dimensions(Del).X loop
            if (I+1)/Dimensions(Del).Y <= Dimensions(Del).Z  then
               Putty:= Putty & To_String(Integer
                                           (Index(Del,
                                                  K,1+((I-1) mod Dimensions(Del).Y),
                                                  (I+1)/Dimensions(Del).Y)));
--Put(K*100+10*(1+((I-1) mod Dimensions(Del).Y))+(I+1)/Dimensions(Del).Y);
            end if;
         end loop;
         if I mod Dimensions(Del).Y = 1 and
           (I+1)/Dimensions(Del).Y <= Dimensions(Del).Z  then

            Putty:=  Putty & ")";

         elsif (I+1)/Dimensions(Del).Y <= Dimensions(Del).Z  then

            Putty:= Putty & "]";

         end if;
         Drawz(To_String(Putty));
      end loop;

   end Pussel;


begin

   Pussel(Get(To_Unbounded_String("3x4x2 110101011111101111000001"),23),
          Get(To_Unbounded_String("2x2x2 10101010"),1),
          1);
null;

end Grafics;
