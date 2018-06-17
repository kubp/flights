package cz.mendelu.flightsearch.flightsearch;

public class Flight {
    private float price;
    private String cityFrom;
    private String cityTo;
    private String duration;
    private long id;

    private float latFrom;
    private float latTo;
    private float lngFrom;
    private float lngTo;

    public float getLatFrom() {
        return latFrom;
    }

    public void setLatFrom(float latFrom) {
        this.latFrom = latFrom;
    }

    public float getLatTo() {
        return latTo;
    }

    public void setLatTo(float latTo) {
        this.latTo = latTo;
    }

    public float getLngFrom() {
        return lngFrom;
    }

    public void setLngFrom(float lngFrom) {
        this.lngFrom = lngFrom;
    }

    public float getLngTo() {
        return lngTo;
    }

    public void setLngTo(float lngTo) {
        this.lngTo = lngTo;
    }

    public Flight(float price, String cityFrom, String cityTo, String duration, long id, float latFrom, float latTo, float lngFrom, float lngTo) {
        this.price = price;
        this.cityFrom = cityFrom;
        this.cityTo = cityTo;
        this.duration = duration;
        this.id = id;
        this.latFrom = latFrom;
        this.latTo = latTo;
        this.lngFrom = lngFrom;
        this.lngTo = lngTo;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public Flight(float price, String cityFrom, String cityTo, String duration) {
        this.price = price;
        this.cityFrom = cityFrom;
        this.cityTo = cityTo;
        this.duration = duration;
    }

    public Flight() {

    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public String getCityFrom() {
        return cityFrom;
    }

    public void setCityFrom(String cityFrom) {
        this.cityFrom = cityFrom;
    }

    public String getCityTo() {
        return cityTo;
    }

    public void setCityTo(String cityTo) {
        this.cityTo = cityTo;
    }

    @Override
    public String toString() {
        return "Flight{" +
                "price=" + price +
                ", cityFrom='" + cityFrom + '\'' +
                ", cityTo='" + cityTo + '\'' +
                '}';
    }
}