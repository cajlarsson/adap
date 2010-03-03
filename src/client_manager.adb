with Ada.Exceptions;                     use Ada.Exceptions;

package body Client_Manager is

   task body Client_Task is

      procedure Destroy is
      begin
         null;
      end Destroy;

      Me : Client_Type;

   begin
      accept Set(Self: Client_Type) do
         Me := Self;
      end Set;
      loop
         select
            accept Kill do
               Destroy;
            end Kill;
         or
            accept Run do
               if Login(Me.Socket) then
                  Me.Nick := Get_Nick(Me.Socket);
               end if;
            end Run;
         end select;
      end loop;
   end Client_Task;

   protected body Clients is
      procedure Insert(Item: in Client_Type) is
      begin
         Client_List.Insert(List, Item);
      end Insert;
      procedure Remove(Item: in Socket_Type) is
      begin
         Client_List.Remove(List, Item);
      end Remove;
   end Clients;

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
      New_Client := new Client_Element_Type;
      New_Client.Nick := To_Unbounded_String("");
      New_Client.Self := New_Client;
      New_Client.T.Set(New_Client);
      return New_Client;
   end Get_New_Client;

   function Get_Socket (Item: in Client_Type) return Socket_Type is
   begin
      return Item.Socket;
   end Get_Socket;

   procedure Put (Item: in Client_Type) is
   begin
      Put_Line(To_String(Item.Nick));
   end Put;

   function Get_Figure_Id (Item: in Result_Type) return Positive is
   begin
      return Item.Figure_Id;
   end Get_Figure_Id;

   procedure Put (Item: in Result_Type) is
   begin
      null;
   end Put;

end Client_Manager;
