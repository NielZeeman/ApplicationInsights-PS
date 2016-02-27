####################
# Dabling in creating a powershell client for application inshgts
# Use at own risk...
# Author : Niel Zeeman
####################

[string]$TelemetryEndPoint = "https://dc.services.visualstudio.com/v2/track"
[string]$TelemetryKey = "0d3c13e3-40d2-4165-80ac-4e0e7c16ab5d";

#some randomly identyfying information -  this must be unique per session / client
[string]$accountId = "D8B4B0EC-D0AD-46DA-AF34-C49FD9DEB8E0"; 
[string]$authUserId = "76F37807-566A-489D-9A7A-B4375F125F85" #

function PostTelemetry($postData){
	
	$headers = @{
	 Accept = "application/json";
	};

	$json = ConvertTo-Json -InputObject $postData -Depth 5

	$errors = Invoke-WebRequest -Uri $TelemetryEndPoint -Method Post -ContentType "application/json; charset=utf-8" -Headers $headers -Body $json
		
	Write-Verbose $errors
}


function TrackEvent($name, $properties = @{}, $measures = @{}){
	
	
	$envelope = @{
		iKey = $TelemetryKey
		name = "Microsoft.ApplicationInsights.Event";
		time = ((get-date).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ss.fffZ");
		tags = @{
			'ai.internal.sdkVersion' = "PowerShell:0.0.1";
			'ai.user.accountId' = $accountId;
			'ai.user.authUserId' = $authUserId;
		};
		data = @{
			baseType = "EventData";
			baseData = @{
				ver = 2;
				name = $name;
				measurements = $measures;
				properties =  $properties;
			};
		};
	}

	PostTelemetry($envelope);
}
