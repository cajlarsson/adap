with Ada.Strings.Unbounded;              use Ada.Strings.Unbounded;
with Tja.Calendar;                       use Tja.Calendar;


package body Packets is

   function Assemble_Packet(Head: Character; content : U_String) return U_String is
   begin
      return Time_Now & ' ' & Head & ' ' & content;
   end;

   function Packet_Head(Packet : U_String) return Character is
   begin
      return To_String(Packet)(10);
   end Packet_Head;

   function Packet_Content(Packet : U_String) return U_String is
   begin
      return To_Unbounded_String(Slice(Packet, 12, Length(Packet)));
   end Packet_Content;

   function Time_Now return U_String is
   begin
      return To_Unbounded_String(Get_Time(Clock));
   end Time_Now;

end Packets;
