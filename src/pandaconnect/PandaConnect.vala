using Soup;
using Gee;




public class PandaConnect : PandaPlugin,GLib.Object{


    protected Map<string,Gee.List<PandaSignal>> signals_manager;
    protected PandaPluginManager manager;
    public static string SERVICE = "pandamanager";
    
    public PandaConnect(PandaPluginManager manager) {
        this.manager = manager;
        signals_manager = new Gee.HashMap<string,Gee.List<PandaSignal>>(GLib.str_hash, GLib.str_equal);
        this.manager.loaded.connect(on_plugin_loaded);
        this.manager.unloaded.connect(on_plugin_unloaded);
    }
    public void init(){
        Gee.List<string> args = new Gee.ArrayList<string>();
        register("connect",args);
        register("disconnect",args);
        register("connection",null);
        register("rpcs",null);
        register("hosts",null);
    }
    public string invoke(string cmd,Gee.List<string> args){
        string ret="";
        if(cmd=="connect"){
            if(args.size < 4) return "not valid arguments";
            Gee.List<string> slice = args.slice(4,args.size);
            ret = connect_to(args.get(0),args.get(1),args.get(2),args.get(3),slice);
        }
        if(cmd=="connection"){
            ret = list_connection();
        }
         if(cmd=="rpcs"){
            ret = list_rpcs();
        }
        if(cmd=="disconnect") {
             if(args.size < 4) return "not valid arguments";
            ret = disconnect_from(args.get(0),args.get(1),args.get(2),args.get(3));
        }
        return ret;
    }
    public string invoke_rpc(string json){
        return "ok";
    }
    public string get_dashboard_html(string context){
        return "ok";
    }
    public string get_handler_path(){
        return SERVICE;
    }
    protected void on_plugin_loaded(PandaPlugin p){
        
        
        uint[] sig = GLib.Signal.list_ids(p.get_type());
        var emitter = new Gee.ArrayList<PandaSignal>();
        signals_manager.set(p.get_handler_path(),emitter); 
        foreach(uint i in sig){       
            string name = GLib.Signal.name(i);
            PandaSignal sig_manager = new PandaSignal(i);
            sig_manager.panda_invoke.connect(invoke_handler);
            signals_manager.get(p.get_handler_path()).add(sig_manager); 
            GLib.Signal.connect_object(p,name,(Callback)proxy_signal,sig_manager,0);
        }
    }
    
    public void invoke_handler(string plugin,string host,string cmd,Gee.List<string> args){
         string input_args = "";
            foreach(string s in args){
                if(s!="command"){
                    input_args += s + "";
                }
         }
         if(host!=null && host != "") {
         
         } else {
            string sig = manager.invoke(plugin + " " + cmd + " " + input_args);
        }
    }
    public void on_plugin_unloaded(PandaPlugin p){
        
    }
    protected string list_connection(){
        string ret="";
        foreach(string plug in signals_manager.keys){
            ret += "*** " + plug + " ***\n";
            foreach(PandaSignal s in signals_manager.get(plug)){
                ret += "\t" +s.list_callbacks() + "\n";
            }
        }
        return ret;
    }
    protected string list_rpcs(){
        return manager.list_rpcs();
    }
    protected  bool has_signal(string source,string sign){
         if(signals_manager.has_key(source)){
            foreach (PandaSignal s in signals_manager.get(source)){
                   string name = GLib.Signal.name(s.id);
                   if(sign==name){
                       return true;
                }
            }
         }
         return false;
    }
    protected string connect_to(string source,string sign ,string target,string cmd,Gee.List<string> args){
            
            if(!has_signal(source,sign)) return "Source signal not found";
            string host = "";
            string dest = "" ;
            host = target.chr(-1,'@');
            if(host==null) {
                host ="";
            }
            host = target.replace(host,"");
            dest = target.replace(host + "@","");
            if(!manager.has_action(dest,cmd)) return "Target command not found";
            foreach (PandaSignal s in signals_manager.get(source)){
                string name = GLib.Signal.name(s.id);
                if(sign==name){
                    s.add_callback(dest,host,cmd,args);
                }
              
            }
            return "connection established";

    }
    protected string disconnect_from(string source,string sign,string target, string cmd) {
          
          if(!has_signal(source,sign)) return "Source signal not found";
          foreach (PandaSignal s in signals_manager.get(source)){
                string name = GLib.Signal.name(s.id);
                if(sign==name){
                    s.remove_callback(target,cmd);
                }
           }
           return "disconnected";
    }
}
public void proxy_signal(PandaPlugin p,PandaSignal s){
    s.proxy_signal();
}