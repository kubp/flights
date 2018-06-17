package cz.mendelu.flightsearch.flightsearch;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;

public class FavoritesActivity extends AppCompatActivity {


    private static final int DETAIL_REQUEST_CODE = 100;

    private ArrayList<Flight> flights;
    private FlightsDao flightsDao;
    private FAQAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favorites);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });



        flights = new ArrayList<>();
        flightsDao = new FlightsDao(this);
        flights.addAll(flightsDao.getAllFlights());

        adapter = new FAQAdapter(flights);

        RecyclerView recyclerView = (RecyclerView) findViewById(R.id.favorites_list);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(adapter);


    }

    @Override
    public void onBackPressed() {

        Intent intent = new Intent();
        intent.putExtra("asd", "Ukoncuji aktivitu FAQ");
        setResult(RESULT_OK, intent);
        finish();


    }


    public class FAQAdapter extends RecyclerView.Adapter<FAQAdapter.FavoriteFlightsViewHolder>{

        private ArrayList<Flight> flightArrayList;

        public FAQAdapter(ArrayList<Flight> flightArrayList) {
            this.flightArrayList = flightArrayList;
        }

        @Override
        public FavoriteFlightsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater
                    .from(FavoritesActivity.this)
                    .inflate(R.layout.row_flight_item, parent, false);

            return new FavoriteFlightsViewHolder(view);

        }

        @Override
        public void onBindViewHolder(final FavoriteFlightsViewHolder holder, int position) {
            final Flight flight = flightArrayList.get(position);
            holder.cityFrom.setText(flight.getCityFrom());
            holder.cityTo.setText(flight.getCityTo());
            holder.price.setText(flight.getDuration());



        }

        @Override
        public int getItemCount() {
            return flightArrayList.size();
        }

        public class FavoriteFlightsViewHolder extends RecyclerView.ViewHolder{

            public TextView cityFrom;
            public TextView cityTo;
            public TextView price;


            public FavoriteFlightsViewHolder(View itemView) {
                super(itemView);
                cityFrom = itemView.findViewById(R.id.cityFrom);
                cityTo = itemView.findViewById(R.id.cityTo);
                price = itemView.findViewById(R.id.price);

            }
        }



    }


    private void refreshList(){
        flights.clear();
        flights.addAll(flightsDao.getAllFlights());
        adapter.notifyDataSetChanged();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == DETAIL_REQUEST_CODE){
            refreshList();
        }

    }
}
