with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with GNAT.Regpat;                        use GNAT.Regpat;

with Misc;                               use Misc;
with Part_Types;                         use Part_Types;
with Generic_Sorted_List;

package Part_Convert is

   subtype Input_Type is File_Type;

   function From_File_To_Part_Array (F_In : Input_Type) return Part_Array;

private

   type Part_Struct is
      record
         Id : Natural;
         Dim : Unbounded_String;
         Data : Unbounded_String;
      end record;

   package Part_List is
      new Generic_Sorted_List (Data_Type => Full_Part,
                               Key_Type => Natural,
                               Get_Key => Get_Id);

   ROW_LENGTH : constant Natural := 255;
   subtype Bit_Type is Character range '0' .. '1';

   function Get_Part (I : Input_Type) return Part_Struct;

   function Get_Part_List (I : Input_Type) return Part_List.List_Type;

   procedure Put (Item: Part_Struct);

end Part_Convert;
