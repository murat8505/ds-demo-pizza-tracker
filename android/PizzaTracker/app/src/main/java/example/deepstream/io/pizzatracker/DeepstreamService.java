package example.deepstream.io.pizzatracker;

import io.deepstream.DeepstreamClient;

import java.net.URISyntaxException;

public class DeepstreamService {
    private static DeepstreamService ourInstance = new DeepstreamService();
    private String userName;

    public static DeepstreamService getInstance() {
        return ourInstance;
    }

    DeepstreamClient deepstreamClient;
    DeepstreamService() {
        try {
            this.deepstreamClient = new DeepstreamClient( "52.29.229.244:6021" );
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
    }

    DeepstreamClient getDeepstreamClient() {
        return this.deepstreamClient;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserName() {
        return userName;
    }
}
