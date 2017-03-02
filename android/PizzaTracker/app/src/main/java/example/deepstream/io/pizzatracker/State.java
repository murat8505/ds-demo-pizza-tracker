package example.deepstream.io.pizzatracker;


public class State {

    private static State instance = null;
    private String email;

    protected State() {
    }

    public static State getInstance() {
        if(instance == null) {
            instance = new State();
        }
        return instance;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}