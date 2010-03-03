with Ada.Text_IO;                        use Ada.Text_IO;
--with Ada.Strings_Edit.Integer;           use Ada.Strings_Edit.Integer;
with Ada.Command_Line;                   use Ada.Command_Line;
with Ada.Exceptions;                     use Ada.Exceptions;
with Ada.Strings;                        use Ada.Strings;
with Ada.Integer_Text_IO;                use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Ada.Characters;                     use Ada.Characters;

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
   Text,Input,T1,T2 : U_String;
   Text_Length: Natural;
   Delbeskrivning : FP_A;
   Ind,I2 : Integer;
   Lösis : Full_Part;


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
      if Text /= "OK" then
         Put(To_String(Text));
         Raise_Exception(Constraint_Error'Identity,
                         "Userdata not accepted by server");
         Close(Socket);
      end if;

      Put_Line(Socket,Assemble_Packet(NICK_HEAD,To_Unbounded_String("Fistosaurus")));--  FixMes: Nick,
   end Login;
----------------------------------------------------------------------------------------

   function Solver(Lösis : Full_Part; Delbeskrivning : FP_A)return FP_A is
   begin
     return null;
      end Solver;
----------------------------------------------------------------------------------------
--procedure Haz_Draz

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

      Get_Line(Socket,Text);

      Case Packet_Head(Text) is
         when 'D' =>
            Input := Trim(Packet_Content(Text),Left);
            Ind := Integer'Value(To_string(Head(Input,Index(Input," "))));
            Delbeskrivning := new Full_Part_Array(1..Ind);
            Input := Delete(Input,1,Index(Input," "));

            for I in 1..Ind loop
               T2 := Tail(Input,Length(Input) - Index(Input," "));
               I2 := Index(T2," ");
               T1 := Head(Input,I2);
               Delbeskrivning(I):= Get(T1,I);
               Input :=Tail(T2,Length(T2) - Index(T2," "));
               end loop;

            -- FixMe: Testing
         when 'F' =>
            Input := Trim(Packet_Content(Text),Left);
            Ind := Integer'Value(To_string(Head(Input,Index(Input," "))));
            Lösis := Get(Delete(Input,1,Index(Input," ")),Ind);

            Text := To_Unbounded_String(Integer'Image(Delbeskrivning'Last));
            Text := Trim(Text,Left);
            Delbeskrivning := Solver(Lösis,Delbeskrivning);
            for I in Delbeskrivning'Range loop
               Text := Text & " ";
               Text :=Text & Put(Delbeskrivning(I));
            end loop;
            Put_Line(Socket,Assemble_Packet(ROTATION_HEAD,Text));
              -- FixMe: Testing
         when 'R' =>
            Input := Packet_Content(Text);
            Input := Head(Tail(Input,3),1);
            case To_String(Input)(1) is
               when 's' =>
                 Put_Line("Qapla'!");
               when 'r' =>
                 Put_Line("We gave up and succeded at it!");
               when others =>
                 Put_Line("Garrdak");
            end case;

            -- FixMe: Better text
         when 'Q' =>
            Put(To_String(Packet_Content(Text)));
            -- Quit
         when others =>
           null;
           --FixMe: Error Flyn!
      end case;
   end loop;

end Client;



