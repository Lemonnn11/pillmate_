package com.example.pillmate.model;


import java.util.Date;


public class Pharmacy {
    private String pharID;
    private String storeName;
//    private Date date;
    private String address;
    private String latitude;
    private String longitude;
    private String phoneNumber;
    private String email;
    private String password;
    private String serviceTime;
    private String serviceDate;

    public Pharmacy(){

    }

    public Pharmacy(String pharID, String storeName, String address, String latitude, String longitude, String phoneNumber, String email, String password, String serviceTime, String serviceDate){
        this.pharID = pharID;
        this.storeName = storeName;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.password = password;
        this.serviceTime = serviceTime;
        this.serviceDate = serviceDate;
    }

    public String getPharID() {
        return pharID;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getAddress() {
        return address;
    }

    public String getLatitude() {
        return latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String getServiceDate() {
        return serviceDate;
    }

    public String getServiceTime() {
        return serviceTime;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public void setPharID(String pharID) {
        this.pharID = pharID;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setServiceDate(String serviceDate) {
        this.serviceDate = serviceDate;
    }

    public void setServiceTime(String serviceTime) {
        this.serviceTime = serviceTime;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }
}
