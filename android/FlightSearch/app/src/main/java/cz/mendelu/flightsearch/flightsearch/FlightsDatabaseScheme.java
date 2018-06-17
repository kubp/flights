package cz.mendelu.flightsearch.flightsearch;

import android.provider.BaseColumns;

public interface FlightsDatabaseScheme extends BaseColumns {

    String TABLE_NAME = "flights";

    String COLUMN_CITY_FROM = "cityfrom";
    String COLUMN_CITY_TO = "cityto";
    String COLUMN_DURATION = "duration";
    String COLUMN_PRICE = "price";

    String QUESTIONS_CREATE_TABLE =
            "CREATE TABLE " + TABLE_NAME
                    + " ("
                    + _ID + " INTEGER PRIMARY KEY,"
                    + COLUMN_CITY_FROM + " TEXT,"
                    + COLUMN_CITY_TO + " TEXT,"
                    + COLUMN_PRICE + " INTEGER,"
                    + COLUMN_DURATION + " TEXT"
                    + ")";

    String FLIGHTS_DROP_TABLE = "DROP TABLE IF EXISTS " + TABLE_NAME;


}
