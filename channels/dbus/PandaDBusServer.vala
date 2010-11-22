using Json;
using Gee;


public class PandaDBusServer : PandaAbstractServer {


  
  public PandaDBusServer(){    

  }
  public override void init(){
    

    manager.loaded.connect(add_handler);
    manager.unloaded.connect(remove_handler);

  }
  public override void run(){   
     Bus.own_name (BusType.SESSION, "org.panda.command", BusNameOwnerFlags.NONE,
                  on_bus_aquired,
                  () => {},
                  () => stderr.printf ("Could not aquire name\n"));

  }
  public void add_handler(PandaPlugin plugin){
      

  }
  public void remove_handler(PandaPlugin plugin){

  }
  
  protected void on_bus_aquired (DBusConnection conn) {
    try {
        conn.register_object ("/org/panda/command", new PandaDBusService());
    } catch (IOError e) {
        stderr.printf ("Could not register service\n");
    }
  }   

  protected string invoke_request(string command){
        return manager.invoke(command);
  }
}
   

