with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with GNAT.RegExp;                        use GNAT.RegExp;

with Ada.Integer_Text_Io;                use Ada.Integer_Text_Io;
with Misc;                               use Misc;

 --debug
with Ada.Text_Io; use Ada.Text_Io;
--debug

package body Part_Types is

   procedure Get(Src :in Unbounded_String; Id :integer ; Packet :out Full_Part) is
      Re:  Regexp := Compile ("^[0-9]*x[0-9]*x[0-9]* "
                                , Glob => True);
      Position : Natural;
      Data : Unbounded_String;
   begin
    --FIXME: Johan fixa regexp grejen :)
    --FIXME: Borde ha ett exception block för att fånga krasch i bit_volume.get

    --  if not Match(To_String(Head(Src,Index(Src," "))), Re) then
    --     raise Malformed_Input;
    --  end if;

      Packet := Make;
      Packet.Genotype.Master := Id;

      Data := Src;
      Position := Index(data,"x") -1 ; -- ändrad till text
      --   Put_Line(To_String( Head(Data,Position)));
      Packet.Phenotype.X := Integer'Value(To_String(Head(Data,Position)));

      Data := Tail(Data,Length(Data)- Position -1);
      Position := Index(Data,"x") -1;
      --    Put_Line(To_String( Head(Data,Position)));
      Packet.Phenotype.Y := Integer'Value(To_String(Head(Data,Position)));

      Data := Tail(Data,Length(Data)- Position -1);
      --      Put_Line(To_String( Head(Data,Position)));
      Packet.Phenotype.Z := Integer'Value(To_String(Head(Data,Position)));
      Position := Index(Data," ") -1;
      Data := Tail(Data,Length(Data)- Position -1);
      --      Put_Line(To_String(Data));
      Packet.Phenotype.Bits := Get(Data);
   end Get;

   function Get_Id(Item: Full_Part) return Integer is
   begin
      return Item.Genotype.Master;
   end Get_Id;

   function Get(Src : Unbounded_String; Id :integer)return Full_Part is
   Dst : Full_Part;
   begin
      Get(Src,Id,Dst);
      Return Dst;
   end Get;

   procedure Decorate(Sbj : in out Full_Part; Data : in Unbounded_String) is
      Work : Unbounded_String;

      function First_Num(Str : Unbounded_String) return Integer is
      begin
         return Integer'Value(To_String(Trim(Head(Str,
                                                  Index(Str, " "))
                                               ,Ada.Strings.Left)));
      end First_Num;

      procedure Del_1_Word(Sbj : in out Unbounded_String) is
      begin
          Sbj := Tail(Sbj,Length(Sbj)-Index(Sbj," "));
      end Del_1_Word;

   begin
      Work := Trim(Data,Ada.Strings.Left) &" ";
      Del_1_Word(Work);
      Sbj.Genotype.Rot.X := First_Num(Work);
      Del_1_Word(Work);
      Sbj.Genotype.Rot.Y := First_Num(Work);
      Del_1_Word(Work);
      Sbj.Genotype.Rot.Z := First_Num(Work);
      Del_1_Word(Work);
      Sbj.Genotype.Off.X := First_Num(Work);
      Del_1_Word(Work);
      Sbj.Genotype.Off.Y := First_Num(Work);
      Del_1_Word(Work);
      Sbj.Genotype.Off.Z := First_Num(Work);
   end Decorate;



   procedure Put(Packet : in  Full_Part; Src : out Unbounded_string) is
      function Trim1(Src :Unbounded_String) return Unbounded_String is
      begin
         if To_String(Src)(1..1) = " " then
            return Tail(Src, Length(Src) -1);
         else
            return Src;
         end if;

      end Trim1;

   begin
      Src := "! " &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Rot.X)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Rot.Y)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Rot.Z)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Off.X
                                               + Packet.Genotype.Roff.x)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Off.Y
                                               + Packet.Genotype.Roff.Y)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Off.Z
                                               + Packet.Genotype.Roff.Z)));

   end Put;

   function Put(Packet : Full_Part) return Unbounded_String is
      Result : Unbounded_String;
   begin
      Put(Packet, Result);
      return Result;
   end Put;

   procedure Put(Packet : Full_Part) is
   begin
      Put("Dim: ");
      Put(Packet.Phenotype.X);
      Put(Packet.Phenotype.Y);
      Put(Packet.Phenotype.Z);
      New_Line;
      Put("Rot: ");
      Put(Packet.Genotype.Rot.X);
      Put(Packet.Genotype.Rot.y);
      Put(Packet.Genotype.Rot.z);
      New_Line;
      Put("Off: ");
      Put(Packet.Genotype.off.X);
      Put(Packet.Genotype.off.y);
      Put(Packet.Genotype.off.z);
      New_Line;
      Put("rof: ");
      Put(Packet.Genotype.roff.X);
      Put(Packet.Genotype.roff.y);
      Put(Packet.Genotype.roff.z);
      New_Line;
      Put("Bits: ");
      Put(Packet.Phenotype.Bits);
   end Put;

   procedure Put_Phenotypes(Packets : in Part_Array;
                            Dst : out Unbounded_String) is
   begin
      Dst := To_Unbounded_String(Packets);
   end Put_Phenotypes;

   function To_Unbounded_String(Packet : in Full_Part) return Unbounded_String is
      R : Unbounded_String;
   begin
      R := To_Unbounded_String(To_String(Packet.Phenotype.X));
      R := R & "x" & To_Unbounded_String(To_String(Packet.Phenotype.y));
      R := R & "x" & To_Unbounded_String(To_String(Packet.Phenotype.z));
      R := R & " " & Put(Packet.Phenotype.Bits);
      return R;
   end To_Unbounded_String;

   function To_Unbounded_String(Packets : in Part_Array) return  Unbounded_String is
      Result : Unbounded_String;
   begin
      Result := To_Unbounded_String(To_String(Packets'Last)) ;

      for I in Packets'Range loop
         Result := Result & " " & To_Unbounded_String(Packets(I));
      end loop;
      return Result;

   end To_Unbounded_String;

   procedure Put(Item : Part_Array) is
   begin
      Put(To_Unbounded_String(Item));
   end Put;

   function Make return Full_Part is
      Result : Full_Part;
   begin
      Result := new Full_Part_Base;
      Result.phenotype := Make;
      Result.Genotype := Make;
      return Result;
   end Make;

   function Make return Part_Volume is
      Result : Part_Volume;
   begin
      Result := new Part_Volume_Base;
      Result.X := 0;
      Result.Y := 0;
      Result.Z := 0;
      Result.Bits := Make(1);
      return Result;
   end Make;

   function Make return Part_Type is
      Result : Part_Type;
   begin
      Result := new Part_Type_Base;
      Result.Rot.X := 0;
      Result.Rot.Y := 0;
      Result.Rot.Z := 0;
      Result.Off.X := 0;
      Result.Off.Y := 0;
      Result.Off.Z := 0;
      Result.Roff.X := 0;
      Result.Roff.Y := 0;
      Result.Roff.Z := 0;
      Result.Master := 0;
      return Result;
   end Make;

   function Make(X,Y,Z,id :Integer) return Full_Part is
      Result : Full_Part;
   begin
      Result := new Full_Part_Base;
      Result.phenotype := Make(X,Y,Z);
      Result.Genotype := Make(Id);
      return Result;
   end Make;

   function Make(X,Y,Z :Integer) return Part_Volume is
      Result : Part_Volume;
   begin
      Result := new Part_Volume_Base;
      Result.X := X;
      Result.Y := Y;
      Result.Z := Z;
      Result.Bits := Make(X*Y*Z);
      return Result;
   end Make;

   function Make(ID:Integer) return Part_Type is
      Result : Part_Type;
   begin
      Result := new Part_Type_Base;
      Result.Rot.X := 0;
      Result.Rot.Y := 0;
      Result.Rot.Z := 0;
      Result.Off.X := 0;
      Result.Off.Y := 0;
      Result.Off.Z := 0;
      Result.Master := id;
      return Result;
   end Make;

   procedure Delete(Inane : in out Full_Part) is
      procedure Free is new Ada.Unchecked_Deallocation
        (Object => Full_Part_Base, Name => Full_part);
   begin
      Delete(Inane.Genotype);
      Delete(Inane.Phenotype);
      Free(Inane);
   end delete;

   procedure Delete(Inane : in out Part_Volume) is
       procedure Free is new Ada.Unchecked_Deallocation
        (Object => Part_Volume_Base, Name => Part_Volume);
   begin
      Delete(Inane.Bits);
      Free(Inane);
   end delete;

   procedure Delete(Inane : in out Part_Type) is
    procedure Free is new Ada.Unchecked_Deallocation
        (Object => Part_Type_Base, Name => Part_Type);
   begin
      Free(Inane);
   end delete;

   function Index(Src: Full_Part; X,Y,Z : Integer) return Bit is
   begin
--      Put(Integer(Index( Src.Phenotype.Bits,
--                    Src.Phenotype.X * Src.Phenotype.Y * (Z-1)
  --                         +Src.Phenotype.X*(Y-1) + X)));
  --    New_Line;
      return Index( Src.Phenotype.Bits,
                    Src.Phenotype.X * Src.Phenotype.Y * (Z-1)
                      +Src.Phenotype.X*(Y-1) + X);
   end Index;

   procedure Set_Index( Dst : in out Full_Part;Src : in bit ; X,Y,Z : in Integer) is
   begin
      Set_Index(Dst.Phenotype.bits, dst.Phenotype.X * dst.Phenotype.Y * (Z-1)
                  +dst.Phenotype.X*(Y-1) + X,Src);
     end Set_Index;

     function "and" (FP1,FP2 : Full_Part) return Full_Part is
     Result : Full_Part;
     begin
        if Fp1.Phenotype.X /= Fp2.Phenotype.X
          or Fp1.Phenotype.Y /= Fp2.Phenotype.Y
          or Fp1.Phenotype.Z /= Fp2.Phenotype.Z then
           raise Incompatible_Dimensions;
        end if;
        Result := Make(Fp1.Phenotype.X , Fp1.Phenotype.Y,
                       Fp1.Phenotype.Z, Fp1.Genotype.Master);
        Result.Phenotype.Bits := Fp1.Phenotype.Bits and Fp2.Phenotype.Bits;
        return Result ;
     end "and";

     function "or" (FP1,FP2 : Full_Part) return Full_Part is
     Result : Full_Part;
     begin
        if Fp1.Phenotype.X /= Fp2.Phenotype.X
          or Fp1.Phenotype.Y /= Fp2.Phenotype.Y
          or Fp1.Phenotype.Z /= Fp2.Phenotype.Z then
           raise Incompatible_Dimensions;
        end if;
        Result := Make(Fp1.Phenotype.X , Fp1.Phenotype.Y,
                       Fp1.Phenotype.Z, Fp1.Genotype.Master);
        Result.Phenotype.Bits := Fp1.Phenotype.Bits or Fp2.Phenotype.Bits;
        return Result ;
     end "or";

     function "not" (FP : Full_Part) return Full_Part is
     Result : Full_Part;
     begin
        Result := Make(Fp.Phenotype.X , Fp.Phenotype.Y,
                       Fp.Phenotype.z, Fp.Genotype.Master);
        Result.Phenotype.Bits := not Fp.Phenotype.Bits;
        Result.Genotype := Fp.Genotype;
        return Result ;
     end "not";


     function "=" (FP1,FP2 : Full_Part) return Boolean is
     begin
        if Fp1.Phenotype.X /= Fp2.Phenotype.X
          or Fp1.Phenotype.Y /= Fp2.Phenotype.Y
          or Fp1.Phenotype.Z /= Fp2.Phenotype.Z then
           raise Incompatible_Dimensions;
        end if;

        return Fp1.Phenotype.Bits = Fp2.Phenotype.Bits;
     end "=";



     function Dimensions(Src : Full_Part) return Offset_Type is
     Result : Offset_Type;
     begin
        Result.X := Src.Phenotype.X;
        Result.y := Src.Phenotype.y;
        Result.z := Src.Phenotype.z;

        return Result;

     end Dimensions;

   procedure Move_to(Sbj: in out  Full_Part; X,Y,Z :  in Integer) is
   begin
      Sbj.Genotype.Off.X := X;
      Sbj.Genotype.Off.Y := Y;
      Sbj.Genotype.Off.Z := Z;

   end Move_To;

   procedure Rotate_To (Sbj: in out Full_Part ; X,Y,Z :in Integer) is
   N : Integer;
   begin
 --     Put(Sbj);
      N := X;
      while N < 0 loop
         N := N +4;
      end loop;

      for I in 1..N loop
         Rotate_X_Cw(Sbj);
      end loop;

      case N is
         when 1 =>
            Sbj.Genotype.Roff.Y := Sbj.Genotype.Roff.Y + Sbj.Phenotype.Z;
         when 2 =>
            Sbj.Genotype.Roff.Y := Sbj.Genotype.Roff.Y + Sbj.Phenotype.Y;
            Sbj.Genotype.Roff.Z := Sbj.Genotype.Roff.Z + Sbj.Phenotype.Z;
         when 3 =>
            Sbj.Genotype.Roff.Z := Sbj.Genotype.Roff.Z + Sbj.Phenotype.Y;
         when others =>
            null;
      end case;


      N := Y;
      while N < 0 loop
         N := N +4;
      end loop;

      for I in 1..N loop
         Rotate_Y_Cw(Sbj);
      end loop;

      case N is
         when 1 =>
            Sbj.Genotype.Roff.z := Sbj.Genotype.Roff.z + Sbj.Phenotype.x;
         when 2 =>
            Sbj.Genotype.Roff.x := Sbj.Genotype.Roff.x + Sbj.Phenotype.x;
            Sbj.Genotype.Roff.Z := Sbj.Genotype.Roff.Z + Sbj.Phenotype.z;
         when 3 =>
            Sbj.Genotype.Roff.x := Sbj.Genotype.Roff.x + Sbj.Phenotype.z;
         when others =>
            null;
      end case;


       N := Z;
      while N < 0 loop
         N := N +4;
      end loop;

      --Put(N);


      for I in 1..N loop
         Rotate_Z_Cw(Sbj);
      end loop;

           case N is
         when 1 =>
            Sbj.Genotype.Roff.x := Sbj.Genotype.Roff.x + Sbj.Phenotype.y;
         when 2 =>
            Sbj.Genotype.Roff.x := Sbj.Genotype.Roff.x + Sbj.Phenotype.x;
            Sbj.Genotype.Roff.y := Sbj.Genotype.Roff.y + Sbj.Phenotype.y;
         when 3 =>
            Sbj.Genotype.Roff.y := Sbj.Genotype.Roff.y + Sbj.Phenotype.x;
         when others =>
            null;
      end case;

--Put(Sbj);
   end Rotate_To;

   procedure Grow(src : in Full_Part; Dst : in out Full_Part) is
   begin
      Clear(Dst.Phenotype.bits);
   --     New_Line;
--        Put(Src.Phenotype.Bits);
 --b       New_Line;

      for Z in 1..Src.Phenotype.Z loop
         for Y in 1..Src.Phenotype.Y loop
            for X in 1..Src.Phenotype.X loop
               --            Put(Src.Phenotype.X*Src.Phenotype.Y*(Z-1) + Src.Phenotype.X*(Y-1) + X );
     --                 Put((dst.Phenotype.x) * (dst.Phenotype.Y) * (Z-1)
--                              +(dst.Phenotype.X ) * (Y-1) + X);
--          New_Line;
               Set_Index(Dst, Index(src,X,Y,Z)
                           ,X+Src.Genotype.Off.X +Src.Genotype.Roff.x ,
                         Y + Src.Genotype.Off.Y +Src.Genotype.Roff.y,
                         Z + Src.Genotype.Off.Z +Src.Genotype.Roff.z);
            end loop;
         end loop;
      end loop;
    --  Set_Index(Dst,Bit(1),2,1,1);
   --   Set_Index(Dst.Phenotype.Bits,1,1);
    --  Put(Dst.Phenotype.Bits);
   end Grow;


   procedure Rotate_X_Cw(Sbj : in out Full_Part) is
      Worker : Full_Part;

      procedure Swap_Row(Src_a,Src_B,Dst_A,Dst_B : integer) is
      begin
--           New_Line;
--           Put (Src_A);
--           Put( Src_B);
--           New_Line;
--           Put(Dst_A);
--           Put(Dst_B);
--           New_Line;
         for X in 1..Sbj.Phenotype.X loop
            Set_Index(Worker,Index(Sbj,X,Src_A,Src_B)
                        ,X,Dst_A,Dst_b);
         end loop;
      end Swap_Row;

   begin



      Worker := Make(Sbj.Phenotype.X,
                     Sbj.Phenotype.Z, --swap y and z dimensional sizes
                       Sbj.Phenotype.Y,
                     Sbj.Genotype.Master);

      Worker.Genotype := Sbj.Genotype;
--        New_Line;
--        Put_Line("--------------------------------");
--        Put_Line("rotation");
--        Put(Sbj.Phenotype.Y);
--        Put(Sbj.Phenotype.z);
--        New_Line;
--        Put(worker.Phenotype.Y);
--        Put(worker.Phenotype.z);
--        New_Line;
--        Put("--------------------------------");
--        New_Line;
      for y in 1..Sbj.Phenotype.Y loop
         for Z in 1..Sbj.Phenotype.Z loop
            Swap_Row( Y,Z
                        ,sbj.Phenotype.z -z +1
                        , y );
         end loop;
      end loop;

      Sbj := Worker;
   end Rotate_X_Cw;

   procedure Rotate_Y_Cw(Sbj : in out Full_Part) is
      Worker : Full_Part;

      procedure Swap_Row(Src_a,Src_B,Dst_A,Dst_B : integer) is
      begin
--           New_Line;
--           Put (Src_A);
--           Put( Src_B);
--           New_Line;
--           Put(Dst_A);
--           Put(Dst_B);
--           New_Line;
         for Y in 1..Sbj.Phenotype.Y loop
            Set_Index(Worker,Index(Sbj,Src_A,Y,Src_B)
                        ,Dst_A,Y,Dst_b);
            end loop;
      end Swap_Row;

   begin
      Worker := Make(Sbj.Phenotype.Z,
                     Sbj.Phenotype.Y, -- swap y and z dimensional sizes
                     Sbj.Phenotype.X,
                     Sbj.Genotype.Master);
      Worker.Genotype := Sbj.Genotype;

--        New_Line;
--        Put_Line("--------------------------------");
--        Put_Line("rotation");
--        Put(Sbj.Phenotype.x);
--        Put(Sbj.Phenotype.z);
--        New_Line;
--        Put(worker.Phenotype.x);
--        Put(worker.Phenotype.z);
--        New_Line;
--        Put("--------------------------------");
--        New_Line;

      for X in 1..Sbj.Phenotype.X loop
         for Z in 1..Sbj.Phenotype.Z loop
            Swap_Row( X,Z
                        ,sbj.Phenotype.z -z +1
                        , X );
         end loop;
      end loop;

      Sbj := Worker;
   end Rotate_Y_Cw;

   procedure Rotate_Z_Cw(Sbj : in out Full_Part) is
      Worker : Full_Part;

      procedure Swap_Row(Src_a,Src_B,Dst_A,Dst_B : integer) is
      begin
--           New_Line;
--           Put (Src_A);
--           Put( Src_B);
--           New_Line;
--           Put(Dst_A);
--           Put(Dst_B);
--           New_Line;
         for z in 1..Sbj.Phenotype.z loop
            Set_Index(Worker,Index(Sbj,Src_A,Src_B,z)
                        ,Dst_A,Dst_B,z);
            end loop;
      end Swap_Row;

   begin
      Worker := Make(Sbj.Phenotype.Y,
                     Sbj.Phenotype.X, -- swap y and z dimensional sizes
                     Sbj.Phenotype.Z,
                     Sbj.Genotype.Master);

      Worker.Genotype := Sbj.Genotype;
--        New_Line;
--        Put_Line("--------------------------------");
--        Put_Line("rotation");
--        Put(Sbj.Phenotype.x);
--        Put(Sbj.Phenotype.Y);
--        Put(Sbj.Phenotype.Z);
--        New_Line;
--        Put(worker.Phenotype.x);
--        Put(worker.Phenotype.y);
--        Put(Worker.Phenotype.z);
--        New_Line;
--        Put("--------------------------------");
--        New_Line;

      for X in 1..Sbj.Phenotype.X loop
         for y in 1..Sbj.Phenotype.y loop
            Swap_Row( X,y
                        ,sbj.Phenotype.y -y +1
                        , X );
         end loop;
      end loop;

      Sbj := Worker;
   end Rotate_Z_Cw;


   procedure Clear_bits (Sbj : in out Full_Part) is
   begin
      Clear(Sbj.Phenotype.Bits);
   end Clear_Bits;

   function Rotate(Sbj : Full_Part) return Full_Part is
   Result : Full_Part;
   begin
  --    Put(Sbj);
      Result := Make(Sbj.Phenotype.X,Sbj.Phenotype.Y,Sbj.Phenotype.Z,0);
--      New_Line;
--      Put(Result);
--      New_Line;

      Result.Phenotype.Bits := sbj.phenotype.bits;
      Rotate_To(Result,Sbj.Genotype.Rot.X,Sbj.Genotype.Rot.Y,Sbj.Genotype.Rot.Z);
  --    Put (Result);


      Result.Genotype := Sbj.Genotype;
      return Result;
   end Rotate;

   function Empty (Sbj : in Full_Part) return Boolean is
   begin
   return Empty(Sbj.Phenotype.Bits);
   end Empty;

end Part_Types;
