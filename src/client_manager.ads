with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with Packets;                            use Packets;
with Soma;                               use Soma;
with Generic_Unsorted_List;
with Generic_Sorted_List;
with Misc;                               use Misc;
with Part_Types;                         use Part_Types;

with TJa.Sockets;                        use TJa.Sockets;

package Client_Manager is

   type Client_Element_Type;
   type Client_Type is access Client_Element_Type;

   task type Client_Task is
      entry Set(Self : in Client_Type);
      entry Run;
      --entry Kill;
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

   function Get_Figure_Id (Item: in Result_Type) return Positive;
   procedure Put (Item: in Result_Type);
   package Result_List is
      new Generic_Sorted_List (Data_Type => Result_Type,
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

   function Get_New_Client return Client_Type;

   protected Clients is
      procedure Insert(Item: in Client_Type);
      procedure Remove(Item: in Socket_Type);
      procedure Put;
   private
      List: Client_List.List_Type;
   end Clients;

   protected Parts is
      function Get return Unbounded_String;
      function Get return Part_Array;
      procedure Set (Parts_In : Part_Array);
   private
      Parts: Part_Array_Access;
   end Parts;

   protected Figures is
      function Get(Id : Natural) return Unbounded_String;
      function Get(Id : Natural) return Full_Part;
      function Exist(Id : Natural) return Boolean;
      procedure Set (Figures_In : Part_Array);
   private
      Figures: Part_Array_Access;
   end Figures;

private

   function Login (Socket: Socket_Type) return Boolean;
   function Get_Nick (Socket: Socket_Type) return Unbounded_String;
   procedure Send_Parts (Socket: in Socket_Type);
   procedure Send_Figure (Socket: in Socket_Type; Figure_Id : Natural);
   procedure Send_Result (Socket: Socket_Type; Result: String);
   procedure Send_Finish (Socket: Socket_Type; Solved: Natural; Place: Natural);
   function New_Result (Figure_Id: Positive; Solved: Boolean) return Result_Type;

end Client_Manager;
