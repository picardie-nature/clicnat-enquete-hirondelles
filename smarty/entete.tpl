<!DOCTYPE html>
<html {if $page} class="{$page}" {/if} lang="fr">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="{$url_statique}/bootstrap-3.3.4-dist/css/bootstrap.min.css"></link>
		<link rel="stylesheet" href="{$url_statique}/bootstrap-3.3.4-dist/css/bootstrap-theme.min.css"></link>
		{if $ie_nav}
     		 <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
     		 <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
		{/if}
		<link rel="stylesheet" href="{$url_statique}/font-awesome-4.3.0/css/font-awesome.min.css"></link>
		<link rel="stylesheet" href="{$url_statique}/jquery-ui-1.11.4/jquery-ui.min.css"></link>
		<link rel="stylesheet" href="{$url_statique}/OpenLayers-3.4.0/css/ol.css"></link>
		<link rel="stylesheet" href="{$url_statique}/jquery-ui-1.11.4/jquery-ui.css"></link>
		<link rel="stylesheet" href="style.css"></link>
		<link rel="stylesheet" href="http://www.clicnat.fr/css/logo.css"></link>
		<title>Hirondelles - Clicnat - {$page}</title>
	</head>
	<body>
	{foreach from=$alertes item=alerte}
		<div class="alert alert-{$alerte.classe}">{$alerte.message}</div>
	{/foreach}
