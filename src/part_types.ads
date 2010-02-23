with Bit_Volume; use Bit_Volume;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
package  Part_Types  is

   type Part_Type_Base is private;
   type Part_Volume_Base is private;
   type Full_Part_Base is private;


   type Part_Type is access Part_Type_Base;
   type Part_Volume is access Part_Volume_Base;
   type Full_Part is access Full_Part_Base;

   procedure Get(Src : Unbounded_String ; Packet : Full_Part);
   function Get(Src : Unbounded_String)return Full_Part;

   function Make() return Full_part;
   function Make() return Part_Volume;
   function Make() return Part_Type;
   
   procedure Delete(Inane : Full_Part);
   procedure Delete(Inane : Part_Volume);
   procedure Delete(Inane : Part_Type);
   
  
   --    function ... IO

private:
      type Rotation_type is  record
      X,Y,Z : Integer;
      end record;

      type Offset_type is  record
         X,Y,Z: Integer;
      end record;

      type Part_Type_Base  is record
         Rot : Rotation_Type;
         Off : Offset_Type;
         Master : Integer;
      end record;

      type Part_Volume_Base is record
         X,Y,Z : Integer;
         Bits : Bit_Volume_Type;
      end record;

      type Full_Part_Base is record
         Genotype : Part_Type;
         Phenotype : Part_Volume;
      end record;



end Part_Types;
