package cz.mendelu.flightsearch.flightsearch;

import java.util.ArrayList;

public interface IFlightDao {
    void addFlight(Flight question);
    void updateFlight(Flight question);
    ArrayList<Flight> getAllFlights();
    Flight getFlightByID(long id);

}
