package body Part_Convert is

   function Part_From_File_To_Packet(Input_Type : S_In) return Unbounded_String;

   function Figure_From_File_To_Packet(Input_Type : S_In) return Unbounded_String;

   function Get(Input_Type : S_In) return Bit_Type is
      C : Character;
   begin
      loop
         Get
      end loop;
   end Get;

   function Get_Size_From_Dim(D : String) return Natural is
      X, Y, Z, P1, P2 : Natural := 1;
   begin
      for I in 1..D'Last loop
         if (D(1));
         end if;
      end loop;
   end Get_Size_From_Dim;

   function Get_Dimension(Input_Type: S_In) return Unbounded_String is
      Re : constant Regexp :=
        Compile ("Dimensions: [0-9]x[0-9]x[0-9]", Glob => True);
      Row : String(1..ROW_LENGTH);
      Row_Len : Integer;
      Res : Unbounded_String;
   begin
      Get_Line(S_In, Row, Row_Len);

      if Match(Ds(1..Row_Len), Re) then
         Res := To_Unbounded_String(Row(12..Row_Len));

      end if;
   end Get_Dimenstion;

end Part_Convert;
