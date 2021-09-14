$ipAddress = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content #Read-Host -Prompt 'What is your IP?' #"101.113.146.186"
$subscription =  Read-Host -Prompt 'What is the name of your Azure subscription IP?' #"PAYG-AuctionsPlus"
$firewallRule =  Read-Host -Prompt 'Please enter a name or label for your firewall. If this name exists then the existing rule will be replaced with this.' #"Prem"

$jsonArray = az sql server list  --subscription $subscription --query '[].{name:name, group:resourceGroup}'
$data = $jsonArray | ConvertFrom-Json
foreach ($object in $data) {
	$group = $object.group
	$name = $object.name
	
	az sql server firewall-rule delete -n $firewallRule -s $name -g $group --subscription $subscription 
	az sql server firewall-rule create -n $firewallRule -s $name -g $group --subscription $subscription --start-ip-address $ipAddress  --end-ip-address $ipAddress 
}