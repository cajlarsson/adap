package body Misc is

   function To_String (Item : in Integer) return String is
      Text : String := Integer'Image(Item);
   begin
      return Trim(Text, Both);
   end To_String;

   procedure Put (Item: in Unbounded_String) is
   begin
      Put(To_String(Item));
   end Put;

   procedure Get_Line (Item: out Unbounded_String) is
      Buffer: String(1..100);
      Length: Positive := 100;
   begin
      -- This is needed because GNAT i broken.
      Item := To_Unbounded_String("");
      while Length = 100 loop
         Get_Line(Buffer, Length);
         Item := Item & To_Unbounded_String(Buffer(1..Length));
      end loop;
   end Get_Line;

   function Get_Line return Unbounded_String is
      Temp : Unbounded_String;
   begin
      Get_Line(Temp);
      return Temp;
   end Get_Line;

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

   procedure Del_1_Word(Sbj : in out Unbounded_String) is
   begin
      Sbj := Tail(Sbj,Length(Sbj)-Index(Sbj," "));
   end Del_1_Word;

   function First_word(Str : Unbounded_String) return Unbounded_String is
   begin
      return Trim(Head(Str, Index(Str, " ")) ,Ada.Strings.Left);
   end First_Word;

end Misc;
