with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with GNAT.Regpat;                        use GNAT.Regpat;
with Misc;                               use Misc;

package Part_Convert is

   type Part_Type is
      record
         Id : Natural;
         Dim : Unbounded_String;
         Data : Unbounded_String;
      end record;

   function Part_From_File_To_Packet(F_In : File_Type) return Part_Type;

   function Figure_From_File_To_Packet(F_In : File_Type) return Part_Type;

   procedure Put (Item: Part_Type);

private

   ROW_LENGTH : constant Natural := 255;
   subtype Bit_Type is Character range '0' .. '1';

   subtype Input_Type is File_Type;

   function Get_Part (I : Input_Type) return Part_Type;

end Part_Convert;
