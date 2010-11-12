using Gee;


public class PandaCallback : GLib.Object {
    
    
    public string cmd  { get; private set; }
    
    public Gee.List<string> args  { get; private set; }
    
    public PandaCallback(string cmd , Gee.List<string> args){
        this.args = args;
        this.cmd = cmd;
    }

}