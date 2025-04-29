* Encoding: UTF-8.
*Syntax follows for the Marital Adjustment Test (MAT), Dyadic Adjustment Scale (DAS), Pittsburgh Sleep Quality Index (PSQI), 
*Adult Attachment Scale (AAS), Beck Depression Inventory (BDI), Edinburgh Postnatal Depression Scale (EPDS), State Anxiety Inventory (STAI), 
*Symptom Checklist (SCL-90), Perceived Stress Scale, Ages & Stages Questionnaire (ASQ); Infant Behavior Questionnaire (IBQ); 
*Baby Care Questionnaire (BCQ); Parenting Your Child-Infant Scale (PARYC-I); Parenting Stress Scale; Parenting Stress Inventory (PSI);
*Postpartum Bonding Questionnaire (PBQ); Maternal Attachment Inventory (MAI); Life Attitudes Profile Revised (LAP-R); Brief COPE

*For postpartum data, check IDs; for two participants, names are entered instead of ID number; correct numbers are 08B (SR) and 12B (HT)

*Mom in couple 24 is pregnant again at pp visit (interpret hormone data with caution or drop her data)
*Mom in couple 37 did the postpartum questionnaire twice -- once at the prenatal visit by mistake, and then at the pp visit. Score both and you can 
*import some of her data into the prenatal file. Her "prenatal" pp was on 12/19/15 and she weighed 195 pounds; her "real" pp was 11/12/16 and she weighed 164 pounds
*Mom in couple 52 completed the original version of the postpartum questionnaire and her partner completed the version dated 05.05.2017, so they will not appear in the same download
*Mom in couple 58 is missing from most current Qualtrics file; she did an older version of the questionnaire whereas her partner did the more updated version, so you can merge her data in
*Dad in couple 61 is mislabeled as 31 at end of file! Check the end of the file when the SubjectID is repeated and make sure his date matches 61A and then fix
*Mom in couple 78 is labeled as 93A-3 at the end of the postpartum dataset-??
*99A was given this questionnaire by mistake at the prenatal visit but didn't complete responses; you can delete
*81 started questionnaire for a 2nd time but didn't include any items
87A is in the file with no data-- mistakenly given wrong q at prenatal visit? 
*mom in 89 put wrong birthdate-- 11/19/19 instead of 9/18/19-- dad's date is correct
*91 did questionnaires online but accidentally indicated ID number as 93. Check master log-- the real 91 has initials HY & NS, and real 93 is ML & CR

*Note that Qualtrics has gender coded as 1=male, 2=female. This is the opposite of how we have our hormones coded (A=1=female; B=2=male). 
*Therefore we should switch the genders so when we restructure this file to merge with the hormone data, the genders match up correctly. 

RECODE 
Gender
 (1=2) (2=1) INTO
Gender.
EXECUTE.

*Calculating Body Mass Index (BMI)
*note: you can only do this if you import the "Height" data from the prenatal visit into your pp file. We don't ask about height at the pp visit. 
*Divide weight in pounds by height in inches squared and multiply by a conversion factor of 703 (BMI = weight (lb) / [height (in)]2 x 703).

COMPUTE Heightinches.2 = ((Height_1.2 * 12) + Height_2.2).
EXECUTE.
COMPUTE Heightsquared.2 = (Heightinches.2 * Heightinches.2).
EXECUTE.

COMPUTE BMI.1.pp = (Weight_1.1pp/Heightsquared.1)*703.
EXECUTE.

COMPUTE BMI.2.pp = (Weight_1.2pp/Heightsquared.2)*703.
EXECUTE.

Weight_1.1pp
Weight_1.2pp

Height_2.1
Height_2.2

*Calculate baby's age at the time of visit:
*manually convert birthdate from a string to a date mm/dd/yyyy variable
*doublecheck that people put the right birth year. There are a couple mistakes where people said "2015" for Dec. 2014 births.
*E.g. dad in couple 13, dad in couple 15, mom in couple 28. The dads in couple 19 and couple 35 give birth years in 1970s. 
 *Mom in couple year put birth year as 1989. Fix. 
*couple 45 have baby's birthdate as 10/1/17 but it is 10/1/16
*manually convert V8 (when they started the q) to a date mm/dd/yyyy variable
*note that some V8 date looks wrong; check V9 and when in doubt, use the date that matches for the couple

alter type StartDate(adate8).

alter type Birthdate_1(adate8).

COMPUTE 
bage6pp = StartDate - Birthdate_1.
EXECUTE. 

*convert from number of seconds to number of days

COMPUTE 
bage6pp = bage6pp/(24*60*60).
EXECUTE. 

*convert from number of days to number of weeks

COMPUTE 
bage6pp = bage6pp/7.
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

Compute MATpp=
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
COMPUTE DAStotpp = SUM(DAS1r, DAS2r, DAS3r, DAS4r, DAS5r, 
				DAS6r, DAS7r, DAS8r, DAS9r, DAS10r, DAS11r, DAS12r, DAS13r, 
				DAS14r, DAS15r, DAS16, DAS17, DAS18r, DAS19r, DAS20, DAS21, 
				DAS22, DAS23r, DAS24r, DAS25, DAS26, DAS27, DAS28, DAS29, DAS30, DAS31, DAS32r) .
VARIABLE LABELS DAStotpp 'DAS full scale'. 
EXECUTE.

*DAS Subscale scoring per original Spanier *.
COMPUTE DAScons.pp = SUM(DAS1r, DAS2r, DAS3r, DAS5r, DAS7r, DAS8r, DAS9r, DAS10r, DAS11r, DAS12r, DAS13r, DAS14r, DAS15r) .
COMPUTE DASaff.pp = SUM(DAS4r, DAS6r, DAS29, DAS30) .
COMPUTE DASsat.pp = SUM(DAS16, DAS17, DAS18r, DAS19r, DAS20, DAS21, DAS22, DAS23r, DAS31, DAS32r) .
COMPUTE DAScoh.pp = SUM(DAS24r, DAS25, DAS26, DAS27, DAS28) .
VARIABLE LABELS DAScons.pp 'DAS consensus subscale' DASaff.pp 'DAS affective expression subscale' DASsat.pp 'DAS satisfaction subscale' DAScoh.pp 'DAS cohesion subscale'. 
EXECUTE .

**Pittsburgh Sleep Quality Index (PSQI; Buysee et al., 1989) 
*The PSQI is comprised of seven components (sleep quality, latency, duration, efficiency, disturbances, use of sleep medication, and daytime dysfuction)
*This syntax does not include a sleep efficiency score so we are scoring based on the total of six rather than seven components. 
*We can calculate sleep efficiency but it will require some manual data editing because the sleep and wake times are currently entered as string variables.
*A number of studies have used the PSQI minus the "efficiency" component but be mindful that our means/ranges may differ from studies that use the full PSQI. 

Rename Variables
(Q114
Q115
Q116
Q117
Q118_1
Q118_2
Q118_3
Q118_4
Q118_5
Q118_6
Q118_7
Q118_8
Q118_9
Q118_10
Q119
Q120_1
Q120_2
Q121
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

*IMPORTANT! PSQI_1-4 are string variables that you will have to manually edit to be numerical; note that this syntax only requires PSQI_2 and PSQI_4)
*(e.g., edit "15 minutes" to be "15" and "7 hours 30 minutes" to be 7.5)
*if they give a range, just calculate the middle of the range. 
*couple 15 provide their hours slept per night as "200" and "210" -- not clear if these are minutes;
*I elected to treat this as missing data

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

COMPUTE AAS_CLOSEpp = MEAN(AAS_1, AAS_6, AAS_8r, AAS_12, AAS_13r, AAS_17r).
COMPUTE AAS_DEPENDpp = MEAN(AAS_2r, AAS_5, AAS_7r, AAS_14, AAS_16r, AAS_18r).
COMPUTE AAS_ANXpp = MEAN(AAS_3, AAS_4, AAS_9, AAS_10, AAS_11, AAS_15).
COMPUTE AAS_AVOIDpp = MEAN(AAS_1r, AAS_2, AAS_5r, AAS_6r, AAS_7, AAS_8, AAS_12r, AAS_13, AAS_14r, AAS_16, AAS_17, AAS_18).
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

Compute BDIpp=
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
variable labels BDIpp "BDIpp".

**Edinburgh Postnatal Depression Scale (EPDS).
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

*DO IF SubjectID < 10. 
*RECODE PDS_2
(3=0) (2=1) (1=2) (0=3) INTO
PDS_2.
*END IF.
*EXECUTE .  

COMPUTE
EPDSpp = mean (PDS_1, PDS_2, PDS_3, PDS_4, PDS_5, PDS_6, PDS_7, PDS_8, PDS_9). 
EXECUTE . 


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

COMPUTE AnxietyStatepp=
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

COMPUTE PSSpp = mean (PSS_1, PSS_2, PSS_3, PSS_4r, PSS_5r, PSS_6r, PSS_7r, PSS_8, PSS_9r, PSS_10r, PSS_11, PSS_12, PSS_13r, PSS_14).
EXECUTE.

**Ages and Stages Scoring for 6-Month Postpartum Visit
*note: for participants 7-10 and 15, ASQ6fm_2, ASQ6fm_4, and ASQfm_5 were missing. Existing scores should have already adjusted for this. 

RENAME VARIABLES 
(
Q122_1
Q122_2
Q122_3
Q122_4
Q122_5
Q122_6
Q122_7
Q122_8
Q122_9
Q122_10
Q122_11
Q122_12
Q122_13
Q122_14
Q122_15
Q122_16
Q122_17
Q122_18
Q122_19
Q122_20
Q122_21
Q122_22
Q122_23
Q122_24
Q122_25
Q122_26
Q122_27
Q122_28
Q122_29
Q122_30
=
ASQ6c_1
ASQ6c_2
ASQ6c_3
ASQ6c_4
ASQ6c_5
ASQ6c_6
ASQ6gm_1
ASQ6gm_2
ASQ6gm_3
ASQ6gm_4
ASQ6gm_5
ASQ6gm_6
ASQ6fm_1
ASQ6fm_2
ASQ6fm_3
ASQ6fm_4
ASQ6fm_5
ASQ6fm_6
ASQ6ps_1
ASQ6ps_2
ASQ6ps_3
ASQ6ps_4
ASQ6ps_5
ASQ6ps_6
ASQ6soc_1
ASQ6soc_2
ASQ6soc_3
ASQ6soc_4
ASQ6soc_5
ASQ6soc_6
).
EXECUTE.

RECODE 
ASQ6c_1
ASQ6c_2
ASQ6c_3
ASQ6c_4
ASQ6c_5
ASQ6c_6
ASQ6gm_1
ASQ6gm_2
ASQ6gm_3
ASQ6gm_4
ASQ6gm_5
ASQ6gm_6
ASQ6fm_1
ASQ6fm_2
ASQ6fm_3
ASQ6fm_4
ASQ6fm_5
ASQ6fm_6
ASQ6ps_1
ASQ6ps_2
ASQ6ps_3
ASQ6ps_4
ASQ6ps_5
ASQ6ps_6
ASQ6soc_1
ASQ6soc_2
ASQ6soc_3
ASQ6soc_4
ASQ6soc_5
ASQ6soc_6
(1=10) (2=5) (3=0) INTO
ASQ6c_1
ASQ6c_2
ASQ6c_3
ASQ6c_4
ASQ6c_5
ASQ6c_6
ASQ6gm_1
ASQ6gm_2
ASQ6gm_3
ASQ6gm_4
ASQ6gm_5
ASQ6gm_6
ASQ6fm_1
ASQ6fm_2
ASQ6fm_3
ASQ6fm_4
ASQ6fm_5
ASQ6fm_6
ASQ6ps_1
ASQ6ps_2
ASQ6ps_3
ASQ6ps_4
ASQ6ps_5
ASQ6ps_6
ASQ6soc_1
ASQ6soc_2
ASQ6soc_3
ASQ6soc_4
ASQ6soc_5
ASQ6soc_6.

EXECUTE .

COMPUTE ASQ_6c = mean (ASQ6c_1, ASQ6c_2, ASQ6c_3, ASQ6c_4, ASQ6c_5, ASQ6c_6).
COMPUTE ASQ_6gm = mean (ASQ6gm_1, ASQ6gm_2, ASQ6gm_3, ASQ6gm_4, ASQ6gm_5, ASQ6gm_6).
COMPUTE ASQ_6fm = mean (ASQ6fm_1, ASQ6fm_2, ASQ6fm_3, ASQ6fm_4, ASQ6fm_5, ASQ6fm_6).
COMPUTE ASQ_6ps = mean (ASQ6ps_1, ASQ6ps_2, ASQ6ps_3, ASQ6ps_4, ASQ6ps_5, ASQ6ps_6). 
COMPUTE ASQ_6soc = mean (ASQ6soc_1, ASQ6soc_2, ASQ6soc_3, ASQ6soc_4, ASQ6soc_5, ASQ6soc_6). 
EXECUTE . 

*Renaming other ASQ questions so they have more descriptive names

Rename Variables
(Q123_1
Q123_2
Q123_3
Q123_4
Q123_5
Q123_6
Q123_7
Q123_8
=
move.hands.and.legs.6pp
feet.flat.6pp
baby.too.quiet.6pp
fam.history.hearing.6pp
vision.concerns.6pp
recent.medical.problems.6pp
concerns.about.baby.6pp
anything.worry.you.6pp). 
EXECUTE. 
 
**Infant Behavior Questionnaire Very Short Version (Rothbart)

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

**Baby Care Questionnaire (Winstanley)

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

**PARYC-I. Computes se, pa, and total subscales. Supporting Positive Behavior, Setting Limits, and Proactive Parenting
*note: the numbering using the 11.16.2017 version of the questionnaire looks different from the previous version. I rewrote the syntax to match and greyed out the old version. 

*RENAME VARIABLES
(
Q108_1_1
Q108_1_2
Q108_1_3
Q108_1_4
Q108_1_8
Q108_1_9
Q108_1_10
Q108_1_11
=
PARYCse_1
PARYCse_2
PARYCse_3
PARYCse_4
PARYCse_5
PARYCse_6
PARYCse_7
PARYCse_8
).
*EXECUTE .

RENAME VARIABLES
(
Q108_1_1
Q108_1_2
Q108_1_3
Q108_1_4
Q108_1_5
Q108_1_6
Q108_1_7
Q108_1_8
=
PARYCse_1
PARYCse_2
PARYCse_3
PARYCse_4
PARYCse_5
PARYCse_6
PARYCse_7
PARYCse_8
).
EXECUTE 

RENAME VARIABLES
(
Q111_1_1
Q111_1_2
Q111_1_3
Q111_1_4
Q111_1_5
Q111_1_6
Q111_1_7
Q111_1_8
Q111_1_9
=
PARYCpa_1
PARYCpa_2
PARYCpa_3
PARYCpa_4
PARYCpa_5
PARYCpa_6
PARYCpa_7
PARYCpa_8
PARYCpa_9
).
EXECUTE . 

COMPUTE PARYCse = mean (PARYCse_1, PARYCse_2, PARYCse_3, PARYCse_4, PARYCse_5, PARYCse_6, PARYCse_7, PARYCse_8).
COMPUTE PARYCpa = mean (PARYCpa_1, PARYCpa_2, PARYCpa_3, PARYCpa_4, PARYCpa_5, PARYCpa_6, PARYCpa_7, PARYCpa_8, PARYCpa_9).
COMPUTE PARYCtot = mean (PARYCse, PARYCpa). 
EXECUTE .

**Parenting Stress Scale

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

**Parental Stress Inventory (PSI)
*IMPORTANT: first, manually recode 21.0 (the 2nd time it appears at the end of the variable list) as 211, 32.0 as 34, and 33.0 as 35. This variable was mislabeled. 

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

COMPUTE PSI_PD = 12 *mean (PSI_1, PSI_2, PSI_3, PSI_4, PSI_5, PSI_6, PSI_7, PSI_8, PSI_9, PSI_10, PSI_11, PSI_12).
EXECUTE. 
COMPUTE PSI_DI = 12 * mean (PSI_13, PSI_14, PSI_15, PSI_16, PSI_17, PSI_18, PSI_19, PSI_20, PSI_21, PSI_22, PSI_23, PSI_211) .
EXECUTE. 
COMPUTE PSI_DC = 12 * mean (PSI_24, PSI_25, PSI_26, PSI_27, PSI_28, PSI_29, PSI_30, PSI_31, PSI_32, PSI_33, PSI_34, PSI_35).
EXECUTE. 
COMPUTE PSI_tot = 4 * mean (PSI_PD, PSI_DI, PSI_DC).
EXECUTE. 

VARIABLE LABELS PSI_PD 'PSI - Parental Distress'.
EXECUTE.

VARIABLE LABELS PSI_DI 'PSI - Parent?Child Dysfunctional Interaction'.
EXECUTE.

VARIABLE LABELS PSI_DC 'PSI - Difficult Child'.
EXECUTE.

VARIABLE LABELS PSI_tot 'PSI - Total Parental Stress'.
EXECUTE.

**Postpartum Bonding Questionnaire
*Higher scores indicate more problematic bonding

RENAME VARIABLES 
(
Q107_1
Q107_2
Q107_3
Q107_4
Q107_5
Q107_6
Q107_7
Q107_8
Q107_9
Q107_10
Q107_11
Q107_12
Q107_13
Q107_14
Q107_15
Q107_16
Q107_17
Q107_18
Q107_19
Q107_20
Q107_21
Q107_22
Q107_23
Q107_24
Q107_25
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

COMPUTE PBQ = mean (PBQ1, PBQ2, PBQ3, PBQ4, PBQ8, PBQ9, PBQ11, PBQ16, PBQ22, PBQ25, PBQ5, PBQ6, PBQ7, PBQ10, PBQ12, PBQ13, PBQ14, PBQ15, PBQ17, PBQ18, PBQ19, PBQ20, PBQ21, PBQ23, PBQ24).
EXECUTE . 

**Maternal Attachment Inventory (MAI)
*Reverse coding is to bring these in line with prior published work. Higher scores represent more secure/positive attachment.

RENAME VARIABLES
(
Q128_1
Q128_2
Q128_3
Q128_4
Q128_5
Q128_6
Q128_7
Q128_8
Q128_9
Q128_10
Q128_11
Q128_12
Q128_13
Q128_14
Q128_15
Q128_16
Q128_17
Q128_18
Q128_19
Q128_20
Q128_21
Q128_22
Q128_23
Q128_24
Q128_25
Q128_26
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

COMPUTE MAI_Tot = 
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

VARIABLE LABELS MAI_Tot 'MAI - Total Maternal Attachment'.
EXECUTE.

*Life Attitude Profile - Revised (LAP-R)
*We have included items from the Personal Meaning Index (PMI).
*The PMI is comprised of the Purpose and Coherence subscales.
*In the postpartum questionnaire, the raw variable names are labeled "PMI" rather than "LAP_R," so we'll start by fixing the names. 

RECODE 
PMI_1
PMI_2
PMI_3
PMI_4
PMI_5
PMI_6
PMI_7
PMI_8
PMI_9
PMI_10
PMI_11
PMI_12
PMI_13
PMI_14
PMI_15
PMI_16
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

*Relabeling time with baby questions so they have more descriptive names

Rename Variables
(Q131
Q132
Q133
Q134
Q135
=
weekdayhrs.with.baby.6pp
weekday.alone.with.baby.6pp
weekendhrs.with.baby.6pp
weekend.alone.with.baby.6pp
share.compared.to.partner.6pp).
EXECUTE. 

Recode
wkdayalonewithbaby.1.6pp
wkendalonewithbaby.1.6pp
wkdayalonewithbaby.2.6pp
wkendalonewithbaby.2.6pp
(1=.83) (2=.67) (3=.50) (4=.33) (5=.17) INTO
wkdayalonewithbaby.1.6pp_r
wkendalonewithbaby.1.6pp_r
wkdayalonewithbaby.2.6pp_r
wkendalonewithbaby.2.6pp_r.
Execute.

Recode
    wkdayhourswithbaby.1.6pp
    wkdayhourswithbaby.2.6pp
(1=40) (2=32.5) (3=17.5) (4=7.5) (5=2.5) INTO
 wkdayhourswithbaby.1.6pp_r
    wkdayhourswithbaby.2.6pp_r.
Execute. 

Recode
    wkendhourswithbaby.1.6pp
    wkendhourswithbaby.2.6pp
    (1=24) (2=16) (3=13) (4=8) (5=4) (6=1.5) INTO
    wkendhourswithbaby.1.6pp.r
    wkendhourswithbaby.2.6pp.r.
   Execute. 

COMPUTE
    total.wkly.hours.with.baby.1.6pp =  wkdayhourswithbaby.1.6pp_r+wkendhourswithbaby.1.6pp.r.
 Execute. 

COMPUTE
    total.wkly.hours.with.baby.2.6pp =  wkdayhourswithbaby.2.6pp_r+wkendhourswithbaby.2.6pp.r.
 Execute. 

COMPUTE
primary.caregiver.wkdy.hours.1.6pp =   wkdayhourswithbaby.1.6pp_r*wkdayalonewithbaby.1.6pp_r.
Execute. 
COMPUTE
primary.caregiver.wkdy.hours.2.6pp =   wkdayhourswithbaby.2.6pp_r*wkdayalonewithbaby.2.6pp_r.
Execute. 
COMPUTE
primary.caregiver.wknd.hours.1.6pp =   wkendhourswithbaby.1.6pp.r*wkendalonewithbaby.1.6pp_r.
Execute. 
COMPUTE
primary.caregiver.wknd.hours.2.6pp =   wkendhourswithbaby.2.6pp.r*wkendalonewithbaby.2.6pp_r.
Execute. 

COMPUTE
primary.caregiver.total.hours.1.6pp =   primary.caregiver.wkdy.hours.1.6pp + primary.caregiver.wknd.hours.1.6pp.
Execute. 
COMPUTE
primary.caregiver.total.hours.2.6pp =   primary.caregiver.wkdy.hours.2.6pp + primary.caregiver.wknd.hours.2.6pp.
 Execute. 


**Restructuring to Couple Level
After scoring all data, you may want to restructure to create a couple level file. To do so, delete all "A"s, "B"s, and other text from the SubjectID field
*and convert from a string to a numeric variable. As you delete, double check that gender labels match your "A"s and "B"s. "1" should be "A" and "2" should be "B"
*You may want to also edit the file to remove individual item-level responses and other "clutter" before you restructure. Otherwise, your new file will be very wide. 
*Check notes at the top of this file for Couples 41 and 49 (mislabeled gender). 

SORT CASES BY CoupID Gender.
CASESTOVARS
  /ID=CoupID
  /INDEX=Gender
  /GROUPBY=VARIABLE.

