package body Packets is

   function Assemble_Packet(Head: Character; Content: U_String) return U_String is
   begin
      return Time_Now & ' ' & Head & ' ' & Content;
   end;

   function Assemble_Packet(Head: Character; Content: Integer) return U_String is
   begin
      return Time_Now & ' ' & Head & ' ' & To_Unbounded_String(Content);
   end;

   function Packet_Head(Packet: U_String) return Character is
   begin
      return To_String(Packet)(10);
   end Packet_Head;

   function Packet_Content(Packet: U_String) return U_String is
   begin
      return To_Unbounded_String(Slice(Packet, 12, Length(Packet)));
   end Packet_Content;

   procedure Get_Line (Socket: in Socket_Type; Item: out U_String) is
      Buffer: String(1..100);
      Length: Positive := 100;
   begin
      while Length = 100 loop
         Get_Line(Socket, Buffer, Length);
         Item := Item & To_Unbounded_String(Buffer(1..Length));
      end loop;
   end Get_Line;

   function Get_Line (Socket: in Socket_Type) return U_String is
      Temp : U_String;
   begin
      Get_Line(Socket, Temp);
      return Temp;
   end Get_Line;

   procedure Put_Line (Socket: in Socket_Type; Item: in U_String) is
   begin
      Put_Line(Socket,To_String(Item));
   end Put_Line;

   function Time_Now return U_String is
   begin
      return To_Unbounded_String(Get_Time(Clock));
   end Time_Now;

end Packets;
