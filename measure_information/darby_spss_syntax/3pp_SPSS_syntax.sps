* Encoding: UTF-8.
*Syntax follows for the MAT, DAS, PSQI, Postnatal Attachment Scale, BDI, SCL-90, Perceived Stress Scale, Ages and Stages 2 month and 4 month, Infant Behavior Questionnaire, 
*Baby Care Questionnaire, Parenting Stress, Parent Infant Attachment Scale, Parental Bonding Q, EPDS, Parenting Stress Inventory, Maternal Attachment Inventory, MOS Social Support
*also some syntax for perinatal interview + Who Does What appears at the end of this file

*For 4th trimester Q, note that there are several entries for 46B and 48B. These participants partially completed their questionnaires and then retook them. Save the complete entry and delete the others. 
*Also, 48A indicated she was male. Check this. Couple 73, both partners indicate they are male. LB should be relabeled as female.  
*Note that Qualtrics has gender coded as 1=male, 2=female. This is the opposite of how we have our hormones coded (A=1=female; B=2=male). 
*Therefore we should switch the genders so when we restructure this file to merge with the hormone data, the genders match up correctly. 

RECODE 
Gender
 (1=2) (2=1) INTO
Gender.
EXECUTE.

*Calculating Body Mass Index (BMI)
*Divide weight in pounds by height in inches squared and multiply by a conversion factor of 703 (BMI = weight (lb) / [height (in)]2 x 703).
*First, change name of "weight" variable to Weight_3pp

*COMPUTE Heightinches = ((Height_1_TEXT * 12) + Height_2_TEXT).
*EXECUTE.
*COMPUTE Heightsquared = (Heightinches * Heightinches).
*EXECUTE.
COMPUTE BMI.3pp.1 = (Weight_3pp.1/Heightsquared.1)*703.
EXECUTE.
COMPUTE BMI.3pp.2 = (Weight_3pp.2/Heightsquared.2)*703.
EXECUTE.


*Calculate baby's age at the time of questionnaire:
*manually convert birthdate from a string to a date mm/dd/yyyy variable
*doublecheck that people put the right birth year. There are a couple mistakes where people said "2015" for Dec. 2014 births. 
*manually convert V8 (when they started the q) to a date mm/dd/yyyy variable
*note that some V8 date looks wrong; check V9 and when it doubt, use the date that matches for the couple

alter type StartDate(adate8).

alter type Birthdate_1(adate8).

COMPUTE 
bage3pp = StartDate - Birthdate_1.
EXECUTE. 

*convert from number of seconds to number of days

COMPUTE 
bage3pp = bage3pp/(24*60*60).
EXECUTE. 

*convert from number of days to number of weeks

COMPUTE 
bage3pp = bage3pp/7.
EXECUTE. 
*The MAT variables are weird, so we are going to rename them

RENAME VARIABLES 
(
MAT_1
MAT_2_1
MAT_2_2
MAT_2_3
MAT_2_4
MAT_2_5
MAT_2_6
MAT_2_7
MAT_2_8
MAT_10
MAT_11
MAT_12
MAT_12b
MAT_13
MAT_14
MAT_15
=
MAT1
MAT2
MAT3
MAT4
MAT5
MAT6
MAT7
MAT8
MAT9
MAT10
MAT11
MAT12
MAT12b
MAT13
MAT14
MAT15).
EXECUTE.

*Cleaning and scoring the MAT

*Fixing just item 1

RECODE 
MAT1
 (1=0) (2=2) (3=7) (4=15) (5=20) (6=25) (7=35) INTO
MAT1_fixed.
EXECUTE.

*Fixing 2, 3, 5, 7, 8, 9

RECODE 
MAT2
MAT3
MAT5
MAT7
MAT8
MAT9
 (1=5) (2=4) (3=3) (4=2) (5=1) (6=0) INTO
MAT2_fixed
MAT3_fixed
MAT5_fixed
MAT7_fixed
MAT8_fixed
MAT9_fixed.
EXECUTE.

*Fixing 4

Recode
MAT4
(1=8) (2=6) (3=4) (4=2) (5=1) (6=0) INTO
MAT4_fixed.
Execute.

*Fixing 6

Recode
MAT6
(1=15) (2=12) (3=9) (4=4) (5=1) (6=0) INTO
MAT6_fixed.
Execute.

*Fixing 10

Recode
MAT10
(1=0) (2=2) (3=10) INTO
MAT10_fixed.
Execute.

*Fixing 11

Recode
MAT11
(1=10) (2=8) (3=3) (4=0) INTO
MAT11_fixed.
Execute.

*Fixing 12

IF  (MAT12=1)&(MAT12b=1) MAT12_Fixed=3.
EXECUTE.

IF  (MAT12=2)&(MAT12b=2) MAT12_Fixed=10.
EXECUTE.

IF  (MAT12=2)&(MAT12b=1) MAT12_Fixed=2.
EXECUTE.

IF  (MAT12=1)&(MAT12b=2) MAT12_Fixed=2.
EXECUTE.

*Fixing 13

Recode
MAT13
(1=0) (2=3) (3=8) (4=15) INTO
MAT13_fixed.
Execute.

*Fixing 14

Recode
MAT14
(1=15) (2=0) (3=1) INTO
MAT14_fixed.
Execute.

*Fixing 15

Recode
MAT15
(1=0) (2=2) (3=10) (4=10) INTO
MAT15_fixed.
Execute.

*creating a sum score where higher values mean greater satisfaction

Compute MaritalSat=
MAT1_fixed+
MAT2_fixed+
MAT3_fixed+
MAT5_fixed+
MAT7_fixed+
MAT8_fixed+
MAT9_fixed+
MAT4_fixed+
MAT6_fixed+
MAT10_fixed+
MAT11_fixed+
MAT12_Fixed+
MAT13_fixed+
MAT14_fixed+
MAT15_fixed.
Execute.


*** DAS full scoring ***

RENAME VARIABLES (DAS1_15_1
DAS1_15_2
DAS1_15_3
DAS1_15_4
DAS1_15_5
DAS1_15_6
DAS1_15_7
DAS1_15_8
DAS1_15_9
DAS1_15_10
DAS1_15_11
DAS1_15_12
DAS1_15_13
DAS1_15_14
DAS1_15_15
=
DAS1
DAS2
DAS3
DAS4
DAS5
DAS6
DAS7
DAS8
DAS9
DAS10
DAS11
DAS12
DAS13
DAS14
DAS15).
EXECUTE.

RENAME VARIABLES (DAS16_22_1
DAS16_22_2
DAS16_22_3
DAS16_22_4
DAS16_22_5
DAS16_22_6
DAS16_22_7
DAS23_1
DAS24_1
DAS25_28_1
DAS25_28_2
DAS25_28_3
DAS25_28_4
DAS29_30_1
DAS29_30_2
DAS_32
=
DAS16
DAS17
DAS18
DAS19
DAS20
DAS21
DAS22
DAS23
DAS24
DAS25
DAS26
DAS27
DAS28
DAS29
DAS30
DAS32).
EXECUTE.

* Designate missing values. Greyed this out for now because there are no missing values, but check if you need to do this. Much more detailed
syntax for mean substitution of missing values available through CCHN DAS syntax..*.
*MISSING VALUES DAS1 to DAS32 (97, 98, 99).
*EXECUTE .

*Identify missings*.
*FREQUENCIES VARIABLES=DAS1 DAS2 DAS3 DAS4 DAS5 DAS6 DAS7 
    DAS8 DAS9 DAS10 DAS11 DAS12 DAS13 DAS14 DAS15 DAS16 DAS17 
    DAS18 DAS19 DAS20 DAS21 DAS22 DAS23 DAS24 DAS25 DAS26 DAS27 
    DAS28 DAS29 DAS30 DAS31 DAS32 
  /ORDER=ANALYSIS.

** Original scales range from 0-5; current version is 5-point (1-5)**.
** Maintained 5 as top of scale, making lowest possible score = 30 ,highest=152**.

*Reverse code items such that higher=more satisfied*.
RECODE DAS1 DAS2 DAS3 DAS4 DAS5 DAS6 DAS7 DAS8 DAS9 
			DAS10 DAS11 DAS12 DAS13 DAS14 DAS15 (1=5) (2=4) (3=3) (4=2) (5=1) INTO 
			DAS1r DAS2r DAS3r DAS4r DAS5r DAS6r DAS7r DAS8r DAS9r 
			DAS10r DAS11r DAS12r DAS13r DAS14r DAS15r.
RECODE DAS18 DAS19 DAS23 DAS24 (1=5) (2=4) (3=3) (4=2) (5=1) INTO DAS18r DAS19r DAS23r DAS24r.
EXECUTE .

RECODE DAS32 (1 = 6) (2 = 5) (3 = 4) (4 = 3) (5 = 2) (6 = 1) INTO DAS32r.
EXECUTE.

*Sum full DAS*.
COMPUTE DAStot = SUM(DAS1r, DAS2r, DAS3r, DAS4r, DAS5r, 
				DAS6r, DAS7r, DAS8r, DAS9r, DAS10r, DAS11r, DAS12r, DAS13r, 
				DAS14r, DAS15r, DAS16, DAS17, DAS18r, DAS19r, DAS20, DAS21, 
				DAS22, DAS23r, DAS24r, DAS25, DAS26, DAS27, DAS28, DAS29, DAS30, DAS31, DAS32r) .
VARIABLE LABELS DAStot 'DAS full scale'. 
EXECUTE.

*DAS Subscale scoring per original Spanier *.
COMPUTE DAScons = SUM(DAS1r, DAS2r, DAS3r, DAS5r, DAS7r, DAS8r, DAS9r, DAS10r, DAS11r, DAS12r, DAS13r, DAS14r, DAS15r) .
COMPUTE DASaff = SUM(DAS4r, DAS6r, DAS29, DAS30) .
COMPUTE DASsat = SUM(DAS16, DAS17, DAS18r, DAS19r, DAS20, DAS21, DAS22, DAS23r, DAS31, DAS32r) .
COMPUTE DAScoh = SUM(DAS24r, DAS25, DAS26, DAS27, DAS28) .
VARIABLE LABELS DAScons 'DAS consensus subscale' DASaff 'DAS affective expression subscale' DASsat 'DAS satisfaction subscale' DAScoh 'DAS cohesion subscale'. 
EXECUTE .

**MOS Social Support
    
Rename Variables 
    (Q103_1
Q103_2
Q103_3
Q103_4
Q103_5
Q103_6
Q103_7
Q103_8
Q103_9
Q103_10
Q103_11
Q103_12
Q103_13
Q103_14
Q103_15
Q103_16
Q103_17
Q103_18
Q103_19
=
MOS_1
MOS_2
MOS_3
MOS_4
MOS_5
MOS_6
MOS_7
MOS_8
MOS_9
MOS_10
MOS_11
MOS_12
MOS_13
MOS_14
MOS_15
MOS_16
MOS_17
MOS_18
MOS_19). 
EXECUTE. 


COMPUTE MOSemotsupp = MEAN(MOS_1, MOS_2, MOS_3, MOS_4, MOS_5, MOS_6, MOS_7, MOS_8).
COMPUTE MOStangsupp = MEAN(MOS_9, MOS_10, MOS_11, MOS_12). 
COMPUTE MOSaffsupp = MEAN(MOS_13, MOS_14, MOS_15).
COMPUTE MOSpossoc = MEAN(MOS_16, MOS_17, MOS_18). 
COMPUTE MOSsocsupptot = MEAN(MOS_1, MOS_2, MOS_3, MOS_4, MOS_5, MOS_6, MOS_7, MOS_8, MOS_9, MOS_10, MOS_11, MOS_12, MOS_13, MOS_14, MOS_15, MOS_16, MOS_17, MOS_18, MOS_19). 
EXECUTE. 

**Pittsburgh Sleep Quality Index
*The PSQI is comprised of seven components (sleep quality, latency, duration, efficiency, disturbances, use of sleep medication, and daytime dysfuction)
*This syntax does not include a sleep efficiency score so we are scoring based on the total of six rather than seven components. 
*We can calculate sleep efficiency but it will require some manual data editing because the sleep and wake times are currently entered as string variables.
*A number of studies have used the PSQI minus the "efficiency" component but be mindful that our means/ranges may differ from studies that use the full PSQI. 

Rename Variables
(Q123
Q125
Q127
Q129
Q131_1
Q131_2
Q131_3
Q131_4
Q131_5
Q131_6
Q131_7
Q131_8
Q131_9
Q131_10
Q133
Q135_1
Q135_2
Q137
= 
PSQI_1
PSQI_2
PSQI_3
PSQI_4
PSQI_5a
PSQI_5b
PSQI_5c
PSQI_5d
PSQI_5e
PSQI_5f
PSQI_5g
PSQI_5h
PSQI_5i
PSQI_5j
PSQI_6
PSQI_7
PSQI_8
PSQI_9).
EXECUTE. 

*PSQI_1-4 are string variables that you will have to manually edit to be numerical
*(e.g., edit "15 minutes" to be "15" and "7 hours 30 minutes" to be 7.5)
*for this syntax, you only need PSQI_2 and PSQI_4

RECODE
PSQI_6
(1=0) (2=1) (3=2) (4=3) INTO
PSQI_qual.
EXECUTE.

IF (PSQI_2 <16) PSQI_lat1= 0.
IF (PSQI_2 >15 & PSQI_2 <31) PSQI_lat1= 1.
IF (PSQI_2 >30 & PSQI_2 <61) PSQI_lat1= 2.
IF (PSQI_2 >60) PSQI_lat1= 3.
EXECUTE.

RECODE
PSQI_5a
(1=0) (2=1) (3=2) (4=3) INTO
PSQI_lat2.
EXECUTE.

COMPUTE PSQI_latsum = SUM (PSQI_lat1, PSQI_lat2).

IF (PSQI_latsum < 1) PSQI_latency= 0.
IF (PSQI_latsum =1) PSQI_latency= 1.
IF (PSQI_latsum =2) PSQI_latency= 1.
IF (PSQI_latsum =3) PSQI_latency= 2.
IF (PSQI_latsum =4) PSQI_latency= 2.
IF (PSQI_latsum =5) PSQI_latency= 3.
IF (PSQI_latsum =6) PSQI_latency= 3.
EXECUTE.

IF (PSQI_4 >7) PSQI_durat= 0.
IF (PSQI_4 <=7 & PSQI_4 > 6) PSQI_durat= 1.
IF (PSQI_4 <= 6 & PSQI_4 > 5) PSQI_durat= 2.
IF (PSQI_4 <= 5) PSQI_durat= 3.
EXECUTE.

RECODE
PSQI_5b
PSQI_5c
PSQI_5d
PSQI_5e
PSQI_5f
PSQI_5g
PSQI_5h
PSQI_5i
PSQI_5j
(1=0) (2=1) (3=2) (4=3) INTO
PSQI_5b
PSQI_5c
PSQI_5d
PSQI_5e
PSQI_5f
PSQI_5g
PSQI_5h
PSQI_5i
PSQI_5j.
EXECUTE.

COMPUTE PSQI_distsum = SUM (PSQI_5b,
PSQI_5c,
PSQI_5d,
PSQI_5e,
PSQI_5f,
PSQI_5g,
PSQI_5h,
PSQI_5i,
PSQI_5j).
EXECUTE. 

IF (PSQI_distsum =0) PSQI_disturb= 0.
IF (PSQI_distsum <=9 & PSQI_distsum >= 1) PSQI_disturb= 1.
IF (PSQI_distsum <= 18 & PSQI_distsum >= 10) PSQI_disturb= 2.
IF (PSQI_distsum >18) PSQI_disturb= 3.
EXECUTE.

RECODE
PSQI_7
(1=0) (2=1) (3=2) (4=3) INTO
PSQI_med.
EXECUTE.

RECODE
PSQI_8
PSQI_9
(1=0) (2=1) (3=2) (4=3) INTO
PSQI_8
PSQI_9.
EXECUTE.

COMPUTE PSQI_daysum = SUM (PSQI_8, PSQI_9).
EXECUTE.

IF (PSQI_daysum < 1) PSQI_daydys= 0.
IF (PSQI_daysum =1) PSQI_daydys= 1.
IF (PSQI_daysum =2) PSQI_daydys= 1.
IF (PSQI_daysum =3) PSQI_daydys= 2.
IF (PSQI_daysum =4) PSQI_daydys= 2.
IF (PSQI_daysum =5) PSQI_daydys= 3.
IF (PSQI_daysum =6) PSQI_daydys= 3.
EXECUTE.

COMPUTE PSQI_tot = SUM (PSQI_qual, PSQI_latency, PSQI_durat, PSQI_disturb, PSQI_med, PSQI_daydys). 
EXECUTE. 

*Condon Postnatal Attachment Scale 
*there are maternal and paternal versions
*since the mom in couple 48 indicated that she is male, she did the PPNAS-- you can use her "tot" score 

Rename Variables
(Q129.0
Q130
Q131
Q132
Q133.0
Q134
Q135
Q136
Q137.0
Q138
Q139
Q140
Q141
Q142
Q143
Q144
Q145
Q146
Q147
=
MPNAS_1
MPNAS_2
MPNAS_3
MPNAS_4
MPNAS_5
MPNAS_6
MPNAS_7
MPNAS_8
MPNAS_9
MPNAS_10
MPNAS_11
MPNAS_12
MPNAS_13
MPNAS_14
MPNAS_15
MPNAS_16
MPNAS_17
MPNAS_18
MPNAS_19).
EXECUTE. 

Rename Variables
(Q103
Q104
Q105.0
Q106
Q107.0
Q108.0
Q109.0
Q110.0
Q111.0
Q112.0
Q113
Q114.0
Q115.0
Q116.0
Q117.0
Q118
Q119
Q120
Q121
=
PPNAS_1
PPNAS_2
PPNAS_3
PPNAS_4
PPNAS_5
PPNAS_6
PPNAS_7
PPNAS_8
PPNAS_9
PPNAS_10
PPNAS_11
PPNAS_12
PPNAS_13
PPNAS_14
PPNAS_15
PPNAS_16
PPNAS_17
PPNAS_18
PPNAS_19).
EXECUTE.

*First, we'll score the MPNAS. 
*Reverse code items that are on a 4 point scale

RECODE
MPNAS_7
MPNAS_10
(1=4) (2=3) (3=2) (4=1) INTO
MPNAS_7rr
MPNAS_10rr.
EXECUTE.

*recode items that on a 2-point scale into a 5 point scale that is reverse coded 

RECODE
MPNAS_8 
MPNAS_12 
(1=5) (2=1) INTO
MPNAS_8r 
MPNAS_12r.
EXECUTE.  

*convert items that are on a 4 point scale into a 5 point scale

RECODE
MPNAS_4
MPNAS_5
MPNAS_6 
MPNAS_7rr
MPNAS_10rr
MPNAS_15
MPNAS_16
MPNAS_17
MPNAS_18
MPNAS_19
(1=1) (2=2.3) (3=3.6) (4=5) INTO
MPNAS_4r
MPNAS_5r
MPNAS_6r 
MPNAS_7r
MPNAS_10r
MPNAS_15r
MPNAS_16r
MPNAS_17r
MPNAS_18r
MPNAS_19r.
EXECUTE.

* reverse code items on a 5 point scale

RECODE
MPNAS_9 
MPNAS_11 
MPNAS_13
MPNAS_14
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
MPNAS_9r 
MPNAS_11r 
MPNAS_13r
MPNAS_14r.
EXECUTE. 

COMPUTE MPNAS_attach = MEAN(MPNAS_3, MPNAS_4r, MPNAS_5r, MPNAS_6r, MPNAS_7r, MPNAS_10r, MPNAS_14r, MPNAS_18r, MPNAS_19r). 
COMPUTE MPNAS_abs.host = MEAN(MPNAS_1, MPNAS_2, MPNAS_15r, MPNAS_16r, MPNAS_17r). 
COMPUTE MPNAS_pleas = MEAN(MPNAS_8r, MPNAS_9r, MPNAS_11r, MPNAS_12r, MPNAS_13r).
EXECUTE.  

COMPUTE MPNAS_tot = MEAN(MPNAS_attach, MPNAS_abs.host, MPNAS_pleas). 
EXECUTE. 

*from the MPNAS manual:
Items in brackets( ) are reverse scored
Quality of attachment: 3 4 5 6 (7) (10) (14) 18 19
Absence of hostility: 1 2 15 16 17
Pleasure in interaction: all reversed ( 8 9 11 12 13)
To ensure equal weighting of all questions it is recommended that response options be
recoded to represent a score of 1 (low attachment) to 5 (high attachment) for every
question. For example:
Question PM4 would be scored as: 1; 2.3; 3.6; 5
Question 8 would be (reverse) scored as: 5; 1 

*Scoring the PPNAS

*Recode items that need to be reverse-coded 

RECODE
PPNAS_4
PPNAS_5
PPNAS_10
PPNAS_12
PPNAS_14
 (1=5) (2=4) (3=3) (4=2) (5=1) INTO
PPNAS_4r
PPNAS_5r
PPNAS_10r
PPNAS_12r
PPNAS_14r.
EXECUTE. 

* Recode items on a 4-point scale to a 5-point scale

RECODE
PPNAS_6
PPNAS_17
PPNAS_18
PPNAS_19 
(1=1) (2=2.3) (3=3.6) (4=5) INTO
PPNAS_6r
PPNAS_17r
PPNAS_18r
PPNAS_19r.
EXECUTE. 

* Recode items on a 4 point scale and reverse code them

RECODE
PPNAS_7
PPNAS_9
PPNAS_11
PPNAS_15
 (1=5) (2=3.6) (3=2.3) (4=1) INTO
PPNAS_7r
PPNAS_9r
PPNAS_11r
PPNAS_15r.
EXECUTE. 

*Recode items on a 2 point scale

RECODE
PPNAS_8
PPNAS_13
 (1=5) (2=1) INTO
PPNAS_8r
PPNAS_13r.
EXECUTE. 

RECODE
PPNAS_16
 (1=5) (2=3) (3=1) INTO
PPNAS_16r.
EXECUTE. 

COMPUTE PPNAS_patience = mean(PPNAS_2, PPNAS_1, PPNAS_6r, PPNAS_19r, PPNAS_11r, PPNAS_17r, PPNAS_13r, PPNAS_18r). 
COMPUTE PPNAS_pleas = mean(PPNAS_5r, PPNAS_15r, PPNAS_9r, PPNAS_12r, PPNAS_4r, PPNAS_8r, PPNAS_10r). 
COMPUTE PPNAS_affection = mean(PPNAS_3, PPNAS_7r, PPNAS_14r, PPNAS_16r). 
COMPUTE PPNAS_tot = mean (PPNAS_affection, PPNAS_pleas, PPNAS_patience). 
EXECUTE. 

*Beck Depression Inventory
*Renaming the items to make it easier for us

Rename Variables
(
BDI1_Sad
BDI2_Pess
BDI3_Fail
BDI4_Pleas
BDI5_Guilt
BDI6_Punis
BDI7_Disli
BDI8_crit
BDI10_cry
BDI11_Agit
BDI12_int
BDI13_Deci
BDI14_Wort
BDI15_Ener
BDI16_Slee
BDI17_Irri
BDI18_Appe
BDI19_Conc
BDI20_Tire
BDI21_Sex
=
BDI1
BDI2
BDI3
BDI4
BDI5
BDI6
BDI7
BDI8
BDI10
BDI11
BDI12
BDI13
BDI14
BDI15
BDI16
BDI17
BDI18
BDI19
BDI20
BDI21
).
Execute.

*Let's assign variable labels so that we dont' have to go back to the paper questionnaire to know what each item was saying

VARIABLE LABELS BDI1 "BDI1. Sadness".
VARIABLE LABELS BDI2 "BDI2. Pessimism".
VARIABLE LABELS BDI3 "BDI3. Past Failure".
VARIABLE LABELS BDI4 "BDI4. Loss of Pleasure".
VARIABLE LABELS BDI5 "BDI5. Guilty Feelings".
VARIABLE LABELS BDI6 "BDI6. Punishment Feelings".
VARIABLE LABELS BDI7 "BDI7. Self-dislike".
VARIABLE LABELS BDI8 "BDI8. Self-criticalness".
VARIABLE LABELS BDI10 "BDI10. Crying".
VARIABLE LABELS BDI11 "BDI11. Agitation".
VARIABLE LABELS BDI12 "BDI12. Loss of Interest".
VARIABLE LABELS BDI13 "BDI13. Indecisiveness".
VARIABLE LABELS BDI14 "BDI14. Worthlessness".
VARIABLE LABELS BDI15 "BDI15. Loss of Energy".
VARIABLE LABELS BDI16 "BDI16. Changes in Sleeping Pattern".
VARIABLE LABELS BDI17 "BDI17. Irritability".
VARIABLE LABELS BDI18 "BDI18. Changes in Appetite".
VARIABLE LABELS BDI19 "BDI19. Concentration Difficulty".
VARIABLE LABELS BDI20 "BDI20. Tiredness or Fatigue".
VARIABLE LABELS BDI21 "BDI21. Loss of Interest in Sex".

*Recoding the variables so that the bottom value is 0

RECODE 
BDI1
BDI2
BDI3
BDI4
BDI5
BDI6
BDI7
BDI8
BDI10
BDI11
BDI12
BDI13
BDI14
BDI15
BDI17
BDI19
BDI20
BDI21
(4=3) (3=2) (2=1) (1=0) INTO
BDI1_r
BDI2_r
BDI3_r
BDI4_r
BDI5_r
BDI6_r
BDI7_r
BDI8_r
BDI10_r
BDI11_r
BDI12_r
BDI13_r
BDI14_r
BDI15_r
BDI17_r
BDI19_r
BDI20_r
BDI21_r.
EXECUTE.

Recode
BDI16
BDI18
(1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) INTO
BDI16_r
BDI18_r.
Execute.

RECODE BDI16_r
(0=0) 
(1=1) 
(2=1) 
(3=2) 
(4=2) 
(5=3) 
(6=3) 
INTO 
BDI16_r_fixed.
Execute.


RECODE BDI18_r 
(0=0) 
(1=1) 
(2=1) 
(3=2) 
(4=2) 
(5=3) 
(6=3) 
INTO 
BDI18_r_fixed.
Execute.

*Now everything is ready to be scored; we have to be careful to list the correct variables since there are three versions of 16 and 18

Compute BDIsum3pp=
BDI1_r+
BDI2_r+
BDI3_r+
BDI4_r+
BDI5_r+
BDI6_r+
BDI7_r+
BDI8_r+
BDI10_r+
BDI11_r+
BDI12_r+
BDI13_r+
BDI14_r+
BDI15_r+
BDI17_r+
BDI19_r+
BDI20_r+
BDI21_r+
BDI16_r_fixed+
BDI18_r_fixed.
Execute.
variable labels BDIsum3pp "BDIsum3pp".

*Symptom Checklist 90: SCL90

Rename variables 
(
SCL90_1
SCL90_2
SCL90_3
SCL90_4
SCL90_5
SCL90_6
SCL90_7
SCL90_8
SCL90_9
SCL90_10
SCL90_11
SCL90_12
SCL90_13
SCL90_14
SCL90_15
SCL90_16
SCL90_17
SCL90_18
SCL90_19
SCL90_20
SCL90_21
SCL90_22
SCL90_23
SCL90_24
SCL90_25
SCL90_26
SCL90_27
SCL90_28
SCL90_29
SCL90_30
SCL90_31
SCL90_32
SCL90_33
SCL90_34
SCL90_35
SCL90_36
SCL90_37
SCL90_38
SCL90_39
SCL90_40
SCL90_41
SCL90_42
SCL90_43
SCL90_44
SCL90_45
SCL90_46
SCL90_47
SCL90_48
SCL90_49
SCL90_50
SCL90_51
SCL90_52
SCL90_53
SCL90_54
SCL90_55
SCL90_56
SCL90_57
SCL90_58
SCL90_59
SCL90_60
SCL90_61
SCL90_62
SCL90_63
SCL90_64
SCL90_65
SCL90_66
SCL90_67
SCL90_68
SCL90_69
SCL90_70
SCL90_71
SCL90_72
SCL90_73
SCL90_74
SCL90_75
SCL90_76
SCL90_77
SCL90_78
SCL90_79
SCL90_80
SCL90_81
SCL90_82
SCL90_83
SCL90_84
SCL90_85
SCL90_86
=
SCL1
SCL2
SCL3
SCL4
SCL5
SCL6
SCL7
SCL8
SCL9
SCL10
SCL11
SCL12
SCL13
SCL14
SCL15
SCL16
SCL17
SCL18
SCL19
SCL20
SCL21
SCL22
SCL23
SCL24
SCL25
SCL26
SCL27
SCL28
SCL29
SCL30
SCL31
SCL32
SCL33
SCL34
SCL35
SCL36
SCL37
SCL38
SCL39
SCL40
SCL41
SCL42
SCL43
SCL44
SCL45
SCL46
SCL47
SCL48
SCL49
SCL50
SCL51
SCL52
SCL53
SCL54
SCL55
SCL56
SCL57
SCL58
SCL59
SCL60
SCL61
SCL62
SCL63
SCL64
SCL65
SCL66
SCL67
SCL68
SCL69
SCL70
SCL71
SCL72
SCL73
SCL74
SCL75
SCL76
SCL77
SCL78
SCL79
SCL80
SCL81
SCL82
SCL83
SCL84
SCL85
SCL86
).
EXECUTE. 

COMPUTE sclSOM=MEAN(scl1,scl4,scl12,scl27,scl40,scl42,
    scl48,scl49,scl52,scl53,scl56,scl58).
EXECUTE.

COMPUTE sclOC=MEAN(scl3,scl9,scl10,scl28,scl38,scl45,
    scl46,scl51,scl55,scl56).
EXECUTE.

COMPUTE sclINT=MEAN(scl6,scl21,scl34,scl36,scl37,scl41,
    scl61,scl69,scl73).
EXECUTE.

COMPUTE sclDEP=SUM(scl5,scl14,scl15,scl20,scl22,scl26,
    scl29,scl30,scl31,scl32,scl54,scl71,scl79).
EXECUTE.

COMPUTE sclANX=MEAN(scl2,scl17,scl17,scl23,scl33,scl39,
    scl57,scl72,scl78,scl80,scl86).
EXECUTE.

COMPUTE sclHOS=MEAN(scl11,scl24,scl63,scl67,scl74,scl81).
EXECUTE.

COMPUTE sclPHOB=MEAN(scl13,scl25,scl47,scl50,scl70,scl75,
    scl82).
EXECUTE.

COMPUTE sclPAR=MEAN(scl8,scl18,scl43,scl68,scl76,scl83).
EXECUTE.

COMPUTE sclPSY=MEAN(scl7,scl16,scl35,scl62,scl77,scl84,
    scl85).
EXECUTE.

COMPUTE sclADDIT=MEAN(scl9,scl60,scl44,scl64,scl66,scl59).
EXECUTE.

COMPUTE sclGSI=MEAN(
sclSOM,
sclOC,
sclINT,
sclDEP,
sclANX,
sclHOS,
sclPHOB,
sclPAR,
sclPSY,
sclADDIT
).
VARIABLE LABELS  sclGSI 'sclGSI. general severity index'.
EXECUTE.

COUNT sclPSDI=scl1 scl2 scl3 scl4 scl5 scl6 
    scl7 scl8 scl9 scl10 scl11 scl12 scl13 
    scl14 scl15 scl16 scl17 scl18 scl19 scl20 
    scl21 scl22 scl23 scl24 scl25 scl26 scl27 
    scl28 scl29 scl30 scl31 scl32 scl33 scl34 
    scl35 scl36 scl37 scl38 scl39 scl40 scl41 
    scl42 scl43 scl44 scl45 scl46 scl47 scl48 
    scl49 scl50 scl51 scl52 scl53 scl54 scl55 
    scl56 scl57 scl58 scl59 scl60 scl61 scl62 
    scl63 scl64 scl65 scl66 scl67 scl68 scl69 
    scl70 scl71 scl72 scl73 scl74 scl75 scl76 
    scl77 scl78 scl79 scl80 scl81 scl82 scl83 
    scl84 scl85 scl86 (1 
    thru Highest).
VARIABLE LABELS  sclPSDI 'sclPSDI. number of positive items'.
EXECUTE.

COMPUTE sclPST=sclGSI / sclPSDI.
VARIABLE LABELS  sclPST 'sclPST. positive symptoms total'.
EXECUTE.

*Perceived Stress Scale

RECODE
PSS_4
PSS_5
PSS_6
PSS_7
PSS_9
PSS_10
PSS_13
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
PSS_4r
PSS_5r
PSS_6r
PSS_7r
PSS_9r
PSS_10r
PSS_13r.

EXECUTE .

COMPUTE PSS.3pp = mean (PSS_1, PSS_2, PSS_3, PSS_4r, PSS_5r, PSS_6r, PSS_7r, PSS_8, PSS_9r, PSS_10r, PSS_11, PSS_12, PSS_13r, PSS_14).
EXECUTE.


*Ages and Stages Questionnaire for 4th Trimester Survey (Creates Different Scores for 2 Month and 4 Month Qs)

RENAME VARIABLES 
(
Q106_1
Q106_2
Q106_3
Q106_4
Q106_5
Q106_6
Q106_7
Q106_8
Q106_9
Q106_10
Q106_11
Q106_12
Q106_13
Q106_14
Q106_15
Q106_16
Q106_17
Q106_18
Q106_19
Q106_20
Q106_21
Q106_22
Q106_23
Q106_24
Q106_25
Q106_26
Q106_27
Q106_28
Q106_29
Q106_30
Q106_31
Q106_32
Q106_33
Q106_34
Q106_35
Q106_36
Q106_37
Q106_38
Q106_39
Q106_40
Q106_41
Q106_42
Q106_43
Q106_44
Q106_45
Q106_46
Q106_47
Q106_48
=
ASQ2c_1
ASQ2c_2
ASQ2c_3
ASQ2c_4
ASQ2c_5.4c_1
ASQ2c_6.4c_2
ASQ4c_3
ASQ4c_4
ASQ4c_5
ASQ5c_6
ASQ2gm_1
ASQ2gm_2
ASQ2gm_3
ASQ2gm_4
ASQ2gm_5.4gm_1
ASQ2gm_6.4gm_2
ASQ4gm_3
ASQ4gm_4
ASQ4gm_5
ASQ4gm_6
ASQ2fm_1
ASQ2fm_2
ASQ2fm_3
ASQ4fm_2
ASQ2fm_4
ASQ2fm_5.4fm_1
ASQ2fm_6.4fm_3
ASQ4fm_4
ASQ4fm_5
ASQ4fm_6
ASQ2ps_1
ASQ2ps_2
ASQ2ps_3.4ps_1
ASQ2ps_4.4ps_2
ASQ2ps_5.4ps_3
ASQ2ps_6.4ps_6
ASQ4ps_4
ASQ4ps_5
ASQ2soc_1
ASQ2soc_2
ASQ2soc_3
ASQ2soc_4
ASQ2soc_5.4soc_1
ASQ2soc_6.4soc_3
ASQ4soc_2
ASQ4soc_4
ASQ4soc_5
ASQ4soc_6
).
EXECUTE.

RECODE 
ASQ2c_1
ASQ2c_2
ASQ2c_3
ASQ2c_4
ASQ2c_5.4c_1
ASQ2c_6.4c_2
ASQ4c_3
ASQ4c_4
ASQ4c_5
ASQ5c_6
ASQ2gm_1
ASQ2gm_2
ASQ2gm_3
ASQ2gm_4
ASQ2gm_5.4gm_1
ASQ2gm_6.4gm_2
ASQ4gm_3
ASQ4gm_4
ASQ4gm_5
ASQ4gm_6
ASQ2fm_1
ASQ2fm_2
ASQ2fm_3
ASQ4fm_2
ASQ2fm_4
ASQ2fm_5.4fm_1
ASQ2fm_6.4fm_3
ASQ4fm_4
ASQ4fm_5
ASQ4fm_6
ASQ2ps_1
ASQ2ps_2
ASQ2ps_3.4ps_1
ASQ2ps_4.4ps_2
ASQ2ps_5.4ps_3
ASQ2ps_6.4ps_6
ASQ4ps_4
ASQ4ps_5
ASQ2soc_1
ASQ2soc_2
ASQ2soc_3
ASQ2soc_4
ASQ2soc_5.4soc_1
ASQ2soc_6.4soc_3
ASQ4soc_2
ASQ4soc_4
ASQ4soc_5
ASQ4soc_6
(1=10) (2=5) (3=0) INTO
ASQ2c_1
ASQ2c_2
ASQ2c_3
ASQ2c_4
ASQ2c_5.4c_1
ASQ2c_6.4c_2
ASQ4c_3
ASQ4c_4
ASQ4c_5
ASQ5c_6
ASQ2gm_1
ASQ2gm_2
ASQ2gm_3
ASQ2gm_4
ASQ2gm_5.4gm_1
ASQ2gm_6.4gm_2
ASQ4gm_3
ASQ4gm_4
ASQ4gm_5
ASQ4gm_6
ASQ2fm_1
ASQ2fm_2
ASQ2fm_3
ASQ4fm_2
ASQ2fm_4
ASQ2fm_5.4fm_1
ASQ2fm_6.4fm_3
ASQ4fm_4
ASQ4fm_5
ASQ4fm_6
ASQ2ps_1
ASQ2ps_2
ASQ2ps_3.4ps_1
ASQ2ps_4.4ps_2
ASQ2ps_5.4ps_3
ASQ2ps_6.4ps_6
ASQ4ps_4
ASQ4ps_5
ASQ2soc_1
ASQ2soc_2
ASQ2soc_3
ASQ2soc_4
ASQ2soc_5.4soc_1
ASQ2soc_6.4soc_3
ASQ4soc_2
ASQ4soc_4
ASQ4soc_5
ASQ4soc_6.
EXECUTE .

COMPUTE ASQ_2c = mean (ASQ2c_1,
ASQ2c_2,
ASQ2c_3,
ASQ2c_4,
ASQ2c_5.4c_1,
ASQ2c_6.4c_2).
EXECUTE. 
COMPUTE ASQ_2gm = mean (ASQ2gm_1,
ASQ2gm_2,
ASQ2gm_3,
ASQ2gm_4,
ASQ2gm_5.4gm_1,
ASQ2gm_6.4gm_2).
COMPUTE ASQ_2fm = mean (ASQ2fm_1,
ASQ2fm_2,
ASQ2fm_3,
ASQ2fm_4,
ASQ2fm_5.4fm_1,
ASQ2fm_6.4fm_3).
COMPUTE ASQ_2ps = mean (ASQ2ps_1,
ASQ2ps_2,
ASQ2ps_3.4ps_1,
ASQ2ps_4.4ps_2,
ASQ2ps_5.4ps_3,
ASQ2ps_6.4ps_6). 
COMPUTE ASQ_2soc = mean (ASQ2soc_1,
ASQ2soc_2,
ASQ2soc_3,
ASQ2soc_4,
ASQ2soc_5.4soc_1,
ASQ2soc_6.4soc_3). 
COMPUTE ASQ_4c = mean (ASQ2c_5.4c_1,
ASQ2c_6.4c_2,
ASQ4c_3,
ASQ4c_4,
ASQ4c_5,
ASQ5c_6).
COMPUTE ASQ_4gm = mean (ASQ2gm_5.4gm_1,
ASQ2gm_6.4gm_2,
ASQ4gm_3,
ASQ4gm_4,
ASQ4gm_5,
ASQ4gm_6).
COMPUTE ASQ_4fm = mean (ASQ2fm_5.4fm_1,
ASQ4fm_2,
ASQ2fm_6.4fm_3,
ASQ4fm_4,
ASQ4fm_5,
ASQ4fm_6).
COMPUTE ASQ_4ps = mean (ASQ2ps_3.4ps_1,
ASQ2ps_4.4ps_2,
ASQ2ps_5.4ps_3,
ASQ2ps_6.4ps_6,
ASQ4ps_4,
ASQ4ps_5). 
COMPUTE ASQ_4soc = mean (ASQ2soc_5.4soc_1,
ASQ2soc_6.4soc_3,
ASQ4soc_2,
ASQ4soc_4,
ASQ4soc_5,
ASQ4soc_6). 
EXECUTE . 

*Renaming other ASQ questions so they have more descriptive names

Rename Variables
(Q107
Q108
Q109
Q110
Q111
Q112
Q114
Q115
Q116
Q117
=
newborn.hearing.test.3pp
move.hands.and.legs.3pp
fam.history.problems.3pp
baby.medical.problems.3pp
concerns.about.baby.3pp
anything.worry.you.3pp
feet.flat.3pp
baby.too.quiet.3pp
vision.concerns.3pp
recent.medical.problems.3pp). 
EXECUTE. 

*Infant Behavior Questionnaire Very Short Version (Rothbart)

RENAME VARIABLES 
(
Q87_1
Q87_2
Q87_3
Q87_4
Q87_5
Q87_6
Q87_7
Q87_8
Q87_9
Q87_10
Q87_11
Q87_12
Q87_13
Q87_14
Q87_15
Q87_16
Q87_17
Q87_18
Q87_19
Q87_20
Q87_21
Q87_22
Q87_23
Q87_24
Q87_25
Q87_26
Q87_27
Q87_28
Q87_29
Q87_30
Q87_31
Q87_32
Q87_33
Q87_34
Q87_35
Q87_36
Q87_37
=
ibqrvsh1
ibqrvsh2
ibqrvsh3
ibqrvsh4
ibqrvsh5
ibqrvsh6
ibqrvsh7
ibqrvsh8
ibqrvsh9
ibqrvsh10
ibqrvsh11
ibqrvsh12
ibqrvsh13
ibqrvsh14
ibqrvsh15
ibqrvsh16
ibqrvsh17
ibqrvsh18
ibqrvsh19
ibqrvsh20
ibqrvsh21
ibqrvsh22
ibqrvsh23
ibqrvsh24
ibqrvsh25
ibqrvsh26
ibqrvsh27
ibqrvsh28
ibqrvsh29
ibqrvsh30
ibqrvsh31
ibqrvsh32
ibqrvsh33
ibqrvsh34
ibqrvsh35
ibqrvsh36
ibqrvsh37
).
EXECUTE.

COMPUTE ibqrvsh11r = (8-ibqrvsh11). 

COMPUTE sur = mean (ibqrvsh1, ibqrvsh2, ibqrvsh7, ibqrvsh8, ibqrvsh13, ibqrvsh14, ibqrvsh15, ibqrvsh20, ibqrvsh21, ibqrvsh26, ibqrvsh27, ibqrvsh36, ibqrvsh37).
COMPUTE neg = mean (ibqrvsh3, ibqrvsh4, ibqrvsh9, ibqrvsh10, ibqrvsh16, ibqrvsh17, ibqrvsh22, ibqrvsh23, ibqrvsh28, ibqrvsh29, ibqrvsh32, ibqrvsh33).
COMPUTE eff = mean (ibqrvsh5, ibqrvsh6, ibqrvsh11r, ibqrvsh12, ibqrvsh18, ibqrvsh19, ibqrvsh24, ibqrvsh25, ibqrvsh30, ibqrvsh31, ibqrvsh34, ibqrvsh35). 

EXECUTE .

*Baby Care Questionnaire (Winstanley)

RENAME VARIABLES
(
Q94_1
Q94_2
Q94_3
Q94_4
Q94_5
Q94_6
Q94_7
Q94_8
Q94_9
Q94_10
Q94_11
Q94_12
Q94_13
Q94_14
Q94_15
Q94_16
Q94_17
Q94_18
Q94_19
Q94_20
Q94_21
Q94_22
Q94_23
Q94_24
Q94_25
Q94_26
Q94_27
Q94_28
Q94_29
Q94_30
=
BCQ_S1
BCQ_S2
BCQ_S3
BCQ_S4
BCQ_S5
BCQ_S6
BCQ_S7
BCQ_S8
BCQ_S9
BCQ_E1
BCQ_E2
BCQ_E3
BCQ_E6
BCQ_E7
BCQ_E10
BCQ_E4
BCQ_E5
BCQ_E8
BCQ_E9
BCQ_So1
BCQ_So2
BCQ_So4
BCQ_So9
BCQ_So10
BCQ_So3
BCQ_So5
BCQ_So6
BCQ_So7
BCQ_So8
BCQ_So11
).

COMPUTE BCQ_S1r = (5-BCQ_S1).
COMPUTE BCQ_S2r = (5-BCQ_S2).
COMPUTE BCQ_S3r = (5-BCQ_S3).
COMPUTE BCQ_S9r = (5-BCQ_S9).
COMPUTE BCQ_E5r = (5-BCQ_E5).
COMPUTE BCQ_E9r = (5-BCQ_E9).
COMPUTE BCQ_E3r = (5-BCQ_E3).
COMPUTE BCQ_E6r = (5-BCQ_E6).
COMPUTE BCQ_E10r = (5-BCQ_E10).
COMPUTE BCQ_So3r = (5-BCQ_So3).
COMPUTE BCQ_So7r = (5-BCQ_So7).
COMPUTE BCQ_So2r = (5-BCQ_So2).
COMPUTE BCQ_So4r = (5-BCQ_So4).
COMPUTE BCQ_So5r = (5-BCQ_So5).
COMPUTE BCQ_So10r = (5-BCQ_So10).
  
COMPUTE BCQstructure = mean (BCQ_S4, BCQ_S5, BCQ_S6, BCQ_S1r, BCQ_S2r, BCQ_S3r, BCQ_E1, BCQ_E2, BCQ_E7, BCQ_E3r, BCQ_E6r, BCQ_E10r, BCQ_So1, BCQ_So9, BCQ_So2r, BCQ_So4r, BCQ_So10r).
COMPUTE BCQattunement = mean (BCQ_S7, BCQ_S8, BCQ_S9r, BCQ_E4, BCQ_E8, BCQ_E5r, BCQ_E9r, BCQ_So6, BCQ_So8, BCQ_So11, BCQ_So3r, BCQ_So5r, BCQ_So7r).

EXECUTE. 

*Parenting Stress Scale

RECODE 
PingSS_1
PingSS_2
PingSS_5
PingSS_6
PingSS_7
PingSS_8
PingSS_17
PingSS_18
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
PingSS_1r
PingSS_2r
PingSS_5r
PingSS_6r
PingSS_7r
PingSS_8r
PingSS_17r
PingSS_18r.

EXECUTE .

COMPUTE PingSS = mean (PingSS_1r, PingSS_2r, PingSS_3, PingSS_4, PingSS_5r, PingSS_6r, PingSS_7r, PingSS_8r, PingSS_9, PingSS_10, PingSS_11, PingSS_12, PingSS_13, PingSS_14, PingSS_15, PingSS_16, PingSS_17r, PingSS_18r).
EXECUTE .  

*Parent Infant Attachment Scale

RECODE
PIAS_1
PIAS_3
PIAS_6
PIAS_8
PIAS_10
PIAS_11
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
PIAS_1r
PIAS_3r
PIAS_6r
PIAS_8r
PIAS_10r
PIAS_11r.

EXECUTE . 

COMPUTE PIAS = mean (PIAS_1r, PIAS_2, PIAS_3r, PIAS_4, PIAS_5, PIAS_6r, PIAS_7, PIAS_8r, PIAS_9, PIAS_10r, PIAS_11r, PIAS_12, PIAS_13, PIAS_14).
EXECUTE .

*Postpartum Bonding Questionnaire
*rename variables for 3 month '4th trimester' q

RENAME VARIABLES 
(
Q119_1
Q119_2
Q119_3
Q119_4
Q119_5
Q119_6
Q119_7
Q119_8
Q119_9
Q119_10
Q119_11
Q119_12
Q119_13
Q119_14
Q119_15
Q119_16
Q119_17
Q119_18
Q119_19
Q119_20
Q119_21
Q119_22
Q119_23
Q119_24
Q119_25
=
PBQ1
PBQ2
PBQ3
PBQ4
PBQ5
PBQ6
PBQ7
PBQ8
PBQ9
PBQ10
PBQ11
PBQ12
PBQ13
PBQ14
PBQ15
PBQ16
PBQ17
PBQ18
PBQ19
PBQ20
PBQ21
PBQ22
PBQ23
PBQ24
PBQ25
).
EXECUTE .


RECODE
PBQ1
PBQ4
PBQ8
PBQ9
PBQ11
PBQ16
PBQ22
PBQ25
(1=0) (2=1) (3=2) (4=3) (5=4) (6=5) INTO
PBQ1
PBQ4
PBQ8
PBQ9
PBQ11
PBQ16
PBQ22
PBQ25.

EXECUTE . 

RECODE
PBQ2
PBQ3
PBQ5
PBQ6
PBQ7
PBQ10
PBQ12
PBQ13
PBQ14
PBQ15
PBQ17
PBQ18
PBQ19
PBQ20
PBQ21
PBQ23
PBQ24
(0=6) (1=5) (2=4) (3=3) (4=2) (5=1) (6=0) INTO
PBQ2
PBQ3
PBQ5
PBQ6
PBQ7
PBQ10
PBQ12
PBQ13
PBQ14
PBQ15
PBQ17
PBQ18
PBQ19
PBQ20
PBQ21
PBQ23
PBQ24.

EXECUTE . 

COMPUTE PBQ.3pp = mean (PBQ1, PBQ2, PBQ3, PBQ4, PBQ8, PBQ9, PBQ11, PBQ16, PBQ22, PBQ25, PBQ5, PBQ6, PBQ7, PBQ10, PBQ12, PBQ13, PBQ14, PBQ15, PBQ17, PBQ18, PBQ19, PBQ20, PBQ21, PBQ23, PBQ24).
EXECUTE . 


*Perceived Stress Scale

RECODE
PSS_4
PSS_5
PSS_6
PSS_7
PSS_9
PSS_10
PSS_13
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
PSS_4r
PSS_5r
PSS_6r
PSS_7r
PSS_9r
PSS_10r
PSS_13r.

EXECUTE .

COMPUTE PSS = mean (PSS_1, PSS_2, PSS_3, PSS_4r, PSS_5r, PSS_6r, PSS_7r, PSS_8, PSS_9r, PSS_10r, PSS_11, PSS_12, PSS_13r, PSS_14).
EXECUTE.

*Parental Stress Inventory (PSI)
*first, manually recode 21.0 (the 2nd time it appears at the end of the variable list) as 211, 32.0 as 34, and 33.0 as 35. This variable was mislabeled. 

RECODE
PSI_1
PSI_2
PSI_3
PSI_4
PSI_5
PSI_6
PSI_7
PSI_8
PSI_9
PSI_10
PSI_11
PSI_12
PSI_13
PSI_14
PSI_15
PSI_16
PSI_17
PSI_18
PSI_19
PSI_20
PSI_21
PSI_22
PSI_23
PSI_24
PSI_25
PSI_26
PSI_27
PSI_28
PSI_29
PSI_30
PSI_31
PSI_34
PSI_35
PSI_211
PSI_32
PSI_33
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
PSI_1
PSI_2
PSI_3
PSI_4
PSI_5
PSI_6
PSI_7
PSI_8
PSI_9
PSI_10
PSI_11
PSI_12
PSI_13
PSI_14
PSI_15
PSI_16
PSI_17
PSI_18
PSI_19
PSI_20
PSI_21
PSI_22
PSI_23
PSI_24
PSI_25
PSI_26
PSI_27
PSI_28
PSI_29
PSI_30
PSI_31
PSI_34
PSI_35
PSI_211
PSI_32
PSI_33.

EXECUTE. 

COMPUTE PSI_PD.3pp = mean (PSI_1, PSI_2, PSI_3, PSI_4, PSI_5, PSI_6, PSI_7, PSI_8, PSI_9, PSI_10, PSI_11, PSI_12) *12.
EXECUTE. 
COMPUTE PSI_DI.3pp = mean (PSI_13, PSI_14, PSI_15, PSI_16, PSI_17, PSI_18, PSI_19, PSI_20, PSI_21, PSI_22, PSI_23, PSI_211) * 12.
EXECUTE. 
COMPUTE PSI_DC.3pp = mean (PSI_24, PSI_25, PSI_26, PSI_27, PSI_28, PSI_29, PSI_30, PSI_31, PSI_32, PSI_33, PSI_34, PSI_35) * 12.
EXECUTE. 
COMPUTE PSI_tot.3pp = mean (PSI_PD.3pp, PSI_DI.3pp, PSI_DC.3pp) *4.
EXECUTE. 
*note that this syntax calculates a mean. For a PSI score that maps onto scores in the literature, which use summing, multiply by 12 for the subscales and 36 for the full scale.  

VARIABLE LABELS PSI_PD.3pp 'PSI - Parental Distress'.
EXECUTE.

VARIABLE LABELS PSI_DI.3pp 'PSI - Parent?Child Dysfunctional Interaction'.
EXECUTE.

VARIABLE LABELS PSI_DC.3pp 'PSI - Difficult Child'.
EXECUTE.

VARIABLE LABELS PSI_tot.3pp 'PSI - Total Parental Stress'.
EXECUTE.

*Edinburgh Postnatal Depression Scale (EPDS).
*NOTE: Question 2 was phrased incorrectly until Couple 10 (July 11, 2015). Change scoring if q was completed before that date. 

RECODE
PDS_1
PDS_2
PDS_4
(1=0) (2=1) (3=2) (4=3)  INTO
PDS_1
PDS_2
PDS_4.

EXECUTE . 

RECODE
PDS_3
PDS_5
PDS_6
PDS_7
PDS_8
PDS_9
(1=3) (2=2) (3=1) (4=0) INTO
PDS_3
PDS_5
PDS_6
PDS_7
PDS_8
PDS_9.

EXECUTE .

*Important note: PDS_2 was incorrectly phrased until Couple 10. Fix for those couples.  

*DO IF CoupID < 10 
RECODE PDS_2
(3=0) (2=1) (1=2) (0=3) INTO
PDS_2.
*END IF.
*EXECUTE . 

COMPUTE
EPDS.3pp = mean (PDS_1, PDS_2, PDS_3, PDS_4, PDS_5, PDS_6, PDS_7, PDS_8, PDS_9). 
EXECUTE . 

*Relabeling time with baby questions so they have more descriptive names

Rename Variables
(Q148
Q151
Q152
Q153
Q154
=
weekdayhrs.with.baby.3pp
weekday.alone.with.baby.3pp
weekendhrs.with.baby.3pp
weekend.alone.with.baby.3pp
share.compared.to.partner.3pp).
EXECUTE. 

**Maternal Attachment Inventory (MAI)
*Reverse coding is to bring these in line with prior published work. Higher scores represent more secure/positive attachment.

RENAME VARIABLES
(
Q102_1
Q102_2
Q102_3
Q102_4
Q102_5
Q102_6
Q102_7
Q102_8
Q102_9
Q102_10
Q102_11
Q102_12
Q102_13
Q102_14
Q102_15
Q102_16
Q102_17
Q102_18
Q102_19
Q102_20
Q102_21
Q102_22
Q102_23
Q102_24
Q102_25
Q102_26
=
MAI_1
MAI_2
MAI_3
MAI_4
MAI_5
MAI_6
MAI_7
MAI_8
MAI_9
MAI_10
MAI_11
MAI_12
MAI_13
MAI_14
MAI_15
MAI_16
MAI_17
MAI_18
MAI_19
MAI_20
MAI_21
MAI_22
MAI_23
MAI_24
MAI_25
MAI_26
).
EXECUTE.

RECODE MAI_1
MAI_2
MAI_3
MAI_4
MAI_5
MAI_6
MAI_7
MAI_8
MAI_9
MAI_10
MAI_11
MAI_12
MAI_13
MAI_14
MAI_15
MAI_16
MAI_17
MAI_18
MAI_19
MAI_20
MAI_21
MAI_22
MAI_23
MAI_24
MAI_25
MAI_26
(1=4) (2=3) (3=2) (4=1) INTO
MAI_1_REV
MAI_2_REV
MAI_3_REV
MAI_4_REV
MAI_5_REV
MAI_6_REV
MAI_7_REV
MAI_8_REV
MAI_9_REV
MAI_10_REV
MAI_11_REV
MAI_12_REV
MAI_13_REV
MAI_14_REV
MAI_15_REV
MAI_16_REV
MAI_17_REV
MAI_18_REV
MAI_19_REV
MAI_20_REV
MAI_21_REV
MAI_22_REV
MAI_23_REV
MAI_24_REV
MAI_25_REV
MAI_26_REV.
EXECUTE.

COMPUTE MAI_Tot.3pp = 
MAI_1_REV + 
MAI_2_REV + 
MAI_3_REV + 
MAI_4_REV + 
MAI_5_REV + 
MAI_6_REV + 
MAI_7_REV + 
MAI_8_REV + 
MAI_9_REV + 
MAI_10_REV + 
MAI_11_REV + 
MAI_12_REV + 
MAI_13_REV + 
MAI_14_REV + 
MAI_15_REV + 
MAI_16_REV + 
MAI_17_REV + 
MAI_18_REV + 
MAI_19_REV + 
MAI_20_REV + 
MAI_21_REV + 
MAI_22_REV + 
MAI_23_REV + 
MAI_24_REV + 
MAI_25_REV + 
MAI_26_REV.
EXECUTE.

VARIABLE LABELS MAI_Tot.3pp 'MAI - Total Maternal Attachment'.
EXECUTE.

*Giving COVID Q's more descriptive labels
    
Rename Variables
    (Q182_1
Q182_6
Q182_3
Q182_4
Q182_13
Q182_7
Q182_9
Q182_10
Q182_15
Q182_16
Q182_14
Q182_14_TEXT
= 
COVID.precaution.1
COVID.precaution.2
COVID.precaution.3
COVID.precaution.4
COVID.precaution.5
COVID.precaution.6
COVID.precaution.7
COVID.precaution.8
COVID.precaution.9
COVID.precaution.10
COVID.precaution.11
COVID.precaution.12).
EXECUTE.

Rename Variables
    (Q183_1
Q183_11
Q183_5
Q183_35
Q183_22
Q183_12
Q183_31
Q183_18
Q183_30
Q183_29
Q183_32
= 
COVID.impact.1
COVID.impact.2
COVID.impact.3
COVID.impact.4
COVID.impact.5
COVID.impact.6
COVID.impact.7
COVID.impact.8
COVID.impact.9
COVID.impact.10
COVID.impact.11
).
EXECUTE.

Rename Variables
    (Q184_1
Q184_2
Q184_3
= 
COVID.childcare.1
COVID.childcare.2
COVID.childcare.3
).
EXECUTE.

Rename Variables
    (Q185_1
Q185_2
Q185_3
Q185_4
Q185_5
= 
COVID.social.1
COVID.social.2
COVID.social.3
COVID.social.4
COVID.social.5
).
EXECUTE.

Rename variables
    (Q188 = 
    COVID.parenting).
EXECUTE. 

Rename variables
    (Q189_1
Q189_2
Q189_5
Q189_6 = 
    COVID.work.1
    COVID.work.2
    COVID.work.3
    COVID.work.4
    ).
EXECUTE. 

*lets compute reliability

Reliability
 /Variables= BDI1_r
BDI2_r
BDI3_r
BDI4_r
BDI5_r
BDI6_r
BDI7_r
BDI8_r
BDI10_r
BDI11_r
BDI12_r
BDI13_r
BDI14_r
BDI15_r
BDI17_r
BDI19_r
BDI20_r
BDI21_r
BDI16_r_fixed
BDI18_r_fixed
 /Scale('BDIsum') ALL
 /Model=Alpha.


*Perinatal Interview
*these instructions recode scores in .5 or whole numbers. Because RAs are entering Likkert scale data from 
*the sheets. there may also be numbers like "2.70"--check these and change to .5 numbers so they recode

RECODE
Q5
Q8
Q9
Q10
(1=7) (1.5=6.5) (1.75=6.25) (2=6) (2.25 = 5.75) (2.5=5.5) (2.75=5.25) (3=5) (3.25=4.75) (3.5=4.5) (4=4) (4.5=3.5) (4.75=3.25) (5=3) (5.25=2.75) (5.5=2.5) (5.75=2.25) (6=2) (6.25=1.75) (6.5=1.5) (7=1) INTO
Q5r
Q8r
Q9r
Q10r.

EXECUTE. 

COMPUTE
peristress.imp = mean (Q1meanimp, Q2, Q3, Q4, Q5rmeanimp, Q6, Q7). 
EXECUTE. 

COMPUTE
perisupport = mean (Q8, Q9).
EXECUTE.

COMPUTE
peritot.imp.2 = mean (Q1meanimp2, Q3.2.00, Q5rmeanimp.2.00, Q7.2.00, Q9r.2.00, Q2.2.00, Q4.2.00, Q6.2.00, Q8rmeanimp.2, Q10rmeanimp.2.00).
EXECUTE. 

COMPUTE
peristress.imp = mean (Q1meanimp2, Q2.2.00, Q3.2.00, Q4.2.00, Q5rmeanimp.2.00, Q6.2.00, Q7.2.00). 
EXECUTE. 

COMPUTE
perisupport.imp = mean (Q8rmeanimp.2, Q9.2.00).
EXECUTE.

COMPUTE
peritot.imp.odd.2 = mean (Q1meanimp2, Q3.2.00, Q5rmeanimp.2.00, Q7.2.00, Q9r.2.00).
EXECUTE. 

COMPUTE
peritot.imp.even.2 = mean (Q2.2.00, Q4.2.00, Q6.2.00, Q8rmeanimp.2, Q10rmeanimp.2.00).
EXECUTE. 

COMPUTE
peritot.imp.evenwo10.2 = mean (Q2.2.00, Q4.2.00, Q6.2.00, Q8rmeanimp.2).
EXECUTE. 

COMPUTE
peritot.imp.wo10.2 = mean (Q1meanimp2, Q3.2.00, Q5rmeanimp.2.00, Q7.2.00, Q9r.2.00, Q2.2.00, Q4.2.00, Q6.2.00, Q8rmeanimp.2).
EXECUTE. 


COMPUTE
perifear = mean (Q6, Q7).
EXECUTE. 

COMPUTE
periplan = Q5.
EXECUTE.

COMPUTE
peripainandov.2 = mean (Q3.2.00, Q10rmeanimp.2.00). 
EXECUTE. 

COMPUTE
peripainandov.1 = mean (Q3.1.00, Q10r.1.00). 
EXECUTE. 

COMPUTE
peristresswofear.1 = mean (Q1.1.00, Q2.1.00, Q3.1.00, Q4.1.00, Q5r.1.00). 
EXECUTE. 

COMPUTE
peristresswofear2 = mean (Q1meanimp2, Q2.2.00, Q3.2.00, Q4.2.00, Q5rmeanimp.2.00). 
EXECUTE. 

*Experiences in Close Relationships - Revised (ECR-R)
*Note that this excludes one participant who is missing a single item. If you want to include him/her, change the COMPUTE syntax to use "MEAN" rather than simply calculating the mean.
*The two subscales of the ECR-R are Attachment-Related Anxiety and Attachment-Related Avoidance.

RECODE ECR_R_9 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_9_Rev. 
EXECUTE.

RECODE ECR_R_11 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_11_Rev.
EXECUTE.

RECODE ECR_R_20 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_20_Rev.
EXECUTE.

RECODE ECR_R_22 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_22_Rev.
EXECUTE.

RECODE ECR_R_26 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_26_Rev.
EXECUTE.

RECODE ECR_R_27 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_27_Rev.
EXECUTE.

RECODE ECR_R_28 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_28_Rev.
EXECUTE.

RECODE ECR_R_29 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_29_Rev.
EXECUTE.

RECODE ECR_R_30 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_30_Rev.
EXECUTE.

RECODE ECR_R_31 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_31_Rev.
EXECUTE.

RECODE ECR_R_33 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_33_Rev.
EXECUTE.

RECODE ECR_R_34 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_34_Rev.
EXECUTE.

RECODE ECR_R_35 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_35_Rev.
EXECUTE.

RECODE ECR_R_36 (7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO ECR_R_36_Rev.
EXECUTE. 

COMPUTE ECR_Anx = (ECR_R_1 + ECR_R_2 + ECR_R_3 + ECR_R_4 + ECR_R_5 + ECR_R_6 + ECR_R_7 + ECR_R_8 + ECR_R_9_Rev + ECR_R_10 + ECR_R_11_Rev + 
ECR_R_12 + ECR_R_13 + ECR_R_14 + ECR_R_15 + ECR_R_16 + ECR_R_17 + ECR_R_18) / 18.
EXECUTE.

VARIABLE LABELS ECR_Anx 'ECR-R - Attachment-Related Anxiety'. 
EXECUTE.

COMPUTE ECR_Avd = (ECR_R_19 + ECR_R_20_Rev + ECR_R_21 + ECR_R_22_Rev + ECR_R_23 + ECR_R_24 + ECR_R_25 + ECR_R_26_Rev + ECR_R_27_Rev + ECR_R_28_Rev + 
ECR_R_29_Rev + ECR_R_30_Rev + ECR_R_31_Rev + ECR_R_32 + ECR_R_33_Rev + ECR_R_34_Rev + ECR_R_35_Rev + ECR_R_36_Rev) / 18.
EXECUTE. 

VARIABLE LABELS ECR_Avd 'ECR-R - Attachment-Related Avoidance'. 
EXECUTE.



**Who Does What

Compute WDW_1 = mean (Q1_1, Q2_1, Q3_1, Q4_1, Q5_1, Q6_1, Q7_1, Q8_1, Q9_1).
EXECUTE.

Compute WDW_1plus10 = mean (Q1_1, Q2_1, Q3_1, Q4_1, Q5_1, Q6_1, Q7_1, Q8_1, Q9_1, Q10_1).
EXECUTE.

Compute WDW_3 = mean (Q1_3, Q2_3, Q3_3, Q4_3, Q5_3, Q6_3, Q7_3, Q8_3, Q9_3).
EXECUTE.

Compute WDW_3plus10 = mean (Q1_3, Q2_3, Q3_3, Q4_3, Q5_3, Q6_3, Q7_3, Q8_3, Q9_3, Q10_3).
EXECUTE.

Compute WDW_discrp = WDW_1 - WDW_3. 
EXECUTE.


**Restructuring to Couple Level
After scoring all data, you may want to restructure to create a couple level file. To do so, delete all "A"s, "B"s, and other text from the SubjectID field
*and convert from a string to a numeric variable. As you delete, double check that gender labels match your "A"s and "B"s. Check notes at top of file for mislabeled gender. 

SORT CASES BY CoupID Gender.
CASESTOVARS
  /ID=CoupID
  /INDEX=Gender
  /GROUPBY=VARIABLE.

*Bonus syntax for analyses
*running the correlation to see if risky family and marital satisfaction are related

CORRELATIONS
  /VARIABLES=MaritalSat Riskiness
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

*running a regression to using riskiness as a predictor of marital satisfaction


REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT MaritalSat
  /METHOD=ENTER Riskiness.




