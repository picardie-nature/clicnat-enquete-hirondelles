<div id="citation_visite_{$espece}" class="row">
  <div class="panel panel-success">
    <div class="panel-heading">
      <h3 class="panel-title">{$espece_titre}</h3>
    </div>
    <div class="panel-body">
      {assign var=age_titre value="Adulte"}
      {assign var=age value="ad"}
      {include file="_citation_visite_age.tpl" age_titre="Adultes" age="ad"}
      {include file="_citation_visite_age.tpl" age_titre="Jeunes" age="juv"}
      {include file="_citation_visite_age.tpl" age_titre="Jeunes morts" age="juvmorts"}
      {include file="_citation_visite_age.tpl" age_titre="Oeufs" age="oeuf"}
    </div>
  </div>
</div>
