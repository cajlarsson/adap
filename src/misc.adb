package body Misc is

   function To_String (Item : in Integer) return String is
      Text : String := Integer'Image(Item);
   begin
      return Trim(Text, Both);
   end To_String;

end Misc;
