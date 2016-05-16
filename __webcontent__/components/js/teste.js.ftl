var scriptGoogleMapsAPI = "http://maps.googleapis.com/maps/api/js?key=${google_developer_key}&sensor=false&libraries=places";
var flagScriptLoaded = undefined;


$( document ).ready(function() {
    console.log( "ready!" );
    initGoogleMapsAPI();
});

function initGoogleMapsAPI(){
	if(!flagScriptLoaded){
		$.getScript(scriptGoogleMapsAPI, function(){
			console.log("Google Maps API Loaded!");
			flagScriptLoaded = true;
		});
	}
}