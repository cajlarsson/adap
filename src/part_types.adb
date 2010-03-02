with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Unchecked_Deallocation;
with GNAT.RegExp;                        use GNAT.RegExp;

with Ada.Integer_Text_Io;                use Ada.Integer_Text_Io;

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

   function Get(Src : Unbounded_String; Id :integer)return Full_Part is
   Dst : Full_Part;
   begin
      Get(Src,Id,Dst);
      Return Dst;
   end Get;

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
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Off.X)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Off.Y)))
        & ' ' &
        Trim1(to_Unbounded_String(Integer'Image( Packet.Genotype.Off.Y)));

   end Put;

   function Put(Packet : Full_Part) return Unbounded_String is
      Result : Unbounded_String;
   begin
      Put(Packet, Result);
      return Result;
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

   procedure Move_to(Sbj: in out  Full_Part; X,Y,Z :  in Integer) is
   begin
      Sbj.Genotype.Off.X := X;
      Sbj.Genotype.Off.Y := Y;
      Sbj.Genotype.Off.Z := Z;

   end Move_To;

   procedure Rotate_To (Sbj: in out Full_Part ; X,Y,Z :in Integer) is
   N : Integer;
   begin
      N := X;
      while N < 0 loop
         N := N +4;
      end loop;

      for I in 1..N loop
         Rotate_X_Cw(Sbj);
      end loop;

       N := Y;
      while N < 0 loop
         N := N +4;
      end loop;

      for I in 1..N loop
         Rotate_Y_Cw(Sbj);
      end loop;

       N := Z;
      while N < 0 loop
         N := N +4;
      end loop;

      for I in 1..N loop
         Rotate_Z_Cw(Sbj);
      end loop;
   end Rotate_To;

   procedure Grow(src : in out Full_Part; Dst :   out Full_Part) is
   begin
      Clear(Dst.Phenotype.bits);
      New_Line;
      Put(Src.Phenotype.Bits);
      New_Line;
      for Z in 1..Src.Phenotype.X loop
         for Y in 1..Src.Phenotype.Y loop
            for X in 1..Src.Phenotype.Z loop
               Put(Src.Phenotype.bits,Src.Phenotype.X*Src.Phenotype.Y*Z + Src.Phenotype.X*Y + X -6 );
               Put(Integer( Index(Src.Phenotype.bits,Src.Phenotype.X*Src.Phenotype.Y*Z + Src.Phenotype.X*Y + X -6 )));
               New_Line;
               Set_Index(Dst.Phenotype.bits
                           ,((X + Src.Genotype.Off.X)
                             *(Y + Src.Genotype.Off.Y)
                               *(Z + Src.Genotype.Off.Z)
                               +((X + Src.Genotype.Off.X)
                                 *(Y + Src.Genotype.Off.Y))
                               +(X + Src.Genotype.Off.X))
                         ,Index(Src.Phenotype.bits,Src.Phenotype.X*Src.Phenotype.Y*Z + Src.Phenotype.X*Y + X -6 ));

            end loop;
         end loop;
      end loop;
        Put(Dst.Phenotype.Bits);
   end Grow;

   procedure Rotate_X_Cw(Sbj : in out Full_Part) is
   begin
      null;
   end Rotate_X_Cw;

   procedure Rotate_Y_Cw(Sbj : in out Full_Part) is
   begin
   null;
   end Rotate_Y_Cw;

   procedure Rotate_Z_Cw(Sbj : in out Full_Part) is
   begin
   null;
   end Rotate_Z_Cw;



end Part_Types;
