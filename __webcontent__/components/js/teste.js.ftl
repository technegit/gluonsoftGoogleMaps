var scriptGoogleMapsAPI = "http://maps.googleapis.com/maps/api/js?key=${google_developer_key}&sensor=false&libraries=places";
var flagScriptLoaded = undefined;

function initGoogleMapsAPI(){
	if(!flagScriptLoaded){
		$(this).getScript(scriptGoogleMapsAPI, function(){
			console.log("Google Maps API Loaded!");
		});
	}
}