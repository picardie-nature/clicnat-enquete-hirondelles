function zeropad(n) {
	if (n<10) return '0'+n;
	return n;
}

if (!Date.prototype.toDate) {
	Date.prototype.toDate = function () {
		return this.getFullYear()+
			'-'+zeropad(this.getMonth()+1)+
			'-'+zeropad(this.getDate());
	};
}

var messages = {
	prog_inscription_envoi: "Envoi de la demande de création...",
	prog_inscription_okconf: "Le message de confirmation a été envoyé",
	prog_inscription_err: "Une erreur a eu lieu pendant le processus de création de votre compte : ",
	prog_login_envoi: "Envoi des identifiants de connection",
	prog_login_ok: "Bienvenue",
	prog_login_err: "Identification incorrect : "
}

// initialisation de la page de création d'une nouvelle colonie
var gbl_nouveau = {
	min_zoom_pointage: 16,
	map: undefined,
	commune: undefined,
	colonies: undefined,
	coordonnees_dernier_click: undefined
}

function init_choix_colonie(env) {
	var projection = ol.proj.get('EPSG:3857');
	gbl_nouveau.commune = new ol.layer.Vector({
		source: new ol.source.Vector({
			attributions: [new ol.Attribution({html: "Contours des commmunes IGN ROUTE 500"})]
		})
	});
	gbl_nouveau.colonies_style_cache = {};
	gbl_nouveau.colonies_style = function (feature) {
		var s = undefined;
		var n = feature.get('features').length;
		if (n > 1) {
			var sname = 'g'+n;
			s = gbl_nouveau.colonies_style_cache[sname];
			if (!s) {
				s = new ol.style.Style({
					image: new ol.style.Circle({
						radius: 10,
						stroke: new ol.style.Stroke({color: '#fff'}),
						fill: new ol.style.Fill({color: '#3399CC'})
					}),
					text: new ol.style.Text({
						text: n.toString(),
						fill: new ol.style.Fill({color: '#fff'})
					})
				});
				gbl_nouveau.colonies_style_cache[sname] = s;
			}
		} else {
			s = gbl_nouveau_colonies_style_simple;
		}
		return s;
	}

	gbl_nouveau_colonies_style_simple = new ol.style.Style({
		image: new ol.style.Circle({
			radius: 10,
			stroke: new ol.style.Stroke({color: '#fff'}),
			fill: new ol.style.Fill({color: '#aaaaff'})
		})
	});

	gbl_nouveau.colonies = new ol.layer.Vector({
		source: new ol.source.Cluster({
			distance: 20,
			source: new ol.source.Vector({
				attributions: [new ol.Attribution({html: "Colonies d'hirondelles &copy; Picardie Nature et ses contributeurs"})]
			})
		}),
		style: function (feature,resolution) {
			var s = gbl_nouveau.colonies_style(feature);
			return [s];
		}
	});
	var layers = [
		new ol.layer.Tile({
			source: new ol.source.TileWMS({
				attributions: [new ol.Attribution({html:"Fond de carte &copy; OpenStreetMap et ses contributeurs"})],
				url: 'http://gpic.web-fr.org/mapproxy/service',
				params: {LAYERS:'osm_geopicardie_bright',VERSION:'1.1.1'}
			})
		}),
		gbl_nouveau.commune,
		gbl_nouveau.colonies
	];
	gbl_nouveau.map = new ol.Map({
		controls: ol.control.defaults().extend([
			new ol.control.ScaleLine({
				units: 'metric'
			}),
			new ol.control.Attribution(),
			new ol.control.Rotate()
		]),
		layers: layers,
		target: 'map',
		view: new ol.View({
			projection: projection,
			center: ol.proj.transform([2.80151, 49.69606], 'EPSG:4326', 'EPSG:3857'),
			zoom: 8
		})
	});

	var select = new ol.interaction.Select({
		layers: [gbl_nouveau.colonies],
		style: function (feature,resolution) {
			return [gbl_nouveau.colonies_style(feature)];
		}
	});

	gbl_nouveau.map.addInteraction(select);
	select.on('select', function (evt) {
		var nselect = evt.target.getFeatures().getLength();
		var ncluster = 0;
		if (nselect > 0) {
			var feature_cluster = evt.target.getFeatures().getArray()[0];
			var features = feature_cluster.get('features');
			ncluster = features.length;

		}
		if (nselect == 0 || ncluster > 1) {
			// zoom si nécessaire sinon création d'une colonie
			var pt = ol.proj.transform(gbl_nouveau.coordonnees_dernier_click, 'EPSG:3857', 'EPSG:4326');
			var zoom = gbl_nouveau.map.getView().getZoom()
			if (zoom <= gbl_nouveau.min_zoom_pointage) {
				gbl_nouveau.map.getView().setZoom(zoom+1);
				gbl_nouveau.map.getView().setCenter(gbl_nouveau.coordonnees_dernier_click);
			} else {
				$('#modal_nouveau_point').modal();
				$('#creer_point_x').val(pt[0]);
				$('#creer_point_y').val(pt[1]);
				// création d'une nouvelle colonie
			}
		} else {
			// choix colonie pointée
			if (ncluster == 1) {
				$('#id_espace_visite_colonie').val(features[0].get('id_espace'));
				$('#datepicker').datepicker({maxDate: "+0D"});
				$('#modal_nouvelle_visite').modal();
				var spinners = $('.spinner');
				// remise a zéro des spinners
				for (var i=0; i<spinners.length; i++) {
					$(spinners[i]).spinner({min:0,max:100});
					$(spinners[i]).spinner("value",0);
				}
				// reprise de la dernière visite et affichage historique
				$.ajax({
					url: '?t=colonie_details&id='+features[0].get('id_espace'),
					success: function (data,txtStatus,xhr) {
						if (data.visites.length >= 1) {
							// reprise
							var derniere_visite = data.visites[data.visites.length-1];
							var spinners = $('.spinner');
							for (var i=0; i<spinners.length; i++) {
								var name = $(spinners[i]).attr('name');
								$(spinners[i]).spinner("value", derniere_visite[name]);
							}
							// historique
							$('#historique').html("");
							for (var i=data.visites.length-1; i>=0 ; i--) {
								var v = data.visites[i];
								var tr = "<tr><td>"+v['date_visite_nid']+"</td>";
								tr += "<td>"+v['n_nid_occupe_r']+"</td>";
								tr += "<td>"+v['n_nid_vide_r']+"</td>";
								tr += "<td>"+v['n_nid_detruit_r']+"</td>";
								tr += "<td>"+v['n_nid_occupe_f']+"</td>";
								tr += "<td>"+v['n_nid_vide_f']+"</td>";
								tr += "<td>"+v['n_nid_detruit_f']+"</td>";
								tr += "<td>"+v['n_nid_occupe_ri']+"</td>";
								tr += "<td>"+v['n_nid_vide_ri']+"</td>";
								tr += "<td>"+v['n_nid_detruit_ri']+"</td>";
								tr += "</tr>";
								$('#historique').append(tr);
							}
						}
					}
				});
			}
		}
		// deselect
		evt.target.getFeatures().clear();
	});
	gbl_nouveau.map.on('click', function(evt) {
		gbl_nouveau.coordonnees_dernier_click = evt.coordinate;
		return;
	});

	gbl_nouveau.raffraichir_couche_colonies = function () {
		$.ajax({
			url: '?t=geojson_points',
			success: function (data,textStatus,xhr) {
				var src = new ol.source.GeoJSON({
					defaultProjection: 'EPSG:4326',
					projection: 'EPSG:3857',
					object: data
				});
				gbl_nouveau.colonies.getSource().getSource().clear();
				gbl_nouveau.colonies.getSource().getSource().addFeatures(src.getFeatures());
			}
		});
	}

	gbl_nouveau.raffraichir_couche_colonies();

	$('#auto_commune').autocomplete({
		source: '?t=autocomplete_commune',
		select: function (event,ui) {
			$.ajax({
				url: '?t=commune_geojson&id='+ui.item.value,
				success: function (data,textStatus,xhr) {
					var src = new ol.source.GeoJSON({
						defaultProjection: 'EPSG:4326',
						projection: 'EPSG:3857',
						object:data
					});
					gbl_nouveau.commune.getSource().clear();
					gbl_nouveau.commune.getSource().addFeatures(src.getFeatures());
					var features = gbl_nouveau.commune.getSource().getFeatures();
					// recentrer la carte
					for (var i=0; i<features.length; i++) {
						gbl_nouveau.map.getView().fitExtent(features[i].getGeometry().getExtent(), gbl_nouveau.map.getSize());
					}
					$('#auto_commune').val('');
					return;
				}
			});
		}
	});

	$('#dnp').submit(function () { // création nouvelle colonie
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			error: function (xhr,text,error) {
				alert('erreur lors de la création de la colonie');
			},
			success: function (data,text,xhr) {
				if (data.etat == 'ok') {
					$('#modal_nouveau_point').modal('hide');
					gbl_nouveau.raffraichir_couche_colonies();
				}
			}
		});
		return false;
	})

	$('#dnv').submit(function () { // enregistre nouvelle visite
		$('#date_visite_nid').val($('#datepicker').datepicker("getDate").toDate());
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			error: function (xhr,text,error) {
				alert('erreur pendant le transfert');
			},
			success: function (data,text,xhr) {
				if (data.etat == 'ok') {
					$('#modal_nouvelle_visite').modal('hide');
					// voir évenement hidden de modal_nouvelle_visite
					// qui va ouvrir la fenêtre
					// $('#modal_citations_visite').modal('show');
					$('#id_visite_nid').val(data.id_visite_nid);
				} else {
					alert(data.message);
				}
			}
		});
		return false;
	});

	// envoi du formulaire de création d'une visite
	$('#ccv').submit(function () {
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			error: function (xhr,text,error) {
				alert('erreur pendant le transfert');
			},
			success: function (data,text,xhr) {
				$('#id_visite_nid').val("");
				alert("Observations enregistrées");
				$('#modal_citations_visite').modal('hide');
			}
		});
		return false;
	});

	// initialisation du formulaire des citations
	$('#modal_citations_visite').on('show.bs.modal', function (e) {
		$('.spinner_citation').spinner({min:0,max:100});
	});

	// remise à zéro du formulaire nouvelle visite
	$('#modal_nouvelle_visite').on('show.bs.modal', function (e) {
		$('.spinner').val(0);
	});

	// corrige un bug où la scrollbar n'était plus présente
	// après quand on enchaine avec la saisie des citations
	$('#modal_nouvelle_visite').on('hidden.bs.modal', function (e) {
			if ($('#id_visite_nid').val() > 0) {
				$('#modal_citations_visite').modal();
				$('body').addClass('modal-open');
			}
	});
}


// initialisation de la page d'accueil
function init_accueil(env) {
	// activation bouton nouveau compte
	$('#bnc').click(function () {
		$(this).hide();
		$('#dlogin').hide();
		$('#dnew').show();
	});

	// envoi du formulaire d'inscription
	$('#form_inscription').submit(function () {
		$('#vue_progression_inscription').html(messages.prog_inscription_envoi);
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			error: function (xhr,text,error) {
				$('#vue_progression_inscription').html(messages.prog_inscription_err+text);
			},
			success: function (data,text,xhr) {
				if (data.etat == 'ok')
					$('#vue_progression_inscription').html(messages.prog_inscription_okconf);
				else
					$('#vue_progression_inscription').html(messages.prog_inscription_err+data.message);
			}
		});
		// stop event
		return false;
	});

	// envoi du formulaire de connection
	$('#dlogin').submit(function () {
		$('#vue_progression_login').html(messages.prog_login_envoi);
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			error: function (xhr,text,error) {
				$('#vue_progression_login').html(message.prog_login_err+text);
				return;
			},
			success: function (data,text,xhr) {
				if (data.etat == 'ok') {
					$('#vue_progression_login').html(messages.prog_login_ok);
					document.location.href = '?t=choix_colonie';
				} else {
					$('#vue_progression_login').html(messages.prog_login_err+data.message);
				}
			}
		});
		// stop event
		return false;
	});
}
