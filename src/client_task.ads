
task Client_Task is

   entry Kill;
   entry Set(Socket : in Socket_Type);
   entry Set(Nick : in Unbounded_String);

end Client_Task;
