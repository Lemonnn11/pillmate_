package com.example.pillmate.service.impl;

import com.example.pillmate.model.Drug;
import com.example.pillmate.repository.DrugRepository;
import com.example.pillmate.service.DrugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DrugServiceimpl implements DrugService {

    @Autowired
    DrugRepository drugRepository;

    @Override
    public List<Drug> getDrugs() {
        return drugRepository.getAllDrugs();
    }
}
