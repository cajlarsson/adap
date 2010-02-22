package Bit_Volume is

   type Bit_Volume_Base is private;
   type Bit_Volume_Type is access all Bit_Volume_base;
   subtype Bit is Integer range 0..1; -- FIXME?

   function Make(length : Positive) return Bit_Volume_Type;
   procedure Delete(BVT : Bit_Volume_Type);
   --   function copy( BVT : Bit_Volume_Type) return Bit_Volume_Type;

   function "and" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type;
   function "or" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type;
   function "not" (BVT :Bit_Volume_Type) return Bit_Volume_Type;
   function empty (BVT : Bit_Volume_Type) return Boolean;

   --   rainbowtables för masker
   --   function at ( x,y,z : integer) return bit;
   --   function rotate(BVT: bit_volume_type ;x,y,z : integer) return bit_volume_type;


   procedure Put ( BVT : Bit_Volume_Type);


   Not_Same_Size :exception;


private
   type Unsigned_Int64 is mod 2**64;

   type Bit_Chunks_Type is array (integer range <>) of Unsigned_Int64;
   type Bit_Chunks is access Bit_Chunks_Type; -- Must be access for constant size

   type Bit_Volume_Base is record
      Chunks : Bit_Chunks;
      Last_Chunk_Length : Positive;
   end record;

   end Bit_Volume;
