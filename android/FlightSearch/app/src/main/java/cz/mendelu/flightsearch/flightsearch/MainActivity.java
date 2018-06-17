package cz.mendelu.flightsearch.flightsearch;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;

interface AsyncResponse {
    void processFinish(JSONArray output);
}

public class MainActivity extends AppCompatActivity implements AsyncResponse{
    MyAsyncTask asyncTask;

    private static final int DETAIL_REQUEST_CODE = 100;

    private ArrayList<Flight> flights;
  //  private QuestionsDao questionsDao;
    private FAQAdapter adapter;
    private Toolbar toolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);


        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });

       // String message = getIntent().getStringExtra("test");


        flights = new ArrayList<>();

        flights.add(new Flight(40,"dadsa", "asdas", "asass"));


        adapter = new FAQAdapter(flights);

        RecyclerView recyclerView = (RecyclerView) findViewById(R.id.faq_list);

        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        recyclerView.setAdapter(adapter);




        final Button button = (Button) findViewById(R.id.search_button);
        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                asyncTask = new MyAsyncTask();
                asyncTask.delegate = MainActivity.this;

                asyncTask.execute();


//                flights.add(new Flight(40,"dadsa", "asdas"));
//                adapter.notifyDataSetChanged();
            }
        });


    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            Intent intent = new Intent(MainActivity.this,
                    FavoritesActivity.class);

            startActivityForResult(intent, DETAIL_REQUEST_CODE);

            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void processFinish(JSONArray rawFlights) {
        //Here you will receive the result fired from async class

        try {
            flights.clear();
        for (int i = 0; i < rawFlights.length(); i++)
        {
            String flyTo = rawFlights.getJSONObject(i).getString("flyTo");
            String flyFrom = rawFlights.getJSONObject(i).getString("flyFrom");
            int price = rawFlights.getJSONObject(i).getInt("price");
            String fly_duration = rawFlights.getJSONObject(i).getString("fly_duration");
//            float lngTo = rawFlights.getJSONObject(i).getInt("lngTo");
//            float lngFrom = rawFlights.getJSONObject(i).getInt("lngFrom");
//            float latTo = rawFlights.getJSONObject(i).getInt("latTo");
//            float latFrom = rawFlights.getJSONObject(i).getInt("latFrom");


          flights.add(new Flight(price,flyFrom, flyTo, fly_duration));


            // Log.e("App", post_id);



        }

            adapter.notifyDataSetChanged();

        } catch (JSONException ex) {
            Log.e("App", "Failure", ex);
        }


    }




    @Override
    public void onBackPressed() {

        Intent intent = new Intent();
        intent.putExtra("MESSAGE", "Ukoncuji aktivitu FAQ");
        setResult(RESULT_OK, intent);
        finish();


    }




    public class FAQAdapter extends RecyclerView.Adapter<FAQAdapter.QuestionViewHolder>{

        private ArrayList<Flight> flightArrayList;

        public FAQAdapter(ArrayList<Flight> flightArrayList) {
            this.flightArrayList = flightArrayList;
        }

        @Override
        public QuestionViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater
                    .from(MainActivity.this)
                    .inflate(R.layout.row_flight_item, parent, false);

            return new QuestionViewHolder(view);

        }

        @Override
        public void onBindViewHolder(final QuestionViewHolder holder, int position) {
            final Flight flight = flightArrayList.get(position);
            holder.question.setText(flight.getCityFrom());

            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    int newPosition = holder.getAdapterPosition();
                    Intent intent = new Intent(MainActivity.this,
                            MapsActivity.class);
                    intent.putExtra("cityFrom", flight.getCityFrom());
                    intent.putExtra("cityTo", flight.getCityTo());
                    intent.putExtra("price", Float.toString(flight.getPrice()));
                    intent.putExtra("duration", flight.getDuration());
                    startActivityForResult(intent, DETAIL_REQUEST_CODE);
                }
            });


        }

        @Override
        public int getItemCount() {
            return flightArrayList.size();
        }

        public class QuestionViewHolder extends RecyclerView.ViewHolder{

            public TextView question;


            public QuestionViewHolder(View itemView) {
                super(itemView);
                question = itemView.findViewById(R.id.cityFrom);

            }
        }



    }


    private void refreshList(){
       // flights.clear();
        //flights.addAll(questionsDao.getAllQuestions());
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


class MyAsyncTask extends AsyncTask<Void, Void, JSONObject>{
    public AsyncResponse delegate = null;


    @Override
    protected JSONObject doInBackground(Void... params)
    {

        String str="https://api.skypicker.com/flights?adults=1&affilid=stories&asc=1&children=0&dateFrom=28%2F07%2F2018&dateTo=28%2F08%2F2018&daysInDestinationFrom=2&daysInDestinationTo=10&featureName=results&flyFrom=49.2-16.61-250km&infants=0&limit=60&locale=us&offset=0&one_per_date=0&oneforcity=0&partner=skypicker&returnFrom=&returnTo=&sort=quality&to=LAX&typeFlight=return&v=3&wait_for_refresh=0";
        URLConnection urlConn = null;
        BufferedReader bufferedReader = null;
        try
        {
            URL url = new URL(str);
            urlConn = url.openConnection();
            bufferedReader = new BufferedReader(new InputStreamReader(urlConn.getInputStream()));

            StringBuffer stringBuffer = new StringBuffer();
            String line;
            while ((line = bufferedReader.readLine()) != null)
            {
                stringBuffer.append(line);
            }

            return new JSONObject(stringBuffer.toString());
        }
        catch(Exception ex)
        {
            Log.e("App", "yourDataTask", ex);
            return null;
        }
        finally
        {
            if(bufferedReader != null)
            {
                try {
                    bufferedReader.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    protected void onPostExecute(JSONObject response)
    {
        if(response != null)
        {

            try {
               // Log.e("App", response.getString("data"));


                JSONArray arr =  response.getJSONArray("data");
                delegate.processFinish(arr);
                for (int i = 0; i < arr.length(); i++)
                {
                    String post_id = arr.getJSONObject(i).getString("flyTo");
                  // Log.e("App", post_id);



                }


               // Log.e("App", "Success: " + response.getString("yourJsonElement") );
            } catch (JSONException ex) {
                Log.e("App", "Failure", ex);
            }
        }
    }
}