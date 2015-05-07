<div class="col-sm-6 col-md-3">
  <div class="well well-sm">
    <h4>{$age_titre}</h4>
    <input
      type="text"
      class="spinner_citation"
      name="nb_{$age}_{$espece}"
      {if $age == "juv"}
        title="ne pas inclure les jeunes morts"
      {/if}
    />
    <label for="nb_{$age}_{$espece}_ind">
      <input type="checkbox" name="nb_{$age}_{$espece}_ind" id="nb_{$age}_{$espece}_ind" value="1"/>
      effectif inconnu
    </label>
    <div class="clear:both;"></div>
    <textarea placeholder="commentaire" name="commentaire_{$age}_{$espece}"></textarea>
  </div>
</div>
