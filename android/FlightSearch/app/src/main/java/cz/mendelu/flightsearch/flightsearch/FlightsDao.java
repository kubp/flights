package cz.mendelu.flightsearch.flightsearch;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;

public class FlightsDao implements IFlightDao, FlightsDatabaseScheme{
    private Context context;

    public FlightsDao(Context context) {
        this.context = context;
    }

    @Override
    public void addFlight(Flight question) {

        DatabaseHelper databaseHelper = new DatabaseHelper(context);
        if (databaseHelper != null){
            SQLiteDatabase sqLiteDatabase = databaseHelper.getWritableDatabase();
            try {
                long id = sqLiteDatabase.insert(TABLE_NAME,
                        null,
                        questionToContentValues(question));
                question.setId(id);
            } finally {
                sqLiteDatabase.close();
            }
        }

    }

    @Override
    public void updateFlight(Flight flight) {

        DatabaseHelper databaseHelper = new DatabaseHelper(context);
        if (databaseHelper != null){
            SQLiteDatabase sqLiteDatabase = databaseHelper.getWritableDatabase();
            try {
                int numberOfRows = sqLiteDatabase.update(TABLE_NAME,
                        questionToContentValues(flight),
                        _ID + "=? ",
                        new String[]{String.valueOf(flight.getId())}
                );

            } finally {
                sqLiteDatabase.close();
            }
        }
    }

    @Override
    public ArrayList<Flight> getAllFlights() {

        ArrayList<Flight> list = new ArrayList<>();
        DatabaseHelper databaseHelper = new DatabaseHelper(context);
        if (databaseHelper != null){
            SQLiteDatabase sqLiteDatabase = databaseHelper.getWritableDatabase();
            Cursor cursor = sqLiteDatabase.query(
                    TABLE_NAME,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null);
            try {
                if (cursor != null){
                    while (cursor.moveToNext()){
                        list.add(cursorToQuestion(cursor));
                    }
                }
            } finally {
                if(cursor != null){
                    cursor.close();
                }
                sqLiteDatabase.close();
            }
        }
        return list;
    }

    @Override
    public Flight getFlightByID(long id) {
        Flight question = null;
        DatabaseHelper databaseHelper = new DatabaseHelper(context);
        if (databaseHelper != null){
            SQLiteDatabase sqLiteDatabase = databaseHelper.getWritableDatabase();

            String selection = _ID + "=? ";
            String[] selectionArgs = new String[]{String.valueOf(id)};


            Cursor cursor = sqLiteDatabase.query(
                    TABLE_NAME,
                    null,
                    selection,
                    selectionArgs,
                    null,
                    null,
                    null);
            try {
                if (cursor != null){
                    if (cursor.moveToNext()){
                        question = cursorToQuestion(cursor);
                    }
                }
            } finally {
                if(cursor != null){
                    cursor.close();
                }
                sqLiteDatabase.close();
            }
        }
        return question;    }

    private ContentValues questionToContentValues(Flight flight){

        ContentValues contentValues = new ContentValues();
        contentValues.put(FlightsDatabaseScheme.COLUMN_CITY_FROM, flight.getCityFrom());
        contentValues.put(FlightsDatabaseScheme.COLUMN_CITY_TO, flight.getCityTo());
        contentValues.put(FlightsDatabaseScheme.COLUMN_DURATION, flight.getDuration());
        contentValues.put(FlightsDatabaseScheme.COLUMN_PRICE, flight.getPrice());

        return contentValues;
    }

    private Flight cursorToQuestion(Cursor cursor){
        Flight flight = new Flight();
        flight.setId(cursor.getLong(cursor.getColumnIndex(_ID)));
        flight.setCityFrom(cursor.getString(cursor.getColumnIndex(COLUMN_CITY_FROM)));
        flight.setCityTo(cursor.getString(cursor.getColumnIndex(COLUMN_CITY_TO)));
        flight.setDuration(cursor.getString(cursor.getColumnIndex(COLUMN_DURATION)));
        flight.setPrice(cursor.getFloat(cursor.getColumnIndex(COLUMN_PRICE)));



        return flight;
    }



}
