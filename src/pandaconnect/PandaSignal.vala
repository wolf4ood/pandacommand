using Gee;

public class PandaSignal : GLib.Object {


    public uint id { get; private set; } 
    public signal void panda_invoke(string plugin,string host,string cmd,Gee.List<string> args);
    protected Map<string,Gee.List<PandaCallback>> plugin_actions  { get; private set; } 
    
    public PandaSignal(uint id) {
        this.id = id;
        stdout.printf("%i - %p\n",(int)id,this);
        this.plugin_actions = new Gee.HashMap<string,Gee.List<PandaCallback>>(GLib.str_hash, GLib.str_equal);
    }  
    public void add_callback(string plugin,string host,string cmd,Gee.List<string> args){

        if(!plugin_actions.has_key(plugin)){
            var callbacks = new Gee.ArrayList<PandaCallback>();
            plugin_actions.set(plugin,callbacks);
        }
        PandaCallback call = new PandaCallback(host,cmd,args);
        plugin_actions.get(plugin).add(call);
    }
    
    public void remove_callback(string plugin,string cmd){
        if(plugin_actions.has_key(plugin)){
             foreach (PandaCallback c in plugin_actions.get(plugin)) {
                if(c.cmd == cmd){
                    plugin_actions.get(plugin).remove(c);
                }
             }
        }
    }
    public void proxy_signal(){
        foreach (string plugs in plugin_actions.keys){
          var commands = plugin_actions.get(plugs);
            foreach(PandaCallback c  in commands){
                panda_invoke(c.host,plugs,c.cmd,c.args);
            } 
        }     
    }
    public string list_callbacks(){
        string ret="";    
        foreach(string plug in plugin_actions.keys){
            string name = GLib.Signal.name(id);
            ret +="signal: " + name + "\n";
            ret += "\t\t<< " + plug + " >>  ";
            foreach(PandaCallback c in plugin_actions.get(plug)){
                ret += c.host + " - " + c.cmd  + "\n";
            }
        }
        return ret;
    }
}