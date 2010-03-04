with Ada.Text_Io; use Ada.Text_Io;
package body Soma is

   function Verify(Desc : Part_Array; Goal : Full_Part) return Boolean is
      Inverted_Goal,Result,work : Full_Part;
      Ret : Boolean;
   begin
      Result := not Goal;
      Work := (not Goal ) and Goal;

      for I in Desc'Range loop
         --Put(Desc(I));
         Clear_bits(Work);
         Grow(Rotate(Desc(I)),Work);
      --   Put(Rotate(Desc(I)));
         Result := Work or Result;
         Put(Result);
         New_Line;
      end loop;

      Put( Result);
      Ret := Empty( not Result);

      Delete(Result);
      Delete(Work);

      return Ret;

   end Verify;

   function Solve(Desc : Part_Array; Goal : Full_Part) return Part_Array is
   begin
   return Desc;
   end Solve;



end Soma;
