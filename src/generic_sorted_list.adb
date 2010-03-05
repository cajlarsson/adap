package body Generic_Sorted_List is

   procedure Deallocate is
      new Ada.Unchecked_Deallocation(Object => Element_Type,
                                     Name => List_Type);

   function Data (List: in List_Type) return Data_Type is
   begin
      return List.Data;
   end Data;

   function Next (List: in List_Type) return List_Type is
   begin
      return List.Next;
   end Next;

   function Empty (List: in List_Type) return Boolean is
   begin
      return List = null;
   end Empty;

   function Cons (Item : in Data_Type; Next : in List_Type) return List_Type is
   begin
      return new Element_Type'(Item, Next);
   end Cons;

   -- This function is destructive
   function Rest (List : in List_Type) return List_Type is
      Ref : List_Type := List;
      Next : List_Type := List.Next;
   begin
      Deallocate(Ref);
      return Next;
   end Rest;

   procedure Insert (List: in out List_Type; Item: in Data_Type) is
      This : List_Type;
      Last : List_Type := List;
   begin
      if Empty(List) then
         List := Cons(Item, null);
         return;
      elsif Get_Key(List.Data) = Get_Key(Item) then
         return;
      elsif Get_Key(Item) < Get_Key(List.Data) then
         List := Cons(Item, List);
         return;
      else
         This := List.Next;
      end if;
      loop
         if Empty(This) then
            Last.Next := Cons(Item, null);
            return;
         elsif Get_Key(This.Data) = Get_Key(Item) then
            return;
         elsif Get_Key(Item) < Get_Key(This.Data) then
            Last.Next := Cons(Item, This.Next);
            return;
         end if;
         Last := This;
         This := This.Next;
      end loop;
   end Insert;

   procedure Put (List: in List_Type) is
      Next : List_Type := List;
   begin
      while not Empty(Next) loop
         Put(Next.Data);
         Next := Next.Next;
      end loop;
   end Put;

   function Member (List: in List_Type; Item: in Key_Type) return Boolean is
      Next : List_Type := List;
   begin
      loop
         if Empty(Next) then
            return False;
         elsif Get_Key(Next.Data) = Item then
            return True;
         else
            Next := Next.Next;
         end if;
      end loop;
   end Member;

   procedure Remove (List: in out List_Type; Item: in Key_Type) is
      This : List_Type;
      Last : List_Type := List;
   begin
      if Empty(List) then
         raise Item_Not_Found;
      elsif Get_Key(List.Data) = Item then
         List := Rest(List);
         return;
      else
         This := List;
      end if;
      loop
         if Empty(This) then
            raise Item_Not_Found;
         elsif Get_Key(This.Data) = Item then
            Last.Next := Rest(This);
            return;
         end if;
         Last := This;
         This := This.Next;
      end loop;
   end Remove;

   procedure Delete (List: in out List_Type) is
   begin
      while not Empty(List) loop
         List := Rest(List);
      end loop;
   end Delete;

   function Find (List: in List_Type; Item: in Key_Type) return Data_Type is
      Next : List_Type := List;
   begin
      while not Empty(Next) loop
         if Get_Key(Next.Data) = Item then
            return Next.Data;
         end if;
         Next := Next.Next;
      end loop;
      raise Item_Not_Found;
   end Find;

   procedure Find (List: in List_Type; Item: in Key_Type; Res: out Data_Type) is
   begin
      Res := Find(List, Item);
   end Find;

   function Length (List: in List_Type) return Natural is
      Next : List_Type := List;
      Length : Natural := 0;
   begin
      while not Empty(Next) loop
         Length := Length + 1;
         Next := Next.Next;
      end loop;
      return Length;
   end Length;

end Generic_Sorted_List;
