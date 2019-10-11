import pandas as pd
import numpy as np
import seaborn as sns
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt

#matplotlib inline
df = pd.read_csv('/Users/Arman/Desktop/Arauco Energy Data for regression.csv')
df2 = df[[column for column in df if df[column].count() / len(df) >= 0.3]]
#del df2['Id']
print("List of dropped columns:", end=" ")
for c in df.columns:
    if c not in df2.columns:
        print(c, end=", ")
print('\n')
df = df2
#list(df) #Get the data values

df.drop(df.loc[df['Fibrex 2 Production']=='Null'].index, inplace=True)

df['Fibrex 2 Production'] = pd.to_numeric(df['Fibrex 2 Production'], errors='coerce')


#ALways use axis as 1 to remove the starting columns
df = df.drop(df.columns[[0, 1, 2,3,4,5]], axis=1)

for c in range(31):
    df[df.columns[c]] = pd.to_numeric(df[df.columns[c]], errors='coerce')
    
#Only running mode
df = df[df['Downtime flag'] == 0]

columns = [5,16,17,18,19,20,21,22,23,24,25,26,27]



Energydf = df[df.columns[columns]]

Prediction = []

list(Prediction) = list(df)

Production = Energydf[Energydf.columns[0]]
for column in Energydf:
    Prediction[column] = Energydf[column]/Production
   
    
Energydf[Energydf.columns[column]]/Production    
column+=1





#Once the normalization is done
for column in Energydf:
    print(Energydf[column].describe())

Energydf

def sumColumn(m, column):
    total = 0
    for row in range(len(m)):
        total += m[row][column]
    return total

column = 1
print("Sum of the elements in column", column, "is", sumColumn(Check, column))


Check = Energydf[Energydf.columns[[1,2,3,4]]]