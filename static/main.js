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

    var scaleIndicator = document.createElement('div');
    scaleIndicator.classList.add('scale-indicator');
    map.controls[google.maps.ControlPosition.BOTTOM_LEFT].push(scaleIndicator);

    fetch('/regions/')
    .then(function(result) { return result.json() })
    .then(function(regions) {
        var minSalary = Math.min(...regions.map(r => r.avg_salary));
        var maxSalary = Math.max(...regions.map(r => r.avg_salary));
        console.log(minSalary, maxSalary);

        regions.forEach(function(region) {
            var k = (region.avg_salary - minSalary) / (maxSalary - minSalary);

            var region = new google.maps.Polygon({
                paths: region.poly,
                strokeColor: '#FF0000',
                strokeOpacity: 0.8,
                strokeWeight: 2,
                fillColor: colorScale(k),
                fillOpacity: 0.4
            });
            region.setMap(map);
        });


        var minSalarySpan = document.createElement('span');
        minSalarySpan.innerText = minSalary + 'zł';
        scaleIndicator.appendChild(minSalarySpan);

        var lgSteps = [];
        for (var k = 0; k <= 1; k += 0.1)
            lgSteps.push(colorScale(k));
        var colorLine = document.createElement('div')
        colorLine.classList.add('color-line');

        colorLine.style.background = 'linear-gradient(90deg, ' + lgSteps.join(',') + ')';
        scaleIndicator.appendChild(colorLine);

        var maxSalarySpan = document.createElement('span');
        maxSalarySpan.innerText = maxSalary + 'zł';
        scaleIndicator.appendChild(maxSalarySpan);
    });
}

function colorScale(k) {
    return 'hsl(' + (180*k) + ', 80%, 50%)';
}
