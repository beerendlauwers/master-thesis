<?php

/***************************************\
* 				CHMDUMPER				*
* Dit scriptje neemt de JavaScript-code *
* van een door CHMDecoder-gegenereerde  *
* helpfile en kopieert de boomstructuur *
* in het JavaScript-bestand over naar   *
* een MSSQL-database. Zowel categorieën *
* als artikels worden overgekopieerd.   *
*										*
*				VEREISTEN				*
* - Een webserver die PHP kan draaien.	*
* - De PHP-driver van Microsoft. Zie	*
*	de folder 'MSSQL_PHP'.				*
* - Een MSSQL-server die remote connect *
*	ions toelaat, en een user die de	*
*	'sysadmin' rol heeft.				*
* - Reeds bestaande tabellen in de data *
*	base: tblArtikel, tblCategorie,		*
*	tblVersie, tblTaal en tblBedrijf.	*
* - Een tekstbestand met de JavaScript	*
*	code die wordt gebruikt om de boom	*
*	structuur te genereren in HTML.		*
* - De eigenlijke HTML-bestanden van de	*
*	reference manual.					*
*										*
*				OPMERKINGEN				*
* Zorg ervoor dat niemand anders bezig	*
* is met het toevoegen van artikels of	*
* categorieën wanneer u dit script		*
* runt.									*
*										*
*		  VOORBEELDCONFIGURATIE			*
*	  (Zie de folder exampleconfig)		*
* - Webserver: WAMPSERVER 2.0i			*
* - PHP-driver: php_sqlsrv_53_ts.dll	*
* - Tabellen: zie SQL-code in folder	*
* - JavaScript: zie folder				*
* - Helpbestand: zie folder				*
\***************************************/

/* 		BELANGRIJKE PARAMETERS		   */

// De locatie van het JavaScript-tekstbestand.
$CONST_JS = "javascriptFR.txt";

// De locatie van de hulpbestanden.
$CONST_HTMLBESTANDEN = "C:/xampp/htdocs/javascript/AAAFRMF_GEFIXT/";

// Parameters om de taal, versie en het bedrijf van de te importeren manual in te stellen.
// De waardes zijn de Primary Keys van tblTaal, tblVersie en tblBedrijf.
$CONST_VERSIEID = 52;
$CONST_TAALID = 15;
$CONST_BEDRIJFID = 16;

// Uncomment deze variabelen als je testtabellen wilt gebruiken in plaats van tblCategorie en tblArtikel.
// Voorwaarde is dat deze bestaan en dezelfde structuur (constraints maken niet uit) hebben.
//$TABEL_ART = "tblArtikelTEST";
//$TABEL_CAT = "tblCategorieTEST";

// De versie van het artikel.
$CONST_VERSIE = "010302";

// De taalafkorting die voor elke tag van een artikel wordt geplaatst.
// Bv. 'FR-' geeft 'FR_DTA/FINAN.HTM'.
$CONST_TAALAFKORTING = 'FR';

// De volledige naam van de taal.
$CONST_TAAL = 'frans';

// Module waaronder tags die nog geen module hebben, geplaatst worden.
$CONST_MODULE = 'VARIA';

//De prefix die voor bijna elk artikel staat.
// Bv. De 'N' bij 'NWELKOM01.HTM'.
$CONST_TAALPREFIX = 'F';

// De tag van het bedrijf waaronder dit artikel gepubliceerd wordt.
$CONST_BEDRIJF = "AAAFinancials";

// Parameters om de debug-informatie te zien van een bepaald artikel of categorie.
// Zet SKIPPEN op 1 en BEGIN_VANAF als de titel waarvoor debug-info moet worden weergegeven
$SKIPPEN = 0;
$BEGIN_VANAF = "Werken met functies (ASE13RC1)";

// Parameter om alle debug-informatie te zien.
$ISDEBUG = FALSE;

// Wijzig deze variabele naar 1 als je de root node (begin van de boomstructuur) wilt inserten in de database.
$INSERTROOTNODE = 0;


/* 				SCRIPT				*/

// Als deze variabelen niet werden geïnitialiseerd, gebruiken we de default-waarden.
if (!isset( $TABEL_ART )) { $TABEL_ART = "tblArtikel"; }
if (!isset( $TABEL_CAT )) { $TABEL_CAT = "tblCategorie"; }

// Tellers die bijhouden hoeveel keer een categorie of artikel werd geïnsert.
$AANTALCATS = 0;
$AANTALARTS = 0;

// Met MSSQL Connecten
include('inc\db_open.php');

$query = "SET ANSI_WARNINGS OFF";
$stmt = sqlsrv_query( $conn, $query );

// tblCategorie tijdelijk wijzigen om toe te laten dat men manueel inserts mag doen met een primary key.
$query = "SET IDENTITY_INSERT $TABEL_CAT ON";
$stmt = sqlsrv_query( $conn, $query );
if ( $stmt )
{
	echo "$TABEL_CAT: IDENTITY_INSERT = ON<br/>";
}
else 
{
	echo "Error in statement execution.\n";
	echo "<br/>Plaats in script (zoek hierop): ERROR0000<br/>";
	echo "<br/>SQL-query: $query<br/>";
	die( print_r( sqlsrv_errors(), true));
}

// De offsets ophalen voor categorieën. Als een categorie wordt geïnserteerd in de database,
// Wordt het CategorieID verhoogd met deze waarde om dubbele Primary Keys te vermijden.
$query = "SELECT MAX(CategorieID) FROM $TABEL_CAT";
$stmt = sqlsrv_query( $conn, $query );
if ( $stmt )
{
	if( $row = sqlsrv_fetch_array( $stmt ) )
	{
		$CONST_OFFSET_CAT = intval($row[0]);
		$CONST_OFFSET_CAT += 1;
		echo "CONST_OFFSET_CAT = $CONST_OFFSET_CAT<br/>";
	}
	else
	{
		$CONST_OFFSET_CAT = 0;
		echo "CONST_OFFSET_CAT = $CONST_OFFSET_CAT<br/>";
	}
}
else 
{
	echo "Error in statement execution.\n";
	echo "<br/>Plaats in script (zoek hierop): ERROR0001<br/>";
	echo "<br/>SQL-query: $query<br/>";
	die( print_r( sqlsrv_errors(), true));
}

// root id ophalen
if( $SKIPPEN == 0 )
{

	if( $INSERTROOTNODE == 1 )
	{
		$query = "INSERT INTO $TABEL_CAT ( CategorieID, Categorie, Diepte, Hoogte, Fk_parent, FK_taal, FK_versie, FK_bedrijf ) VALUES( 0, 'root_node','-1','0',0, $CONST_TAALID, $CONST_VERSIEID, $CONST_BEDRIJFID);";
		$stmt = sqlsrv_query( $conn, $query );

		if ( $stmt )
		{
			echo $query.'<br/>';
			$AANTALCATS++;
		}
		else 
		{
			echo "Error in statement execution.\n";
			echo "<br/>Plaats in script (zoek hierop): ERROR0002<br/>";
			die( print_r( sqlsrv_errors(), true));
		}
	}

	// Root ID ophalen
	$query = "SELECT CategorieID FROM $TABEL_CAT WHERE Categorie = 'root_node'; ";

	$stmt = sqlsrv_query( $conn, $query );

	if ( $stmt )
	{
		$row = sqlsrv_fetch_array( $stmt );
		$ROOT_ID = $row['CategorieID'];
		echo "ROOT_ID = $ROOT_ID.<br/>";
	}
	else
	{
		echo "Error in statement execution.\n";
		echo "<br/>Plaats in script (zoek hierop): ERROR0003<br/>";
		echo "<br/>SQL-query: $query<br/>";
		die( print_r( sqlsrv_errors(), true));
		
	}

}

$huidigeDiepte = 0;
$huidigeHoogte = 0;


// Open javascript.txt
$file = fopen($CONST_JS, 'r');

// Lees 1 lijn uit javascript.txt
while ( $lijn = fgets($file) )
{
	// Lijn cleanen
	$lijn = str_replace("d.add(","",$lijn);
	$lijn = str_replace(");","",$lijn);

	// Waardes uit lijn halen
	$waardes = explode( ",", $lijn );
	
	// Checken of er meer dan 4 waardes zijn.
	$aantalWaardes = count( $waardes );
	
	if( $aantalWaardes > 4 )
	{
		// Debug-info
		if( $ISDEBUG )
		{
			echo "Node met ID ".$waardes[0]." heeft een array met een grootte van $aantalWaardes. Dit betekent dat er in de titel (dit nemen we aan) er een of meerdere comma's zijn.<br/>";
		}
	
		// Oeps, blijkbaar zit er in één van die strings in de array nog een of meerdere comma's. We nemen aan dat dit in de titel is gebeurd.
		$aantalSplits = 2; // Plaats in de $waardes-array
		
		
		if( $ISDEBUG ) { echo "Volledige titel terug opbouwen...<br/>"; }
		$volledigeTitel = "";
		while( $aantalSplits < ($aantalWaardes - 1) )
		{
			if( $ISDEBUG ) { echo "Volledige titel is momenteel: '$volledigeTitel'.<br/>"; }
			$volledigeTitel = $volledigeTitel.$waardes[ $aantalSplits ];
			$volledigeTitel = $volledigeTitel.",";
			$aantalSplits++;
		}
	
		// Het laatste (en dus extra) commatje uit bovenstaande loop terug wegdoen
		$volledigeTitel = substr( $volledigeTitel, 0, strlen($volledigeTitel) -1 );
		
		if( $ISDEBUG ) { echo "Uiteindelijke volledige titel: '$volledigeTitel'.<br/>"; }
		
		$waardes[2] = $volledigeTitel;
		
		$waardes[3] = $waardes[ $aantalWaardes - 1 ];
		
		if( $ISDEBUG ) { echo "in waardes[3] zou normaal gezien de link naar het HTML-bestand moeten zitten (of niets in het geval van een categorie).<br/>waardes[3] bevat: ".$waardes[3]."<br/>"; }
		
	}
	
	// Dubbele haakjes weghalen
	$waardes[3] = str_replace('"',"",$waardes[3]);
	$waardes[3] = trim($waardes[3]);
	
	if( $ISDEBUG ) { echo "waardes[3] na trimmen van dubbele haakjes: ".$waardes[3]."<br/>"; }

	if( $SKIPPEN == 1 )
	{
		$titel = trim(str_replace('"',"",$waardes[2])) ;
		if( !($titel == $BEGIN_VANAF) )
		{
			continue;
		}
	}
	
	// Debug-info
	if( $ISDEBUG )
	{
		if( $waardes[3] == "" ) { echo "ID van categorie = ".$waardes[0]."<br/>"; }
		else { echo "ID van artikel = ".$waardes[0]."<br/>"; }
		echo "ID van parent-categorie = ".$waardes[1]."<br/>";
		echo "Titel = ".$waardes[2]."<br/>";
		if( !($waardes[3] == "") ) { echo "HTM-bestand = ".$waardes[3]."<br/><br/>"; }
	}

	if( $waardes[3] == "" ) // Dit is een categorie.
	{
		// Alle categoriewaardes eruit halen
		$categorieTitel = trim(str_replace('"',"",$waardes[2])) ;
		$categorieTitel = html_entity_decode(str_replace("'","''",$categorieTitel));
		$Parent = intval(trim($waardes[1])) ;
		$categorieID = intval(trim($waardes[0])) ;
		// Voeg een offset toe om geen dubbele Primary Keys te hebben.
		$categorieID += $CONST_OFFSET_CAT;
		if( !($Parent == 0 ) ) { $Parent += $CONST_OFFSET_CAT; }
		
		// Haal de gegevens van de parent op.
		$query = "SELECT * FROM $TABEL_CAT WHERE CategorieID = $Parent;";
		$stmt = sqlsrv_query( $conn, $query );
		
		if ( $stmt )
		{
			$row = sqlsrv_fetch_array( $stmt );
			$ParentCategorieID = $row['CategorieID'];
			$ParentTitel = $row['Categorie'];
			$huidigeDiepte = $row['Diepte'];
		}
		else 
		{
			echo "Error in statement execution.\n";
			echo "<br/>Plaats in script (zoek hierop): ERROR0004<br/>";
			echo "<br/>SQL-query: $query<br/>";
			die( print_r( sqlsrv_errors(), true));
		}
		
		if( $ISDEBUG ) { echo "SQL-query voor parentgegevens: $query.<br/>"; }
		
		// We zijn een categorie ingegaan, we gaan dus 1 niveau dieper
		$huidigeDiepte++;
		
		echo "<br/>Ingelezen Parent waarde: $Parent.<br/>";
		echo "Parent voor deze categorie is: '$ParentTitel' (CategorieID: $ParentCategorieID).<br/>";
		
		// Juiste hoogte ophalen en verhogen met 1
		$query = "SELECT MAX(Hoogte) FROM $TABEL_CAT WHERE FK_parent = $ParentCategorieID;";
		$stmt = sqlsrv_query( $conn, $query );
		if( $stmt )
		{
			$row = sqlsrv_fetch_array( $stmt );
			$huidigeHoogte = $row[0];
			if( is_null( $huidigeHoogte ) )
			{
				$huidigeHoogte = 0;
			}
			$huidigeHoogte++;
		}
		else
		{
			$huidigeHoogte = 0;
		}
		
		// We inserten de categorie.
		$query = "INSERT INTO $TABEL_CAT ( CategorieID, Categorie, Diepte, Hoogte, Fk_parent, FK_taal, FK_versie, FK_bedrijf ) VALUES( $categorieID, '$categorieTitel', $huidigeDiepte, $huidigeHoogte, $ParentCategorieID, $CONST_TAALID, $CONST_VERSIEID, $CONST_BEDRIJFID );";
		$stmt = sqlsrv_query( $conn, $query );
		
		if ( $stmt )
		{
			echo "Categorie '$categorieTitel' succesvol toegevoegd.<br/>";
			$AANTALCATS++;
		}
		else 
		{
			echo "Error in statement execution.\n";
			echo "<br/>Plaats in script (zoek hierop): ERROR0005<br/>";
			echo "<br/>SQL-query: $query<br/>";
			die( print_r( sqlsrv_errors(), true));
		}
		
		if( $ISDEBUG ) { echo "SQL-query voor insert van de nieuwe categorie: $query.<br/>"; }
	}
	else // Dit is een artikel.
	{
		 
		// HTML-bestand openen
		$bestand = $CONST_HTMLBESTANDEN.$waardes[3];

		// Bestand uitlezen
		$html_bestand = file_get_contents($bestand,'r');

		// Alles op 1 lijn plaatsen en omzetten naar tekst
		$html_bestand = str_replace(array("\r\n", "\r", "\n"), ' ', $html_bestand);
		$hoofdlijn = trim(html_entity_decode($html_bestand));

		// De tag opbouwen: VERSIE_TAAL_BEDRIJF_MODULE_NAAM
		$gesplitsteTag = explode( "/", $waardes[3] );
		
		if( count( $gesplitsteTag ) == 2 )
		{
			//De taalprefix voor de tag weghalen.
			//Eerst eens kijken of deze tag een uitzondering is.
			$artikelTag  = $waardes[3];
			$isUitzondering = FALSE;
			if( $artikelTag  == "DTA/FINAN.HTM" OR $artikelTag  == "DTA/FRAME.HTM" )
			{
				$isUitzondering = TRUE;
			}
		
			$ModuleGedeelte = $gesplitsteTag[0];
			$NaamGedeelte = $gesplitsteTag[1];
			if( $ISDEBUG ){ echo "Module: $ModuleGedeelte | Naam: $NaamGedeelte <br/>"; }
			
			if( $isUitzondering == FALSE )
			{
				if( $NaamGedeelte[0] == $CONST_TAALPREFIX )
				{
					$NaamGedeelte = substr( $NaamGedeelte, 1);
					if( $ISDEBUG ){ echo "Naam na verwijderen prefix: $NaamGedeelte <br/>"; }
				}
			}
		
			$artikelTag = $ModuleGedeelte.'_'.$NaamGedeelte;
		}
		else
		{
			$NaamGedeelte = $gesplitsteTag[0];
			if( $ISDEBUG ){ echo "Naam: $NaamGedeelte <br/>"; }
			
			if( $NaamGedeelte[0] == $CONST_TAALPREFIX )
			{
				$NaamGedeelte = substr( $NaamGedeelte, 1);
				if( $ISDEBUG ){ echo "Naam na verwijderen prefix: $NaamGedeelte <br/>"; }
			}
			
			$artikelTag = $NaamGedeelte;
		}
		
		$artikelTag = $CONST_VERSIE.'_'.$CONST_TAALAFKORTING.'_'.$CONST_BEDRIJF.'_'.$artikelTag;	// bv. 010302_NL_AAAFinancials_DTA_FINAN.HTM
		
		if( $ISDEBUG ) { echo "Uiteindelijke artikeltag: $artikelTag <br/>"; }
		
		// We verwijderen de dubbele haakjes uit de titel
		$artikelTitel = trim(html_entity_decode(str_replace('"',"",$waardes[2]))); 
		
		// We vervangen de enkele haakjes door twee enkele haakjes (MSSQL escapet op die manier een haak-karakter)
		$artikelTitel = str_replace("'","''",$artikelTitel); 
		$artikelTekst = str_replace("'","''",$hoofdlijn);
		
		// Query opstellen.
		$query = "INSERT INTO $TABEL_ART ( tag, tekst, titel, fk_categorie, fk_versie, fk_taal, fk_bedrijf, is_final ) VALUES( '$artikelTag', '$artikelTekst', '$artikelTitel', $categorieID, $CONST_VERSIEID, $CONST_TAALID, $CONST_BEDRIJFID, 1 );";
		
		// Debug-info weergeven indien nodig
		if( $SKIPPEN == 1 ) { echo $query.'<br/>'; }
		
		// Query uitvoeren
		$stmt = sqlsrv_query( $conn, $query );
		if ( $stmt )
		{
			echo "Artikel '$artikelTitel' succesvol toegevoegd.<br/>";
			$AANTALARTS++;
		}
		else 
		{
			echo "Error in statement execution.\n";
			echo "<br/>Plaats in script (zoek hierop): ERROR0006<br/>";
			echo "<br/>SQL-query: $query<br/>";
			die( print_r( sqlsrv_errors(), true));
		}
	}
	
	// Executielimiet van het script resetten naar 60 seconden.
	set_time_limit(60);
	
}

// Sluit javascript.txt
fclose($file);

// Alle hoogtes verminderen met 1
$query = "UPDATE $TABEL_CAT SET Hoogte = Hoogte - 1 WHERE CategorieID != 0 AND FK_versie = $CONST_VERSIEID AND FK_TAAL = $CONST_TAALID AND FK_BEDRIJF = $CONST_BEDRIJFID";
$stmt = sqlsrv_query( $conn, $query );
if ( $stmt )
{
	echo $query.'<br/>';
}
else 
{
	echo "Error in statement execution.\n";
	echo "<br/>Plaats in script (zoek hierop): ERROR0007<br/>";
	echo "<br/>SQL-query: $query<br/>";
	die( print_r( sqlsrv_errors(), true));
}

// tblCategorie terug normaal maken
$query = "SET IDENTITY_INSERT $TABEL_CAT OFF";
$stmt = sqlsrv_query( $conn, $query );
if ( $stmt )
{
	echo "$TABEL_CAT: IDENTITY_INSERT = OFF<br/>";
}
else 
{
	echo "Error in statement execution.\n";
	echo "<br/>Plaats in script (zoek hierop): ERROR0008<br/>";
	echo "<br/>SQL-query: $query<br/>";
	die( print_r( sqlsrv_errors(), true));
}

// Tags die nog geen module hebben fixen
// OPM: Dit werkt alleen als de artikeltabel 'tblArtikel' noemt.
$query = "EXEC [dbo].[Manual_HerstelTags] @teGebruikenModule = '$CONST_MODULE'";
$stmt = sqlsrv_query( $conn, $query );

// Executielimiet van het script resetten naar 5 minuten.
set_time_limit(300);

// TblVglTaal opbouwen
$query = "EXEC [dbo].[Manual_MaakTalenTabel]";
$stmt = sqlsrv_query( $conn, $query );

// Checken voor dubbele artikels in talentabel
$query = "SELECT tag FROM tblVglTaal WHERE $CONST_TAAL = 2";
echo $query."<br/>";
$stmt = sqlsrv_query( $conn, $query );

// Alles lezen in een array
$dubbelegegevens = array();
while( $row = sqlsrv_fetch_array( $stmt ) )
{
	echo $row[0]."<br/>";
	if( $row[0] )
	{
		array_push( $dubbelegegevens, $row[0] );
	}
}

if( count( $dubbelegegevens ) > 0 )
{
	$aantaldubbeletags = count( $dubbelegegevens );
	echo "<br/><br/>Er werden $aantaldubbeletags  dubbele tags gevonden. Deze zullen automatisch worden opgelost.<br/>";
	$echoteller = 0;

	// Dubbele artikels fixen
	for( $teller = 0; $teller < count( $dubbelegegevens ); $teller++ )
	{
		if( $dubbelegegevens[$teller] == "OPGELOST" )
			continue;
	
		$echoteller++;
		echo "Dubbele tag $echoteller: $dubbelegegevens[$teller]<br/>";
		
		$query = "SELECT * FROM $TABEL_ART WHERE TAG LIKE '%$dubbelegegevens[$teller]%' AND FK_versie = $CONST_VERSIEID AND FK_TAAL = $CONST_TAALID AND FK_BEDRIJF = $CONST_BEDRIJFID;";
		$stmt = sqlsrv_query( $conn, $query );
		
		if( $row = sqlsrv_fetch_array( $stmt ) )
		{
			//Artikeldetails ophalen
			$artikelID = $row['ArtikelID'];
			$artikelNaam = $row['Titel'];
			$artikelTag = $row['Tag'];
					
			//Tag opsplitsen
			$tagArray = explode( '_', $artikelTag );
			$laatsteStuk = $tagArray[4];
					
			//Laatste stuk opsplitsen
			$laatsteStukArray = explode( '.', $laatsteStuk );
			$echteTag = $laatsteStukArray[0];
					
			//Echte tag wijzigen zodat hij uniek wordt
			$echteTag = $echteTag.'0.'.$laatsteStukArray[1];
					
			// De nieuwe tag opbouwen
			$nieuweTag = $tagArray[0].'_'.$tagArray[1].'_'.$tagArray[2].'_'.$tagArray[3].'_'.$echteTag;
					
			echo "De nieuwe tag van het artikel '$artikelNaam' (ID $artikelID) is nu '$nieuweTag'.<br/>";
					
			$query = "UPDATE $TABEL_ART SET Tag = '$nieuweTag' WHERE artikelID = $artikelID;";
			$stmt = sqlsrv_query( $conn, $query );		
		}
	}
				
	set_time_limit(30);
}

// TblVglTaal opbouwen
$query = "EXEC [dbo].[Manual_MaakTalenTabel]";
//$stmt = sqlsrv_query( $conn, $query );

$query = "SET ANSI_WARNINGS ON";
$stmt = sqlsrv_query( $conn, $query );

sqlsrv_free_stmt( $stmt );

echo "Aantal categorieën toegevoegd: $AANTALCATS.<br/>";
echo "Aantal artikels toegevoegd: $AANTALARTS.<br/>";

//MSSQL connectie sluiten
include('inc\db_close.php');

?>