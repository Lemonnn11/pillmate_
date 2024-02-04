package com.example.pillmate.service;

import com.example.pillmate.model.Drug;

import java.util.List;

public interface DrugService {
    List<Drug> getDrugs();

    List<Drug> getDrugsByQuery(String query);
}
