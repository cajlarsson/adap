with Bit_Volume; use Bit_Volume;
package  Parts_Volumes  is

   type Rotation_type is  record
      X,Y,Z : Integer;
   end record;

   type Offset_type is  record
   X,Y,Z: Integer;
   end record;

   type Base_Part_Type is record
      X,Y,Z: Integer;
      Bits : Bit_Volume_Type;
   end record;

   type Part_type is record
      Rot : Rotation_Type;
      Off : Offset_Type;
      Master : Integer;
   end record;

   type Part_Volume is record
      X,Y,Z : Integer;
      Bits : Bit_Volume_Type;
   end record;


--    function ... IO


end Parts_Volumes;
