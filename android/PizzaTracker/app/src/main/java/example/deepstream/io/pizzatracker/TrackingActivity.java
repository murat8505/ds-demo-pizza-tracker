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
import android.util.Log;
import android.widget.Toast;
import com.google.gson.JsonObject;

import java.net.URISyntaxException;
import java.util.Arrays;

import io.deepstream.DeepstreamClient;
import io.deepstream.DeepstreamFactory;
import io.deepstream.List;
import io.deepstream.Record;

import static android.Manifest.permission.ACCESS_FINE_LOCATION;

public class TrackingActivity extends AppCompatActivity {

    private LocationManager locationManager;
    private DeepstreamFactory factory;
    private DeepstreamClient client;
    private State state;
    private Record locationRecord;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (checkSelfPermission(ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(
                    new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                    15
            );
        }

        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

        locationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER, 2 * 60 * 1000, 10, locationListenerGPS);

        state = State.getInstance();
        factory = DeepstreamFactory.getInstance();
        try {
            client = factory.getClient(this.getString(R.string.dsh_app_url));
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        List users = client.record.getList( "pizza-tracker/users" );
        if( !Arrays.asList( users.getEntries() ).contains( state.getEmail() )) {
            users.addEntry( state.getEmail() );
        }

        locationRecord = client.record.getRecord(state.getEmail());
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
                    Toast.makeText(TrackingActivity.this, "Location Change", Toast.LENGTH_SHORT).show();
                }
            });

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    Toast.makeText(TrackingActivity.this, "Record Content", Toast.LENGTH_SHORT).show();
                }
            });

            JsonObject coords = new JsonObject();
            Log.w("dsh", "lat:" + latitudeNetwork + " long:" + longitudeNetwork);
            coords.addProperty( "lat", latitudeNetwork );
            coords.addProperty( "lng", longitudeNetwork );
            coords.addProperty( "online", true );
            locationRecord.set( coords );

            System.out.println( coords );

            runOnUiThread(new Runnable() {
                @Override
                    public void run() {
                        Toast.makeText(TrackingActivity.this, "GPS Provider update", Toast.LENGTH_SHORT).show();
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
