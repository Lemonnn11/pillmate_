package com.example.pillmate.service.impl;

import com.example.pillmate.model.Pharmacy;
import com.example.pillmate.repository.PharmacyRepository;
import com.example.pillmate.service.PharmacyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class PharmacyServiceimpl implements PharmacyService {

    @Autowired
    PharmacyRepository pharmacyRepository;

    @Override
    public boolean addPharmacy(Pharmacy pharmacy) throws ExecutionException, InterruptedException {
            String result = pharmacyRepository.createPharmacy(pharmacy);
            return result != null;
    }
}
