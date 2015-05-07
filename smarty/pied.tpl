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
