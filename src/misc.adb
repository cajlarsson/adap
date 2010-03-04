package body Misc is

   function To_String (Item : in Integer) return String is
      Text : String := Integer'Image(Item);
   begin
      return Trim(Text, Both);
   end To_String;

   function Get_Dec( Parts : Part_Array; Data: Unbounded_String) return Part_Array is
      Result : Part_Array(Parts'Range);
      Work : Unbounded_String;
   begin
      Work := Tail(Data,Length(Data) -2)& "!" ;
      for I in Result'Range loop
         Result(I) := Parts(I);
         Work := Tail( Work, Length(Work) -1);
         Decorate(Result(I), "!" & Head(Work,Index(Work,"!") -1));

         Work :=  tail(Work,Length(Work) - Index(Work,"!")+1);
         New_Line;
      end loop;

   return Result;
   end Get_Dec;

end Misc;
