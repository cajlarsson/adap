with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Command_Line;                   use Ada.Command_Line;
with Ada.Exceptions;                     use Ada.Exceptions;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with Packets;                            use Packets;
with Client_Manager;                     use Client_Manager;

with TJa.Sockets;                        use TJa.Sockets;

procedure Server is

   procedure Accept_Pool(Port: Natural) is
   Listener : Listener_Type;
   New_Client : Client_Type;
   Id : Natural := 1;
   begin
      Initiate(Listener,Port);
      loop
         New_Client := Get_New_Client;
         Put_Line("Listening for connection...");
         Wait_For_Connection(Listener,New_Client.Socket);
   --      Put(Ascii.Cr);
         Put_Line("Client connected...");
         New_Client.Nick := To_Unbounded_String("Client" & Integer'Image(Id));
         New_Client.T.Run;
         Clients.Insert(New_Client);
      end loop;
   end Accept_Pool;

begin
   if Argument_Count /= 1 then
      Raise_Exception(Constraint_Error'Identity,
                      "Usage: " & Command_Name & " port");
   end if;

   Accept_Pool(Natural'Value(Argument(1)));

end Server;



