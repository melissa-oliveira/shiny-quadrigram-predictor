#!/usr/bin/python3
"""
Created on Fri Oct 04 2024

@author:  Melissa Silva de Oliveira
"""
from joblib import load

# Carrega o modelo e o vetorizer
rnd_mdl_loaded = load('./models/random_forest_model.joblib')
vectorizer_loaded = load('./models/tfidf_vectorizer.joblib')

# Mapeamento entre valores numéricos e categorias
label_map = {
    0: "APRENDIZAGEM",
    1: "ENTRETENIMENTO",
    2: "ESTÉTICA",
    3: "EVASÃO"
}

def predict(text):
    # Transforma o texto usando o vetorizer
    text_vectorized = vectorizer_loaded.transform([text])
    # Faz a previsão
    prediction = rnd_mdl_loaded.predict(text_vectorized)
    # Retorna a categoria correspondente
    return label_map[prediction[0]] 

