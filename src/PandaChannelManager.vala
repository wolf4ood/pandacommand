

public class PandaChannelManager : GLib.Object{

    private PandaPluginManager manager ;
    
    private PandaHttpServer httpServer ;
    private PandaSocketServer socketServer;
    //private PandaDBusServer dbusServer;
   
    protected Gee.List<PandaAbstractServer> channels;
    
    
    public PandaChannelManager() {
        manager  = new PandaPluginManager();
        httpServer = new PandaHttpServer(8088);
        socketServer = new PandaSocketServer();
        //dbusServer = new PandaDBusServer();
        socketServer.manager = manager;
        httpServer.manager = manager;      
        //dbusServer.manager = manager;    
    }
    public int startup(){
        initServer(httpServer);
        initServer(socketServer);
        //initServer(dbusServer);
        runServer(httpServer);
        runServer(socketServer);
        //runServer(dbusServer);
       
        return 0;  
    }
    public void initServer(PandaAbstractServer server) {
        server.init();
    }
    public async void runServer(PandaAbstractServer server) {
        server.run();
    }
   
}