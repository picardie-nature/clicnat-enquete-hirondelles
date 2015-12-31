{include file="entete.tpl"}

<div class="modal fade" id="modal_login" tabindex="-1" role="dialog" aria-labelledby="modal_label_login" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="modal_label_login">Suivre les nids d'hirondelles</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline" id="dlogin" method="post" action="?t=login">
					<div class="form-group">
						<p>Pour participer à l'enquête il est nécessaire que vous possédiez un compte sur <a href="http://www.clicnat.fr" alt="www.clicnat.fr" >www.clicnat.fr</a>.</p>
						<p>Si vous possédez déjà un compte sur <a href="http://www.clicnat.fr" alt="www.clicnat.fr">www.clicnat.fr</a> utilisez -le et connectez vous.</p>
						<input type="text" name="clicnat_login" class="form-control" placeholder="Identifiant"/>
						<input type="password" name="clicnat_pwd" class="form-control" placeholder="Mot de passe"/>
						<button type="submit" class="btn btn-primary">Se connecter</button>
					</div>
					<div id="vue_progression_login"></div>
				</form>
				<br/>
				<button id="bnc" class="btn btn-primary">Je n'ai pas encore de compte sur <a href="http://www.clicnat.fr" alt="www.clicnat.fr"  style="color:white">www.clicnat.fr</a> : <b>en créer un</b></button>
				<a href="http://poste.obs.picardie-nature.org/" class="btn btn-warning" style="margin-top:10px">J'ai perdu mon mot de passe, <b>en redemander un</b></a>
				<div id="dnew" style="display:none;">
					<h4>Créer un nouveau compte</h4>
					<div class="row">
						<div class="col-md-6">
							<form method="post" action="?t=creer_compte" id="form_inscription">
								<div class="form-group">
									<label for="nnom">Nom</label>
									<input type="text" class="form-control" id="nnom" name="nom"/>
								</div>
								<div class="form-group">
									<label for="nprenom">Prénom</label>
									<input type="text" class="form-control" id="nprenom" name="prenom"/>
								</div>
								<div class="form-group">
									<label for="nmail">Adresse mail</label>
									<input type="text" class="form-control" id="nmail" name="email"/>
								</div>
								<button type="submit" class="btn btn-default">Créer le compte</button>
							</form>
						</div>
						<div class="col-md-6">
							<p>Dans quelques instants vous allez recevoir un email de confirmation. Dans ce message de
							confirmation vous trouverez un lien qui nous permettra de valider
							votre adresse email.</p>
							<div id="vue_progression_inscription"></div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
<div class="container-fluid main accueil">
	<div class="row entete shadow-5px-black fond-blanc">
		<div class="col-xs-12 col-sm-8">
			<h1 class="pad-15px">Enquête sur les hirondelles nichant en Picardie </h1>
		</div>
		<div class="col-xs-12 col-sm-4 pull-right">
		  {include file="__petit_menu.tpl"}
		</div>	
	</div>
	<div class="fond-accueil"></div>
	<div class="row row-contenu-first">
		<div class="col-md-8 text-center fond_accueil"></div>
		<div class="col-md-4 text-center boite-accueil fond-blanc">
		<div class="apercu">
			<h2 style="display:inline;text-align:justify">Les populations d'hirondelles ont<br>chuté de 50 %</h2> <p style="display:inline"> depuis les années 1990. Plusieurs raisons à cela : </p>
		</div>	
		<div class="detail" id="dt_pourquoi">
			<ul>
			  <li>La disparition drastique de leurs proies : molécules chimiques impactant les insectes, disparition de prairies pâturées ou fauchées, de friches, et autres zones naturelles riches en biodiversité.</li>
			  <li>La raréfaction des points d'eau et de boue pour maçonner le nid : par le comblement de mare.</li>
			  <li>La destruction directe de leurs nids sur les bâtiments : par raison esthétique ou suite à des travaux de réfection importants.</li>
			</ul>
			<p>D'autre part, les <b>hirondelles sont des oiseaux protégés par la loi</b> du 10 juillet 1976, art. L411-1 et suivants, du code de l'environnement ; toute destruction d’individu ou de nid est interdite sous peine de poursuites judiciaires.</p>
			<p><b>L'association Picardie Nature</b> agit depuis 1970 pour la <b>protection de la nature et de l'environnement</b> en Picardie.
			Mutualisant connaissance de la faune sauvage picarde avec expérience juridique pour une meilleure prise en compte de l'environnement, c'est tout naturellement que nous agissons dans des cas de destructions directes pour  informer sur les marches à suivre à respecter. Rendez-vous sur <a href="http://www.picardie-nature.org" alt="www.picardie-nature.org" target="_blank">www.picardie-nature.org</a></p>
			<p>Les Hirondelle rustique et hirondelle de fenêtre ont pour particularité de nicher au niveau des maisons, granges, écoles et autres bâtiments de notre quotidien. <b>Chaque picard est donc aux premières loges pour observer le retour de ces oiseaux</b> migrateurs chaque printemps.</p>
			<p>Parce que <b>l'observation et la protection de la nature est possible par tous</b>, Picardie Nature fait appel aux habitants de la région pour rassembler les informations sur les hirondelles et les protéger ensemble.</p>
			<p>Si vous constatez une destruction imminente, contactez le 03.62.72.22.59 (tapez 3 comme pour les chauves-souris).</p>
		</div>
					<a href="#dt_pourquoi" class="apercu_btn btn btn-success glyphicon glyphicon-plus"></a>
		
		</div>
	</div>
	<div class="row">
		<div class="col-md-8 text-center"></div>
		<div class="col-md-4 text-center boite-accueil fond-blanc">
		<div class="apercu">
			<a class="btn btn-primary btn-lg" href="?t=carte_nids">La carte des nids d'hirondelles</a>
			<h2>Consultez la carte de tous les nids d'hirondelles recensés</h2>
		<p>Une, puis deux, puis trois observations transmises... : c'est <b>grâce à vous qu'il est possible de réaliser cette carte</b> : elle évolue au fur et à mesure des informations envoyées. N'hésitez pas à la consulter régulièrement.</p>
		</div>
		<div class="detail" id="dt_carte">
			<p>Si vous connaissez un nid qui n'est pas indiqué, nous vous invitons à le signaler : pour cela aller vers « <a href="?t=carte_nids" alt="Trasmettez vos données">Partagez et suivez vos observations</a> ».</p>
		</div>
		<a href="#dt_carte" class="apercu_btn btn btn-success glyphicon glyphicon-plus"></a>
		</div>
	</div>
	<div class="row">
	<div class="col-md-8 text-center"></div>
	<div class="col-md-4 text-center boite-accueil fond-blanc" id="cell-suivre-hir">
	<div class="apercu">
		<a class="btn btn-primary btn-lg" {if !$utl} data-toggle="modal" data-target="#modal_login"{else} href="?t=choix_colonie" {/if}>Suivre les nids d'hirondelles</a>
		<h2>Partagez et suivez vos observations de nids d'hirondelles</h2>
		<p>L'objectif est d'obtenir une <b>carte précise de la localisation des nids d'hirondelles en Picardie</b> ainsi que des <b>informations sur l'occupation</b> qu'en ont les oiseaux.
			En transmettant vos observations de nids et/ou d'oiseaux au nid, nous pourrons :</p> 
	</div>
	<div class="detail" id="dt_suivi">
	
	<ul>
		  <li>Affiner notre connaissance sur le rythme de vie des hirondelles (début/fin de nidification, nombre de jeunes à l'envol)</li>
		  <li>Agir pour protéger des nids menacés de destruction</li>
		  <li>Agir pour réhabiliter des nids détruits</li>
		</ul>
		<p>Pour accéder à cette partie, il vous sera nécessaire d'avoir un compte (si vous possédez déjà un compte sur <a href="http://www.clicnat.fr" alt="www.clicnat.fr" target="_blank">www.clicnat.fr</a>, il fonctionne également ici).</p>
	</div>
	<a href="#dt_suivi" class="apercu_btn btn btn-success glyphicon glyphicon-plus"></a>


	</div>
</div>
</div>
{include file="pied.tpl"}
