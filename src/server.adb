with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Command_Line;                   use Ada.Command_Line;
with Ada.Exceptions;                     use Ada.Exceptions;

with TJa.Sockets;                        use TJa.Sockets;

procedure Server is
   Listener : Listener_Type;

   Socket : Socket_Type;

   Port : Natural;

   Text      : String(1..100); --Används för att ta emot text
   Text_Length : Natural;        --Kommer innehålla längden på denna text

begin
   if Argument_Count /= 1 then
      Raise_Exception(Constraint_Error'Identity,
                      "Usage: " & Command_Name & " port");
   end if;

   Port := Natural'Value(Argument(1));

   Initiate(Listener,Port);
   Put("Listening for connection...");
   Wait_For_Connection(Listener,Socket);
   Put(Ascii.Cr);
   Put_Line("Client connected...");
   loop
      Get_Line(Socket,Text,Text_Length);
      Put_Line("Client sent: " & Text(Text_Length));
      Put_Line(Socket,"You sent: " & Text(Text_Length));

   end loop;

   Close(Socket);

end Server;



