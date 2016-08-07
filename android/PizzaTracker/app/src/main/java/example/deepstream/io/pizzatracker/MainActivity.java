package example.deepstream.io.pizzatracker;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.widget.Toast;
import com.google.gson.JsonObject;
import io.deepstream.DeepstreamClient;
import io.deepstream.DeepstreamRuntimeErrorHandler;
import io.deepstream.Record;
import io.deepstream.constants.Event;
import io.deepstream.constants.Topic;

import static android.Manifest.permission.ACCESS_FINE_LOCATION;

public class MainActivity extends AppCompatActivity {
    private LocationManager locationManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        if (ActivityCompat.checkSelfPermission(this, ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    15);
        }

        locationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER, 2 * 60 * 1000, 10, locationListenerGPS);

        DeepstreamClient client = DeepstreamService.getInstance().getDeepstreamClient();
        client.setRuntimeErrorHandler(new DeepstreamRuntimeErrorHandler() {
            @Override
            public void onException(Topic topic, Event event, String s) {
                System.err.println( topic.toString() + " " + event.toString() + " " + s);
            }
        });
    }

    private final LocationListener locationListenerGPS = new LocationListener() {
        @Override
        public void onLocationChanged(Location location) {

            System.out.println( "Location changed" );

            double longitudeNetwork = location.getLongitude();
            double latitudeNetwork = location.getLatitude();

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(MainActivity.this, "Location Change", Toast.LENGTH_SHORT).show();
                }
            });

            DeepstreamClient client = DeepstreamService.getInstance().getDeepstreamClient();
            Record record = client.record.getRecord(DeepstreamService.getInstance().getUserName());

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(MainActivity.this, "Record Content", Toast.LENGTH_SHORT).show();
                }
            });

            JsonObject coords = new JsonObject();
            coords.addProperty( "lat", latitudeNetwork );
            coords.addProperty( "lon", longitudeNetwork );
            coords.addProperty( "online", true );
            record.set( coords );

            System.out.println( coords );

            runOnUiThread(new Runnable() {
                @Override
                    public void run() {
                        Toast.makeText(MainActivity.this, "GPS Provider update", Toast.LENGTH_SHORT).show();
                    }
            });
        }
        @Override
        public void onStatusChanged(String s, int i, Bundle bundle) {
        }
        @Override
        public void onProviderEnabled(String s) {
        }
        @Override
        public void onProviderDisabled(String s) {
        }
    };
}
