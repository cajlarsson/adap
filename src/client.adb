with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Command_Line;                   use Ada.Command_Line;
with Ada.Exceptions;                     use Ada.Exceptions;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;

with TJa.Sockets;                        use TJa.Sockets;

procedure Client is

   Socket : Socket_Type;
   Port : Natural;

   Text      : String(1..100);
   Text_Length : Natural;

begin

   if Argument_Count /= 2 then
      Raise_Exception(Constraint_Error'Identity,
                      "Usage: " & Command_Name & " remotehost remoteport");
   end if;

   Port := Natural'Value(Argument(2));

   Initiate(Socket);

   Connect(Socket, Argument(1), Port);

   loop

      Put_Line("Skriv en sträng, skriv exit för att avsluta");
      Get_Line(Text,Text_Length);
      if Text_Length=100 then Skip_Line; end if;

      exit when Text(1..4) = "exit";

      Put_Line(Socket,Text(1..Text_Length));

      Get_Line(Socket,Text,Text_Length);
      Put_Line(Text(1..Text_Length));

   end loop;

   Close(Socket);

end Client;



