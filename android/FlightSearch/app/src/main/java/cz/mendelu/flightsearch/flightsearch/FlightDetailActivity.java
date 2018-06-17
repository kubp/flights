package cz.mendelu.flightsearch.flightsearch;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

public class FlightDetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_flight_detail);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Flight added to your favorites", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();

                Bundle extras = getIntent().getExtras();

                FlightsDao flightsDao = new FlightsDao(FlightDetailActivity.this);
                flightsDao.addFlight(new Flight(
                        extras.getFloat("price"),
                        extras.getString("cityFrom"),
                        extras.getString("cityTo"),
                        extras.getString("duration")));

            }
        });

        Bundle extras = getIntent().getExtras();


        if (extras != null) {
            TextView from = (TextView) findViewById(R.id.detailCityFrom);
            from.setText(extras.getString("cityFrom"));


            TextView to = (TextView) findViewById(R.id.detailCityTo);
            to.setText(extras.getString("cityTo"));


            TextView price = (TextView) findViewById(R.id.detailPrice);
            price.setText(extras.getString("price"));


            TextView duration = (TextView) findViewById(R.id.detailDuration);
            duration.setText(extras.getString("duration"));
        }


    }

}
