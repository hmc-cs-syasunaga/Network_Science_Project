import pandas as pd

w = pd.io.excel.read_excel('participant_ratings_raw.xlsx',header=None)
trials = w.as_matrix()

# trials[0]

Valence_Lo=[]
Valence_Hi=[]
Arousal_Lo=[]
Arousal_Hi=[]

count = 0
valence = 0
arousal = 0.0
for row in range(1280):
    id = row
    count+=1
    # valence
    if trials[row][4] <= 3.9:
        Valence_Lo.append(id)
    if trials[row][4] >= 7.0:
        Valence_Hi.append(id)
    # arousal
    if trials[row][5] <= 3.8:
        Arousal_Lo.append(id)
    if trials[row][5] >= 6.9:        
        Arousal_Hi.append(id)
print count

print Valence_Lo
print Valence_Hi
print len(Valence_Hi)
print len(Valence_Lo)
# print Valence_Hi
# print Arousal_Lo
# print Arousal_Hi

# print len(Valence_Lo)
# print len(Valence_Hi)
# print len(Arousal_Lo)
# print len(Arousal_Hi)