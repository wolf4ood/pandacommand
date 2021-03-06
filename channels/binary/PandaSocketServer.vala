using Json;
using Gee;

public class PandaSocketServer : PandaAbstractServer {

  private SocketService server = new SocketService();
  
  public PandaSocketServer(){    

  }
  public override void init(){
    
    try {
        server.add_inet_port (3333, null);
        server.incoming.connect (on_incoming_connection);
    } catch (Error e) {
        stderr.printf ("%s\n", e.message);
    }
    manager.loaded.connect(add_handler);
    manager.unloaded.connect(remove_handler);

  }
  public override void run(){   
    server.start();
  }
  public void add_handler(PandaPlugin plugin){
      

  }
  public void remove_handler(PandaPlugin plugin){

  }
  
  protected async void process_request(SocketConnection conn){
    try {
        var dis = new DataInputStream (conn.input_stream);
        var dos = new DataOutputStream (conn.output_stream);
        string req = yield dis.read_line_async (Priority.HIGH_IDLE);
        dos.put_string (invoke_request(req) + "\n");
    } catch (Error e) {
        stderr.printf ("%s\n", e.message);
    }
  }
  protected bool on_incoming_connection (SocketConnection conn) {
    stdout.printf ("Got incoming connection\n");
    process_request.begin (conn);
    return true;
  }
  protected string invoke_request(string command){
		if(command.has_prefix("{") && command.has_suffix("}")){
		    return manager.invoke_rpc(command);
		}else {
		    return manager.invoke(command);
        }
  }
}
   

