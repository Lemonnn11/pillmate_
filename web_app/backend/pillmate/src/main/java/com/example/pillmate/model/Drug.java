package com.example.pillmate.model;

public class Drug {

    private String id;
    private String tradeName;
    private String genericName;
    private String dosageForm;
    private String category;
    private String protectedFromLight;
    private String imgSource;

    public Drug(){

    }

    public Drug(String id, String tradeName, String genericName, String dosageForm,
                String category, String protectedFromLight, String imgSource) {
        this.id = id;
        this.tradeName = tradeName;
        this.genericName = genericName;
        this.dosageForm = dosageForm;
        this.category = category;
        this.protectedFromLight = protectedFromLight;
        this.imgSource = imgSource;
    }
    public String getId() {
        return id;
    }

    public String getTradeName() {
        return tradeName;
    }

    public String getGenericName() {
        return genericName;
    }

    public String getDosageForm() {
        return dosageForm;
    }

    public String getCategory() {
        return category;
    }

    public String getProtectedFromLight() {
        return protectedFromLight;
    }

    public String getImgSource() {
        return imgSource;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setTradeName(String tradeName) {
        this.tradeName = tradeName;
    }

    public void setGenericName(String genericName) {
        this.genericName = genericName;
    }

    public void setDosageForm(String dosageForm) {
        this.dosageForm = dosageForm;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setProtectedFromLight(String protectedFromLight) {
        this.protectedFromLight = protectedFromLight;
    }

    public void setImgSource(String imgSource) {
        this.imgSource = imgSource;
    }
}

