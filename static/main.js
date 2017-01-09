"use strict";

function initMap() {
    var controlDiv = document.createElement('div');
    var skillInput = document.createElement('input');
    skillInput.classList.add('skill-input');
    skillInput.placeholder = "Wyszukaj umiejętności programistyczne";
    controlDiv.appendChild(skillInput);

    skillInput.addEventListener('input', function(event) {
        // TODO
    });

    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 52.2, lng: 21},
        zoom: 6,
        mapTypeControl: false,
    });

    map.controls[google.maps.ControlPosition.TOP_LEFT].push(controlDiv);

    fetch('/regions/')
    .then(function(result) { return result.json() })
    .then(function(polygons) {
    
        polygons.forEach(function(polygon) {
            var region = new google.maps.Polygon({
                paths: polygon,
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: '#FF0000',
                fillOpacity: 0.35
            });
            region.setMap(map);
        });

    });
}
