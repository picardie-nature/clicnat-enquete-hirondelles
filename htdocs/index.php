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
		$ret = [
			"id_colonie" => $colonie->id_espace,
			"id_utilisateur" => $colonie->id_utilisateur,
			"visites" => array()
		];
		$p = 0;
		foreach ($colonie->visites() as $visite) {
			$ret['visites'][] = [
				'date_visite_nid' => $visite->date_visite_nid,
				'n_nid_occupe_r' => $visite->n_nid_occupe_r,
				'n_nid_vide_r' => $visite->n_nid_vide_r,
				'n_nid_detruit_r' => $visite->n_nid_detruit_r,
				'n_nid_occupe_ri' => $visite->n_nid_occupe_ri,
				'n_nid_vide_ri' => $visite->n_nid_vide_ri,
				'n_nid_detruit_ri' => $visite->n_nid_detruit_ri,
				'n_nid_occupe_f' => $visite->n_nid_occupe_f,
				'n_nid_vide_f' => $visite->n_nid_vide_f,
				'n_nid_detruit_f' => $visite->n_nid_detruit_f,
				'id_visite_nid' => $visite->id_visite_nid
			];
		}
		$this->header_json();
		echo json_encode($ret);
		exit(0);
	}

	public function before_creer_citations_visite() {
		$this->header_json();
		$retour = [
			"citations" => [],
			"id_observation" => null
		];
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
			$id_observation = bobs_observation::insert($this->db, $observation);
			$retour['id_observation'] = $id_observation;
			$observation = get_observation($this->db, $id_observation);
			$observation->ajoute_tag(CLICNAT_HIRONDELLE_TAG, $this->id_visite, "visite_espace_hirondelle.id_visite");
			$observation->add_observateur($_SESSION['id_utilisateur']);
			$ages = [
				"ad" => "AD",
				"juv" => "JUV",
				"juvmorts" => "JUV",
				"oeuf" => "P"
			];
			$especes = [
				"fenetre" => 387,
				"rustique" => 725,
				"rivage" => 815
			];
			foreach ($especes as $e_champ => $id_espece) {
				foreach ($ages as $a_champ => $age_clicnat) {
					if (!empty($_POST["nb_{$a_champ}_{$e_champ}"]) or ($_POST["nb_{$a_champ}_{$e_champ}_ind"] == 1)) {
						if ($_POST["nb_{$a_champ}_{$e_champ}_ind"] == 1)
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
						$citation->set_effectif($nb);
						$citation->ajoute_tag(CLICNAT_HIRONDELLE_TAG, $this->id_visite, "visite_espace_hirondelle.id_visite");
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
		} catch (Exception $e) {
			echo json_encode(["etat" => "err", "message" => $e->getMessage()]);
			exit(0);
		}
		echo json_encode([
				"etat" => "ok",
				"id_visite_nid" => $visite->id_visite_nid,
				"date_visite_nid" => $visite->date_visite_nid
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
			if (empty($_GET['x']) || empty($_GET['y']))
				throw new Exception("pas de coordonnées x,y");
			$point = [
				'x' => $_GET['x'],
				'y' => $_GET['y'],
				'nom' => '',
				'reference' => '',
				'id_utilisateur' => $_SESSION['id_utilisateur']
			];
			$id_espace = bobs_espace_point::insert($this->db, $point);
			$point = new clicnat_espace_hirondelle($this->db, $id_espace);
			$point->ajoute_tag(CLICNAT_HIRONDELLE_TAG);

			if (isset($_GET['occupant'])) {
				$point->ajoute_tag(CLICNAT_HIRONDELLE_ID_TAG_OCCUPANT);
			}

			if (isset($_GET['publique'])) {
				$point->ajoute_tag(CLICNAT_HIRONDELLE_ID_TAG_PUBLIQUE);
			}
			echo json_encode(["etat" => "ok", "id_espace" => $id_espace]);
		} catch (Exception $e) {
			echo json_encode(["etat" => "err", "message" => $e->getMessage()]);
		}
		exit(0);
	}

	public function before_geojson_points() {
		$this->header_json();
		echo clicnat_espace_hirondelle::geojson_utilisateur($this->db, get_utilisateur($this->db, $_SESSION['id_utilisateur']));
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
				$this->ajoute_alerte('info', 'Vous êtes maintenant déconnecté');
				$this->redirect('?t=accueil');
			}
		}
	}

	public function before_choix_colonie() {
	}

	public function display() {
		global $start_time;

		session_start();

		if (!isset($_SESSION['id_utilisateur']))
			$_SESSION['id_utilisateur'] = false;

		$this->assign('page', $this->template());
		$this->assign('url_statique', URL_STATIQUE);
		$before_func = 'before_'.$this->template();
		if (method_exists($this, $before_func)) {
			if (!in_array($this->template(), ['accueil','creer_compte','inscription','login'])) {
				if ($_SESSION['id_utilisateur'] == false) {
					throw new Exception('vous devez être identifié');
				}
			}

			if ($_SESSION['id_utilisateur'])
				$this->assign('utl', get_utilisateur($this->db, $_SESSION['id_utilisateur']));
			else
				$this->assign('utl', false);

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
