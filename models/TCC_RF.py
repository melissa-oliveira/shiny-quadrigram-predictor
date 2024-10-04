# -*- coding: utf-8 -*-
"""
Created on Mon Sep 12 21:58:05 2022

@author: Johann Belenda Mashio

Modified on Fri Oct 04 2024 by Melissa Silva de Oliveira
"""

from sklearn.ensemble import RandomForestClassifier
import matplotlib.pyplot as plt
import unidecode
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import metrics
from sklearn.metrics import confusion_matrix
from pandas import read_excel
from sklearn.model_selection import train_test_split
from sklearn.metrics import f1_score
from joblib import dump


# Carregar base de quadrigramas classificados
data = read_excel("./data_set_PEJ.xlsx")
data["DOMINIO_l"] = data["DOMINIO"].map({ "APRENDIZAGEM": 0, "ENTRETENIMENTO" : 1, "ESTETICA": 2, "EVASÃO":3})

data = data.drop(columns="DOMINIO")
y = data["DOMINIO_l"].values

# Remover todos os ascentos das letras
for x in range(0, len(data)):
    data["QUADRIGRAMAS"][x] = unidecode.unidecode(data["QUADRIGRAMAS"][x])

# Definir divisão de treinamento (80%) e teste (20%)
x_train, x_test, y_train, y_test = train_test_split(data["QUADRIGRAMAS"], y, test_size=0.20, random_state=(40))

# Treinar o modelo
vectorizer = TfidfVectorizer()
X_train_vectorize = vectorizer.fit_transform(x_train)

rnd_mdl = RandomForestClassifier(n_estimators=1000, criterion='gini', max_depth=10, max_features='sqrt')
rnd_mdl.fit(X_train_vectorize, y_train)

vect_transform = vectorizer.transform(x_test)

# Imprimir informações relevantes
output_test_pred = rnd_mdl.predict(vect_transform)
print(metrics.classification_report(y_test, output_test_pred))
print(f'Acuracia: {metrics.accuracy_score(y_test, output_test_pred)}')

# Salvar o modelo e o vectorizer em um arquivo
dump(rnd_mdl, 'random_forest_model.joblib')
dump(vectorizer, 'tfidf_vectorizer.joblib')

