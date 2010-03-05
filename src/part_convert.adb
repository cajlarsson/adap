package body Part_Convert is

   function From_File_To_Part_Array (F_In : Input_Type) return Part_Array is
      Res : Part_Array_Access;
      List : Part_List.List_Type;
   begin
      List := Get_Part_List(F_In);
      Res := new Part_Array(1..Part_List.Length(List));
      for I in 1..Part_List.Length(List) loop
         Res(I) := Part_List.Find(List, I);
      end loop;
      return Res.all;
   end From_File_To_Part_Array;

   function Get_Part_List (I : Input_Type) return Part_List.List_Type is
      List : Part_List.List_Type;
      Temp : Part_Struct;
   begin
      loop
         Temp := Get_Part(I);
         Part_List.Insert(List, Get(Temp.Dim &To_Unbounded_String(" ")& Temp.Data, Temp.Id));
      end loop;
   exception
      when End_Error =>
         return List;
   end Get_Part_List;

   procedure Put (Item: Part_Struct) is
   begin
      Put("Id: " & To_String(Item.Id));
      New_Line;
      Put("Dimension: ");
      Put(Item.Dim);
      New_Line;
      Put("Data: ");
      Put(Item.Data);
      New_Line;
   end Put;

   function Get_Bit (S_In : Input_Type) return String is
      C : Character;
   begin
      loop
         Get(S_In, C);
         if C = '0' or C = '1' then
            return ""&C;
         end if;
      end loop;
   end Get_Bit;

   function Get_Part_Data (I: Input_Type; X: Natural; Y: Natural; Z: Natural) return Unbounded_String is
      Res: Unbounded_String;
   begin
      for I_Z in 1..Z loop
         for I_Y in 1..Y loop
            for I_X in 1..X loop
               Res := Res & To_Unbounded_String(Get_Bit(I));
            end loop;
            Skip_Line(I);
         end loop;
         Skip_Line(I);
      end loop;
      return Res;
   end Get_Part_Data;

   function Get_Part (I : Input_Type) return Part_Struct is
      Re_Part_Cap : constant Pattern_Matcher :=
        Compile ("# Part: ([0-9]{1,2})");
      Re_Dim : constant Pattern_Matcher :=
        Compile ("Dimensions: [0-9]{1,2}x[0-9]{1,2}x[0-9]{1,2}");
      Re_Dim_Cap : constant Pattern_Matcher :=
        Compile ("Dimensions: ([0-9]{1,2})x([0-9]{1,2})x([0-9]{1,2})");
      Matches_Dim : Match_Array(1..3);
      Matches_Part : Match_Array(1..1);
      Row : String(1..ROW_LENGTH);
      Row_Len : Integer;
      Res : Part_Struct;
      X,Y,Z: Natural := 0;
   begin
      Get_Line(I, Row, Row_Len);
      Match(Re_Part_Cap, Row(1..Row_Len), Matches_Part);
      Res.Id := Integer'Value(Row(Matches_Part(1).First .. Matches_Part(1).Last));
      Get_Line(I, Row, Row_Len);
      --if Match(Re_Dim, Row(1..Row_Len)) then
      Match(Re_Dim_Cap, Row(1..Row_Len), Matches_Dim);
      X := Integer'Value(Row(Matches_Dim(1).First .. Matches_Dim(1).Last));
      Y := Integer'Value(Row(Matches_Dim(2).First .. Matches_Dim(2).Last));
      Z := Integer'Value(Row(Matches_Dim(3).First .. Matches_Dim(3).Last));
      Res.Data := Get_Part_Data(I,X,Y,Z);
      Res.Dim := To_Unbounded_String(To_String(X) &"x"& To_String(Y) &"x"& To_String(Z));
      --end if;
      return Res;
   end Get_Part;

end Part_Convert;
