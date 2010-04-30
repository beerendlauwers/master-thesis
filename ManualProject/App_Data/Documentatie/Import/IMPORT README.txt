1) Importeer met dumper.php

2) Run linkfixer.php in zoekmodus

3) Voer manuele opschoonacties uit.
Voor NL:

Artikel "Werken met functies (ASE13RC1)"
- Verander de link "../MNU/NSE13C1.htm" naar "../IBV/NSE13C1A.htm".
- Verander de link "mk:@MSITStore:C:\PROGRAM%20FILES\AAAFIN\AAAFRMN.CHM::/PRT/NPT0501.htm" in naar "../PRT/NPT0501.htm".

Artikel "Electronische BTW-aangifte  (ABT04R01)"
- Verander de link "mk:@MSITStore:C:\Program%20Files\AAAFIN\AAAFRMN.CHM::/ALG/NZ035ZC1.htm" naar "../ALG/NZ035ZC1.htm".
- Verander de link "mk:@MSITStore:C:\PROGRAM%20FILES\AAAFIN\AAAFRMN.CHM::/PRT/NPT0501.htm" naar "../PRT/NPT0501.htm".

Artikel "BTW-kwartaalopgave: VAT INTRA (ABT03R01)"
- Verander de link "mk:@MSITStore:C:\Program%20Files\AAAFIN\AAAFRMN.CHM::/ALG/NZ035ZC1.htm" naar "../ALG/NZ035ZC1.htm".

- Voeg manueel het HTML-bestand "NWELKOM2.HTM" onder de module "VARIA" toe (maak deze aan als deze nog niet bestaat).
- Voeg manueel het HTML-bestand "NSPOC.HTML" onder de module "VARIA" toe.

Voor FR:
- Voeg manueel het HTML-bestand "FWELKOM2.HTM" onder de module "VARIA" toe (maak deze aan als deze nog niet bestaat).
- Voeg manueel het HTML-bestand "FSPOC.HTM" onder de module "vARIA" toe.

Artikel "Lignes d’écriture par valeur de Z.E.C. (AEX20RC2)"
- Verander de link "../../AAFRM3102/FR/ALG/FSTAFUNC.HTM" naar "../ALG/FSTAFUNC.HTM".
- Verander de link "../../AAFRM3102/FR/ALG/FONDERVR.HTM" naar "../ALG/FONDERVR.HTM".
- Verander de link "../../AAFRM3102/FR/DTA/FINAN.htm" naar "../DTA/FINAN.htm".
- Verander de link "../../AAFRM3102/FR/MNU/FGE12C1.HTM" naar "../MNU/FGE12C1.HTM".

Artikel "Gestion des codes option (AGE12RC1)"
- Verander de link "../../AAFRM3102/FR/ALG/FSTAFUNC.HTM" naar "../ALG/FSTAFUNC.HTM".

Artikel "Annexe 2 : Banques pour lesquelles des supports magnétiques peuvent être créés."
- Verander de link "../../../../../../../../../AAFRM/NL/DTA/FINAN.htm#ATBD36" naar "../DTA/FINAN.htm#ATBD36".

Artikel "Extourne de pièces comptables (ASP01R01)"
-Verander de link "file:///\\qrdcsys\rnd\AAA%20Financials\AAFRMREC\NL\DTA\FINAN.htm#SPFD06" naar "../DTA/FINAN.htm#SPFD06".

4) Run linkfixer.php in fixmodus

5) Er zijn enkele dubbele artikels in de reference manual. Wijzig de tag of verwijder een van de artikels indien ze exact hetzelfde zijn.

SQL-query: SELECT * FROM tblVglTaal WHERE Nederlands = 2 OR français = 2 -- enzovoort voor elke andere taal

Nederlands

Bijwerken rapporteringsmodellen (ASR38R01)	010302_NL_AAAFinancials_SRP_SR3801.HTM		Afhankelijk analytische boekhouding
Bijwerken rapporteringsmodellen (ASR38R01)	010302_NL_AAAFinancials_SRP_SR3801.HTM		Standaardrapportering - definities

Historiek acties van uitvoerder (ZD12ZRC1)	010302_NL_AAAFinancials_DOS_ZD12ZC1.HTM		Historiek acties van uitvoerder
Historiek acties (ZD12YRC2)			010302_NL_AAAFinancials_DOS_ZD12ZC1.HTM		Historiek acties

Actie (ZD12AR10)				010302_NL_AAAFinancials_DOS_ZD12A10.HTM		Historiek acties van uitvoerder
Actie (ZD12AR10)				010302_NL_AAAFinancials_DOS_ZD12A10.HTM		Historiek acties

Frans

Mise à jour des modèles de rapport (ASR38R01)	010302_FR_AAAFinancials_SRP_SR3801.HTM		Comptabilité analytique dépendante
Mise à jour des modèles de rapport (ASR38R01)	010302_FR_AAAFinancials_SRP_SR3801.HTM		Générateur d'états - définitions

Historique actions exécutant (ZD12ZRC1)		010302_FR_AAAFinancials_DOS_ZD12ZC1.HTM		Historique actions exécutant
Historique actions (ZD12YRC2)			010302_FR_AAAFinancials_DOS_ZD12ZC1.HTM		Historique actions

Action (ZD12AR10)				010302_FR_AAAFinancials_DOS_ZD12A10.HTM		Historique actions exécutant
Action (ZD12AR10)				010302_FR_AAAFinancials_DOS_ZD12A10.HTM		Historique actions


6) Er zijn enkele artikels die een incorrecte tag hebben. WIjzig de tag.

SQL-query: SELECT titel, tag FROM tblArtikel A WHERE ( SELECT count(data) FROM dbo.SplitTekst( A.tag, '_' ) ) < 5

Welkom							010302_NL_AAAFinancials_WELKOM0.HTM
Toelichting bij de Reference Manual			010302_NL_AAAFinancials_WELKOM1.HTM
Aanpassingen en nieuwe functionaliteiten		010302_NL_AAAFinancials_WELKOM3.HTM

Adaptations et fonctionnalités modifiées PTF 3102	010302_FR_AAAFinancials_WELKOM3102.HTM

