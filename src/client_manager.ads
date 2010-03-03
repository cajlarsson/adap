with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with Packets;                            use Packets;
with Generic_Unsorted_List;

with TJa.Sockets;                        use TJa.Sockets;

package Client_Manager is

   --type Result_Type is private;
   --type Client_List_Type is private;
   --type Result_List_Type is private;
   --type Client_List is access Client_List_Type;
   --type Result_List is access Result_List_Type;

   type Client_Element_Type;
   type Client_Type is access Client_Element_Type;

   task type Client_Task is
      entry Set(Self : in Client_Type);
      entry Run;
      entry Kill;
   end Client_Task;

   type Result_Type is
      record
         Figure_Id: Positive;
         Solved: Boolean;
      end record;

   function Get_Socket (Item: in Client_Type) return Socket_Type;
   procedure Put (Item: in Client_Type);
   package Client_List is
      new Generic_Unsorted_List (Data_Type => Client_Type,
                                 Key_Type => Socket_Type,
                                 Get_Key => Get_Socket);
   --type Client_List_Type is new Client_List.List_Type;

   function Get_Figure_Id (Item: in Result_Type) return Positive;
   procedure Put (Item: in Result_Type);
   package Result_List is
      new Generic_Unsorted_List (Data_Type => Result_Type,
                                 Key_Type => Positive,
                                 Get_Key => Get_Figure_Id);

   type Client_Element_Type is
      record
         Socket: Socket_Type;
         Nick: Unbounded_String;
         T: Client_Task;
         Completed: Boolean := False;
         Results: Result_List.List_Type;
         Self: Client_Type;
      end record;

   function Login (Socket: Socket_Type) return Boolean;
   function Get_Nick (Socket: Socket_Type) return Unbounded_String;
   function Get_New_Client return Client_Type;

   protected Clients is
      procedure Insert(Item: in Client_Type);
      procedure Remove(Item: in Socket_Type);
   private
      List: Client_List.List_Type;
   end Clients;

private

end Client_Manager;
