package com.example.pillmate.service.impl;

import com.example.pillmate.model.Drug;
import com.example.pillmate.repository.DrugRepository;
import com.example.pillmate.service.DrugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class DrugServiceimpl implements DrugService {

    @Autowired
    DrugRepository drugRepository;

    @Override
    public List<Drug> getDrugs() {
        return drugRepository.getAllDrugs();
    }

    @Override
    public List<Drug> getDrugsByQuery(String query) {
        List<Drug> drugs = drugRepository.getAllDrugs();
        List<Drug> result = new ArrayList<>();

        for (Drug drug:
             drugs) {
            if(drug.getId().toLowerCase().contains(query.toLowerCase())){
                result.add(drug);
            }

            if(drug.getTradeName().toLowerCase().contains(query.toLowerCase())){
                result.add(drug);
            }

            if(drug.getGenericName().toLowerCase().contains(query.toLowerCase())){
                result.add(drug);
            }
        }

        return result;
    }




}
