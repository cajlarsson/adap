with Ada.Unchecked_Deallocation;
with Ada.Text_IO;                        use Ada.Text_IO;

generic

   type Data_Type is private;
   type Key_Type is private;
   with procedure Put (Item : in Data_Type) is <>;
   with function Get_Key(Item: in Data_Type) return Key_Type is <>;
   with function "=" (R, L : in Key_Type) return Boolean is <>;

package Generic_Unsorted_List is

   type List_Type is private;

   function Empty (List: in List_Type) return Boolean;

   procedure Insert (List: in out List_Type; Item: in Data_Type);

   procedure Put (List: in List_Type);

   function Member (List: in List_Type; Item: in Key_Type) return Boolean;

   -- raise Item_Not_Found
   procedure Remove (List: in out List_Type; Item: in Key_Type);

   procedure Delete (List: in out List_Type);

   -- raise Item_Not_Found
   function Find (List: in List_Type; Item: in Key_Type) return Data_Type;

   -- raise Item_Not_Found
   procedure Find (List: in List_Type; Item: in Key_Type; Res: out Data_Type);

   function Length (List: in List_Type) return Natural;

   Item_Not_Found : exception;

private
   type Element_Type;
   type List_Type is access Element_Type;

   type Element_Type is
      record
         Data: Data_Type;
         Next: List_Type;
      end record;

end Generic_Unsorted_List;
