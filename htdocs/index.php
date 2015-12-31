<?php
$start_time = microtime(true);
$context = 'hirondelles';

if (file_exists('config.php'))
	require_once('config.php');
else
	require_once('/etc/baseobs/config.php');

if (!defined('LOCALE'))
	define('LOCALE', 'fr_FR.UTF-8');
if (!defined('SMARTY_TEMPLATE_HIRONDELLES'))
	define('SMARTY_TEMPLATE_HIRONDELLES', 'path_to_templates');
if (!defined('SMARTY_COMPILE_HIRONDELLES'))
	define('SMARTY_COMPILE_HIRONDELLES', '/tmp/hirondelles_cpl');
if (!defined('SMARTY_CACHEDIR_HIRONDELLES'))
	define('SMARTY_CACHEDIR_HIRONDELLES', '/tmp/hirondelles_cache');
if (!defined('URL_STATIQUE'))
	define('URL_STATIQUE', 'http://hyla.picardie-nature.org:8080/~nicolas/statique/');
if (!defined('HIRONDELLES_MAIL_SUPPORT'))
	define('HIRONDELLES_MAIL_SUPPORT', 'hirondelles@picardie-nature.org');
if (!defined('CLICNAT_HIRONDELLE_ID_TAG_PUBLIQUE'))
	define('CLICNAT_HIRONDELLE_ID_TAG_PUBLIQUE', 631);
if (!defined('CLICNAT_HIRONDELLE_TAG'))
	define('CLICNAT_HIRONDELLE_TAG', 629);
if (!defined('CLICNAT_HIRONDELLE_ID_TAG_OCCUPANT'))
	define('CLICNAT_HIRONDELLE_ID_TAG_OCCUPANT', 630);
if (!defined('CLICNAT_HIRONDELLE_ID_ESPECE_RUSTIQUE'))
	define('CLICNAT_HIRONDELLE_ID_ESPECE_RUSTIQUE', 725);
if (!defined('CLICNAT_HIRONDELLE_ID_ESPECE_FENETRE'))
	define('CLICNAT_HIRONDELLE_ID_ESPECE_FENETRE', 387);
if (!defined('CLICNAT_HIRONDELLE_ID_ESPECE_RIVIERE'))
	define('CLICNAT_HIRONDELLE_ID_ESPECE_RIVIERE', 815);

require_once(SMARTY_DIR.'Smarty.class.php');
require_once(OBS_DIR.'element.php');
require_once(OBS_DIR.'espece.php');
require_once(OBS_DIR.'utilisateur.php');
require_once(OBS_DIR.'smarty.php');
require_once(OBS_DIR.'espace_hirondelle.php');


class Hirondelles extends clicnat_smarty {
	protected $db;

	public function __construct($db) {
		setlocale(LC_ALL, LOCALE);
		parent::__construct($db, SMARTY_TEMPLATE_HIRONDELLES, SMARTY_COMPILE_HIRONDELLES, null, SMARTY_CACHEDIR_HIRONDELLES);
	}

	public function template() {
		return isset($_GET['t'])?trim($_GET['t']):'accueil';
	}

	public function before_colonie_details() {
		$colonie = new clicnat_espace_hirondelle($this->db, (int)$_GET['id']);
		$id_espace_commune = $colonie->get_commune()->id_espace;
		$ret = [
			"id_colonie" => $colonie->id_espace,
			"id_utilisateur" => $colonie->id_utilisateur,
			"nom_commune" => $colonie->get_commune()->nom,
			"id_espace" =>$colonie->get_commune()->id_espace,
			"citations_commune" => $this->compte_colonie($id_espace_commune),
			"visites" => []
		];
		$p = 0;
		foreach ($colonie->visites() as $visite) {
			$nb_jeunes = $visite->nb_jeunes();
			$ret['visites'][] = [
				'date_visite_nid' => $visite->date_visite_nid,
				'n_nid_occupe_r' => $visite->n_nid_occupe_r,
				'n_nid_vide_r' => $visite->n_nid_vide_r,
				'n_nid_detruit_r' => $visite->n_nid_detruit_r,
				'n_jeunes_r' =>$nb_jeunes['nb_j_r'],
				'n_nid_occupe_ri' => $visite->n_nid_occupe_ri,
				'n_nid_vide_ri' => $visite->n_nid_vide_ri,
				'n_nid_detruit_ri' => $visite->n_nid_detruit_ri,
				'n_jeunes_ri' =>""+ $visite->nb_jeunes()['nb_j_ri'],
				'n_nid_occupe_f' => $visite->n_nid_occupe_f,
				'n_nid_vide_f' => $visite->n_nid_vide_f,
				'n_nid_detruit_f' => $visite->n_nid_detruit_f,
				'n_jeunes_f' =>""+ $visite->nb_jeunes()['nb_j_f'],
				'id_visite_nid' => $visite->id_visite_nid
			];
		}
		$this->header_json();
		echo json_encode($ret);
		exit(0);
	}

	public function before_creer_citations_visite() {
		$this->header_json();
		try {
			$_POST['id_visite_nid'] = (int)$_POST['id_visite_nid'];
			$visite = new clicnat_visite_espace_hirondelle($this->db, $_POST['id_visite_nid']);
			if (!$visite)
				throw new Exception("pas trouvé de viste avec cet idendifiant : {$_POST['id_visite_nid']}");
			$observation = [
				'datedeb' => $visite->date_visite_nid,
				'datefin' => $visite->date_visite_nid,
				'id_utilisateur' => $_SESSION['id_utilisateur'],
				'table_espace' => 'espace_point',
				'id_espace' => $visite->id_espace
			];
			$id_observation = isset($_POST['id_observation_visite']) ? $_POST['id_observation_visite'] : bobs_observation::insert($this->db, $observation)  ;
			$retour = [
				"citations" => [],
				"id_observation" => $id_observation
			];
			$observation = get_observation($this->db, $id_observation);
			$observation->ajoute_tag(CLICNAT_HIRONDELLE_TAG, $visite->id_visite_nid, "visite_espace_hirondelle.id_visite");
			$observation->add_observateur($_SESSION['id_utilisateur']);

			$ages = [
				"ad" => "AD",
				"juv" => "JUV",
				"juvmorts" => "JUV",
				"oeuf" => "P"
			];
			$especes = [
				"fenetre" => CLICNAT_HIRONDELLE_ID_ESPECE_FENETRE,
				"rustique" => CLICNAT_HIRONDELLE_ID_ESPECE_RUSTIQUE,
				"rivage" => CLICNAT_HIRONDELLE_ID_ESPECE_RIVIERE
			];
			foreach ($especes as $e_champ => $id_espece) {
				foreach ($ages as $a_champ => $age_clicnat) {
					if (!empty($_POST["nb_{$a_champ}_{$e_champ}"]) or (isset($_POST["nb_{$a_champ}_{$e_champ}_ind"]) and($_POST["nb_{$a_champ}_{$e_champ}_ind"] == 1))) {
						if (isset($_POST["nb_{$a_champ}_{$e_champ}_ind"]) && $_POST["nb_{$a_champ}_{$e_champ}_ind"] == 1)
							$nb = 0;
						else
							$nb = (int)$_POST["nb_{$a_champ}_{$e_champ}"];
						$id_citation = $observation->add_citation($id_espece);
						$retour['citations'][] = $id_citation;
						$citation = get_citation($this->db, $id_citation);
						$citation->set_age($age_clicnat);
						if ($a_champ == "juvmorts") {
							$citation->ajoute_tag(70); // mort
						}
						if (!empty($_POST["commentaire_{$a_champ}_{$e_champ}"]) && $_POST["commentaire_{$a_champ}_{$e_champ}"] != ""){
							bobs_element::cls($_POST["commentaire_{$a_champ}_{$e_champ}"]);
							$citation->ajoute_commentaire("info",  $_SESSION['id_utilisateur'],htmlentities($_POST["commentaire_{$a_champ}_{$e_champ}"],ENT_COMPAT,'UTF-8'), true);
						}
						if ( (int)$_POST["nbs_{$a_champ}_{$e_champ}"] > -1 &&  (int)$_POST["nbs_{$a_champ}_{$e_champ}"] != $nb ){
							bobs_element::cli($_POST["nbs_{$a_champ}_{$e_champ}"]);
							$eff_min = min($nb,$_POST["nbs_{$a_champ}_{$e_champ}"]);
							$eff_max = max($nb,$_POST["nbs_{$a_champ}_{$e_champ}"]);
							$citation->set_effectif_min_max($eff_min, $eff_max);
						}
						else $citation->set_effectif($nb);
						$citation->ajoute_tag(CLICNAT_HIRONDELLE_TAG, $visite->id_visite_nid, "visite_espace_hirondelle.id_visite");
					}
				}
			}
			$observation->send();
			$retour['etat'] = 'ok';
		} catch (Exception $e) {
			$retour['etat'] = 'err';
			$retour['message'] = $e->getMessage();
		}
		echo json_encode($retour);
		exit(0);
	}

	public function before_creer_visite_colonie() {
		$this->header_json();
		$visite = [
			"id_espace" => $_POST['id_espace'],
			"n_nid_occupe_r" => $_POST['n_nid_occupe_r'],
			"n_nid_vide_r" => $_POST['n_nid_vide_r'],
			"n_nid_detruit_r" => $_POST['n_nid_detruit_r'],
			"n_nid_occupe_f" => $_POST['n_nid_occupe_f'],
			"n_nid_vide_f" => $_POST['n_nid_vide_f'],
			"n_nid_detruit_f" => $_POST['n_nid_detruit_f'],
			"n_nid_occupe_ri" => $_POST['n_nid_occupe_ri'],
			"n_nid_vide_ri" => $_POST['n_nid_vide_ri'],
			"n_nid_detruit_ri" => $_POST['n_nid_detruit_ri'],
			"id_utilisateur" => $_SESSION['id_utilisateur'],
			"date_visite_nid" => $_POST['date_visite_nid']
		];
		try {
			$id_visite = clicnat_visite_espace_hirondelle::insert(
				$this->db,
				clicnat_visite_espace_hirondelle::table,
				$visite
			);
			$visite = new clicnat_visite_espace_hirondelle($this->db, $id_visite);
				$observation = [
				'datedeb' => $visite->date_visite_nid,
				'datefin' => $visite->date_visite_nid,
				'id_utilisateur' => $_SESSION['id_utilisateur'],
				'table_espace' => 'espace_point',
				'id_espace' => $visite->id_espace
			];
			$id_observation = bobs_observation::insert($this->db, $observation);
			$observation = get_observation($this->db,$id_observation);
			$visite->observation_ajouter($observation);
			if($espace = clicnat_iterateur_visites_espace_hirondelle::from_session($this->db,$visite->id_espace)){
				$espace->ajout_id($id_visite);
				$espace->to_session();
			}
			if (isset($_POST['commentaire_observation']) && $_POST['commentaire_observation'] != ""){
				$observation->ajoute_commentaire("info",$_SESSION['id_utilisateur'],htmlentities($_POST['commentaire_observation'],ENT_COMPAT,'UTF-8'));
			}
			/***  Ajoute la citation si les nids sont vide ou detruit
			 *
			 **/
			foreach ($_POST as $key => $value){
				$espece = false;
				$effectif = false;
				switch ($key){
				case 'n_nid_vide_r' :
					if( $value > 0){
						$espece = CLICNAT_HIRONDELLE_ID_ESPECE_RUSTIQUE;
						$effectif = 0;
					}
					break;
				case 'n_nid_vide_ri' :
					if ( $value > 0 ){
						$espece = CLICNAT_HIRONDELLE_ID_ESPECE_RIVIERE;
						$effectif = 0;
					}
					break;
				case 'n_nid_vide_f' :
					if ( $value > 0){
						$espece = CLICNAT_HIRONDELLE_ID_ESPECE_FENETRE;
						$effectif = 0;
					}
					break;
				case 'n_nid_detruit_r' :
					if( $value > 0){
						$espece = CLICNAT_HIRONDELLE_ID_ESPECE_RUSTIQUE;
						$effectif = -1;
					}
					break;
				case 'n_nid_detruit_ri' :
					if ( $value > 0){
						$espece = CLICNAT_HIRONDELLE_ID_ESPECE_RIVIERE;
						$effectif = -1;
					}
					break;
				case 'n_nid_detruit_f' :
					if ( $value > 0){
						$espece = CLICNAT_HIRONDELLE_ID_ESPECE_FENETRE;
						$effectif = -1;
					}
					break;
				}
				if ( $espece && $effectif !== false ){
					$id_citation = $observation->add_citation($espece);
					$citation = get_citation($this->db, $id_citation);
					$citation->set_effectif($effectif);
					$citation->ajoute_tag(CLICNAT_HIRONDELLE_TAG, $id_visite, "visite_espace_hirondelle.id_visite");
				}
			}
		} catch (Exception $e) {
			echo json_encode(["etat" => "err", "message" => $e->getMessage()]);
			exit(0);
		}
		echo json_encode([
				"etat" => "ok",
				"id_visite_nid" => $visite->id_visite_nid,
				"date_visite_nid" => $visite->date_visite_nid,
				"n_nid_occupe_r" => $_POST['n_nid_occupe_r'],
				"n_nid_occupe_f" => $_POST['n_nid_occupe_f'],
				"n_nid_occupe_ri" => $_POST['n_nid_occupe_ri'],
				"id_observation" => $id_observation

		]);
		exit(0);
	}

	public function before_creer_compte() {
		$this->header_json();
		try {
			$preinscription = new bobs_utilisateur_preinscription();
			$preinscription->set_vars($_POST);

			$sujet_tpl = clicnat_textes::par_nom($this->db, "hirondelles/mail_inscription_sujet")->texte;
			$texte_tpl = clicnat_textes::par_nom($this->db, "hirondelles/mail_inscription")->texte;

			$vars = [
				"mail_support" => HIRONDELLES_MAIL_SUPPORT,
				"base_url" => 'http://hyla.picardie-nature.org/~nicolas/hirondelles/'
			];
			$preinscription->sauve_et_envoi_mail_tpl($sujet_tpl, $texte_tpl, $vars);
		} catch (Exception $e) {
			echo json_encode(["etat" => "err", "message" => $e->getMessage()]);
			exit(0);
		}
		echo json_encode(["etat" => "ok"]);
		exit(0);
	}

	public function before_creer_point() {
		$this->header_json();
		try {
			if (empty($_POST['x']) || empty($_POST['y']))
				throw new Exception("pas de coordonnées x,y");
			$point = [
				'x' => $_POST['x'],
				'y' => $_POST['y'],
				'nom' => '',
				'reference' => '',
				'id_utilisateur' => $_SESSION['id_utilisateur']
			];
			$id_espace = bobs_espace_point::insert($this->db, $point);
			$point = new clicnat_espace_hirondelle($this->db, $id_espace);
			$point->ajoute_tag(CLICNAT_HIRONDELLE_TAG);

			if (isset($_POST['occupant'])) {
				$point->ajoute_tag(CLICNAT_HIRONDELLE_ID_TAG_OCCUPANT);
			}

			if (isset($_POST['publique'])) {
				$point->ajoute_tag(CLICNAT_HIRONDELLE_ID_TAG_PUBLIQUE);
			}
			if($espaces = clicnat_iterateur_espace_hirondelle::from_session($this->db,$_SESSION["id_utilisateur"])){
				$espaces->ajout_id($id_espace);
				$espaces->to_session();
			}
			echo json_encode(["etat" => "ok", "id_espace" => $id_espace]);
		} catch (Exception $e) {
			echo json_encode(["etat" => "err", "message" => $e->getMessage()]);
		}
		exit(0);
	}

	public function before_geojson_points() {
		$this->header_json();
		echo json_encode(clicnat_iterateur_espace_hirondelle::geojson($this->db, get_utilisateur($this->db, $_SESSION['id_utilisateur'])));
	exit(0);
	}

	public function before_login() {
		$this->header_json();
		try {
			$utilisateur = bobs_utilisateur::by_login($this->db, trim($_POST['clicnat_login']));
			if (!$utilisateur) {
				$_SESSION['id_utilisateur'] = false;
				throw new Exception("Nom d'utilisateur ou mot de passe incorrect");
			} else {
				if (!$utilisateur->auth_ok(trim($_POST['clicnat_pwd']))) {
					$_SESSION['id_utilisateur'] = false;
					throw new Exception("Nom d'utilisateur ou mot de passe incorrect");
				} else {
					$_SESSION['id_utilisateur'] = $utilisateur->id_utilisateur;
				}
			}
		} catch (Exception $e) {
			echo json_encode(["etat" => "err", "message" => $e->getMessage()]);
			exit(0);
		}
		echo json_encode(["etat" => "ok"]);
		exit(0);
	}

	public function before_inscription() {
		try {
			$preinscription = bobs_utilisateur_preinscription::reprise($_GET['suivi']);
			$preinscription->creation_compte($this->db, $base_url, HIRONDELLES_MAIL_SUPPORT, $signature);
		} catch (Exception $e) {
			$this->ajoute_alerte('danger', "Il y a eu un problème : {$e->getMessage()}");
			$this->redirect("?t=accueil");
		}
		$this->ajoute_alerte('info', "Votre compte vient d'être activé, vous allez recevoir vos identifiants dans votre boite mail");
		$this->redirect("?t=accueil");
	}

	public function before_accueil() {
		if (isset($_POST['clicnat_login']) && isset($_POST['clicnat_pwd'])) {
			$utilisateur = bobs_utilisateur::by_login($this->db, trim($_POST['clicnat_login']));
			if (!$utilisateur) {
				$_SESSION['id_utilisateur'] = false;
				$this->ajoute_alerte('danger', "Nom d'utilisateur ou mot de passe incorrect");
			} else {
				if (!$utilisateur->acces_chiros) {
					$_SESSION['id_utilisateur'] = false;
					$this->ajoute_alerte('danger', "Accès réservé aux membres du réseau Chiros");
				} else {
					if (!$utilisateur->auth_ok(trim($_POST['clicnat_pwd']))) {
						$_SESSION['id_utilisateur'] = false;
						$this->ajoute_alerte('danger', "Nom d'utilisateur ou mot de passe incorrect");
					} else {
						$_SESSION['id_utilisateur'] = $utilisateur->id_utilisateur;
						$this->ajoute_alerte('success', "Connexion réussie");
					}
				}	
			}
			$this->redirect('?t=accueil');
		} else {
			if (isset($_GET['fermer'])) {
				$_SESSION['id_utilisateur'] = false;
				session_destroy();
				$this->ajoute_alerte('info', 'Vous êtes maintenant déconnecté');
				$this->redirect('?t=accueil');
			}
			if (isset($_GET['acces'])){
				if(!$GET['acces'])
					$this->ajoute_alerte('warning', 'Vous devez être connecté pour accéder à cette partie');
			}
		}
		$this->assign('txt_footer', 'Cette enquête concerne uniquement les nids d\'hirondelles (utilisés ou non, détruits ou non) : <a href="http://obs.picardie-nature.org/?page=fiche&id=387" title="fiche espece hirondelle de fenêtre sur picardie-nature.org"  target="_blank"><b>Hirondelle de fenêtre</b></a>, <a href="http://obs.picardie-nature.org/?page=fiche&id=725" title="fiche espece hirondelle rustique sur picardie-nature.org"  target="_blank"><b>Hirondelle rustique</b></a> et <a href="http://obs.picardie-nature.org/?page=fiche&id=815" title="fiche espece hirondelle de rivage sur picardie-nature.org"  target="_blank"><b>Hirondelle de rivage</b></a>. Pour toute observation en dehors d\'une colonie, reportez-vous au site internet  <a href="http://www.clicnat.fr" alt="www.clicnat.fr"  target="_blank">www.clicnat.fr</a>.');

	}


	public function before_choix_colonie() {
		if(isset($_SESSION['id_utilisateur'])){
			$utilisateur = get_utilisateur($this->db, $_SESSION['id_utilisateur']);
		}else throw new Exception('vous devez être identifié');
	}
	public function before_carte_nids() {
		if(isset($_SESSION['id_utilisateur'])){
			$utilisateur = get_utilisateur($this->db, $_SESSION['id_utilisateur']);
		}else throw new Exception('vous devez être identifié');
	}
	// page image
	public function before_img(){
		$this->assign('auteur', $_GET['auteur']);
		$this->assign('espece', $_GET['espece']);
		$this->assign('lieu', $_GET['lieu']);
		$this->assign('type_nid', $_GET['type_nid']);
	}

	private function stats_selection(){
		$stats =[];
		$utilisateur = new bobs_utilisateur($this->db, 4080);
		$id_selection = $utilisateur->selection_creer("compte_colonies_hiro");
		$selection = new bobs_selection($this->db, $id_selection);
		$extraction = new bobs_extractions($this->db);
		$extraction->ajouter_condition(new bobs_ext_c_tag(CLICNAT_HIRONDELLE_TAG));
		$extraction->dans_selection($id_selection);
		$stats["nb_observateurs"] = count($selection->get_observateurs());
		$stats["nb_citations"] = $selection->n();
		$stats["derniere_date"]= new DateTime('1900-00-00');
		foreach ($selection->get_citations() as $citation){
			$date_obs = new DateTime($citation->date_modif);
			if ( $date_obs > $stats["derniere_date"])
				$stats["derniere_date"] = $date_obs;
		}
		$selection->drop();
		return $stats;
	}
	
	public function display() {
		global $start_time;
		session_start();

		if (!isset($_SESSION['id_utilisateur']))
			$_SESSION['id_utilisateur'] = false;

		$this->assign('page', $this->template());
		$this->assign('url_statique', URL_STATIQUE);
		$this->assign('nb_colonies',clicnat_espace_hirondelle::count_colonies($this->db));
		$stats = $this->stats_selection();
		$this->assign('nb_observateurs',$stats['nb_observateurs']);
		$this->assign('nb_citations', $stats['nb_citations']);
		$this->assign('derniere_date',date_format($stats['derniere_date'], "j / m  / Y"));
		$before_func = 'before_'.$this->template();

		if (method_exists($this, $before_func)) {
			if (!in_array($this->template(), ['accueil','creer_compte','inscription','login','carte_nids','geojson_points','colonie_details','autocomplete_commune','commune_geojson'])) {
				if (!$_SESSION['id_utilisateur']){
					$this->redirect("?t=accueil&acces=false");
					$this->ajoute_alerte('danger','Vous devez vous connecter por accéder à cette partie');
				}
			}
			if ($_SESSION['id_utilisateur'])
				$this->assign('utl', get_utilisateur($this->db, $_SESSION['id_utilisateur']));
			else
				$this->assign('utl', false);
			//test sur le navigateur
			if (ereg("MSIE 6.0", $_SERVER["HTTP_USER_AGENT"]) || ereg("MSIE 7.0", $_SERVER["HTTP_USER_AGENT"]) || ereg("MSIE 8.0", $_SERVER["HTTP_USER_AGENT"]) ) {//pour détecter si le navigateur est IE6
					$this->assign("ie_nav", true );
					$this->ajoute_alerte('warning','Votre navigateur est obsolète il se peut que certaines informations et/ou fonctionnalités n\' apparaissent ou ne fonctionnent pas: Internet Explorer 8 fin de support le 12/01/2016, Internet Explorer 7 fin de support le 13/07/2010, Internet Explorer 6 fin de support le 13/04/2010.');
					
			}
			$this->$before_func();
		} else {
			header("HTTP/1.0 404 Not Found");
			throw new Exception('404 Page introuvable');
		}

		parent::display($this->template().".tpl");
	}

}
require_once(DB_INC_PHP);
get_db($db);
$h = new Hirondelles($db);
$h-> display();
//var_dump($_SESSION);
