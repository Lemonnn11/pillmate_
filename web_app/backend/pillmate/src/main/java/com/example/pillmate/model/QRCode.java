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
    private String expiredDate;
    private String date;
    private String conditionOfUse;
    private String additionalAdvice;
    private int amountOfMeds;
    private int quantity;
    private String adverseDrugReaction;
    private String typeOfMedicine;

    private String genericName;
    private String tradeName;

    public QRCode(String qrCodeID, String pharID, int dosagePerTake, int timePerDay,
                    String timeOfMed, String timePeriodForMed, String takeMedWhen,
                    String expiredDate, String date, String conditionOfUse, String additionalAdvice,
                    int amountOfMeds, int quantity, String adverseDrugReaction,
                    String typeOfMedicine, String genericName, String tradeName) {
        this.qrCodeID = qrCodeID;
        this.pharID = pharID;
        this.dosagePerTake = dosagePerTake;
        this.timePerDay = timePerDay;
        this.timeOfMed = timeOfMed;
        this.timePeriodForMed = timePeriodForMed;
        this.takeMedWhen = takeMedWhen;
        this.expiredDate = expiredDate;
        this.date = date;
        this.conditionOfUse = conditionOfUse;
        this.additionalAdvice = additionalAdvice;
        this.amountOfMeds = amountOfMeds;
        this.quantity = quantity;
        this.adverseDrugReaction = adverseDrugReaction;
        this.typeOfMedicine = typeOfMedicine;
        this.genericName = genericName;
        this.tradeName = tradeName;
    }

    public String getPharID() {
        return pharID;
    }

    public String getExpiredDate() {
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

    public String getDate() {
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
