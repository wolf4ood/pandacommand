using  Gee;


public abstract class PandaAbstractServer : GLib.Object {

          public PandaPluginManager manager {get; set;}
          
          public abstract void init();
          public abstract void run();
          protected string invoke(string command){
                return manager.invoke(command);
          }
}