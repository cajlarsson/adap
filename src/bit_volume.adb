with  Ada.Integer_Text_IO;
package body Bit_Volume is

   function Make(length : Positive) return Bit_Volume_Type is
      Ou : Bit_Volume_Type;
   begin
      Ou := new Bit_Volume_Base;
      Ou.Chunks := new Bit_Chunks_Type(1..(1+(Length / 64)));
      Ou.Last_Chunk_Length := Length mod 64;

      return Ou;
   end Make;

   procedure Delete(BVT : Bit_Volume_Type) is
   begin
      null;
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



   function "not" (BVT :Bit_Volume_Type) return Bit_Volume_Type is
      Result : Bit_Volume_Type;
   begin
      Result := new Bit_Volume_Base;
      Result.Chunks := new Bit_Chunks_Type(BVT.Chunks'Range);
      Result.Last_Chunk_Length := BVT.Last_Chunk_Length;
      for I in BVT.chunks'Range loop
         Result.Chunks(I) := not BVT.Chunks(I);
      end loop;
         return Result;
   end "not";


   function empty (BVT : Bit_Volume_Type) return Boolean is
      Result : Boolean := True;
   begin
      for I in 1..(bvt.chunks'Last -1) loop
         if  Bvt.Chunks(I) /= 0 then
            Result := False;
         end if;

      end loop;
      return Result;
   end Empty;

   procedure Put ( BVT : Bit_Volume_Type) is
   begin
      for I in BVT.chunks'Range loop
         Ada.Integer_Text_IO.Put(Integer(BVT.Chunks(I)), Base => 2);
      end loop;
   end Put;



end Bit_Volume;
