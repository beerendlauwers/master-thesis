<?php

// SQL file aanmaken
//$bestandsnaam = "SQLDUMP - ".date("d-m-Y H#i#s");
//$sql_file = fopen($bestandsnaam,"w+");



// Met MSSQL Connecten, root id ophalen
//include('inc\db_open.php');

// Define the query.
//$query = "INSERT INTO tblCategorie ( Categorie, Diepte, Hoogte, Fk_parent ) VALUES( 'root_node','-1','0',NULL);";

// Execute the query.
//$stmt = sqlsrv_query( $conn, $query );
/*
if ( $stmt )
{
	echo $query.'<br/>';
}
else 
{
	echo "Error in statement execution.\n";
	die( print_r( sqlsrv_errors(), true));
}
*/
// Root ID ophalen
/*
// Define the query.
$query = "SELECT CategorieID FROM tblCategorie WHERE Categorie = 'root_node'; ";

// Execute the query.
$stmt = sqlsrv_query( $conn, $query );

if ( $stmt )
{
	$row = sqlsrv_fetch_array( $stmt );
	$ROOT_ID = $row['CategorieID'];
	echo "ROOT_ID = $ROOT_ID.<br/>";
}
*/

$categorieID = 0;	// de categorieID van ROOT
$groteParent = 0;	// de categorieID van ROOT
$kleineParent = 0;	// de categorieID van ROOT
$groteParentTitel = "root_node";
$kleineParentTitel = "root_node";

$huidigeDiepte = 0;
$huidigeHoogte = 0;


// Open javascript.txt
$file = fopen("javascript.txt", 'r');

// Lees 1 lijn uit javascript.txt
while ( $lijn = fgets($file) )
{
	// Lijn cleanen
	$lijn = str_replace("d.add(","",$lijn);
	$lijn = str_replace(");","",$lijn);

	// Waardes uit lijn halen
	$waardes = explode( ",", $lijn );
	$waardes[3] = str_replace('"',"",$waardes[3]);
	$waardes[3] = trim($waardes[3]);


	if( $waardes[3] == "" ) // Dit is een categorie.
	{
		// Alle categoriewaardes eruit halen
		$categorieTitel = addslashes( trim(str_replace('"',"",$waardes[2])) );
		$groteParentUitLijn = addslashes( trim($waardes[1]) );
		$categorieID = addslashes( trim($waardes[0]) );
		
		if( $groteParent == 0 )
		{
			// Deze categorie is een kind van de hoofdcategorie.
			// We resetten de diepte.
			$groteParent = 0;
			$groteParentTitel = "root_node";
			$huidigeDiepte = 0;
			
			// We halen de juiste hoogte op voor de root en verhogen deze met 1.
			//$query = "SELECT MAX(Hoogte) FROM tblCategorie WHERE FK_parent = 1;";
			//$stmt = sqlsrv_query( $conn, $query );
			//$row = sqlsrv_fetch_array( $stmt );
			//$huidigeHoogte = $row[0];
			//$huidigeHoogte++;
			
			echo "<br/>We zijn terug naar de hoofdcategorie gegaan.<br/>";
		}
		elseif( $groteParent != $groteParentUitLijn )
		{
			// Omdat we één categorie dieper gaan gaan, wordt de huidige kleine parent de grote parent.
			
			// DEBUG
			echo "<br/>groteParentinJS: $groteParentinJS.<br/>";
			echo "kleineParentinJS: $kleineParentinJS.<br/>";
			
			$groteParent = $kleineParent;
			$groteParentTitel = $kleineParentTitel;
			
			$groteParentinJS = $kleineParentinJS;
			
			echo "<br/>De huidige grote parent is nu $groteParent ($groteParentTitel).<br/>";
			echo "In Javascript: $groteParentinJS.<br/>";
		}
		
		// We inserten de categorie.
		$query = "INSERT INTO tblCategorie ( Categorie, Diepte, Hoogte, Fk_parent) VALUES('$categorieTitel', $huidigeDiepte, $huidigeHoogte, $groteParent);";
		echo $query.'<br/>';
		
		/*
		$stmt = sqlsrv_query( $conn, $query );
		if ( $stmt )
		{
			echo $query.'<br/>';
		}
		else 
		{
			echo "Error in statement execution.\n";
			die( print_r( sqlsrv_errors(), true));
		}
		*/

		
		// Deze categorie wordt de huidige kleine parent voor artikels of categorieën die hierna komen.
		//$query = "SELECT CategorieID, Categorie FROM tblCategorie WHERE Categorie = '$categorieTitel'; ";
		//$stmt = sqlsrv_query( $conn, $query );
		//if ( $stmt )
		//{
			//$row = sqlsrv_fetch_array( $stmt );
			//$kleineParent = $row['CategorieID'];
			//$kleineParentTitel = $row['Categorie'];
			
			$kleineParent = $categorieID;
			
			// We zijn nu een categorie dieper gegaan, dus we zetten $huidigeHoogte terug op 0.
			//$huidigeHoogte = 0;
			
			// We zijn een categorie ingegaan, we gaan dus 1 niveau dieper
			//$huidigeDiepte++;
			
			echo "<br/>De huidige kleine parent is nu $kleineParent.<br/>";
		//}
		//else 
		//{
		//	echo "Error in statement execution.\n";
		//	die( print_r( sqlsrv_errors(), true));
		//}
	}
	// else // Dit is een artikel.
	// {
		// /*
		// // HTML-bestand openen
		// $bestand = "C:/wamp/www/javascript/AAAFRMN/".$waardes[3];

		// // Bestand uitlezen
		// $html_bestand = file_get_contents($bestand,'r');

		// // Titel eruit filteren
		// $re1 = '.*?';	# Non-greedy match on filler
		// $re2 = '(Welkom)';	# Word 1

		// if ($c=preg_match_all ("/".$re1.$re2."/is", $html_bestand, $matches))
		// {
			// $titel = $matches[1][0];
		// }

		// // Alles op 1 lijn plaatsen
		// $html_bestand = str_replace(array("\r\n", "\r", "\n"), ' ', $html_bestand); 
		// $hoofdlijn = trim($html_bestand);

		// // SQL-query opstellen
		// $query = "INSERT INTO artikel( naam,diepte,hoogte,fk_parent) VALUES(";
		// */
		
		// $artikelTag = $waardes[3];
		// $artikelTitel = addslashes( trim(str_replace('"',"",$waardes[2])) );
		// $artikelTekst = "test";
		
		// $query = "INSERT INTO artikel ( tag, tekst, titel, fk_categorie, fk_versie, fk_taal, fk_bedrijf ) VALUES( 'TAG_".$artikelTag."', '".$artikelTekst."', '".$artikelTitel."', ".$huidigeParent.",1,1,1 );";
		// echo $query.'<br/>';
		
				// if( $huidigeDiepte == 0 )
			// $huidigeHoogte0++;
		// elseif( $huidigeDiepte == 1 )
			// $huidigeHoogte1++;
		// elseif( $huidigeDiepte == 2 )
			// $huidigeHoogte2++;
		// elseif( $huidigeDiepte == 3 )
			// $huidigeHoogte3++;
		// elseif( $huidigeDiepte == 4 )
			// $huidigeHoogte4++;
		// else
		// {
			// echo "Wacht eens even, dit kan niet!";
			// exit;
		// }

	// }
	
}

// Sluit javascript.txt
fclose($file);

//MSSQL connectie sluiten
//include('inc\db_close.php');

?>