package cz.mendelu.flightsearch.flightsearch;

import android.graphics.Color;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.FragmentActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.gms.maps.model.PolylineOptions;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Flight added to your favorites", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();

                Bundle extras = getIntent().getExtras();


                FlightsDao flightsDao = new FlightsDao(MapsActivity.this);
                flightsDao.addFlight(new Flight(
                        extras.getInt("price"),
                        extras.getString("cityFrom"),
                        extras.getString("cityTo"),
                        extras.getString("duration")));
                Log.e("App", "Failure");

                Log.e("App", flightsDao.getAllFlights().get(0).toString());


            }
        });

        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);

        Bundle extras = getIntent().getExtras();


        if (extras != null) {
            TextView from = (TextView) findViewById(R.id.detailCityTo);
            from.setText(extras.getString("cityFrom"));


            TextView to = (TextView) findViewById(R.id.detailCityFrom);
            to.setText(extras.getString("cityTo"));


            TextView price = (TextView) findViewById(R.id.detailPrice);
            price.setText(extras.getString("price") + " €");


            TextView duration = (TextView) findViewById(R.id.detailDuration);
            duration.setText(extras.getString("duration"));
        }
    }


    /**
     * Manipulates the map once available.
     * This callback is triggered when the map is ready to be used.
     * This is where we can add markers or lines, add listeners or move the camera. In this case,
     * we just add a marker near Sydney, Australia.
     * If Google Play services is not installed on the device, the user will be prompted to install
     * it inside the SupportMapFragment. This method will only be triggered once the user has
     * installed Google Play services and returned to the app.
     */
    @Override
    public void onMapReady(GoogleMap googleMap) {

        Bundle extras = getIntent().getExtras();

        float latFrom = extras.getFloat("latFrom");
        float latTo = extras.getFloat("latTo");
        float lngFrom = extras.getFloat("lngFrom");
        float lngTo =  extras.getFloat("lngTo");


        mMap = googleMap;
        Polyline line = mMap.addPolyline(new PolylineOptions()
                .add(new LatLng(latFrom, lngFrom), new LatLng(latTo, lngTo))
                .width(8)
                .geodesic(true)
                .color(Color.BLUE));


        // Add a marker in Sydney and move the camera
        LatLng from = new LatLng(latFrom, lngFrom);
        mMap.addMarker(new MarkerOptions().position(from).title(extras.getString("cityFrom")));

        LatLng to = new LatLng(latTo, lngTo);
        mMap.addMarker(new MarkerOptions().position(to).title(extras.getString("cityTo")));
        mMap.moveCamera(CameraUpdateFactory.newLatLng(from));
    }
}
