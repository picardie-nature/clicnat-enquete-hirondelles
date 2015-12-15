<div class="col-sm-6 col-md-3">
  <div class="well well-sm">
    <h4>{$age_titre}</h4>
    <div class ="row row_nbs">
    <p class="info_effectif nbs_{$age}_{$espece}_m">Min</p>
    <p class="info_effectif nbs_{$age}_{$espece}_m">Max</p>
    <input
      type="text"
      class="spinner_citation "
      id="nb_{$age}_{$espece}"
      name="nb_{$age}_{$espece}"
      {if $age == "juv"}
        title="ne pas inclure les jeunes morts"
      {/if}
    />

   <input
      type="text"
      class="spinner_citation spinner_nbs"
      id = "nbs_{$age}_{$espece}"
      name="nbs_{$age}_{$espece}"
      {if $age == "juv"}
        title="ne pas inclure les jeunes morts"
      {/if}
    />
    </div>
    <label for="nb_{$age}_{$espece}_ind">
      <input type="checkbox" class="nb_inconnu" name="nb_{$age}_{$espece}_ind" id="nb_{$age}_{$espece}_ind" value="1"/>
     Il y en a, mais l'effectif précis est inconnu 
    </label>
    <!--
    <label for="nbs_{$age}_{$espece}_ind">    
    <input type="checkbox" class="nbs_ind" name="nbs_{$age}_{$espece}_ind" id="nbs_{$age}_{$espece}_ind" value="1"/>
     fourchette
     </label>
     -->
    <div class="clear:both;"></div>
    <textarea placeholder="commentaire" name="commentaire_{$age}_{$espece}"></textarea>
  </div>
</div>
