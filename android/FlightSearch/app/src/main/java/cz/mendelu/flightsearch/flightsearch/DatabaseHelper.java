package cz.mendelu.flightsearch.flightsearch;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DatabaseHelper extends SQLiteOpenHelper {

    private static final String DATABASE_NAME = "flightsearch";
    private static final int DATABASE_VERSION = 1;

    public DatabaseHelper(Context context){
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }


    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL(FlightsDatabaseScheme.QUESTIONS_CREATE_TABLE);
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int oldVersion, int newVersion) {
        if (BuildConfig.DEBUG) {
            sqLiteDatabase.execSQL(FlightsDatabaseScheme.FLIGHTS_DROP_TABLE);
            onCreate(sqLiteDatabase);
        }
    }
}





