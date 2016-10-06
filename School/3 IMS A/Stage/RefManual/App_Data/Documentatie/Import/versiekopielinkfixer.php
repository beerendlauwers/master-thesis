<?php

//Toon debug-informatie.
$debug = FALSE;
//Toon de artikels.
$toonartikel = FALSE;

$linkswegschrijven = TRUE;

//Toon een overzicht van de vervangen links.
$vervangenlinkstonen = TRUE;

//Definieer deze array indien je enkel een bepaald artikel wil onderzoeken. Gebruikt de ArtikelIDs.
$checkwaardes = array(  );

//Het versieID waarvan de artikels dienen gefixt te worden.
$CONST_VERSIEID = 41;

// Gebruik deze debugvariablelen om slechts een bepaalde combinatie van versie, taal en bedrijf te fixen. Indien niet nodig, zet op -1000.
$ENKEL_DEZE_TAAL = 0;
$ENKEL_DIT_BEDRIJF = 0;

// Testtabel
//$TABEL_ART = "tblArtikelTest";

// Met MSSQL Connecten
include('inc\db_open.php');

if (!isset( $TABEL_ART )) { $TABEL_ART = "tblArtikel"; }

// Talen ophalen

$query = "SELECT * from tblTaal";
$taaltabel = sqlsrv_query( $conn, $query );

while( $taalrij = sqlsrv_fetch_array( $taaltabel ) )
{
	$CONST_TAALID = $taalrij['TaalID'];
	
	if( $ENKEL_DEZE_TAAL > -1000 )
	{
		if( $ENKEL_DEZE_TAAL != $CONST_TAALID )
			continue;
	}
	
	// Bedrijven ophalen
	
	$query = "SELECT * from tblBedrijf";
	$bedrijftabel = sqlsrv_query( $conn, $query );
	while( $bedrijfrij = sqlsrv_fetch_array( $bedrijftabel ) )
	{
		$CONST_BEDRIJFID = $bedrijfrij['BedrijfID'];
		
		if( $ENKEL_DIT_BEDRIJF > -1000 )
		{
			if( $ENKEL_DIT_BEDRIJF != $CONST_BEDRIJFID )
				continue;
		}
		
		// Artikels met de gegeven combinatie van versie, taal en bedrijf ophalen en links fixen

		$query = "SELECT * from $TABEL_ART WHERE FK_taal = $CONST_TAALID AND FK_versie = $CONST_VERSIEID AND FK_bedrijf = $CONST_BEDRIJFID";
		if( $debug ) { echo " $query <br/>"; }
		$alleartikels = sqlsrv_query( $conn, $query );

		if ( $alleartikels )
		{
			$lijstonbekendelinks = array();
			$lijstonbekendelinkstekstlinks = array();
			$lijstonbekendelinkspaginas = array();

			while ( $row = sqlsrv_fetch_array( $alleartikels ) )
			{
				$tekst = $row['Tekst'];
				$titel = $row['Titel'];
	
				if( isset( $checkwaardes ) )
				{
					if( count( $checkwaardes ) > 0 )
						if( !(in_array( $row['ArtikelID'], $checkwaardes) ) ) { continue; }
				}
	
				if( $debug OR $vervangenlinkstonen ) { echo "ArtikelID: ".$row['ArtikelID']."<br/>"; }
				if( $toonartikel ) { echo $tekst; }

				//Titel weergeven
				if( !$debug ) { echo "Artikeltitel: $titel<br/>" ; }

				//Naar alle links in de tekst zoeken
				if( !$debug ) { echo "Lengte artikel: ".strlen($tekst)."<br/>"; }

				$aantalLinks = 0;
				$linklijst = array();
				$begin = true;
				$offset = 0;

				while( !($begin === false) )
				{
	
					// We zoeken eerst het begin van de link
					$begin = strpos( $tekst, 'href="', $offset);
	
					if ( !($begin === false) )
					{
	
						$aantalLinks++;
		
						if( $debug ) { echo "<br/>LINK $aantalLinks<br/>"; }
		
						// We beginnen vanaf de gevonden link
						$offset = $begin;
	
						// We zoeken de dubbele haakjes die de link opent
						$eerstehaakje = strpos( $tekst, '"', $offset);

						$offset = $eerstehaakje;
						$tweedehaakje = strpos( $tekst, '"', $offset + 1);

						//We pakken de link tag eruit
						$linktag = substr( $tekst, $begin, ($tweedehaakje - $begin) + 1 );
		
						if( $debug ) { echo "Ruwe link: $linktag<br/>"; }
		
						//Nu gaan we de href-waarde eruit halen
						$haakje1 = strpos( $linktag, '"' );
						$linkwaarde = substr( $linktag, $haakje1);

						//Dubbele haakjes wegdoen
						$linkwaarde = str_replace( '"', '', $linkwaarde);
		
						if( $debug ) { echo "Link zonder haakjes: $linkwaarde<br/>"; }
		
						//Link opsplitsen
						$splitlink = explode("?", $linkwaarde );
						
						if( $splitlink[0] != "page.aspx" )
						{
							// Dit is geen interne paginalink.
							if( $debug ) { echo "Deze link is geen interne link. We gaan naar de volgende link.<br/>"; }
							continue;
						}
			
						if( $debug )
						{
							echo "Link opsplitsen: <br/>";
							for( $i = 0; $i < count($splitlink); $i++ )
							{
								echo "deel $i: (begin)$splitlink[$i](einde)<br/>";
							}
						}
		
						//Kan zijn dat er een anchor (#) achter zit, dus nog eens opsplitsen
						$splitextensie = explode( "#", $splitlink[ sizeof($splitlink)-1 ] );
		
						if( $debug )
						{
							echo "Anchorcheck. We gebruiken ".$splitlink[ sizeof($splitlink)-1 ]." om te splitten.<br/>";
							for( $i = 0; $i < count($splitextensie); $i++ )
							{
								echo "deel $i: (begin)$splitextensie[$i](einde)<br/>";
							}
						}

						//De uiteindelijke link ( bv. "ID=6503" )
						$extensie = $splitextensie[0];
			
						//We halen het ID eruit ( bv. "ID=6503" wordt "6503" )
						$extensie = substr( $extensie, 3);
				
						if( $debug ) { echo "Het uiteindelijke linkID: $extensie<br/>"; }
						if( $debug ){ echo "Deel dat vervangen zal worden: $linkwaarde <br/>"; }
						
						array_push( $lijstonbekendelinkstekstlinks, $linkwaarde );
						array_push( $linklijst, $extensie );
		
						$offset = $tweedehaakje;	
					}
					else
					{
						if( !$debug ) { echo "Einde van de links. Totaal aantal links tegengekomen: $aantalLinks.<br/>"; }
					}
		
					set_time_limit(30);
				}

				if( $debug ) { echo "<br/><br/>Links vervangen:<br/>"; }

				//Alle gevonden links vervangen met de nieuwe links

				$vervangenlinks = 0;

				for ( $counter = 0; $counter < count($linklijst); $counter++)
				{
					// Het originele artikel opzoeken
					$query = "SELECT Tag, Titel, ArtikelID, FK_Taal, FK_Versie, FK_Bedrijf FROM $TABEL_ART WHERE artikelID = $linklijst[$counter];";
					$stmt = sqlsrv_query( $conn, $query );
					if ( $stmt )
					{
						$originelerij = sqlsrv_fetch_array( $stmt );
						$origineelartikelID = $originelerij['ArtikelID'];
						$origineleTag = $originelerij['Tag'];
					
						//Originele tag opsplitsen
						$origineleTagSplit = explode( "_", $origineleTag );
			
						try
						{
							$origineleTag = $origineleTagSplit[3].'_'.$origineleTagSplit[4];
						}
						catch (Exception $e)
						{
							echo "FOUT: De artikeltag $origineleTag heeft een incorrecte vorm (de correcte vorm is VERSIE_TAAL_BEDRIJF_MODULE_ARTIKELTAG ).<br/>";
							continue;
						}
			
						// Het nieuwe artikel opzoeken
						$nieuwerijTaal = $row['FK_Taal'];
						$nieuwerijVersie = $row['FK_Versie'];
						$nieuwerijBedrijf = $row['FK_Bedrijf'];
					
						echo "We zoeken in de database naar het artikel met tag $origineleTag in de versie $nieuwerijVersie, taal $nieuwerijTaal en bedrijf $nieuwerijBedrijf.<br/>";
						$query = "SELECT Tag, Titel, ArtikelID, FK_Taal, FK_Versie, FK_Bedrijf FROM $TABEL_ART WHERE FK_Versie = $nieuwerijVersie AND FK_Taal = $nieuwerijTaal AND FK_Bedrijf = $nieuwerijBedrijf AND dbo.GetSimpleTag( Tag ) = '$origineleTag'";
						if( $debug ) { echo "Query: $query<br/>"; }
						$stmt = sqlsrv_query( $conn, $query );
						if( $stmt )
						{
							// Artikel gevonden! We gaan de link vervangen.
							$nieuwelinkrij = sqlsrv_fetch_array( $stmt );
							$nieuwartikelID =  $nieuwelinkrij['ArtikelID'];
				
							// Nieuwe link opbouwen
							$nieuwelink = "page.aspx?ID=".$nieuwartikelID;
								
							if( $debug OR $vervangenlinkstonen ){ echo "We vervangen '$lijstonbekendelinkstekstlinks[$counter]' met '$nieuwelink'.<br/>"; }
							$tekst = str_replace( $lijstonbekendelinkstekstlinks[$counter], $nieuwelink, $tekst, $count);
							$vervangenlinks += $count;	
				
						}
						else
						{
							echo "<strong>OPGELET! Het artikel van de nieuwe versie ( ID $nieuwerijVersie ) met de artikeltag  met ID $linklijst[$counter] kwam niet voor in de database! Links naar dit artikel zullen niet meer werken.</strong><br/>";
						}
					}
					else
					{
						echo "<strong>OPGELET! Het artikel met ID $linklijst[$counter] kwam niet voor in de database! Links naar dit artikel zullen niet meer werken.</strong><br/>";
					}
				
					set_time_limit(30);
				
				}
	
				//Artikel updaten in de database
	
				if( $linkswegschrijven )
				{
	
					//Dubbele haakjes veilig stellen
					$tekst = str_replace("''","DOBBELEHAAKJES",$tekst);
					//Enkele haakjes replacen om MSSQL te escapen
					$tekst = str_replace("'","''",$tekst);
					//Dubbele haakjes terugbrengen
					$tekst = str_replace("DOBBELEHAAKJES","''",$tekst);
	
					$artikelID = $row['ArtikelID'];
	
					$query = "UPDATE $TABEL_ART SET tekst = '$tekst' WHERE FK_taal = $CONST_TAALID AND FK_versie = $CONST_VERSIEID AND FK_bedrijf = $CONST_BEDRIJFID AND artikelID = $artikelID";
					if( $debug ) { echo "Query voor update van Artikel #$artikelID: $query<br/>"; }
					$stmt = sqlsrv_query( $conn, $query );
	
					if ( $stmt )
					{
						echo "Artikel #$artikelID geüpdatet.<br/>";
					}
					else
					{
						echo "Kon het artikel #$artikelID niet updaten!<br/>";
						die( print_r( sqlsrv_errors(), true));
					}
		
					set_time_limit(30);
				}
	
				if( $toonartikel ) { echo $tekst; }

				if( !$debug ) { echo "Vervangen links: $vervangenlinks.<br/><br/>"; }
			}
		}
		
		set_time_limit(150);
		
	}
	
	set_time_limit(300);
	
}

if( isset( $stmt ) )
{
	sqlsrv_free_stmt( $stmt );
	sqlsrv_free_stmt( $alleartikels );
}

//MSSQL connectie sluiten
include('inc\db_close.php');

?>