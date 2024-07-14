package com.example.pillmate.model;


import java.util.Date;


public class Pharmacy {
    private String pharID;
    private String storeName;
//    private Date date;
    private String address;
    private String province;
    private String city;
    private String latitude;
    private String longitude;
    private String phoneNumber;
    private String serviceTime;
    private String serviceDate;

    private String email;

    public Pharmacy(){

    }

    public Pharmacy(String pharID, String storeName, String address, String latitude, String longitude, String phoneNumber, String serviceTime, String serviceDate, String province, String city, String email){
        this.pharID = pharID;
        this.storeName = storeName;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.phoneNumber = phoneNumber;
        this.serviceTime = serviceTime;
        this.serviceDate = serviceDate;
        this.province = province;
        this.city = city;
        this.email = email;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCity() {
        return city;
    }

    public String getProvince() {
        return province;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getPharID() {
        return pharID;
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
