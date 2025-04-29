* Encoding: UTF-8.
*Syntax follows for the Life Events Checklist (LEC), Marital Adjustment Test (MAT), Risky Families Measure, Pregnancy Symptoms Scale, 
*Pregnancy Specific Anxiety Measure (PSAM), Pregnancy Anxiety Scale (PAS), What Is A Father (WIAF), Dyadic Adjustment Scale (DAS), 
*Pittsburgh Sleep Quality Index (PSQI), Interpersonal Reactivity Index (IRI), Adult Attachment Scale (AAS), Beck Depression Inventory (BDI),
*State Anxiety Inventory (STAI), Symptom Checklist (SCL-90), Perceived Stress Scale, Experiences in Close Relationships (ECR-R), 
*Life Attitude Profile (LAP-R), Brief COPE, Antenatal Emotional Attachment (AEA) Scale, Big Five Inventory (BFI)

**Using this syntax: Go slow and score measure by measure; read comments; there are a few quirks and things that have to be done manually

*Note that Qualtrics has gender coded as 1=male, 2=female. This is the opposite of how we have our hormones coded (A=1=female; B=2=male). 
*Therefore we should switch the genders so when we restructure this file to merge with the hormone data, the genders match up correctly. 
*    note that for couple 21 and 41, both members indicated they are female, so double check by looking at participant ID (A=female, B=male).
*    for couple 49, the genders are reversed and A=male, B=female. When in doubt, check height! 
* for couple 57, there are two entries for the father--delete the one that is mostly blank data
* for couple 64, both participants indicate their gender as male so use the A and B notation to distinguish them
* the mother in couple 37 was given the postpartum questionnaire by mistake so is missing from the prenatal files
* Couple 66 filled out part of the prenatal visit at their postpartum visit; ignore data with the IDs 66A_3 and 66B_3 since that is postpartum data
*73A data is missing?? 
* Typo for Couple 86-- 86A gave their ID as 68
*71B completed his prenatal questionnaires in 2 installments. Make sure to merge the two survey responses. 2nd response picks up at the BFI. #editbySAS5.21.2020

*There are several versions of the prenatal questionnaire on Qualtrics, since we added questions over time. If you want
*to combine multiple downloads into one dataset file, you can open up the datasets and go to SPSS>Merge Files>Add Cases. 
*However, note that scoring may be different with different versions of the q's so check syntax for notes. 

RECODE 
Gender
 (1=2) (2=1) INTO
Gender.
EXECUTE.

*Then carefully check that your gender labels are correct (ID numbers that include "A" should have gender =1, and ID numbers with "B" should have gender = 2, except for the quirks described above). 

*Calculating Body Mass Index (BMI)
*Divide weight in pounds by height in inches squared and multiply by a conversion factor of 703 (BMI = weight (lb) / [height (in)]2 x 703).

COMPUTE Heightinches = ((Height_1 * 12) + Height_2).
EXECUTE.
COMPUTE Heightsquared = (Heightinches * Heightinches).
EXECUTE.
COMPUTE BMI = (Weight_1/Heightsquared)*703.
EXECUTE.

*Compute number of days before due date & number of days pregnant
*First, change the variable "Type" for Duedate_1_TEXT from a string variable to a date (mm/dd/yyyy) variable. 
*Check to make sure it looks OK and that the couples' dates match. 

alter type StartDate(adate8).
alter type Duedate_1(adate8).
EXECUTE. 

*In couple 49, mom came back a week later so change her date to 12/02/16 to match the dad. 

COMPUTE daysbfdue = (Duedate_1 - StartDate)/(24*60*60).
EXECUTE.
COMPUTE dayspreg = 280 - daysbfdue.
EXECUTE.

**Life Event Checklist (LEC)
*note that our latest version only goes up to 15; old syntax is greyed out, use newer syntax for downloadswith the 1.26.2018 q and later
*first, change LEC missing data to zero. 

*RECODE LEC_1_1 LEC_1_2 LEC_1_3 LEC_2_1 LEC_2_2 LEC_2_3 LEC_3_1 LEC_3_2 LEC_3_3 LEC_4_1 LEC_4_2 
    LEC_4_3 LEC_5_1 LEC_5_2 LEC_5_3 LEC_6_1 LEC_6_2 LEC_6_3 LEC_7_1 LEC_7_2 LEC_7_3 LEC_8_1 LEC_8_2 
    LEC_8_3 LEC_9_1 LEC_9_2 LEC_9_3 LEC_10_1 LEC_10_2 LEC_10_3 LEC_12_1 LEC_12_2 LEC_12_3 LEC_13_1 
    LEC_13_2 LEC_13_3 LEC_15_1 LEC_15_2 LEC_15_3 LEC_16_1 LEC_16_2 LEC_16_3 LEC_17_1 LEC_17_2 LEC_17_3 
    (SYSMIS=0).
*EXECUTE.

RECODE LEC_1_1 LEC_1_2 LEC_1_3 LEC_2_1 LEC_2_2 LEC_2_3 LEC_3_1 LEC_3_2 LEC_3_3 LEC_4_1 LEC_4_2 
    LEC_4_3 LEC_5_1 LEC_5_2 LEC_5_3 LEC_6_1 LEC_6_2 LEC_6_3 LEC_7_1 LEC_7_2 LEC_7_3 LEC_8_1 LEC_8_2 
    LEC_8_3 LEC_9_1 LEC_9_2 LEC_9_3 LEC_10_1 LEC_10_2 LEC_10_3 LEC_11_1 LEC_11_2 LEC_11_3 LEC_12_1 LEC_12_2 LEC_12_3 LEC_13_1 
    LEC_13_2 LEC_13_3 LEC_14_1 LEC_14_2 LEC_14_3 LEC_15_1 LEC_15_2 LEC_15_3  
    (SYSMIS=0).
EXECUTE.

*Then, compute the means for stressful life events that happened to the participant, and life events that happened or were witnessed. 

*Compute LEChap = mean (LEC_1_1, LEC_2_1, LEC_3_1, LEC_4_1, LEC_5_1, LEC_6_1, LEC_7_1, LEC_8_1, LEC_9_1, LEC_10_1, LEC_12_1, LEC_13_1, LEC_15_1, LEC_16_1, LEC_17_1).
*Compute LEChapwitns = mean ((LEC_1_1+LEC_1_2), (LEC_2_1+LEC_2_2), (LEC_3_1+LEC_3_2), (LEC_4_1+LEC_4_2), (LEC_5_1+LEC_5_2), (LEC_6_1+LEC_6_2), (LEC_7_1+LEC_7_2),
* (LEC_8_1+LEC_8_2), (LEC_9_1+LEC_9_2), (LEC_10_1+LEC_10_2), (LEC_12_1+LEC_12_2), (LEC_13_1+LEC_13_2), (LEC_15_1+LEC_15_2), (LEC_16_1+LEC_16_2), (LEC_17_1+LEC_17_2)).

*EXECUTE.

Compute LEChap = mean (LEC_1_1, LEC_2_1, LEC_3_1, LEC_4_1, LEC_5_1, LEC_6_1, LEC_7_1, LEC_8_1, LEC_9_1, LEC_10_1, LEC_11_1, LEC_12_1, LEC_13_1, LEC_14_1, LEC_15_1).

EXECUTE. 

Compute LEChapwitns = mean ((LEC_1_1+LEC_1_2), (LEC_2_1+LEC_2_2), (LEC_3_1+LEC_3_2), 
(LEC_4_1+LEC_4_2), (LEC_5_1+LEC_5_2), 
(LEC_6_1+LEC_6_2), (LEC_7_1+LEC_7_2), (LEC_8_1+LEC_8_2), (LEC_9_1+LEC_9_2), 
(LEC_10_1+LEC_10_2), (LEC_11_1+LEC_11_2), (LEC_12_1+LEC_12_2), 
(LEC_13_1+LEC_13_2), (LEC_14_1+LEC_14_2), (LEC_15_1+LEC_15_2)). 

EXECUTE.

**Marital Adjustment Test (MAT; Locke & Wallace)
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

*Cleaning and scoring Risky Families
*Reverse code certain items so that higher scores = more risky family

RECODE 
RF_1
RF_3
RF_6
 (5=1) (4=2) (3=3) (2=4) (1=5) INTO
RF_1_r
RF_3_r
RF_6_r.
EXECUTE.

*Scoring risky families - Higher scores will mean a riskier family

Compute RiskFam=
RF_1_r +
RF_2 +
RF_3_r +
RF_4 +
RF_5 +
RF_6_r +
RF_7 +
RF_8 +
RF_9 +
RF_10 +
RF_11.
Execute.

*Pregnancy Symptoms/Couvade Syndrome Measure (Brennan). This generates subscales for the number of pregnancy symptoms,
*their severity, distressingness, and frequency, and a total sum score of all the subscales. 

Compute PregSympCount= MEAN (PregSymp_1_1, 
PregSymp_1_2,
PregSymp_1_3,
PregSymp_1_4,
PregSymp_1_5,
PregSymp_1_6,
PregSymp_1_7,
PregSymp_1_8,
PregSymp_1_9,
PregSymp_1_10,
PregSymp_1_11,
PregSymp_1_12,
PregSymp_1_13,
PregSymp_1_14,
PregSymp_1_15,
PregSymp_1_16,
PregSymp_1_17,
PregSymp_1_18,
PregSymp_1_19,
PregSymp_1_20,
PregSymp_1_21,
PregSymp_1_22,
PregSymp_1_23,
PregSymp_1_24,
PregSymp_1_25,
PregSymp_1_26,
PregSymp_1_27,
PregSymp_1_28,
PregSymp_1_29,
PregSymp_1_30,
PregSymp_1_31,
PregSymp_1_32,
PregSymp_1_33,
PregSymp_1_34,
PregSymp_1_35,
PregSymp_1_36,
PregSymp_1_37,
PregSymp_1_38,
PregSymp_1_39,
PregSymp_1_40,
PregSymp_1_41,
PregSymp_1_42,
PregSymp_1_43,
PregSymp_1_44
).
EXECUTE.

COMPUTE PregSympSevere = MEAN (PregSymp_2_1, 
PregSymp_2_2,
PregSymp_2_3,
PregSymp_2_4,
PregSymp_2_5,
PregSymp_2_6,
PregSymp_2_7,
PregSymp_2_8,
PregSymp_2_9,
PregSymp_2_10,
PregSymp_2_11,
PregSymp_2_12,
PregSymp_2_13,
PregSymp_2_14,
PregSymp_2_15,
PregSymp_2_16,
PregSymp_2_17,
PregSymp_2_18,
PregSymp_2_19,
PregSymp_2_20,
PregSymp_2_21,
PregSymp_2_22,
PregSymp_2_23,
PregSymp_2_24,
PregSymp_2_25,
PregSymp_2_26,
PregSymp_2_27,
PregSymp_2_28,
PregSymp_2_29,
PregSymp_2_30,
PregSymp_2_31,
PregSymp_2_32,
PregSymp_2_33,
PregSymp_2_34,
PregSymp_2_35,
PregSymp_2_36,
PregSymp_2_37,
PregSymp_2_38,
PregSymp_2_39,
PregSymp_2_40,
PregSymp_2_41,
PregSymp_2_42,
PregSymp_2_43,
PregSymp_2_44
).
EXECUTE.

COMPUTE PregSympDistress = MEAN (PregSymp_3_1, 
PregSymp_3_1, 
PregSymp_3_2,
PregSymp_3_3,
PregSymp_3_4,
PregSymp_3_5,
PregSymp_3_6,
PregSymp_3_7,
PregSymp_3_8,
PregSymp_3_9,
PregSymp_3_10,
PregSymp_3_11,
PregSymp_3_12,
PregSymp_3_13,
PregSymp_3_14,
PregSymp_3_15,
PregSymp_3_16,
PregSymp_3_17,
PregSymp_3_18,
PregSymp_3_19,
PregSymp_3_20,
PregSymp_3_21,
PregSymp_3_22,
PregSymp_3_23,
PregSymp_3_24,
PregSymp_3_25,
PregSymp_3_26,
PregSymp_3_27,
PregSymp_3_28,
PregSymp_3_29,
PregSymp_3_30,
PregSymp_3_31,
PregSymp_3_32,
PregSymp_3_33,
PregSymp_3_34,
PregSymp_3_35,
PregSymp_3_36,
PregSymp_3_37,
PregSymp_3_38,
PregSymp_3_39,
PregSymp_3_40,
PregSymp_3_41,
PregSymp_3_42,
PregSymp_3_43,
PregSymp_3_44
).
EXECUTE. 

*we revised this measure to eliminate the FREQ scale
Compute PregSympFreq= MEAN (PregSymp_4_1, 
PregSymp_4_2,
PregSymp_4_3,
PregSymp_4_4,
PregSymp_4_5,
PregSymp_4_6,
PregSymp_4_7,
PregSymp_4_8,
PregSymp_4_9,
PregSymp_4_10,
PregSymp_4_11,
PregSymp_4_12,
PregSymp_4_13,
PregSymp_4_14,
PregSymp_4_15,
PregSymp_4_16,
PregSymp_4_17,
PregSymp_4_18,
PregSymp_4_19,
PregSymp_4_20,
PregSymp_4_21,
PregSymp_4_22,
PregSymp_4_23,
PregSymp_4_24,
PregSymp_4_25,
PregSymp_4_26,
PregSymp_4_27,
PregSymp_4_28,
PregSymp_4_29,
PregSymp_4_30,
PregSymp_4_31,
PregSymp_4_32,
PregSymp_4_33,
PregSymp_4_34,
PregSymp_4_35,
PregSymp_4_36,
PregSymp_4_37,
PregSymp_4_38,
PregSymp_4_39,
PregSymp_4_40,
PregSymp_4_41,
PregSymp_4_42,
PregSymp_4_43,
PregSymp_4_44
).
*EXECUTE. 
*COMPUTE PregSympTot = MEAN (PregSympCount, PregSympSevere, PregSympDistress, PregSympFreq).
*EXECUTE.

COMPUTE PregSympTot = MEAN (PregSympCount, PregSympSevere, PregSympDistress).
EXECUTE.

**Pregnancy Specific Anxiety Measure (PSAM, Dunkel-Schetter et. al)
*note: for the most recent version of the survey (1.26.2018 and beyond), you can skip the renaming step, so that syntax is greyed out

*RENAME VARIABLES 
(
PSAM_4
PSAM_5
PSAM_6
PSAM_7
PSAM_8
PSAM_9
PSAM_10
PSAM_11
PSAM_12
PSAM_13
PSAM_14
PSAM_15
PSAM_16
=
PSAM1
PSAM2
PSAM3
PSAM4
PSAM5
PSAM6
PSAM7
PSAM8
PSAM9
PSAM10
PSAM11
PSAM12
PSAM13).
*EXECUTE.

COMPUTE PSAMtot = mean (PSAM_1, PSAM_5, PSAM_9, PSAM_11).
EXECUTE.

**Pregnancy Anxiety Scale (PAS; Dunkel-Schetter et al.)

RENAME VARIABLES
(
Q72_1
Q72_2
Q72_3
Q72_4
Q72_5
Q72_6
Q73_1
Q73_2
Q73_3
Q73_4
Q73_5
Q73_6
Q73_7
=
PAS1
PAS2
PAS3
PAS4
PAS5
PAS6
PAS7
PAS8
PAS9
PAS10
PAS11
PAS12
PAS13
).
EXECUTE. 

Recode
PAS1
PAS2
PAS3
(1=5) (2=4) (4=2) (5=1) INTO
PAS1r
PAS2r
PAS3r.
Execute.

*We'll score the PAS two ways - one is the newer version without the 'gaining weight,' 'paying bills,' and 'feeling informed' items that have not
*been used in more recent studies, per Christine Guardino. Then we'll score it with all items and can compare. 

COMPUTE PAStot.new = MEAN (PAS1r, PAS3r, PAS4, PAS5, PAS6, PAS7, PAS8, PAS11, PAS12, PAS13).
EXECUTE.
COMPUTE PAStot.old = MEAN (PAS1r, PAS2r, PAS3r, PAS4, PAS5, PAS6, PAS7, PAS8, PAS9, PAS10, PAS11, PAS12, PAS13).
EXECUTE. 

**WIAF What is A Father (WIAF; Schoppe, 2001)
*We'll compute the average of 4 "non traditional attitudes" items. Double check before using to make sure these are the right items

COMPUTE WIAFnontrad = MEAN (WIAF_1, WIAF_5, WIAF_7, WIAF_11).
EXECUTE.

**Dyadic Adjustment Scale (DAS; Spanier)
*This syntax generates four subscales (consensus, affective expression, satisfaction, and cohesion) and a total sum score

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

**Medical Outcomes Study (MOS) Social Support Survey (Sherborne & Stewart, 1993)
*This syntax generates four subscales (emotional support, tangible support, affective support, and positive social interaction) and a total score. 
*Numbering has changed since the 1.26.2018 version of the survey; old syntax is greyed out

*COMPUTE MOSemotsupp = MEAN(MOS_2, MOS_3, MOS_4, MOS_5, MOS_6, MOS_7, MOS_8, MOS_9).
*COMPUTE MOStangsupp = MEAN(MOS_11, MOS_12, MOS_13, MOS_14). 
*COMPUTE MOSaffsupp = MEAN(MOS_16, MOS_17, MOS_18).
*COMPUTE MOSpossoc = MEAN(MOS_20, MOS_21, MOS_22, MOS_23). 
*COMPUTE MOSsocsupptot = MEAN(MOSemotsupp, MOStangsupp, MOSaffsupp, MOSpossoc). 
*EXECUTE. 

*SCORING FIXED 4.17.2021. NEED TO RESCORE! 

COMPUTE MOSemotsupp = MEAN(MOS_1, MOS_2, MOS_3, MOS_4, MOS_5, MOS_6, MOS_7, MOS_8).
COMPUTE MOStangsupp = MEAN(MOS_9, MOS_10, MOS_11, MOS_12). 
COMPUTE MOSaffsupp = MEAN(MOS_13, MOS_14, MOS_15).
COMPUTE MOSpossoc = MEAN(MOS_16, MOS_17, MOS_18). 
COMPUTE MOSsocsupptot = MEAN(MOS_1, MOS_2, MOS_3, MOS_4, MOS_5, MOS_6, MOS_7, MOS_8, MOS_9, MOS_10, MOS_11, MOS_12, MOS_13, MOS_14, MOS_15, MOS_16, MOS_17, MOS_18, MOS_19). 
EXECUTE. 

**Pittsburgh Sleep Quality Index (PSQI; Buysee et al., 1989) 
*The PSQI is comprised of seven components (sleep quality, latency, duration, efficiency, disturbances, use of sleep medication, and daytime dysfuction)
*This syntax does not include a sleep efficiency score so we are scoring based on the total of six rather than seven components. 
*We can calculate sleep efficiency but it will require some manual data editing because the sleep and wake times are currently entered as string variables.
*A number of studies have used the PSQI minus the "efficiency" component but be mindful that our means/ranges may differ from studies that use the full PSQI. 

Rename Variables
(Q84
Q86
Q88
Q90
Q92_1
Q92_2
Q92_3
Q92_4
Q92_5
Q92_6
Q92_7
Q92_8
Q92_9
Q92_10
Q94
Q96_1
Q96_2
Q98
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

*IMPORTANT! PSQI_2 & PSQI_4 are string variables that you will have to manually edit to be numerical
*(e.g., edit "15 minutes" to be "15" and "7 hours 30 minutes" to be 7.5)

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
EXECUTE. 

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

**Interpersonal Reactivity Index (IRI; Davis, 1980)
**Interpersonal Reactivity Index (IRI; Davis, 1980)

**variable labels a bit off. For subjects 1-18, responses are on a scale of 1-5 (1, 2, 3, 4, 5). For subjects 19-100, responses are missing the "2" and are answered as 1, 3, 4, 5, 6. let's correct and bring them into synchrony with the published measure (0-4)

*for subjects 1-17 use the following code:

RECODE IRI_1
IRI_2
IRI_3
IRI_4
IRI_5
IRI_6
IRI_7
IRI_8
IRI_9
IRI_10
IRI_11
IRI_12
IRI_13
IRI_14
IRI_15
IRI_16
IRI_17
IRI_18
IRI_19
IRI_20
IRI_21
IRI_22
IRI_23
IRI_24
IRI_25
IRI_26
IRI_27
IRI_28
(1=0) (2=1) (3=2) (4=3) (5=4) INTO
IRI_1
IRI_2
IRI_3
IRI_4
IRI_5
IRI_6
IRI_7
IRI_8
IRI_9
IRI_10
IRI_11
IRI_12
IRI_13
IRI_14
IRI_15
IRI_16
IRI_17
IRI_18
IRI_19
IRI_20
IRI_21
IRI_22
IRI_23
IRI_24
IRI_25
IRI_26
IRI_27
IRI_28.
EXECUTE. 

*now reverse code the negative items

RECODE IRI_7
IRI_12
IRI_4
IRI_14
IRI_18
IRI_3
IRI_15
IRI_19
(4=0) (3=1) (2=2) (1=3) (0=4) INTO
IRI_7r
IRI_12r
IRI_4r
IRI_14r
IRI_18r
IRI_3r
IRI_15r
IRI_19r.
EXECUTE.

COMPUTE IRI_FS = MEAN(IRI_1, IRI_5, IRI_7r, IRI_12r, IRI_16, IRI_23, IRI_26).
COMPUTE IRI_EC = MEAN(IRI_2, IRI_4r, IRI_9, IRI_14r, IRI_18r, IRI_20, IRI_22).
COMPUTE IRI_PT = MEAN(IRI_3r, IRI_8, IRI_11, IRI_15r, IRI_21, IRI_25, IRI_28).
COMPUTE IRI_PD = MEAN (IRI_6, IRI_10, IRI_17, IRI_19r, IRI_24, IRI_27). 
EXECUTE.

*for subjects 18-100+ use the following code:

RECODE IRI_1
IRI_2
IRI_3
IRI_4
IRI_5
IRI_6
IRI_7
IRI_8
IRI_9
IRI_10
IRI_11
IRI_12
IRI_13
IRI_14
IRI_15
IRI_16
IRI_17
IRI_18
IRI_19
IRI_20
IRI_21
IRI_22
IRI_23
IRI_24
IRI_25
IRI_26
IRI_27
IRI_28
(1=0) (3=1) (4=2) (5=3) (6=4) INTO
IRI_1
IRI_2
IRI_3
IRI_4
IRI_5
IRI_6
IRI_7
IRI_8
IRI_9
IRI_10
IRI_11
IRI_12
IRI_13
IRI_14
IRI_15
IRI_16
IRI_17
IRI_18
IRI_19
IRI_20
IRI_21
IRI_22
IRI_23
IRI_24
IRI_25
IRI_26
IRI_27
IRI_28.
EXECUTE. 

*now reverse code the negative items

RECODE IRI_7
IRI_12
IRI_4
IRI_14
IRI_18
IRI_3
IRI_15
IRI_19
(4=0) (3=1) (2=2) (1=3) (0=4) INTO
IRI_7r
IRI_12r
IRI_4r
IRI_14r
IRI_18r
IRI_3r
IRI_15r
IRI_19r.
EXECUTE.

COMPUTE IRI_FS = MEAN(IRI_1, IRI_5, IRI_7r, IRI_12r, IRI_16, IRI_23, IRI_26).
COMPUTE IRI_EC = MEAN(IRI_2, IRI_4r, IRI_9, IRI_14r, IRI_18r, IRI_20, IRI_22).
COMPUTE IRI_PT = MEAN(IRI_3r, IRI_8, IRI_11, IRI_15r, IRI_21, IRI_25, IRI_28).
COMPUTE IRI_PD = MEAN (IRI_6, IRI_10, IRI_17, IRI_19r, IRI_24, IRI_27).
EXECUTE.

**Adult Attachment Scale-Revised (Collins, 1996)
*Creates three subscales: Close, Depend, Anxiety
*Note that items & scoring differ from original (Collins & Read, 1990) AAS

RECODE AAS_8
AAS_13
AAS_17
AAS_2
AAS_7
AAS_16
AAS_18
(5=1) (4=2) (3=3) (2=4) (1=5) INTO
AAS_8r
AAS_13r
AAS_17r
AAS_2r
AAS_7r
AAS_16r
AAS_18r.
EXECUTE.

RECODE AAS_1
AAS_5
AAS_6
AAS_12
AAS_14
(5=1) (4=2) (3=3) (2=4) (1=5) INTO
AAS_1r
AAS_5r
AAS_6r
AAS_12r
AAS_14r.
EXECUTE.

COMPUTE AAS_CLOSE = MEAN(AAS_1, AAS_6, AAS_8r, AAS_12, AAS_13r, AAS_17r).
COMPUTE AAS_DEPEND = MEAN(AAS_2r, AAS_5, AAS_7r, AAS_14, AAS_16r, AAS_18r).
COMPUTE AAS_ANX = MEAN(AAS_3, AAS_4, AAS_9, AAS_10, AAS_11, AAS_15).
COMPUTE AAS_AVOID = MEAN(AAS_1r, AAS_2, AAS_5r, AAS_6r, AAS_7, AAS_8, AAS_12r, AAS_13, AAS_14r, AAS_16, AAS_17, AAS_18).
EXECUTE.

**Beck Depression Inventory (Beck, 1996)
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

Compute BDIsum=
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
variable labels BDIsum "BDIsum".

**State-Trait Anxiety Inventory (STAI) State (Speilberger et al., 1993)

*Recoding variables

RECODE
STAI_State_1
STAI_State_2
STAI_State_5
STAI_State_8
STAI_State_10
STAI_State_11
STAI_State_15
STAI_State_16
STAI_State_19
STAI_State_20
(4=1) (3=2) (2=3) (1=4) INTO
STAI_State_1_r
STAI_State_2_r
STAI_State_5_r
STAI_State_8_r
STAI_State_10_r
STAI_State_11_r
STAI_State_15_r
STAI_State_16_r
STAI_State_19_r
STAI_State_20_r.

Execute.

*creat sum scores for state and trait

COMPUTE AnxietyState=
STAI_State_1_r +
STAI_State_2_r +
STAI_State_5_r +
STAI_State_8_r +
STAI_State_10_r +
STAI_State_11_r +
STAI_State_15_r +
STAI_State_16_r +
STAI_State_19_r +
STAI_State_20_r +
STAI_State_3+
STAI_State_4+
STAI_State_6+
STAI_State_7+
STAI_State_9+
STAI_State_12+
STAI_State_13+
STAI_State_14+
STAI_State_17+
STAI_State_18.
Execute.

**Symptom Checklist (SCL-90; Derogatis & Savitz, 2000)
*note that SCL-DEP subscale has been calculated as a SUM rather than a MEAN score in the past. Syntax is rewritten to MEAN to match the other 
*subscales, but if you are scoring variables to merge into existing data, you can edit this to be a SUM score. 

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

COMPUTE sclDEP=MEAN(scl5,scl14,scl15,scl20,scl22,scl26,
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

**Perceived Stress Scale (PSS; Cohen, 1994)

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

**Experiences in Close Relationships - Revised (ECR-R)
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

**Life Attitude Profile - Revised (LAP-R)
*We have included items from the Personal Meaning Index (PMI).
*The PMI is comprised of the Purpose and Coherence subscales.

RECODE LAP_R_1
LAP_R_2
LAP_R_3
LAP_R_4
LAP_R_5
LAP_R_6
LAP_R_7
LAP_R_8
LAP_R_9
LAP_R_10
LAP_R_11
LAP_R_12
LAP_R_13
LAP_R_14
LAP_R_15
LAP_R_16
(7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) INTO
LAP_R_1_REV
LAP_R_2_REV
LAP_R_3_REV
LAP_R_4_REV
LAP_R_5_REV
LAP_R_6_REV
LAP_R_7_REV
LAP_R_8_REV
LAP_R_9_REV
LAP_R_10_REV
LAP_R_11_REV
LAP_R_12_REV
LAP_R_13_REV
LAP_R_14_REV
LAP_R_15_REV
LAP_R_16_REV.
EXECUTE.

COMPUTE LAPR_PMI = 
LAP_R_1_REV + 
LAP_R_2_REV + 
LAP_R_3_REV + 
LAP_R_4_REV + 
LAP_R_5_REV + 
LAP_R_6_REV + 
LAP_R_7_REV + 
LAP_R_8_REV + 
LAP_R_9_REV + 
LAP_R_10_REV + 
LAP_R_11_REV + 
LAP_R_12_REV + 
LAP_R_13_REV + 
LAP_R_14_REV + 
LAP_R_15_REV + 
LAP_R_16_REV.
EXECUTE.

VARIABLE LABELS LAPR_PMI 'LAP-R - Personal Meaning Index'. 
EXECUTE.

COMPUTE LAPR_Purp = 
LAP_R_1_REV + 
LAP_R_2_REV + 
LAP_R_3_REV + 
LAP_R_7_REV + 
LAP_R_8_REV +  
LAP_R_11_REV + 
LAP_R_13_REV + 
LAP_R_16_REV.
EXECUTE.

VARIABLE LABELS LAPR_Purp 'LAP-R - Purpose'. 
EXECUTE.

COMPUTE LAPR_Coher = 
LAP_R_4_REV + 
LAP_R_5_REV + 
LAP_R_6_REV + 
LAP_R_9_REV + 
LAP_R_10_REV + 
LAP_R_12_REV + 
LAP_R_14_REV + 
LAP_R_15_REV.
EXECUTE.

VARIABLE LABELS LAPR_Coher 'LAP-R - Coherence'. 
EXECUTE.

*Brief COPE
*Comprised of 14 2-item subscales indicative of different coping strategies.

COMPUTE COPE_Distrac = 
COPE_1 + 
COPE_19.
EXECUTE.

VARIABLE LABELS COPE_Distrac 'COPE - Self-Distraction'.
EXECUTE.

COMPUTE COPE_Act = 
COPE_2 + 
COPE_7.
EXECUTE.

VARIABLE LABELS COPE_Act 'COPE - Active Coping'.
EXECUTE.

COMPUTE COPE_Den = 
COPE_3 + 
COPE_8.
EXECUTE.

VARIABLE LABELS COPE_Den 'COPE - Denial'.
EXECUTE.

COMPUTE COPE_Subs = 
COPE_4 + 
COPE_11.
EXECUTE.

VARIABLE LABELS COPE_Subs 'COPE - Self-Distraction'.
EXECUTE.

COMPUTE COPE_EmotSupp = 
COPE_5 + 
COPE_15.
EXECUTE.

VARIABLE LABELS COPE_EmotSupp 'COPE - Emotional Support'.
EXECUTE.

COMPUTE COPE_InstSupp = 
COPE_10 + 
COPE_23.
EXECUTE.

VARIABLE LABELS COPE_InstSupp 'COPE - Instrumental Support'.
EXECUTE.

COMPUTE COPE_Diseng = 
COPE_6 + 
COPE_16.
EXECUTE.

VARIABLE LABELS COPE_Diseng 'COPE - Behavioral Disengagement'.
EXECUTE.

COMPUTE COPE_Vent = 
COPE_9 + 
COPE_21.
EXECUTE.

VARIABLE LABELS COPE_Vent 'COPE - Venting'.
EXECUTE.

COMPUTE COPE_Reframe = 
COPE_12 + 
COPE_17.
EXECUTE.

VARIABLE LABELS COPE_Reframe 'COPE - Positive Reframing'.
EXECUTE.

COMPUTE COPE_Plan = 
COPE_14 + 
COPE_25.
EXECUTE.

VARIABLE LABELS COPE_Plan 'COPE - Planning'.
EXECUTE.

COMPUTE COPE_Humor = 
COPE_18 + 
COPE_28.
EXECUTE.

VARIABLE LABELS COPE_Humor 'COPE - Humor'.
EXECUTE.

COMPUTE COPE_Accept = 
COPE_20 + 
COPE_24.
EXECUTE.

VARIABLE LABELS COPE_Accept 'COPE - Acceptance'.
EXECUTE.

COMPUTE COPE_Relig = 
COPE_22 + 
COPE_27.
EXECUTE.

VARIABLE LABELS COPE_Relig 'COPE - Religion'.
EXECUTE.

COMPUTE COPE_Blame = 
COPE_13 + 
COPE_26.
EXECUTE.

VARIABLE LABELS COPE_Blame 'COPE - Self-Blame'.
EXECUTE.

**Antenatal Emotional Attachment Scale (AEAS; Condon, 1993)
*This syntax generates a maternal and a paternal version of the scale.

*Maternal AEAS

RENAME VARIABLES
(
Q106
Q107
Q108
Q109
Q110
Q111
Q112
Q113
Q114
Q115
Q116
Q117
Q118
Q119
Q120
Q121
Q122
Q123
Q124
=
AEA_1
AEA_2
AEA_3
AEA_4
AEA_5
AEA_6
AEA_7
AEA_8
AEA_9
AEA_10
AEA_11
AEA_12
AEA_13
AEA_14
AEA_15
AEA_16
AEA_17
AEA_18
AEA_19
).
EXECUTE.

RECODE AEA_1
AEA_3
AEA_5
AEA_6
AEA_9
AEA_10
AEA_12
AEA_15
AEA_16
AEA_18
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
AEA_1r
AEA_3r
AEA_5r
AEA_6r
AEA_9r
AEA_10r
AEA_12r
AEA_15r
AEA_16r
AEA_18r.
EXECUTE.

COMPUTE mAEA_Qual = MEAN (AEA_3r, AEA_6r, AEA_9r, AEA_10r, AEA_11, AEA_12r, AEA_13, AEA_15r, AEA_16r, AEA_19).
EXECUTE.

COMPUTE mAEA_Time = MEAN (AEA_1r, AEA_2, AEA_4, AEA_5r, AEA_8, AEA_14, AEA_17, AEA_18r).
EXECUTE.

COMPUTE mAEA_Tot = MEAN (AEA_1r, AEA_2, AEA_4, AEA_5r, AEA_8, AEA_14, AEA_17, AEA_18r, AEA_3r, AEA_6r, AEA_9r, 
AEA_10r, AEA_11, AEA_12r, AEA_13, AEA_15r, AEA_16r, AEA_19, AEA_7).
EXECUTE. 

*Paternal AEAS

RENAME VARIABLES
(
Q90.0
Q91
Q92
Q93
Q94.0
Q95
Q96
Q97
Q98.0
Q99
Q100
Q101
Q102
Q103
Q104
Q105
=
pAEA_1
pAEA_2
pAEA_3
pAEA_4
pAEA_5
pAEA_6
pAEA_7
pAEA_8
pAEA_9
pAEA_10
pAEA_11
pAEA_12
pAEA_13
pAEA_14
pAEA_15
pAEA_16
).
EXECUTE.

RECODE pAEA_1
pAEA_3
pAEA_5
pAEA_7
pAEA_8
pAEA_12
pAEA_15
(1=5) (2=4) (3=3) (4=2) (5=1) INTO
pAEA_1r
pAEA_3r
pAEA_5r
pAEA_7r
pAEA_8r
pAEA_12r
pAEA_15r.
EXECUTE.

COMPUTE pAEA_Qual = MEAN (pAEA_1r, pAEA_2, pAEA_3r, pAEA_7r, pAEA_9, pAEA_11, pAEA_12r, pAEA_16).
EXECUTE.

COMPUTE pAEA_Time = MEAN (pAEA_4, pAEA_5r, pAEA_8r, pAEA_10, pAEA_14, pAEA_15r).
EXECUTE.

COMPUTE pAEA_Tot = MEAN (pAEA_1r, pAEA_2, pAEA_3r, pAEA_7r, pAEA_9, pAEA_11, pAEA_12r, pAEA_16, pAEA_4, pAEA_5r,
pAEA_8r, pAEA_10, pAEA_14, pAEA_15r, pAEA_6, pAEA_13).
EXECUTE. 

*Now combine maternal and paternal into more variable

IF  (Gender = 1) AEA_Qual=mAEA_Qual.
IF  (Gender = 2) AEA_Qual=pAEA_Qual.
IF  (Gender = 1) AEA_Time=mAEA_Time.
IF  (Gender = 2) AEA_Time=pAEA_Time.
IF  (Gender = 1) AEA_Tot=mAEA_Tot.
IF  (Gender = 2) AEA_Tot=pAEA_Tot.
EXECUTE.

VARIABLE LABELS AEA_Tot 'Antenatal Attachment'.
EXECUTE.

**Index of Sexual Satisfaction
*Note: numbering is fixed in version adopted 1.26.2018; old syntax for re-numbering is greyed out

*RENAME VARIABLES 
(
ISS_22
ISS_23
ISS_24
ISS_25
ISS_26
ISS_27
=
ISS_20
ISS_21
ISS_22
ISS_23
ISS_24
ISS_25).
*EXECUTE. 

*Items 1,2,3,9,10,12,16,19,21,22,23 are reverse scored. So first we have to recode these items. 

RECODE
ISS_1
ISS_2
ISS_3
ISS_9
ISS_10
ISS_12
ISS_16
ISS_19
ISS_21
ISS_22
ISS_23
(1=7) (2=6) (3=5) (4=4) (5=3) (6=2) (7=1) INTO 
ISS_1_REV
ISS_2_REV
ISS_3_REV
ISS_9_REV
ISS_10_REV
ISS_12_REV
ISS_16_REV
ISS_19_REV
ISS_21_REV
ISS_22_REV
ISS_23_REV.
EXECUTE.

COMPUTE ISS = Sum (ISS_1_REV,
ISS_2_REV,
ISS_3_REV,
ISS_4, 
ISS_5, 
ISS_6, 
ISS_7,
ISS_8,
ISS_9_REV,
ISS_10_REV,
ISS_11,
ISS_12_REV,
ISS_13,
ISS_14,
ISS_15,
ISS_16_REV,
ISS_17,
ISS_18,
ISS_19_REV,
ISS_20,
ISS_21_REV,
ISS_22_REV,
ISS_23_REV,
ISS_24,
ISS_25).
EXECUTE. 

COMPUTE ISS.2 =
((ISS - 25) * 100)/ (150).
EXECUTE. 

**Big Five Inventory (BFI)

*First, reverse-score the reversed items
 
RECODE
  BFI_2_2 BFI_2_6 BFI_2_8 BFI_2_9 BFI_2_12 BFI_2_18 BFI_2_21 BFI_2_23 BFI_2_24 BFI_2_27 BFI_2_31 BFI_2_34 BFI_2_35
  BFI_2_37 BFI_2_41 BFI_2_43
  (1=5)  (2=4)  (3=3)  (4=2)  (5=1)  INTO  BFI_2_2r BFI_2_6r BFI_2_8r BFI_2_9r BFI_2_12r BFI_2_18r BFI_2_21r BFI_2_23r BFI_2_24r 
  BFI_2_27r BFI_2_31r BFI_2_34r BFI_2_35r BFI_2_37r BFI_2_41r BFI_2_43r.
EXECUTE .

*** SCALE SCORES

COMPUTE BFI_e = mean(BFI_2_1,BFI_2_6r,BFI_2_11,BFI_2_16,BFI_2_21r,BFI_2_26,BFI_2_31r,BFI_2_36) .
VARIABLE LABELS BFI_e 'BFI Extraversion scale score'.
EXECUTE .

COMPUTE BFI_a = mean(BFI_2_2r,BFI_2_7,BFI_2_12r,BFI_2_17,BFI_2_22,BFI_2_27r,BFI_2_32,BFI_2_37r,BFI_2_42) .
VARIABLE LABELS BFI_a 'BFI Agreeableness scale score' .
EXECUTE .

COMPUTE BFI_c = mean(BFI_2_3,BFI_2_8r,BFI_2_13,BFI_2_18r,BFI_2_23r,BFI_2_28,BFI_2_33,BFI_2_38,BFI_2_43r) .
VARIABLE LABELS BFI_c 'BFIConscientiousness scale score' .
EXECUTE .

COMPUTE BFI_n = mean(BFI_2_4,BFI_2_9r,BFI_2_14,BFI_2_19,BFI_2_24r,BFI_2_29,BFI_2_34r,BFI_2_39) .
VARIABLE LABELS BFI_n 'BFI Neuroticism scale score' .
EXECUTE .

COMPUTE BFI_o = mean(BFI_2_5,BFI_2_10,BFI_2_15,BFI_2_20,BFI_2_25,BFI_2_30,BFI_2_35r,BFI_2_40,BFI_2_41r,BFI_2_44) .
VARIABLE LABELS BFI_o 'BFI Openness scale score' .
EXECUTE .



**Restructuring to Couple Level
After scoring all data, you may want to restructure to create a couple level file. To do so, delete all "A"s, "B"s, and other text from the SubjectID field;
*(you can do this quickly with a Find & Replace operation)
*and convert from a string to a numeric variable. As you delete, double check that gender labels match your "A"s and "B"s. 
*Check notes at the top of this file for Couples 41 and 49 and 66. 
*you may want to create a blank variable for 37A (who did the postpartum q by mistake) and 73A (who appears to be missing)
*Before restructuring, save a copy of the file so you have the raw data; then delete all raw data (and any other "noise," like time stamps and recoded variables)
*and keep just the scores. Otherwise you will end up with a very very wide file. 

SORT CASES BY SubjectID Gender.
CASESTOVARS
  /ID=SubjectID
  /INDEX=Gender
  /GROUPBY=VARIABLE.

*after restructuring, go through the file and add "pn" to any measures that are repeated (MAT, DAS, PSS, PSQI, etc.) to make it clear that these are prenatal data


