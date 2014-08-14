<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html"/>
  
  <xsl:template match="/">
	 <html>
      <body>
      	<style type="text/css">
* {font-family: "HelveticaNeue", "Helvetica Neue", "HelveticaNeueRoman", "HelveticaNeue-Roman", "Helvetica Neue Roman", Helvetica, Arial, 'Lucida Grande', Tahoma, sans-serif; font-size: 10pt; white-space: nowrap;}
h1 {font-size: 16pt;}
h2 {font-size: 13pt;}
th, td {vertical-align: top; text-align: left; line-height: 1.8; padding: 0 15px 0 5px;}
th {background: #ddd; padding: 3px 3px 0px 5px;}

tr:nth-child(even) {background: #f5f5f5;}
</style>
        <h1><xsl:text disable-output-escaping="yes"><![CDATA[Verk&auml;ufe &uuml;ber Stripe mit IHPayment]]></xsl:text></h1>
        
         <h2>Zusammenfassung</h2>
 		 <xsl:text disable-output-escaping="yes"><![CDATA[F&auml;llige &Uuml;berweisungssumme: ]]></xsl:text>
          <b><xsl:value-of select="sum(/transactions/transaction/Net)"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[ &euro;]]></xsl:text></b>
          
        <h2><xsl:text disable-output-escaping="yes"><![CDATA[Verk&auml;ufe]]></xsl:text></h2>
        
        <xsl:call-template name="transactionTable">
    		<xsl:with-param name="transactionNodes" select="/transactions/transaction[Type='Charge']"/>
 		 </xsl:call-template>
  
    	
    	<h2>Gutschriften</h2>
    	 <xsl:call-template name="transactionTable">
    		<xsl:with-param name="transactionNodes" select="/transactions/transaction[Type='Refund']"/>
 		 </xsl:call-template>
 		 
 		

      </body>
    </html>
  </xsl:template>
  
  <xsl:template name="transactionTable">
  	<xsl:param name="transactionNodes"/>
  	<table>
  		<tr>
  			<th>Datum</th>
  			<th>Stripe ID</th>
  			<th>Transaktion</th>
  			<th>Brutto</th>
			<th>Brutto EUR</th>
			<th><xsl:text disable-output-escaping="yes"><![CDATA[Stripe Geb&uuml;hr]]></xsl:text></th>
  		</tr>
  	 <xsl:apply-templates select="$transactionNodes"/>
  	 	<tr>
  			<td></td>
  			<td></td>
  			<td></td>
  			<td></td>
			<td> <b><xsl:value-of select="sum($transactionNodes/Net)"/><xsl:text disable-output-escaping="yes"><![CDATA[ &euro;]]></xsl:text></b></td>
			<td> <b><xsl:value-of select="sum($transactionNodes/Fees)"/><xsl:text disable-output-escaping="yes"><![CDATA[ &euro;]]></xsl:text></b></td>
  		</tr>
	</table>
  </xsl:template>
  
  <xsl:template match="transaction">
  	<tr>
    	<td><xsl:value-of select="Created"/></td>
        <td><xsl:value-of select="ID"/></td>
        <td><xsl:value-of select="Description"/></td>
		<td><xsl:value-of select="Amount"/><xsl:text><![CDATA[ ]]></xsl:text><xsl:value-of select="Currency"/></td>
		<td><xsl:value-of select="Net"/><xsl:text disable-output-escaping="yes"><![CDATA[ &euro;]]></xsl:text></td>
		<td><xsl:value-of select="Fees"/><xsl:text disable-output-escaping="yes"><![CDATA[ &euro;]]></xsl:text></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
