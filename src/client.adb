with Ada.Text_IO;                        use Ada.Text_IO;
with Ada.Command_Line;                   use Ada.Command_Line;
with Ada.Exceptions;                     use Ada.Exceptions;
with Ada.Strings;                        use Ada.Strings;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with TJa.Sockets;                        use TJa.Sockets;

with Packets;                            use Packets;
with Part_Types;                         use Part_Types;

procedure Client is

   type Full_Part_Array is array (Integer range <>) of Full_Part;
   type FP_A is access Full_Part_Array;

   Socket : Socket_Type;
   Port : Natural;
   UserID : String(1..32);
   UserID_Length : Natural;
   Password : String(1..32);
   Password_Length : Natural;
   Figure_Number : Natural;
   Text : U_String;
   Text_Length: Natural;
   Delbeskrivning : FP_A;
   Ind : Integer;


----------------------------------------------------------------------------------------

   procedure Fail is

   begin
      Put_Line(Socket,Assemble_Packet(FORFEIT_HEAD,Figure_Number));
      Close(Socket);

   end Fail;

----------------------------------------------------------------------------------------

   procedure Login is
   begin
      Put_Line("Please enter your prefered UserID and Password,");
      Put_Line("Do however note that both are stored unencrypted and are thus not secure.");
      Get_Line(UserID,UserID_Length);
      Get_Line(Password,Password_Length);

      Put_Line(Socket,UserID(1..UserID_Length));
      Put_Line(Socket,Password(1..Password_Length));

      Get_Line(Socket,Text);
      if Text_Length /= 2 then
         Put(To_String(Text));
      else
         Raise_Exception(Constraint_Error'Identity,
                         "Userdata not accepted by server");
         Close(Socket);
      end if;

      Put_Line(Socket,Assemble_Packet(NICK_HEAD,To_Unbounded_String("Fistosaurus")));--  FixMes: Nick,
   end Login;
----------------------------------------------------------------------------------------

begin

   if Argument_Count /= 2 then
      Raise_Exception(Constraint_Error'Identity,--  FixMes: ett bättre Exception
                      "Usage: " & Command_Name & " remotehost remoteport");
   end if;

   Port := Natural'Value(Argument(2));

   Initiate(Socket);

   Connect(Socket, Argument(1), Port);

   Login;

   While true loop                       --FixMe: Truue? ORLY?
      Case Packet_Head(Text) is
         when 'D' =>
            Ind := Integer'Value(To_string(Head(Trim(Packet_Content(Text),Left),
                                        Index(Trim(Packet_Content(Text),Left)," "))));
            Delbeskrivning := new Full_Part_Array(1..Ind);

            for I in 1..Ind loop
               null;
               end loop;

            -- FixMe: Delbeskrivning
         when 'F' =>
            null;
            -- FixMe: Figurbeskrivning
         when 'R' =>
            null;
            -- FixMe: Resultat
         when 'Q' =>
            null;
            -- Quit
         when others =>
           null;
           --FixMe: Error Flyn!
      end case;
   end loop;

end Client;



