{include file="entete.tpl"}
<div class="modal fade" id="modal_login" tabindex="-1" role="dialog" aria-labelledby="modal_label_login" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="modal_label_login">Suivre les nids</h4>
			</div>
			<div class="modal-body">
				<form class="form-inline" id="dlogin" method="post" action="?t=login">
					<div class="form-group">
						<p>Pour participer il est nécessaire de posséder un compte.</p>
						<p>Si vous avez un compte Clicnat vous pouvez l'utiliser pour vous connecter.</p>
						<input type="text" name="clicnat_login" class="form-control" placeholder="Identifiant"/>
						<input type="password" name="clicnat_pwd" class="form-control" placeholder="Mot de passe"/>
						<button type="submit" class="btn btn-primary">Se connecter</button>
					</div>
					<div id="vue_progression_login"></div>
				</form>
				<br/>
				<button id="bnc" class="btn btn-primary">Je n'ai pas encore de compte</button>
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
							<p>Vous allez recevoir un email de confirmation. Dans ce message de
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
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12 fond-blanc-60p">
			<h1>Enquête hirondelles</h1>
			<p>Suivi des nids d'hirondelles</p>
		</div>
	</div>
	<div class="row">
		<div class="col-md-8 text-center"></div>
		<div class="col-md-4 text-center boite-accueil fond-blanc-60p" id="cell-suivre-hir">
			<a class="btn btn-primary btn-lg" data-toggle="modal" data-target="#modal_login">Suivre les hirondelles</a>
			<p>Noter les nids dont vous avez connaissance et suivez l'activité des hirondelles</p>
		</div>
	</div>
	<div class="row">
		<div class="col-md-8 text-center"></div>
		<div class="col-md-4 text-center boite-accueil fond-blanc-60p">
			<a class="btn btn-primary btn-lg" href="?t=carte">La carte des nids</a>
			<p>Découvrir où se trouve les autre nids d'hirondelles référencés</p>
		</div>
	</div>
</div>
{include file="pied.tpl"}
