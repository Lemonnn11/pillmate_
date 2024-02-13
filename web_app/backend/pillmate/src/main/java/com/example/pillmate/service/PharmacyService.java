package com.example.pillmate.service;

import com.example.pillmate.model.Pharmacy;

import java.util.concurrent.ExecutionException;

public interface PharmacyService {
    String addPharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException;

    String editPharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException;

    Pharmacy getPharmacyByAccount(String email) throws ExecutionException, InterruptedException;
}
