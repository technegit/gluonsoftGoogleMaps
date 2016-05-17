var geocoder;
var map;
var markers = new Array();
var autocomplete;
var initPosition;
var first;
var flagMapInitialized;
var _initialUserDefinedLocation = "${LOCALIZACAO_INICIAL_MAPA}";  

// Armazena a url da API do Google Maps. O parâmetro key receberá a chave de desenvolvedor durante o load do Gluonsoft na IDE.
var scriptGoogleMapsAPI = "http://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_JAVASCRIPT_API_DEVELOPER_KEY}&sensor=false&libraries=places";
var flagScriptLoaded = undefined;


$( document ).ready(function() {
    initGoogleMapsAPI();
});

// Carrega a API do Google Maps
function initGoogleMapsAPI(){
	if(!flagScriptLoaded){
		$.getScript(scriptGoogleMapsAPI, function(){
			console.log("Google Maps API Loaded!");
			flagScriptLoaded = true;
		});
	}
}


function initialize() {
	if(flagMapInitialized){
		return;
	}
	
	if(getInitialLocationDefinedByUser()==""){
		initPosition = getCurrentPosition();
	} else {
		$('.map-control').val(getInitialLocationDefinedByUser());
	}
	
	initPosition = initPosition == undefined ? new google.maps.LatLng(-23.5652103, -46.65112599999998) : initPosition;
    
    var options = {
  		zoom: 5,
  		center: initPosition,
  		mapTypeId: google.maps.MapTypeId.ROADMAP
  	};
  	var div = $('.map');
  	map = new google.maps.Map(div[0], options);
  	geocoder = new google.maps.Geocoder();
  	var autoCompleteInput = $('.map-control');
  	autoCompleteInput = autoCompleteInput[0];
    autoCompleteOpcoes = {
    types: ['geocode']
  }
  autocomplete = new google.maps.places.Autocomplete(autoCompleteInput,autoCompleteOpcoes);
  google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var data = $('.map-control').serialize();
      app.userEvents.fetchMap();
    });
    map.setCenter(initPosition);
    
    flagMapInitialized = true;
}
 
app.userEvents.fetchMap = function(){
  if (!first){
    first = true
    this.loadMap(getInitialLocationDefinedByUser());
  } else if(!$('.map-control').val().trim()== "") {
    this.loadMap($('.map-control').val());
  }	
  return true;
};

app.userEvents.loadMap = function(endereco){
	if(endereco == undefined || endereco.trim() == ""){
		return;
	}
	
	clearAllMarkers();
  	initialize();
	geocoder.geocode({ 'address': endereco + ', Brasil', 'region': 'BR' }, function (results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
		  if (results[0]) {
				var latitude = results[0].geometry.location.lat();
				var longitude = results[0].geometry.location.lng();
				var location = new google.maps.LatLng(latitude, longitude);
				
				updateMarker(location, map, endereco);
				map.setCenter(location);
				map.setZoom(16);
			}
		}
	})
};


/**
 * Atualiza a marcador no mapa.
 * 
 * @param position  Posicao (new google.maps.LatLng) do marcador no mapa.
 * @param map   Objeto google.maps.Map no qual será inserido o marcador.
 * @param title Titulo a ser exibido ao se posicionar o cursor do mouse sobre o marcador.
 **/
function updateMarker(position, map, title){
    var marker = new google.maps.Marker({
                                    position: position, // Variavel com posições Lat e Lng
                                    map: map,
                                    title: title,
                                    animation: google.maps.Animation.DROP
                                  });
	markers.push(marker);
}

function clearAllMarkers(){
	for(var i = 0; i < markers.length; i++) {
		markers[i].setMap(null);
	}
	
	markers = new Array();
}


function getInitialLocationDefinedByUser() {
	_initialUserDefinedLocation
	
	if(_initialUserDefinedLocation == undefined || 
	   _initialUserDefinedLocation == "INFORME_A_POSICAO_INICIAL_DO_MAPA" ||
	   _initialUserDefinedLocation == ""){
		_initialUserDefinedLocation = ""
	}
	
	return _initialUserDefinedLocation;
}

function getCurrentPosition(){
	var currentLocation = undefined;
	
	// Try W3C Geolocation
	if(navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			currentLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
		});
    }
	
	return currentLocation;
}