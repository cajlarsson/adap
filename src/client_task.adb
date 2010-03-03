with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with TJa.Sockets;                        use TJa.Sockets;

task body Client_Task is

   type Client_Info is
      record
         Socket: Socket_Type;
         Nick: Unbounded_String;
      end record;

   procedure Kill is
   begin
      null;
   end Kill;

   Info : Client_Info;

begin
   loop
      select
         accept Kill do
            Kill;
         end Kill;
      or
         accept Set(Socket : in Socket_Type) do
            Info.Socket := Socket;
      or
         accept Set(Nick : in Unbounded_String);
            Info.Nick := Nick;
      end select;
   end loop
end Client_Task;
