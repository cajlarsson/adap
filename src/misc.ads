with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Strings;                        use Ada.Strings;
with Ada.Strings.Fixed;                  use Ada.Strings.Fixed;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Part_Types;                         use Part_Types;

package Misc is

   function To_String (Item : in Integer) return String;

   procedure Put (Item: in Unbounded_String);

   function Get_Dec( Parts : Part_Array; Data: Unbounded_String)
                   return Part_Array;
   procedure Del_1_Word(Sbj : in out Unbounded_String);

   function First_word(Str : Unbounded_String) return Unbounded_String;

end Misc;
