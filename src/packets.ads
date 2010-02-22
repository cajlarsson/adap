with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;

with Tja.Calendar;                       use Tja.Calendar;
with TJa.Sockets;                        use TJa.Sockets;

package Packets is
   subtype U_String is Unbounded_String;

   NICK_HEAD : constant Character := 'N';
   PART_HEAD  : constant Character := 'D';
   ROTATION_HEAD : constant Character := 'P';
   FIGURE_HEAD : constant Character := 'F';
   FORFEIT_HEAD : constant Character := 'G';
   RESULT_HEAD : constant Character := 'R';
   FINISH_HEAD : constant Character := 'Q';

   function Assemble_Packet(Head: Character; Content: U_String) return U_String;
   function Assemble_Packet(Head: Character; Content: Integer) return U_String;
   function Packet_Head(Packet: U_String) return Character;
   function Packet_Content(Packet: U_String) return U_String;

   procedure Get_Line (Socket: in out Socket_Type; Item: out U_String);
   procedure Put_Line (Socket: in out Socket_Type; Item: in U_String);



private
   function Time_Now return U_String;

end Packets;
