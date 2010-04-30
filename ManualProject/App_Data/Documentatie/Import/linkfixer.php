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

//Zet de zoekmodus aan of uit.
$enkelonbekendelinks = FALSE;

//Taalgerelateerde variabelen.
$CONST_TAALPREFIX = 'F';
$CONST_TAALID = 15;

$CONST_VERSIEID = 52;
$CONST_BEDRIJFID = 16;

// Testtabel
//$TABEL_ART = "tblArtikelTest";

// Met MSSQL Connecten, root id ophalen
include('inc\db_open.php');

if (!isset( $TABEL_ART )) { $TABEL_ART = "tblArtikel"; }

$query = "SELECT * from $TABEL_ART WHERE FK_taal = $CONST_TAALID AND FK_versie = $CONST_VERSIEID AND FK_bedrijf = $CONST_BEDRIJFID";
if( $debug ) { echo " $query <br/>"; }
$alleartikels = sqlsrv_query( $conn, $query );

if ( $alleartikels )
{
	$lijstonbekendelinks = array();
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
	if( !$enkelonbekendelinks ) { echo "Artikeltitel: $titel<br/>" ; }

	//Naar alle links in de tekst zoeken
	if( !$enkelonbekendelinks ) { echo "Lengte artikel: ".strlen($tekst)."<br/>"; }

	$aantalLinks = 0;
	$linklijst = array();
	$tevervangenlinklijst = array();
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
		
			//Checken of het wel een HTM of HTML bestand is
			$splitlink = explode( ".", $linkwaarde );
		
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

			//De uiteindelijke extensie.
			$extensie = $splitextensie[0];
		
			if( $debug ) { echo "De uiteindelijke extensie: $extensie<br/>"; }
		
			//Vergelijken en zo nodig opslaan
			if(  $extensie == "htm" OR $extensie == "html" OR $extensie == "HTM" OR $extensie == "HTML" )
			{
				// De eerste slash wegdoen
				if( substr( $splitlink[ sizeof($splitlink)-2 ], 0, 1 ) === "/" )
				{
					$eerstedeel = substr( $splitlink[ sizeof($splitlink)-2 ], 1 );
				}
				else
				{
					$eerstedeel = $splitlink[ sizeof($splitlink)-2 ];
				}
		
				//Nu even de taalprefix van de link wegdoen
				$gesplitsteTag = explode( "/", $eerstedeel );
					
				$databasezoektag = $eerstedeel;
				
				if( count( $gesplitsteTag ) == 2 )
				{
					//Eerst eens kijken of deze tag een uitzondering is.
					$isUitzondering = FALSE;
					
					if( $databasezoektag   == "DTA/FINAN" OR $databasezoektag   == "DTA/FRAME" )
						$isUitzondering = TRUE;
						
					$laatsteDeelTag = $gesplitsteTag[1];
			
					if( $debug ){ echo "Naamgedeelte van de tag: $laatsteDeelTag <br/>"; }
				
					if( $isUitzondering == FALSE )
					{
						if( strtoupper($laatsteDeelTag[0]) == $CONST_TAALPREFIX )
						{
							$laatsteDeelTag = substr( $laatsteDeelTag, 1);
							if( $debug ){ echo "Naamgedeelte na verwijderen prefix: $laatsteDeelTag <br/>"; }
							$databasezoektag = $gesplitsteTag[0].'_'.$laatsteDeelTag;
						}
					}
					else
					{
						$databasezoektag = $gesplitsteTag[0].'_'.$gesplitsteTag[1];
					}
				}
				else
				{
					if( $debug ){ echo "Naamgedeelte van de tag: $databasezoektag  <br/>"; }
			
					if( strtoupper($databasezoektag [0]) == $CONST_TAALPREFIX )
					{
						$databasezoektag = substr( $databasezoektag , 1);
						if( $debug ){ echo "Naamgedeelte na verwijderen prefix: $databasezoektag <br/>"; }
					}
				}
				
				if( $debug ){ echo "Deel waarop gezocht zal worden in de database: $databasezoektag  <br/>"; }
				if( $debug ){ echo "Deel dat vervangen zal worden: $linkwaarde <br/>"; }
				array_push( $linklijst, $databasezoektag.'.'.$extensie );
				array_push( $tevervangenlinklijst, $linkwaarde );
			}
		
			$offset = $tweedehaakje;	
		}
		else
		{
			if( !$enkelonbekendelinks ) { echo "Einde van de links. Totaal aantal links tegengekomen: $aantalLinks.<br/>"; }
		}
		
		set_time_limit(30);
}

	if( $debug ) { echo "<br/><br/>Links vervangen:<br/>"; }

	//Alle gevonden links vervangen met echte links

	$vervangenlinks = 0;

	for ( $counter = 0; $counter < count($linklijst); $counter++)
	{
		$query = "SELECT ArtikelID from $TABEL_ART WHERE FK_taal = $CONST_TAALID AND FK_versie = $CONST_VERSIEID AND FK_bedrijf = $CONST_BEDRIJFID AND tag LIKE '%".$linklijst[$counter]."%'";
	
		if( $debug ) { echo "Query voor $linklijst[$counter]: $query<br/>"; }
	
		$stmt = sqlsrv_query( $conn, $query );

		if ( $stmt )
		{
			$foundrow = sqlsrv_fetch_array( $stmt );
			$ID = $foundrow['ArtikelID'];
			
			if( $ID === NULL OR $ID=="" )
			{
				if( array_search( $linklijst[$counter], $lijstonbekendelinks ) === FALSE )
				{
					array_push( $lijstonbekendelinks, $linklijst[$counter] );
					$lijstonbekendelinkspaginas[ $linklijst[$counter] ] = "ID: ".$row['ArtikelID']."<br/>";
					continue;
				}
				else
				{
					$lijstonbekendelinkspaginas[ $linklijst[$counter] ] = $lijstonbekendelinkspaginas[ $linklijst[$counter] ]."ID: ".$row['ArtikelID']."<br/>";
				}
				
			}
		
			if( $debug ) { echo "Teruggekregen ID: $ID<br/>"; }
		
			$nieuwelink = "page.aspx?ID=".$ID;
		
			$count = 0;
			//Oude link vervangen met nieuwe link
			
			// Eerst nog even de anchors opsplitsen (want die dingen zijn handig)
			$anchorsplit = explode( "#", $tevervangenlinklijst[$counter] );
			if( count ($anchorsplit) == 2 )
			{
				// We willen enkel het eerste gedeelte vervangen, niet de anchor.
				$tevervangenlinklijst[$counter] = $anchorsplit[0];
			}
			
			if( $debug OR $vervangenlinkstonen ){ echo "We vervangen '$tevervangenlinklijst[$counter]' met '$nieuwelink'.<br/>"; }
			$tekst = str_replace( $tevervangenlinklijst[$counter], $nieuwelink, $tekst, $count);
			$vervangenlinks += $count;
		}
		else
		{
			if( array_search( $linklijst[$counter], $lijstonbekendelinks ) === FALSE )
			{
				array_push( $lijstonbekendelinks, $linklijst[$counter] );
				$lijstonbekendelinkspaginas[ $linklijst[$counter] ] = "ID: ".$row['ArtikelID']."<br/>";
			}
			else
			{
				$lijstonbekendelinkspaginas[ $linklijst[$counter] ] = $lijstonbekendelinkspaginas[ $linklijst[$counter] ]."ID: ".$row['ArtikelID']."<br/>";
			}
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

	if( !$enkelonbekendelinks ) { echo "Vervangen links: $vervangenlinks.<br/><br/>"; }
	

}

	if( $enkelonbekendelinks )
	{
		echo "<br/><br/>Lijst onbekende links:<br/>";
		for($i = 0; $i < count($lijstonbekendelinks); $i++)
		{
			echo $lijstonbekendelinks[$i].'<br/>';
			echo $lijstonbekendelinkspaginas[ $lijstonbekendelinks[$i] ].'<br/>';
		}
		if( count( $lijstonbekendelinks ) == 0 )
			echo 'Geen.<br/>';
	}

}

if( isset( $stmt ) )
{
	sqlsrv_free_stmt( $stmt );
	sqlsrv_free_stmt( $alleartikels );
}

//MSSQL connectie sluiten
include('inc\db_close.php');

?>