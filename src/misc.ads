with Ada.Strings;                        use Ada.Strings;
with Ada.Strings.Fixed;                  use Ada.Strings.Fixed;
with Part_Types;                         use Part_Types;
package Misc is

   function To_String (Item : in Integer) return String;

   function Get_Dec( Parts : Part_Array; Data: Unbounded_String)
                   return Part_Array;
end Misc;
