using Gst;
public class PandaPlayer :  GLib.Object {

    private dynamic Element player;

    public PandaPlayer() {


        player = ElementFactory.make("playbin", "player");
        assert(player!=null);

        Gst.Bus bus = this.player.get_bus();
        bus.add_watch(bus_callback);
        player.set_state(State.NULL);

    }  
    public void open(string stream) {

        this.player.uri = stream;

        this.player.set_state(State.READY);

    }

    public void play() {

        this.player.set_state(State.PLAYING);

    }

    public void pause() {

        this.player.set_state(State.PAUSED);

    }

    public void stop() {

        this.player.set_state(State.READY);

    }
    public string get_uri(){
      return this.player.uri;
    }
    private void foreach_tag(Gst.TagList list, string tag) {
        switch (tag) {
        case "title":
            string tag_string;
            list.get_string (tag, out tag_string);
            stdout.printf ("tag: %s = %s\n", tag, tag_string);
            break;
        default:
            break;
        }
    }

    private bool bus_callback(Gst.Bus bus, Gst.Message message) {
        
        string debug=null;
        switch (message.type) {

            case Gst.MessageType.ERROR:

                GLib.Error err;
            
                message.parse_error (out err, out debug);
                stdout.printf ("Error: %s\n", err.message);

                break;

            case Gst.MessageType.EOS:

                stdout.printf ("end of stream\n");

                break;

               case Gst.MessageType.STATE_CHANGED:

                Gst.State oldstate;
                Gst.State newstate;
                Gst.State pending;
                message.parse_state_changed (out oldstate, out newstate,
                                             out pending);
                if (debug!=null) {
                    stdout.printf ("state changed: %s->%s:%s\n",
                                   oldstate.to_string (), newstate.to_string (),
                                   pending.to_string ());
                }

                break;

            case Gst.MessageType.TAG:

                Gst.TagList tag_list;
                stdout.printf ("taglist found\n");
                message.parse_tag (out tag_list);
                tag_list.foreach ((TagForeachFunc) foreach_tag);

                break;

            default:
                break;

        }

        return true;

    }

}
