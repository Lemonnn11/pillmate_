package com.example.pillmate.service;

import com.example.pillmate.model.Pharmacy;

import java.util.concurrent.ExecutionException;

public interface PharmacyService {
    String addPharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException;
}
