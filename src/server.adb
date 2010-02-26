with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Command_Line;                   use Ada.Command_Line;
with Ada.Exceptions;                     use Ada.Exceptions;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with Packets;                            use Packets;
with Generic_Unsorted_List;

with TJa.Sockets;                        use TJa.Sockets;

procedure Server is

   type Client_Type is
      record
         Socket: Socket_Type;
         Nick: Unbounded_String;
      end record;

   function Get_Socket (Item: in Client_Type) return Socket_Type is
   begin
      return Item.Socket;
   end Get_Socket;

   procedure Put (Item: in Client_Type) is
   begin
      Put_Line(To_String(Item.Nick));
   end Put;

   package Client_List is
      new Generic_Unsorted_List (Data_Type => Client_Type,
                                 Key_Type => Socket_Type,
                                 Get_Key => Get_Socket);
   use Client_List;

   function Login (Socket: Socket_Type) return Boolean is
   begin
      if To_Unbounded_String("adap") = Get_Line(Socket) then
         if To_Unbounded_String("bacon") = Get_Line(Socket) then
            Put_Line(Socket, "OK");
            return True;
         end if;
      end if;
      Put_Line(Socket, "REJECTED");
      return False;
   end Login;

   function Get_Nick (Socket: Socket_Type) return Unbounded_String is
      Packet : Unbounded_String;
   begin
      Packet := Get_Line(Socket);
      if Packet_Head(Packet) = Packets.NICK_HEAD then
         return Packet_Content(Packet);
      end if;
      raise Unexpected_Head_Type;
   end Get_Nick;

   function Get_New_Client return Client_Type is
   New_Client : Client_Type;
   begin
      New_Client.Nick := To_Unbounded_String("");
      return New_Client;
   end Get_New_Client;

   procedure Accept_Pool(Port: Natural) is
   Listener : Listener_Type;
   Clients : Client_List.List_Type;
   New_Client : Client_Type;
   begin
      loop
         New_Client := Get_New_Client;
         Initiate(Listener,Port);
         Put("Listening for connection...");
         Wait_For_Connection(Listener,New_Client.Socket);
         Put(Ascii.Cr);
         Put_Line("Client connected...");

         if Login(New_Client.Socket) then
            New_Client.Nick := Get_Nick(New_Client.Socket);
            Insert(Clients, New_Client);
            Put(Clients);
         end if;
      end loop;
   end Accept_Pool;

begin
   if Argument_Count /= 1 then
      Raise_Exception(Constraint_Error'Identity,
                      "Usage: " & Command_Name & " port");
   end if;

   Accept_Pool(Natural'Value(Argument(1)));

end Server;



