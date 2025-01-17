#The function is to bring to the format understands zabbix
function convertto-encoding ([string]$from, [string]$to){
    begin{
        $encfrom = [system.text.encoding]::getencoding($from)
        $encto = [system.text.encoding]::getencoding($to)
    }
    process{
        $bytes = $encto.getbytes($_)
        $bytes = [system.text.encoding]::convert($encfrom, $encto, $bytes)
        $encto.getstring($bytes)
    }
}

#We define the variables for connecting to MS SQL. $uid и $pwd need to authenticate windows
$SQLServer = $(hostname.exe)
#$uid = "USER" 
#$pwd = "PASSWORD"

#Create a connection to MSSQL

If ($null -ne $uid) {
	#If windows authentication
	$connectionString = "Server = $SQLServer; User ID = $uid; Password = $pwd;"
} else {
	#If integrated authentication
	$connectionString = "Server = $SQLServer; Integrated Security = True;"
}

$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

#Create a request directly to MSSQL
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand  
$SqlCmd.CommandText = "SELECT name FROM  sysdatabases"
$SqlCmd.Connection = $Connection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) > $null
$Connection.Close()

#We get a list of databases. Write to the variable.
$basename = $DataSet.Tables[0]

#Parse and pass a list of databases in zabbix. In the last line need to display the database name without a comma at the end.
$idx = 1
write-host "{"
write-host " `"data`":[`n"
foreach ($name in $basename)
{
    if ($idx -lt $basename.Rows.Count)
        {
            $line= "{ `"{#DBNAME}`" : `"" + $name.name + "`" }," | convertto-encoding "cp866" "utf-8"
            write-host $line
        }
    elseif ($idx -ge $basename.Rows.Count)
        {
            $line= "{ `"{#DBNAME}`" : `"" + $name.name + "`" }" | convertto-encoding "cp866" "utf-8"
            write-host $line
        }
    $idx++;
}

 write-host
write-host " ]"
write-host "}"
