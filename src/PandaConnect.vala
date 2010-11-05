using Soup;

public class PandaConnect : PandaPlugin,GLib.Object{


    protected PandaPluginManager manager;
    public static string SERVICE = "/pandamanager";
    
    public PandaConnect(PandaPluginManager manager) {
        this.manager = manager;
    }
    public void init(){
        
    }
    public string invoke(string cmd,Gee.List<string> arg){
    
        return "ok";
    }
    public string get_dashboard_html(string context){
        return "ok";
    }
    public string get_handler_path(){
        return SERVICE;
    }
}