

[DBus (name = "org.panda.command")]
public class PandaDBusService : Object {

    public signal void invoke(string args);
    private int counter;
    public int ping (string msg) {
        stdout.printf ("%s\n", msg);
        return counter++;
    }

}