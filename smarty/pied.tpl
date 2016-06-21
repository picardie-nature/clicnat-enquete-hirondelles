		<div class="row pied_page shadow-5px-black fond-blanc navbar-fixed-bottom" id="bloc-bas">
		{if $txt_footer}
		<div class="col-sm-12 pull-center" style="text-align : center;">
			<p class="txt_footer">{$txt_footer}</p>
		</div>
		{/if}
		<div id="pied-cont">
		<div class="col-sm-2 pied">
			<ul>
				<li><a href="http://obs.picardie-nature.org/?page=cn" target="_blank">Charte de l'observateur</a></li>
				<li><a href="http://obs.picardie-nature.org/?page=ml" target="_blank">Mentions légales</a></li>
				<li><a href="http://www.picardie-nature.org" target="_blank">Picardie-Nature</a></li>
				<li><a href="http://www.fne.asso.fr" target="_blank">Membre de FNE</a></li>
			</ul>
		</div>
		<div class="col-sm-1">
			<div class="text-center">
				<a href="http://www.gnu.org"><img alt="AGPL V3" style="border-width:0; vertical-align:baseline; width:100%; max-width:200px" src="http://www.gnu.org/graphics/agplv3-155x51.png" /></a>
			</div>
		</div>
		<div class="col-sm-4 pied">
			<p><small><a href="http://www.picardie-nature.org/" target="_blank">Picardie Nature</a> est une association
			régionale de protection de la Nature et de l'Environnement en Picardie</small></p>
			<p style="margin-top : -.5em "><em><a href="http://www.clicnat.fr" alt="www.clicnat.fr" target="_blank">www.clicnat.fr</a>: La base de données régionale d'information sur la faune picarde</em></p>


		</div>
		<div class="col-sm-5 logos">
		<div class="pull-right">
			<div class="text-center">
				<div style="float:left; width:200px; font-size: 12px;">Les actions de Picardie Nature sont cofinancées par le FEDER dans le cadre du programme opérationnel FEDER-FSE pour la Picardie.</div>
				<a href="http://www.europa.eu" target="_blank" title="Union européenne"><div id="logo_europe" class="hoverscroll"></div></a>
			</div>
			<div class="text-center">

				<a href="http://www.picardie-europe.eu" target="_blank" title="Union européenne"><div id="logo_europe_eng" class="hoverscroll"></div></a>
			</div>
			<div class="text-center">
				<a href="http://www.developpement-durable.gouv.fr/" target="_blank"><div id="logo_dreal" class="hoverscroll"></div></a>
			</div>
			<div class="text-center">
				<a href="http://www.picardie.fr/" target="_blank"><div id="logo_cr" class="hoverscroll"></div></a>
			</div>
			<div class="text-center">
				<a href="http://www.cg02.fr" target="_blank"><div id="logo_cg02" class="hoverscroll"></div></a>
			</div>
			<div class="text-center">
				<a href="http://www.cg80.fr" target="_blank"><div id="logo_cg80" class="hoverscroll"></div></a>
			</div>
			<div class="text-center">
				<a href="http://www.amiens.fr" target="_blank"><div id="logo_amiens" class="hoverscroll"></div></a>
			</div>
		</div>
		</div>
		<div class="clearfix"></div>
	</div>
		</div>
		
		<script src="{$url_statique}/jquery/jquery-1.11.2.min.js"></script>
		<script src="{$url_statique}/bootstrap-3.3.4-dist/js/bootstrap.min.js"></script>
		<script src="{$url_statique}/OpenLayers-3.4.0/build/ol-debug.js"></script>
		<script src="{$url_statique}/jquery-ui-1.11.4/jquery-ui.min.js"></script>
		<script src="{$url_statique}/jquery/jquery.ui.datepicker-fr.js"></script>
		<script src="javascript.js"></script>
		<script>
			var utl = undefined;
			{if $utl}
			utl = {$utl->id_utilisateur};
			{/if}

			if (typeof(init_{$page}) == 'function')
			{literal}
			{
				var env = {
					utl: utl
				}

				$(document).ready(function () {
					{/literal}init_{$page}(env);{literal}
				});
			}
			{/literal}
		</script>
	</body>
</html>
