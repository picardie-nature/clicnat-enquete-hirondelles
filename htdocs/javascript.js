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
	var styles = [ 'Road', 'Aerial', 'AerialWithLabels', 'collinsBart', 'ordnanceSurvey' ];
	var bing = new ol.layer.Tile({ 
		visible: true,
		preload: Infinity,
		source: new ol.source.BingMaps({
			key: 'Ah-gSVhOCszl1-LJ6d1gs11SXprWx2-BM6GUkUiqcDAmRWEgV2tNQ_1a7M2wJ33t',
			imagerySet: styles[2]
		})
	});
	gbl_nouveau.commune = new ol.layer.Vector({
		source: new ol.source.Vector({
			attributions: [new ol.Attribution({html: "Contours des commmunes IGN ROUTE 500"})]
		}),
		style: new ol.style.Style({
			fill: new ol.style.Fill({ color: 'rgba(255, 255, 255, 0.6)' }),
			stroke: new ol.style.Stroke({ color: '#319FD3', width: 1 }) 
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
//		new ol.layer.Tile({
//			source: new ol.source.TileWMS({
//				attributions: [new ol.Attribution({html:"Fond de carte &copy; OpenStreetMap et ses contributeurs"})],
//			url: 'http://gpic.web-fr.org/mapproxy/service',
//				params: {LAYERS:'osm_geopicardie_bright',VERSION:'1.1.1'}
//			})
//		}),
		bing,
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
				$('#modal_nouvelle_visite').modal().hide();
				$('#modal_chargement').modal({backdrop: 'static'}).show();
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
							// plus besoin de rependre les données precedantes
							/*
							var derniere_visite = data.visites[data.visites.length-1];
							var spinners = $('.spinner');
							for (var i=0; i<spinners.length; i++) {
								var name = $(spinners[i]).attr('name');
								$(spinners[i]).spinner("value", derniere_visite[name]);
							}
							*/
							// historique
							$('#historique').html("");
							for (var i=data.visites.length-1; i>=0 ; i--) {
								var v = data.visites[i];
								var tr = "<tr><td>"+v['date_visite_nid']+"</td>";
								tr += "<td>"+v['n_nid_occupe_r']+"</td>";
								tr += "<td>"+v['n_nid_vide_r']+"</td>";
								tr += "<td>"+v['n_nid_detruit_r']+"</td>";
								tr += "<td>"+v['n_jeunes_r']+"</td>";
								tr += "<td class=\"bord-left\">"+v['n_nid_occupe_f']+"</td>";
								tr += "<td>"+v['n_nid_vide_f']+"</td>";
								tr += "<td>"+v['n_nid_detruit_f']+"</td>";
								tr += "<td>"+v['n_jeunes_f']+"</td>";
								tr += "<td class=\"bord-left\">"+v['n_nid_occupe_ri']+"</td>";
								tr += "<td>"+v['n_nid_vide_ri']+"</td>";
								tr += "<td>"+v['n_nid_detruit_ri']+"</td>";
								tr += "<td>"+v['n_jeunes_ri']+"</td>";
								tr += "</tr>";
								$('#historique').append(tr);
							}
						}else { $('#historique').html("Pas encore renseigné");}
						$('#nom_commune').html(data.nom_commune);
					}
				});
				if ($('#modal__nouvelle_visite').find('td')){
					$('#modal_chargement').modal('hide');
					$('#modal_nouvelle_visite').modal({backdrop: 'static'}).show();
				}
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
			beforeSend:  function (xhr,settings) {$('#modal_chargement').modal({backdrop: 'static'}).show();},
			success: function (data,textStatus,xhr) {
				var src = new ol.source.GeoJSON({
					defaultProjection: 'EPSG:4326',
					projection: 'EPSG:3857',
					object: data
				});
				//alert(data.features);
				//alert(src.getFeatures());
				gbl_nouveau.colonies.getSource().getSource().clear();
				gbl_nouveau.colonies.getSource().getSource().addFeatures(src.getFeatures());
				$('#modal_chargement').modal('hide');
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
			beforeSend:  function (xhr,settings) {
				$('#modal_chargement').modal({backdrop: 'static'}).show();
			$('#modal_nouveau_point').modal('hide');
			},
			method: 'POST',
			data: $(this).serialize(),
			error: function (xhr,text,error) {
				alert('erreur lors de la création de la colonie');
			},
			success: function (data,text,xhr) {
				if (data.etat == 'ok') {
					gbl_nouveau.raffraichir_couche_colonies();
					$('#id_espace_visite_colonie').val(data.id_espace);
				$('#datepicker').datepicker({maxDate: "+0D"});
				var spinners = $('.spinner');
				// remise a zéro des spinners
				for (var i=0; i<spinners.length; i++) {
					$(spinners[i]).spinner({min:0,max:100});
					$(spinners[i]).spinner("value",0);
				}
				// reprise de la dernière visite et affichage historique
				$.ajax({
					url: '?t=colonie_details&id='+data.id_espace,
					success: function (data,txtStatus,xhr) {
						if (data.visites.length >= 1) {
							// reprise
							// plus besoin de rependre les données precedantes
							/*
							var derniere_visite = data.visites[data.visites.length-1];
							var spinners = $('.spinner');
							for (var i=0; i<spinners.length; i++) {
								var name = $(spinners[i]).attr('name');
								$(spinners[i]).spinner("value", derniere_visite[name]);
							}
							*/
							// historique
							$('#historique').html("");
							for (var i=data.visites.length-1; i>=0 ; i--) {
								var v = data.visites[i];
								var tr = "<tr><td>"+v['date_visite_nid']+"</td>";
								tr += "<td>"+v['n_nid_occupe_r']+"</td>";
								tr += "<td>"+v['n_nid_vide_r']+"</td>";
								tr += "<td>"+v['n_nid_detruit_r']+"</td>";
								tr += "<td>"+v['n_jeunes_r']+"</td>";
								tr += "<td class=\"bord-left\">"+v['n_nid_occupe_f']+"</td>";
								tr += "<td>"+v['n_nid_vide_f']+"</td>";
								tr += "<td>"+v['n_nid_detruit_f']+"</td>";
								tr += "<td>"+v['n_jeunes_f']+"</td>";
								tr += "<td class=\"bord-left\">"+v['n_nid_occupe_ri']+"</td>";
								tr += "<td>"+v['n_nid_vide_ri']+"</td>";
								tr += "<td>"+v['n_nid_detruit_ri']+"</td>";
								tr += "<td>"+v['n_jeunes_ri']+"</td>";
								tr += "</tr>";
								$('#historique').append(tr);
							}
						}else { $('#historique').html("Pas encore renseigné");}
						$('#nom_commune').html(data.nom_commune);
					}
				});
				if ($('#modal_nouvelle_visite').find('td')){
					$('#modal_nouvelle_visite').modal({backdrop: 'static'}).show();
				}
				}
					$('#modal_chargement').modal('hide');
				
			}
		});
		return false;
	})

	$('#dnv').submit(function () { // enregistre nouvelle visite
		$('#date_visite_nid').val($('#datepicker').datepicker("getDate").toDate());
		var occupes = [];
		$("input[name^='n_nid_occupe']").each(function (){
						if($(this).val()>0) { occupes.push($(this).attr('name'))};
		});
		var vides  =[]
		$("input[name^='n_nid_vide']").each(function (){
						if($(this).val()>0) { vides.push($(this).attr('name'))};
		});
		$.ajax({
			url: $(this).attr('action'),
			beforeSend:  function (xhr,settings) {$('#modal_chargement').modal({backdrop: 'static'}).show();},
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

					$('#id_visite_nid').val(data.id_visite_nid).attr('data-occupes',occupes.length);
					$('#id_observation_visite').val(data.id_observation);
					if(data.n_nid_occupe_r > 0){
						$('#n_nid_occupe_r').show();
					}
					else { $('#n_nid_occupe_r').hide(); }
					if(data.n_nid_occupe_f > 0){
						$('#n_nid_occupe_f').show();
					}
					else { $('#n_nid_occupe_f').hide(); }
					if(data.n_nid_occupe_ri > 0){
						$('#n_nid_occupe_ri').show();
					}
					else { $('#n_nid_occupe_ri').hide(); }

					$('#modal_chargement').modal('hide');
					//alert (occupes);

				} else {
					alert("Il y a eu une erreur durant l'enregistrement \n Vous ne pouvez enregistrer qu'une visite par jour sur une colonie");
					$('#modal_chargement').modal('hide');

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
				$('#id_visite_nid').val("").attr('data-occupes',"");
				$('#modal_citations_visite').modal('hide');
				$('#modal_succes').modal().show();
			}
		});
		return false;
	});

	// initialisation du formulaire des citations
	$('#modal_citations_visite').on('show.bs.modal', function (e) {
		$('.spinner_citation').spinner({
			min:0,
			max:100,
			width:'50px',
			spin : function(){
				$(this).parents('.well').find('.nb_inconnu').attr('checked', false).prop('checked', false);
			}

			}).val(0);
		$('#modal_citations_visite').find('textarea').val("");
		$('#modal_citations_visite').find('checkbox').attr('checked', false);
		$('.spinner_nbs').hide();
		$('.info_effectif').hide();
	});
	// décoche effectif inconnu si nb rentré
	$('.spinner_citation').each(function (){
		$(this).keypress(function(){
				$(this).parents('.well').find('.nb_inconnu').attr('checked', false).prop('checked', false);
		});
	});
	// action sur effectif inconnu
	$('.nb_inconnu').change( function () {
		var id = $(this).attr('id').substring(3,$(this).attr('id').length-4);
		if($(this).is( ":checked" )){
			$("#nb_"+id).val(0);
			$("#nbs_"+id).val(0);
			$("#nbs_"+id).hide();
			$(".nbs_"+id+"_m").hide();
			$("#nbs_"+id+"_ind").attr('checked', false).prop('checked', false);

		}
	});
	// action sur selection fourchettes
	$('.nbs_ind').change( function (){
		var id = $(this).attr('id').substring(0,$(this).attr('id').length-4);
		if($(this).is( ":checked" )){
			$("#"+id).show();
			$("."+id+"_m").show();
			$("#nb_"+id.substring(4,$(this).attr('id').length)+"_ind").attr('checked', false).prop('checked', false);
		}
		else {
			$("#"+id).hide();
			$("."+id+"_m").hide();
		}
	});
	// remise à zéro du formulaire nouvelle visite
	$('#modal_nouvelle_visite').on('show.bs.modal', function (e) {
		$('.spinner').val(0);
		$('#modal_nouvelle_visite').find('textarea').val("");
	});

	// corrige un bug où la scrollbar n'était plus présente
	// après quand on enchaine avec la saisie des citations
	$('#modal_nouvelle_visite').on('hidden.bs.modal', function (e) {
			if ($('#id_visite_nid').val() > 0 && $('#id_visite_nid').attr('data-occupes') > 0 ) {
				$('#modal_citations_visite').modal();
				$('body').addClass('modal-open');
			}
	});
}

// initialisation de la page carte des nids
function init_carte_nids(env){
	var projection = ol.proj.get('EPSG:3857');
	var styles = [ 'Road', 'Aerial', 'AerialWithLabels', 'collinsBart', 'ordnanceSurvey' ];
	var bing = new ol.layer.Tile({ 
		visible: true,
		preload: Infinity,
		source: new ol.source.BingMaps({
			key: 'Ah-gSVhOCszl1-LJ6d1gs11SXprWx2-BM6GUkUiqcDAmRWEgV2tNQ_1a7M2wJ33t',
			imagerySet: styles[2]
		})
	});
	gbl_nouveau.commune = new ol.layer.Vector({
		source: new ol.source.Vector({
			attributions: [new ol.Attribution({html: "Contours des commmunes IGN ROUTE 500"})]
		}),
		style: new ol.style.Style({
			fill: new ol.style.Fill({ color: 'rgba(255, 255, 255, 0.6)' }),
			stroke: new ol.style.Stroke({ color: '#319FD3', width: 1 }) 
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
//		new ol.layer.Tile({
//			source: new ol.source.TileWMS({
//				attributions: [new ol.Attribution({html:"Fond de carte &copy; OpenStreetMap et ses contributeurs"})],
//			url: 'http://gpic.web-fr.org/mapproxy/service',
//				params: {LAYERS:'osm_geopicardie_bright',VERSION:'1.1.1'}
//			})
//		}),
		bing,
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
	});	var select = new ol.interaction.Select({
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
			}
		} else {
			// choix colonie pointée
			if (ncluster == 1) {
				$('#id_espace_visite_colonie').val(features[0].get('id_espace'));
				$('#datepicker').datepicker({maxDate: "+0D"});
				$('#modal_citations_visite').modal().hide();
				$('#modal_chargement').modal({backdrop: 'static'}).show();
				var spinners = $('.spinner');
				// remise a zéro des spinners
				for (var i=0; i<spinners.length; i++) {
					$(spinners[i]).spinner({min:0,max:100});
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
								tr += "<td>"+v['n_jeunes_r']+"</td>";
								tr += "<td class=\"bord-left\">"+v['n_nid_occupe_f']+"</td>";
								tr += "<td>"+v['n_nid_vide_f']+"</td>";
								tr += "<td>"+v['n_nid_detruit_f']+"</td>";
								tr += "<td>"+v['n_jeunes_f']+"</td>";
								tr += "<td class=\"bord-left\">"+v['n_nid_occupe_ri']+"</td>";
								tr += "<td>"+v['n_nid_vide_ri']+"</td>";
								tr += "<td>"+v['n_nid_detruit_ri']+"</td>";
								tr += "<td>"+v['n_jeunes_ri']+"</td>";
								tr += "</tr>";
								$('#historique').append(tr);
							}
						}else { $('#historique').html("");}
						$('#nom_commune').html(data.nom_commune);
					}
				});
				if ($('#modal__citation_visite').find('td')){
				$('#modal_chargement').modal('hide');
				$('#modal_citations_visite').modal({backdrop: 'static'}).show();
				}
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
			beforeSend:  function (xhr,settings) {$('#modal_chargement').modal({backdrop: 'static'}).show();},
			success: function (data,textStatus,xhr) {
				var src = new ol.source.GeoJSON({
					defaultProjection: 'EPSG:4326',
					projection: 'EPSG:3857',
					object: data
				});
			//	alert(data);
				//$('.count_colonies').append(data.features.length);
				gbl_nouveau.colonies.getSource().getSource().clear();
				gbl_nouveau.colonies.getSource().getSource().addFeatures(src.getFeatures());
				$('#modal_chargement').modal('hide');
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
	// initialisation du formulaire des citations
	$('#modal_citations_visite').on('show.bs.modal', function (e) {
		$('.spinner_citation').spinner({min:0,max:100});
		$('#modal_citations_visite').find('checkbox').attr('checked', false);		
	});

	// affiche les citations
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
				$('#vue_progression_login').html(messages.prog_login_err+text);
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
$('.boite-image').click(function (e){
	var info = $(this).find('img').attr('src');
	window.open(info);
	return false;
});
$('.apercu_btn').click(function (e){
	var id = $(this).attr('href');
	$(id).toggle();
	if($(this).hasClass('glyphicon-plus')) {$(this).removeClass('glyphicon-plus').addClass('glyphicon-minus');}
	else $(this).removeClass('glyphicon-minus').addClass('glyphicon-plus');
	//alert(id);
	e.preventDefault();
});
$('.polaroids img').each(function (){
	$(this).after('<p class="polaroids-copyright"><span class="glyphicon glyphicon-copyright-mark"></span> '+$(this).attr('data-auteur')+'</p><p class="polaroids-loc">'+$(this).attr('data-loc')+'</p>');
});
// mise en page
// fixe la taille de .main selon la hauteur du footer
function ajuste_page() {
	var pied_height  = $('.pied_page').height()+20;
	var entete_height  =$('.entete').height();
	$('.main').css('margin-bottom',pied_height);
	$('.row-contenu-first').css('margin-top',entete_height);
	if ($('.fond-accueil')){
		 var win_width = $( window ).width();
		if (win_width<992){
			$('.fond-accueil').width('100%').height(win_width*0.75).css({'position':'relative','margin-top':entete_height,'top':0});
			$('html.accueil .row-contenu-first').css('margin-top',0);
			
		}
		else if (win_width<1200){
			var fond_height = $( window ).height()- entete_height;
			$('.fond-accueil').height(fond_height).width('66%').css({'top':entete_height,'position':'fixed','margin-top':0});

		}
		else {
			var fond_height = $( window ).height()- entete_height - pied_height;
			$('.fond-accueil').height(fond_height).width('66%').css({'top':entete_height,'position':'fixed','margin-top':0});
		}
	}
}
function ajuste_polaroids(){
	var largeur = $('.polaroids').parent().width();
	var $polaroids  =$('.polaroids li a');
	if (largeur > $polaroids.length * 260){
		$polaroids.first().css('margin-left',function (){
			return ((largeur - $polaroids.length * 260)/2 - $polaroids.length * 12);
		});
		$polaroids.find('img').each( function (){
			$(this).width('210px').height('210px');
		});
		$('head').append('<style>.polaroids li a:after{width:210px !important;}</style>');
	}
	else if( largeur / $polaroids.length > 170){
		//alert (largeur / $polaroids.length + " > 170");
		var largeur_max_a = largeur / $polaroids.length - 60 ;
		$polaroids.first().css('margin-left', function (){
			return (largeur - $polaroids.length * (largeur / $polaroids.length) - 15);
		});
		$polaroids.find('img').each( function (){
			$(this).width(largeur_max_a).height(largeur_max_a);
		});
		$polaroids.not("a:first").css('margin-left','10px');
		$('head').append('<style>.polaroids li a:after{width:'+largeur_max_a+'px !important;}</style>');
	}
	else {
		$polaroids.css('margin-left',function (){
			return ((largeur - 260)/2 -  12);
		});
		$polaroids.find('img').each( function (){
			$(this).width('210px').height('210px');
		});
		$('head').append('<style>.polaroids li a:after{width:210px !important;}</style>');

	}
}
function ajuste_pied(){
	var l_logos = $('.logos').width();
	var l_total_logos  = 0;
	$('logos .hoverscroll').each(function (){
		l_total_logos += $(this).width();
	});
	var ratio = l_logos / l_total_logos;
	if (l_total_logos > l_logos) {
		$('.logos .hoverscroll').each(function (){
			$(this).width($this.width()*ratio);
		});
	}

}
ajuste_page();
ajuste_polaroids();
ajuste_pied();
$( window ).resize(function (){
	ajuste_page();
	ajuste_polaroids();
	ajuste_pied();
});
