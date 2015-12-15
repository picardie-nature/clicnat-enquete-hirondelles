{include file="entete.tpl"}
{* modal ouverte pour la saisie des citations suite à une visite *}
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
<div class="modal fade" id="modal_succes" tabindex="-1" role="dialog" aria-labelledby="modal_succes" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">Observations enregistrées</h4>
			</div>
			<div class="modal-body">
				<div class="container-fluid" style="text-align:justify;">
					<p><b>Merci, vos observations sont bien enregistrées.</b></p>
					<p>Retrouvez l'historique complet en cliquant à nouveau sur ce point.</p>
					<p>Nous avons surtout besoin de vos observations aux moments clefs de la vie de la colonnie : <em>arrivée et départ des oiseaux, naissances et envol des jeunes...</em></p>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" data-accesskey="n"  class="close btn btn-danger" data-dismiss="modal" aria-label="Close">Fermer</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="modal_citations_visite" tabindex="-1" role="dialog" aria-labelledby="modal_citations_visite" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">À propos des nids occupés</h4>
			</div>
			<div class="modal-body">
				<div class="container-fluid">
					<form method="post" action="index.php?t=creer_citations_visite" id="ccv">
						<input type="hidden" name="id_visite_nid" id="id_visite_nid" value=""/>
						<div class="ccv_items" id="n_nid_occupe_f">{include file="_citation_visite.tpl" espece="fenetre" espece_titre="Hirondelle de fenêtre"}</div>
						<div class="ccv_items" id="n_nid_occupe_r">{include file="_citation_visite.tpl" espece="rustique" espece_titre="Hirondelle rustique"}</div>
						<div class="ccv_items" id="n_nid_occupe_ri">{include file="_citation_visite.tpl" espece="rivage" espece_titre="Hirondelle des rivages"}</div>
						<div style="clear:both;"></div>
						<div class="pull-right">
							<input type="hidden" name="id_observation_visite" id="id_observation_visite" value="">
							<input type="submit" class="btn btn-primary" value="Enregistrer les observations"/>
						</div>
						<div style="clear:both;"></div>
					</form>
				</div>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
{* modal ouverte pour l'enregistrement d'une nouvelle viste *}
<div class="modal fade" id="modal_nouvelle_visite" tabindex="-1" role="dialog" aria-labelledby="modal_label_nouvelle_visite" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">Enregister une nouvelle visite</h4>
				
			</div>
			<div class="modal-body">
				<div class="container-fluid">
					<form id="dnv" method="get" action="index.php?t=creer_visite_colonie">
						<input type="hidden" name="id_espace" id="id_espace_visite_colonie" value=""/>
						<div class="row">
							<div class="col-md-4">
								<div class="form-group">
									<label for="datepicker">Date de visite</label>
									<div id="datepicker"></div>
									<input type="hidden" name="date_visite_nid" id="date_visite_nid" value="">
								</div>
							</div>
							<div class="col-md-8">
								<div class="row">
									<div class="col-md-12">
										<h4>Nombre de nids occupés</h4>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4">
										<h5>Hirondelle rustique</h5>
										<input class="spinner" type="text" name="n_nid_occupe_r"/>
									</div>
									<div class="col-md-4">
										<h5>Hirondelle de fenêtre</h5>
										<input class="spinner" type="text" name="n_nid_occupe_f"/>

									</div>
									<div class="col-md-4">
										<h5>Hirondelle de rivage</h5>
										<input class="spinner" type="text" name="n_nid_occupe_ri"/>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<h4>Nombre de nids vides</h4>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4">
										<h5>Hirondelle rustique</h5>
										<input class="spinner" type="text" name="n_nid_vide_r"/>

									</div>
									<div class="col-md-4">
										<h5>Hirondelle de fenêtre</h5>
										<input class="spinner" type="text" name="n_nid_vide_f"/>
										</div>
									<div class="col-md-4">
										<h5>Hirondelle de rivage</h5>
										<input class="spinner" type="text" name="n_nid_vide_ri"/>
									</div>
								</div>
								<div class="row">
									<div class="col-md-12">
										<h4>Nombre de nids détruits</h4>
									</div>
								</div>
								<div class="row">
									<div class="col-md-4">
										<h5>Hirondelle rustique</h5>
										<input class="spinner" type="text" name="n_nid_detruit_r"/>

									</div>
									<div class="col-md-4">
										<h5>Hirondelle de fenêtre</h5>
										<input class="spinner" type="text" name="n_nid_detruit_f"/>
									</div>
									<div class="col-md-4">
										<h5>Hirondelle de rivage</h5>
										<input class="spinner" type="text" name="n_nid_detruit_ri"/>
									</div>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<h4>Commentaire sur l'observation</h4>
								<textarea placeholder="Exemples: nids présent depuis 10 ans, nid consolidé avec une planche il y a 5 ans et cela fonctionne ..." name="commentaire_observation"></textarea>
							</div>
						</div>
						<div class="row">
							<div class="pull-right">
								<input type="submit" class="btn btn-default btn-primary" value="Enregistrer l'observation de la colonie"/>
							</div>
						</div>
					</form>
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
<div class="modal fade" id="modal_nouveau_point" tabindex="-1" role="dialog" aria-labelledby="modal_label_nouveau_point" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">Signaler une nouvelle colonie d'hirondelles</h4>
			</div>
			<div class="modal-body">
				<form id="dnp" method="post" action="index.php?t=creer_point">
					<input type="hidden" name="x" value="" id="creer_point_x">
					<input type="hidden" name="y" value="" id="creer_point_y">
					<div class="form-group">
						<label>
							<input type="checkbox" name="occupant" value="1"/>
							Cochez cette case si vous habitez le batiment sur lequel se trouve(nt) le(s) nid(s)
						</label>
					</div>
					<div class="form-group">
						<label>
							<input type="checkbox" name="publique" checked=true value=1 />
							Décochez cette case si vous souhaitez que la
							localisation du nid ne soit pas rendue visible aux
							autres utilisateurs.
						</label>
					</div>
					<button type="submit" class="btn btn-default">Enregistrer cette nouvelle colonie</button>
				</form>
			</div>
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>
<div class="container-fluid main">
	<div class="row entete shadow-5px-black fond-blanc">

		<div class="col-xs-12 col-sm-8">
			<h1 class="pad-15px">Partagez et suivez vos observations de nids d'hirondelles</h1>
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
				<h3>Depuis juin 2015, {$nb_colonies}  colonies ont été enregistrées par {$nb_observateurs} observateurs</h3>
				<p>Le dernier enregistrement de colonies date du {$derniere_date}</p>

			</div>
				<div class="row boite-image-row">
				<ul class="polaroids">
			<li><a data-espece="Couple et jeunes au nid d'Hirondelle rustique en nid naturel"  href=""><img data-auteur="W. Mathot" data-loc="Margny sur matz (60)" src="images/Hr4.jpg" alt="Hirondelles rustiques Nid naturel" /></a></li>
			<li><a data-espece="Adulte d'Hirondelle de fênetre nourrissant ses jeunes en nid naturel"  href=""><img data-auteur="B. Tondellier" data-loc="Picardie" src="images/Hdf4.jpg" alt="Hirondelles de fenêtres Nid naturel" /></a></li>
			<li><a data-espece="Couple d'Hirondelle de rivage en nid naturel" href=""><img data-auteur="D. Adam" data-loc="Bourdon (80)" src="images/Hrv4.jpg" alt="Hirondelles de rivages Nid naturel" /></a></li>
			<li><a data-espece="Adulte d'Hirondelle rustique en nid naturel assez atypique" href=""><img data-auteur="P. Gracia" data-loc="Compiègne (60)" src="images/Hr5.jpg" alt="Hirondelles rustiques Nid artificiel" /></a></li>
			<li><a data-espece="Jeune d'Hirondelle de fênetre en nid arificiel" href=""><img data-auteur="S. Declercq" data-loc="Saint-Valery-sur-Somme (80)" src="images/Hdf5.jpg" alt="Hirondelles de fenêtres Nid artificiel" /></a></li>
		</ul>
		</div>	
	<!--	<div class="row boite-image-row">
		<div class="col-xs-0 col-sm-1">	</div>
		<div class="col-xs-6 col-sm-3 col-md-2">
			<div class="boite-image fond-blanc-60p">
				<h4 class="boite-image-titre">Hirondelles rustiques</h4>
				<img src="images/Hr4.jpg" />
				<div class="boite-image-legende fond-blanc-60p">
					<p>W. Mathot,Margny sur matz (60)</p>
				</div>
			</div>
		</div>
		<div class="col-xs-6 col-sm-3 col-md-2">
			<div class="boite-image fond-blanc-60p">
				<h4 class="boite-image-titre">Hirondelles des fenêtres</h4>
				<img src="images/Hdf4.jpg">
				<div class="boite-image-legende fond-blanc-60p">
					<p>B. Tondellier, Lieu inconnu</p>
				</div>
			</div>
		</div>
		<div class="col-xs-6 col-sm-3 col-md-2">
			<div class="boite-image fond-blanc-60p">
			<h4 class="boite-image-titre">Hirondelles des rivages</h4>
			<img src="images/Hrv4.jpg">
				<div class="boite-image-legende fond-blanc-60p">
					<p>D. Adam, Bourdon (80)</p>
				</div>
			</div>
		</div>
		<div class="col-xs-6 col-sm-3 col-md-2">
			<div class="boite-image fond-blanc-60p">
			<h4 class="boite-image-titre">Hirondelles rustiques</h4>
			<img src="images/Hr5.jpg">
				<div class="boite-image-legende fond-blanc-60p">
					<p>P. Gracia, Compiègne (60)</p>
				</div>
			</div>
		</div>
		<div class="col-xs-6 col-sm-3 col-md-2">
			<div class="boite-image fond-blanc-60p">
			<h4 class="boite-image-titre">Hirondelles des fenêtres</h4>
			<img src="images/Hdf5.jpg">
				<div class="boite-image-legende fond-blanc-60p">
					<p>S. Declercq, Saint-Valery-sur-Somme (80)</p>
				</div>
			</div>
		</div>

		</div>
-->

		</div>
		<div class="col-md-4 boite-accueil fond-blanc">
			<h3>Que représente la carte ?</h3>
			<p>Chaque point représente une colonie déjà renseignée par les observateurs en Picardie. Si vous connaissez un nid qui n'est pas indiqué sur la carte, nous vous invitons à le signaler.</p>
			<h3>Comment partager une observation pour une colonie déjà recensée ?</h3>
			<p>Une <b>colonie possède de un à plusieurs dizaines de nids</b>. Cliquez sur la colonie en question, et remplissez le formulaire qui apparait.</p>
			<p>Vous n'êtes pas sûr de l'espèce d'hirondelle concernée, rendez-vous sur <a href="http://www.clicnat.fr" alt="www.clicnat.fr"  target="_blank">www.clicnat.fr</a> pour mieux les connaître et les distinguer.</p>
			<h3>Comment signaler une nouvelle colonie (un ou pluieurs nids) ?</h3>
			<ul>
				<li>Renseignez le nom de la commune concernée dans le bloc texte en haut à gauche, ou zoomez sur la carte à l'aide des boutons « + » et « - ».</li>
				<li>Localisez le point le plus précisément possible en cliquant sur la carte: à l'angle de deux rues, sur un bâtiment ou une maison en particulier (cela est important pour le suivi et l'historique des nids). Pour cela aidez-vous de la photo aérienne.</li>
				<li>Renseignez le formulaire qui apparaît.</li>
			</ul>
			<p>Vous n'êtes pas sur de l'espèce d'hirondelle concernée, rendez-vous sur <a href="http://www.clicnat.fr" alt="www.clicnat.fr"  target="_blank">www.clicnat.fr</a> pour mieux les connaître et les distinguer.</p>
			<h3>Vigilances :</h3>
			<p>Une observation doit se faire dans le respect des animaux et des propriétés privées.</p>
			<ul>
			 	<li>Si le comptage des œufs ou des jeunes est impossible (pour l'Hirondelle de fenêtre et l'Hirondelle de rivage surtout), indiquez juste que le nid est occupé sans effectif</li>
				<li>Si la colonie se situe dans une propriété privée (non visible depuis l'espace public), demandez l'accès au propriétaire</li>
			 	<li>Ne vous mettez pas en danger pour réaliser un comptage (escabeau, échelle, rebord de fenêtre...) : l'information essentielle est de savoir si le nid est occupé par des jeunes.</li>
			</ul>
		</div>
	</div>
</div>
{include file="pied.tpl"}

