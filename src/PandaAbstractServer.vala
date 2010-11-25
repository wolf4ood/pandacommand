using  Gee;


public abstract class PandaAbstractServer : GLib.Object {

          public PandaPluginManager manager {get; set;}
          
          public abstract void init();
          public abstract void run();
          protected string invoke(string command){
                return manager.invoke(command);
          }
          protected string invoke_cmd(string plug,string cmd, Gee.List<string> args){
                return manager.invoke_cmd(plug,cmd,args);
          }
}