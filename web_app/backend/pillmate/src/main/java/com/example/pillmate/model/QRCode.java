package com.example.pillmate.model;


import java.util.Date;


public class QRCode {

    private String qrCodeID;
//    private String code;
//    private String medID;
    private String pharID;
    private int dosagePerTake;
    private int timePerDay;
    private String timeOfMed;
    private String timePeriodForMed;
    private String takeMedWhen;
    private Date expiredDate;
    private Date date;
    private String conditionOfUse;
    private String additionalAdvice;
    private int amountOfMeds;
    private int quantity;
    private String adverseDrugReaction;
    private String typeOfMedicine;

    private String genericName;
    private String tradeName;

    public String getPharID() {
        return pharID;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public int getAmountOfMeds() {
        return amountOfMeds;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getDosagePerTake() {
        return dosagePerTake;
    }

    public int getTimePerDay() {
        return timePerDay;
    }

    public String getAdditionalAdvice() {
        return additionalAdvice;
    }

    public String getConditionOfUse() {
        return conditionOfUse;
    }

    public String getQrCodeID() {
        return qrCodeID;
    }

    public String getTakeMedWhen() {
        return takeMedWhen;
    }

    public String getTimeOfMed() {
        return timeOfMed;
    }

    public String getTimePeriodForMed() {
        return timePeriodForMed;
    }

    public Date getDate() {
        return date;
    }

    public String getAdverseDrugReaction() {
        return adverseDrugReaction;
    }

    public String getGenericName() {
        return genericName;
    }

    public String getTradeName() {
        return tradeName;
    }

    public String getTypeOfMedicine() {
        return typeOfMedicine;
    }

    public void setQrCodeID(String qrCodeID) {
        this.qrCodeID = qrCodeID;
    }
}
