package com.example.pillmate.service.impl;

import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.repository.PharmacyRepository;
import com.example.pillmate.service.PharmacyService;
import com.google.cloud.firestore.FirestoreException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class PharmacyServiceimpl implements PharmacyService {

    @Autowired
    PharmacyRepository pharmacyRepository;

    @Override
    public String addPharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException {
            try{
                String result = pharmacyRepository.createPharmacy(pharmacy);
                return result;
            }
            catch (FirestoreException e){
                return null;
            }
    }
}
