with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
package Bit_Volume is

   type Bit_Volume_Base is private;
   type Bit_Volume_Type is access all Bit_Volume_base;
   type Bit is range 0 .. 1; -- FIXME?


   function Make(length : Positive) return Bit_Volume_Type;
   procedure Delete(BVT : in out Bit_Volume_Type);
  --   function copy( BVT : Bit_Volume_Type) return Bit_Volume_Type;


   function "and" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type;
   function "or" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type;
   function "xor" (BVT1,BVT2 :Bit_Volume_Type) return Bit_Volume_Type;
   function "not" (BVT :Bit_Volume_Type) return Bit_Volume_Type;

   function empty (BVT : Bit_Volume_Type) return Boolean;
   function Index(BVT : Bit_Volume_Type ; I : natural) return Bit;
   procedure  Set_Index(BVT : in out Bit_Volume_Type ; I : in  Natural ; Src : in Bit );
   procedure Clear(BVT : in out Bit_Volume_Type);

   procedure Put ( BVT : in Bit_Volume_Type);
   procedure Put (BVT: in Bit_Volume_Type; Dst : out Unbounded_String);
   function Put (BVT: Bit_Volume_Type) return Unbounded_String;
   procedure Get( BVT : out Bit_Volume_Type; Src : in Unbounded_String);
   function Get( Src: Unbounded_String) return Bit_Volume_Type;

   function Ones(BVT : Bit_Volume_Type) return Natural; -- FIXME: Borked

   Not_Same_Size :exception;

private
   type Unsigned_Int64 is mod 2**64;
   type Bit_Chunks_Type is array (integer range <>) of Unsigned_Int64;
   type Bit_Chunks is access Bit_Chunks_Type; -- Must be access for constant size
   type Bit_Volume_Base is record
      Chunks : Bit_Chunks;
      Last_Chunk_Length : natural;
   end record;

   Select_Table,Rest_Table :   array (1..64) of Unsigned_Int64;

   end Bit_Volume;
