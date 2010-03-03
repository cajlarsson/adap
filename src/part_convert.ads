with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Text_IO;                        use Ada.Text_IO;
with GNAT.Regexp;                        use GNAT.Regexp;

package Part_Convert is

   function Part_From_File_To_Packet(File_Type : F_In) return Unbounded_String;

   function Figure_From_File_To_Packet(File_Type : F_In) return Unbounded_String;

private

   ROW_LENGTH : constant Natural := 255;
   subtype Bit_Type is Character range '0' .. '1';


end Part_Convert;
