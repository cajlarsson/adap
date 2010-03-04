with Part_Types;              use Part_Types;

Package Soma is

   function Verify(Desc : Part_Array; Goal : Full_Part) return boolean;
   function Solve(Desc : Part_Array; Goal : Full_Part) return Part_Array;


private
end Soma;
