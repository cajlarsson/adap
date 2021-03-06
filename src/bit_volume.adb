with  Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;

package body Bit_Volume is

   procedure Free is new Ada.Unchecked_Deallocation
     (Object => Bit_Chunks_type, Name => Bit_Chunks);

   procedure Free is new Ada.Unchecked_Deallocation
     (Object => Bit_Volume_base, Name => Bit_Volume_Type);

   function Make(Length : Positive) return Bit_Volume_Type is
      Ou : Bit_Volume_Type;
   begin
      Ou := new Bit_Volume_Base;
      Ou.Chunks := new Bit_Chunks_Type(1..(1+(Length / 64)));
      Ou.Last_Chunk_Length := Length  mod  64;
      return Ou;
   end Make;

   procedure Delete(BVT: in out Bit_Volume_Type) is
   begin
      Free(BVT.Chunks);
      Free(BVT);
   end;

   function "and" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type is
         Result : Bit_Volume_Type;
   begin
      if BVT1.Last_Chunk_Length /= BVT2.Last_Chunk_Length
        or BVT1.Chunks'first /= BVT2.Chunks'first
        or BVT1.Chunks'last /= BVT2.Chunks'Last then
         raise Not_Same_Size;
      end if;
      Result := new Bit_Volume_Base;
      Result.Chunks := new Bit_Chunks_Type(BVT1.Chunks'Range);
      Result.Last_Chunk_Length := BVT1.Last_Chunk_Length;
      for I in BVT1.chunks'Range loop
         Result.Chunks(I) := BVT1.Chunks(I) and BVT2.Chunks(I);
      end loop;
         return Result;
   end "and";

   function "or" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type is
      Result : Bit_Volume_Type;
   begin
      if BVT1.Last_Chunk_Length /= BVT2.Last_Chunk_Length
        or BVT1.Chunks'first /= BVT2.Chunks'first
        or BVT1.Chunks'last /= BVT2.Chunks'Last then
         raise Not_Same_Size;
      end if;
      Result := new Bit_Volume_Base;
      Result.Chunks := new Bit_Chunks_Type(BVT1.Chunks'Range);
      Result.Last_Chunk_Length := BVT1.Last_Chunk_Length;
      for I in BVT1.chunks'Range loop
         Result.Chunks(I) := BVT1.Chunks(I) or BVT2.Chunks(I);
      end loop;
         return Result;
   end "or";

   function "xor" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type is
      Result : Bit_Volume_Type;
   begin
      if BVT1.Last_Chunk_Length /= BVT2.Last_Chunk_Length
        or BVT1.Chunks'first /= BVT2.Chunks'first
        or BVT1.Chunks'last /= BVT2.Chunks'Last then
         raise Not_Same_Size;
      end if;
      Result := new Bit_Volume_Base;
      Result.Chunks := new Bit_Chunks_Type(BVT1.Chunks'Range);
      Result.Last_Chunk_Length := BVT1.Last_Chunk_Length;
      for I in BVT1.chunks'Range loop
         Result.Chunks(I) := BVT1.Chunks(I) xor BVT2.Chunks(I);
      end loop;
         return Result;
   end "xor";

   function "not" (BVT :Bit_Volume_Type) return Bit_Volume_Type is
      Result : Bit_Volume_Type;
   begin
      Result := new Bit_Volume_Base;
      Result.Chunks := new Bit_Chunks_Type(BVT.Chunks'Range);
      Result.Last_Chunk_Length := BVT.Last_Chunk_Length;
      for I in BVT.chunks'Range loop
         Result.Chunks(I) :=  not BVT.Chunks(I) ;
      end loop;
         return Result;
   end "not";

   function "=" (BVT1,BVT2 :Bit_Volume_Type) return Boolean is
   Result : Boolean := True;
   begin
      if BVT1.Last_Chunk_Length /= BVT2.Last_Chunk_Length
        or BVT1.Chunks'first /= BVT2.Chunks'first
        or BVT1.Chunks'last /= BVT2.Chunks'Last then
         raise Not_Same_Size;
      end if;


      for I in 1..(bvt1.chunks'Last -1) loop
         if  Bvt1.Chunks(I) /= Bvt2.Chunks(I)  then
            Result := False;
         end if;
      end loop;

      if (Bvt1.Chunks(Bvt1.Chunks'Last) and
            (  Rest_Table(Bvt1.Last_Chunk_Length)))
        /=
           (Bvt2.Chunks(Bvt2.Chunks'Last) and
              Rest_Table(Bvt2.Last_Chunk_Length))
      then
         Result := False;
         end if;

         return Result;
   end "=";

   function empty (BVT : Bit_Volume_Type) return Boolean is
      Result : Boolean := True;
   begin
      for I in 1..(bvt.chunks'Last -1) loop
         if  Bvt.Chunks(I) /= 0 then
            Result := False;
         end if;
      end loop;

          if (Bvt.Chunks(Bvt.Chunks'Last) and
               (  Rest_Table(Bvt.Last_Chunk_Length))) /= 0 then
            Result := False;
         end if;

      return Result;
   end Empty;

   procedure Clear(BVT : in out Bit_Volume_Type) is
   begin
      for I in BVT.Chunks'Range loop
         BVT.Chunks(I) := 0;
         end loop;

   end Clear;


   procedure Put ( BVT : Bit_Volume_Type) is
   begin
      for I in 1..(BVT.chunks'last-1) loop
         for J in 1..64 loop
            if (BVT.Chunks(I) and  Select_Table(J)) = 0 then
               Ada.Integer_Text_IO.Put(0,0);
            else
               Ada.Integer_Text_IO.Put(1,0);
            end if;

         end loop;
      end loop;
      for J in 1..BVT.Last_Chunk_Length loop
         if (BVT.Chunks(BVT.Chunks'last) and Select_Table(J)) /= 0 then
            Ada.Integer_Text_IO.Put(1,0);
         else
            Ada.Integer_Text_Io.Put (0,0);
            end if;
      end loop;

   end Put;

   procedure Put (BVT: in Bit_Volume_Type; Dst : out Unbounded_String) is
   begin
      Dst := To_Unbounded_String("");
        for I in 1..(BVT.chunks'last-1) loop
         for J in 1..64 loop
            if (BVT.Chunks(I) and  Select_Table(J)) = 0 then
               Dst := Dst & "1";
            else
               Dst := Dst & "0";
            end if;

         end loop;
      end loop;
      for J in 1..BVT.Last_Chunk_Length loop
         if (BVT.Chunks(BVT.Chunks'last) and Select_Table(J)) /= 0 then
            Dst := Dst & "1";
         else
            Dst := Dst & "0";
            end if;
      end loop;

   end Put;

   function Put (BVT: Bit_Volume_Type) return Unbounded_String is
   Result : Unbounded_String;
   begin
      Put(BVT,Result);
      return Result;
   end Put;

   procedure Get( BVT : out Bit_Volume_Type; Src : in Unbounded_String) is
   Fix_Src : String(1..Length(Src));
   begin
      Fix_Src := To_String(Src);
      BVT := Make(Length(Src));

      for I in Fix_Src'Range loop
         if Fix_Src(I..I) = "1" then
            Set_Index(BVT,I,1);
         elsif Fix_Src(I..I) = "0" then
            Set_Index(BVT,I,0);
         else
            raise Not_Same_Size;
         end if;
      end loop;
   end Get;

   function Get( src : Unbounded_String) return Bit_Volume_Type is
   Result : Bit_Volume_Type;
   begin
      Get(Result, Src);
      return Result;
   end Get;

   function Index(BVT : Bit_Volume_Type; I : natural) return bit is
   begin
      if (Bvt.Chunks(1 + I / 64) and Select_Table(I mod 64)) = 0 then
         return 0;
      else
         return 1;
      end if;

   end Index;

   procedure  Set_Index(BVT : in out Bit_Volume_Type ; I : in Natural ; Src : in Bit ) is
   begin
      if  Src = 1 then
         Bvt.Chunks(1 + I/64) := Bvt.Chunks(1 + I/64) or Select_Table(I mod 64);
      else
         Bvt.Chunks(1 + I/64) := Bvt.Chunks(1 + I/64) and (not Select_Table(I mod 64));
      end if;
   end Set_Index;



   function Ones(BVT : Bit_Volume_Type) return Natural is
      Result : Natural := 0;
   begin
      for I in 1..(BVT.Chunks'Last -1) loop
         for J in 1..64 loop
            Result := Result + Natural((BVT.Chunks(I) and Select_Table(J)) mod 1);
         end loop;
      end loop;
      return Result;
   end;



begin
   Select_Table :=(1,2 ,4 ,8 , 16, 32, 64, 128,256 ,512,1024,2048,4096,8192,
                   16384,32768,65536,131072,262144,524288,1048576,2097152,
                   4194304,8388608,16777216,33554432,67108864,134217728,
                   268435456,536870912,1073741824,2147483648,4294967296,
                   8589934592,17179869184,34359738368,68719476736,137438953472,
                   274877906944,549755813888,1099511627776,2199023255552,
                   4398046511104,8796093022208,17592186044416,35184372088832,
                   70368744177664,140737488355328,281474976710656,562949953421312,
                   1125899906842624,2251799813685248,4503599627370496,
                   9007199254740992,18014398509481984,36028797018963968,
                   72057594037927936,144115188075855872,288230376151711744,
                   576460752303423488,1152921504606846976,2305843009213693952,
                   4611686018427387904,9223372036854775808); -- Magic constants

   Rest_Table :=
        (2#00000000000000000000000000000000000000000000000000000000000000001#,
         2#00000000000000000000000000000000000000000000000000000000000000011#,
         2#00000000000000000000000000000000000000000000000000000000000000111#,
         2#00000000000000000000000000000000000000000000000000000000000001111#,
         2#00000000000000000000000000000000000000000000000000000000000011111#,
         2#00000000000000000000000000000000000000000000000000000000000111111#,
         2#00000000000000000000000000000000000000000000000000000000001111111#,
         2#00000000000000000000000000000000000000000000000000000000011111111#,
         2#00000000000000000000000000000000000000000000000000000000111111111#,
         2#00000000000000000000000000000000000000000000000000000001111111111#,
         2#00000000000000000000000000000000000000000000000000000011111111111#,
         2#00000000000000000000000000000000000000000000000000000111111111111#,
         2#00000000000000000000000000000000000000000000000000001111111111111#,
         2#00000000000000000000000000000000000000000000000000011111111111111#,
         2#00000000000000000000000000000000000000000000000000111111111111111#,
         2#00000000000000000000000000000000000000000000000001111111111111111#,
         2#00000000000000000000000000000000000000000000000011111111111111111#,
         2#00000000000000000000000000000000000000000000000111111111111111111#,
         2#00000000000000000000000000000000000000000000001111111111111111111#,
         2#00000000000000000000000000000000000000000000011111111111111111111#,
         2#00000000000000000000000000000000000000000000111111111111111111111#,
         2#00000000000000000000000000000000000000000001111111111111111111111#,
         2#00000000000000000000000000000000000000000011111111111111111111111#,
         2#00000000000000000000000000000000000000000111111111111111111111111#,
         2#00000000000000000000000000000000000000001111111111111111111111111#,
         2#00000000000000000000000000000000000000011111111111111111111111111#,
         2#00000000000000000000000000000000000000111111111111111111111111111#,
         2#00000000000000000000000000000000000001111111111111111111111111111#,
         2#00000000000000000000000000000000000011111111111111111111111111111#,
         2#00000000000000000000000000000000000111111111111111111111111111111#,
         2#00000000000000000000000000000000001111111111111111111111111111111#,
         2#00000000000000000000000000000000011111111111111111111111111111111#,
         2#00000000000000000000000000000000111111111111111111111111111111111#,
         2#00000000000000000000000000000001111111111111111111111111111111111#,
         2#00000000000000000000000000000011111111111111111111111111111111111#,
         2#00000000000000000000000000000111111111111111111111111111111111111#,
         2#00000000000000000000000000001111111111111111111111111111111111111#,
         2#00000000000000000000000000011111111111111111111111111111111111111#,
         2#00000000000000000000000000111111111111111111111111111111111111111#,
         2#00000000000000000000000001111111111111111111111111111111111111111#,
         2#00000000000000000000000011111111111111111111111111111111111111111#,
         2#00000000000000000000000111111111111111111111111111111111111111111#,
         2#00000000000000000000001111111111111111111111111111111111111111111#,
         2#00000000000000000000011111111111111111111111111111111111111111111#,
         2#00000000000000000000111111111111111111111111111111111111111111111#,
         2#00000000000000000001111111111111111111111111111111111111111111111#,
         2#00000000000000000011111111111111111111111111111111111111111111111#,
         2#00000000000000000111111111111111111111111111111111111111111111111#,
         2#00000000000000001111111111111111111111111111111111111111111111111#,
         2#00000000000000011111111111111111111111111111111111111111111111111#,
         2#00000000000000111111111111111111111111111111111111111111111111111#,
         2#00000000000001111111111111111111111111111111111111111111111111111#,
         2#00000000000011111111111111111111111111111111111111111111111111111#,
         2#00000000000111111111111111111111111111111111111111111111111111111#,
         2#00000000001111111111111111111111111111111111111111111111111111111#,
         2#00000000011111111111111111111111111111111111111111111111111111111#,
         2#00000000111111111111111111111111111111111111111111111111111111111#,
         2#00000001111111111111111111111111111111111111111111111111111111111#,
         2#00000011111111111111111111111111111111111111111111111111111111111#,
         2#00000111111111111111111111111111111111111111111111111111111111111#,
         2#00001111111111111111111111111111111111111111111111111111111111111#,
         2#00011111111111111111111111111111111111111111111111111111111111111#,
         2#00111111111111111111111111111111111111111111111111111111111111111#,
         2#01111111111111111111111111111111111111111111111111111111111111111#);

end Bit_Volume;
