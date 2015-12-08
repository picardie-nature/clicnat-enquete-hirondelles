{include file="entete.tpl"}
<div class="modal fade" id="modal_citations_visite" tabindex="-1" role="dialog" aria-labelledby="modal_citations_visite" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">À propos des nids occupés</h4>
				<p id="nom_commune"></p>
				
			</div>
			<div class="modal-body">
				<div class="container-fluid">				
					<div class="row">
						<div class="col-md-12">
							<h3>Historique des visites</h3>
							<table class="table">
								<thead class="historique">
									<tr>
										<th>Date</th>
										<th colspan="4">Nids d'hirondelles Rustique</th>
										<th colspan="4">Nids d'hirondelles de Fenêtre</th>
										<th colspan="4">Nids d'hirondelles de Rivage</th>
									</tr>
									<tr>
										<th></th>
										<th>occupé</th>
										<th>vide</th>
										<th>détruit</th>
										<th>jeunes</th>
										<th>occupé</th>
										<th>vide</th>
										<th>détruit</th>
										<th>jeunes</th>
										<th>occupé</th>
										<th>vide</th>
										<th>détruit</th>
										<th>jeunes</th>
									</tr>
								</thead>
								<tbody id="historique"></tbody>
							</table>
						</div>
					</div>

				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="modal_chargement" tabindex="-1" role="dialog" aria-labelledby="modal_chargement" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">Chargement en cours</h4>
			</div>
			<div class="modal-body">
				<div class="container-fluid">
					<div class="attente" id="indicateur_chargement">
						<p>Veuillez patienter.</p>
						<div class="progress">
  							<div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width:100%">
								<p>Chargement en cours</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
<div class="container-fluid main">


		<div class="row entete shadow-5px-black fond-blanc">
		<div class="col-xs-12 col-sm-8">
			<h1 class="pad-15px">Consultez la carte des nids d'hirondelles recensés</h1>
		</div>
		<div class="col-xs-12 col-sm-4 pull-right">
		  {include file="__petit_menu.tpl"}
		</div>
	</div>
	<div class="row row-contenu-first">
		<div class="col-md-8">
			<input type="text" id="auto_commune" placeholder="Rechercher une commune" class="marg-top-10px">
			<div id="map" style="width:100%; height: 400px;" class="fond-blanc-60p marg-top-10px"></div>
			<div class="row compte_colonie fond-blanc">
				<h3>Depuis juin 2015, {$nb_colonies} colonies ont été enregistrées par {$nb_observateurs} observateurs</h3>
				<p>Le dernier enregistrement de colonies date du {$derniere_date}</p>


			</div>
		</div>
		<div class="col-md-4 boite-accueil fond-blanc" style="margin-top:50px;">
			<p> Une, puis deux, puis trois observations transmises... : c'est <b>grâce à vous qu'il est possible de réaliser cette carte</b> : elle évolue au fur et à mesure des informations envoyées. N'hésitez pas à la consulter régulièrement.</p>
						<p>Chaque point représente une colonie déjà renseignée par un observateur en Picardie.</p>
			<p>Une colonie possède de une à plusieurs dizaines de nids.</p>
			<p>La taille des ronds dépend du nombre de colonies renseignées.</p>
			<p><b>Zoomez pour visualiser l'emplacement des colonies et les observations</b>.</p>
			<ul>
				<li>Si vous connaissez un nid qui n'est pas indiqué sur la carte, nous vous invitons à le signaler : pour cela aller vers « <a href="?t=choix_colonie" alt="Trasmettez vos données">Partagez et suivez vos observations</a> » depuis la <a href="?t=accueil">page d'accueil</a>.</li>
				<li>Si vous avez observé des oiseaux au niveau d'un ou plusieurs nids, nous vous invitons à transmettre votre observation : pour cela aller vers « <a href="?t=choix_colonie" alt="Trasmettez vos données">Partagez et suivez vos observations</a> » depuis la <a href="?t=accueil">page d'accueil</a>.</li>
			</ul>
		</div>
	</div>
	<div class="row boite-image-row">
<ul class="polaroids">
	<li><a data-espece="Adulte nourrisant ses jeunes Hirondelle rustique en nid naturel" href=""><img data-auteur="C. Derozier" data-loc="La Neuville-Roy (60)" src="images/Hr2.jpg" alt="Hirondelles rustiques Nid naturel" /></a></li>
			<li><a data-espece="Adultes nourrissant ses jeunes Hirondelle de fênetre en nids naturels" href=""><img data-auteur="M. Doublet" data-loc="Saint Germer La Poterie (60)" src="images/Hdf2.jpg" alt="Hirondelles de fenêtres Nid naturel" /></a></li>
			<li><a data-espece="Couple d'Hirondelle de rivage au nid naturel"  href=""><img data-auteur="R. LeCourtois-Nivart" data-loc="Grand-Rozoy (02)" src="images/Hrv2.jpg" alt="Hirondelles de rivages Nid naturel" /></a></li>
			<li><a data-espece="Nichée d'Hirondelle rustique en nid artificiel" href=""><img data-auteur="R. Jabouile" data-loc="Fitz-James (60)" src="images/Hr3.jpg" alt="Hirondelles rustiques Nid artificiel" /></a></li>
			<li><a data-espece="Adulte nourrisssant une jeune Hirondelle de fenêtre en nid artificiel"  href=""><img data-auteur="J.M. Dupont" data-loc="Villers sur Authie (80)" src="images/Hdf3.jpg" alt="Hirondelles de fenêtres Nid artificiel" /></a></li>
		</ul> 
		</div>
</div>
{include file="pied.tpl"}

