{include file="entete.tpl"}
{* modal ouverte pour la saisie des citations suite à une visite *}
<div class="modal fade" id="modal_citations_visite" tabindex="-1" role="dialog" aria-labelledby="modal_label_citations_visite" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title">À propos des nids occupés</h4>
			</div>
			<div class="modal-body">
				<div class="container-fluid">
					<form method="post" action="index.php?t=creer_citations_visite" id="ccv">
						<input type="text" name="id_visite_nid" id="id_visite_nid" value=""/>
						{include file="_citation_visite.tpl" espece="fenetre" espece_titre="Hirondelle de fenêtre"}
						{include file="_citation_visite.tpl" espece="rustique" espece_titre="Hirondelle rustique"}
						{include file="_citation_visite.tpl" espece="rivage" espece_titre="Hirondelle rustique"}
						<div style="clear:both;"></div>
						<div class="pull-right">
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
				<h4 class="modal-title">Enregister une visite sur une colonie</h4>
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
							<div class="pull-right">
								<input type="submit" class="btn btn-default btn-primary" value="Enregistrer la visite de la colonie"/>
							</div>
						</div>
					</form>
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
				<h4 class="modal-title">Enregister une colonie d'hirondelles</h4>
			</div>
			<div class="modal-body">
				<form id="dnp" method="get" action="index.php">
					<input type="hidden" name="t" value="creer_point">
					<input type="hidden" name="x" value="" id="creer_point_x">
					<input type="hidden" name="y" value="" id="creer_point_y">
					<div class="form-group">
						<label>
							<input type="checkbox" name="occupant" value="1"/>
							Cochez cette case si vous habitez le support
							sur lequel se trouve les nids
						</label>
					</div>
					<div class="form-group">
						<label>
							<input type="checkbox" name="publique" checked=true value=1 />
							Décochez cette case si vous souhaitez que la
							localisation du nid ne soient pas rendu visible aux
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
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12 fond-blanc-60p">
			<h1>Enquête hirondelles - trouver ou enregistrer une nouvelle colonie</h1>
			<p></p>
		</div>
	</div>
	<div class="row">
		<div class="col-md-8">
			<input type="text" id="auto_commune" placeholder="Rechercher une commune">
			<div id="map" style="width:100%; height: 400px;" class="fond-blanc-60p"></div>
		</div>
		<div class="col-md-4 fond-blanc">
			{texte nom="hirondelles/explications_carte"}
		</div>
	</div>
</div>
{include file="pied.tpl"}
