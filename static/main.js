"use strict";

function initMap() {
    var controlDiv = document.createElement('div');
    controlDiv.classList.add('skill-control');
    var form = document.createElement('form')
    controlDiv.appendChild(form);

    var skillInput = document.createElement('input');
    var skillDataList = document.createElement('datalist');
    skillDataList.id = 'skill-input-data-list';
    form.appendChild(skillDataList);

    fetch('/skills/')
    .then(function(result) { return result.json() })
    .then(function(skills) {
        skills.forEach(function(skill) {
            var option = document.createElement('option')
            option.value = skill.name;
            skillDataList.appendChild(option);
        });
    });

    skillInput.classList.add('skill-input');
    skillInput.setAttribute('list', 'skill-input-data-list');
    skillInput.placeholder = "Wyszukaj umiejętności programistyczne";
    form.appendChild(skillInput);

    var markersOnMap = [];
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        fetch('/skills/' + encodeURIComponent(skillInput.value))
        .then(function(result) { return result.json() })
        .then(function(skill) {
            document.title = skill.name;
            console.log('results for', skill.name);
            console.log(skill);
            markersOnMap.forEach(function(marker) {
                marker.setMap(null);
            });
            skill.city_counts.forEach(function(cc) {
                var marker = new google.maps.Marker({
                    position: cc.coords,
                    map: map,
                    title: cc.city
                });
                markersOnMap.push(marker);
            });
        });
    });

    var skillSubmit = document.createElement('input')
    skillSubmit.setAttribute('type', 'submit');
    skillSubmit.value = 'Szukaj';
    form.appendChild(skillSubmit);

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
