<?php
		include('inc\db_open.php');

		$query1 = "SELECT * FROM tblArtikel WHERE artikelid = 15213;";
		$stmt1 = sqlsrv_query( $conn, $query1 );
		$row1 = sqlsrv_fetch_array( $stmt1 );
		
		$query2 = "SELECT * FROM tblArtikelFR_Test WHERE tag like '%SE13C1A%';";
		$stmt2 = sqlsrv_query( $conn, $query2 );
		$row2 = sqlsrv_fetch_array( $stmt2 );
		
		echo "OUD<br/><br/>";
		echo $row2['Tekst'];
		echo "<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>";
		echo "NIEUW<br/><br/>";
		echo $row1['Tekst'];
		
		include('inc\db_close.php');
?>