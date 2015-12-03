<div id="citation_visite_{$espece}" class="row">
  <div class="panel panel-success">
    <div class="panel-heading apercu">
      <h3 class="panel-title">{$espece_titre}</h3>
	<a href="#dt_{$espece}" class="apercu_btn btn btn-success glyphicon glyphicon-minus pull-right" style="margin-top:-2em"></a>

    </div>
    <div class="panel-body detail" style="display:block;margin-top:-0.5em;" id="dt_{$espece}">
      {assign var=age_titre value="Adulte"}
      {assign var=age value="ad"}
      {include file="_citation_visite_age.tpl" age_titre="Adultes" age="ad"}
      {include file="_citation_visite_age.tpl" age_titre="Jeunes" age="juv"}
      {include file="_citation_visite_age.tpl" age_titre="Jeunes morts" age="juvmorts"}
      {include file="_citation_visite_age.tpl" age_titre="Oeufs" age="oeuf"}
    </div>
  </div>
</div>
