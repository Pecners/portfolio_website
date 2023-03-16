---
cms_exclude: true
header:
  caption: ""
  image: ""
title: Road Efficiency
summary: This interactive app displays road efficiency by US county.
date: 2023-03-15
---
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Add a polygon to a map using a GeoJSON source</title>
        <meta name="viewport" content="initial-scale=1,maximum-scale=1,user-scalable=no">
        <link href="https://api.mapbox.com/mapbox-gl-js/v2.13.0/mapbox-gl.css" rel="stylesheet">
        <script src='https://api.tiles.mapbox.com/mapbox.js/plugins/turf/v3.0.11/turf.min.js'></script>
        <script src="https://api.mapbox.com/mapbox-gl-js/v2.13.0/mapbox-gl.js"></script>
        <style>
            body { margin: 0; padding: 0; }
            #map { position: absolute; top: 0; bottom: 0; width: 100%; }
            .map-overlay {
                position: absolute;
                font-family: sans-serif;
                margin-top: 5px;
                margin-left: 5px;
                padding: 5px;
                width: 30%;
                box-shadow: 2px 2px 10px black;
                font-size: 18px;
                line-height: 2;
                color: #222;
                background-color: #ffffffd9;
                border-radius: 3px;
            }

            #legend {
                font-size: 12px;
                padding: 10px;
                line-height: 18px;
                width: 90%;
            }

            .legend-key {
                display: flex;
                float: left;
                width: 10px;
                height: 10px;
                margin-right: 0px;
                width: 20%;
            }

            .key-label {
                display: flex;
                float: left;
                width: 10px;
                height: 10px;
                margin-right: 0px;
                margin-bottom: 10px;
                width: 20%;
            }

            .explainer {
                line-height: 1.25;
                font-size: 14px;
                padding-top: 10px;
                padding-bottom: 10px;
            }

            /* #legend:hover .legend-row{
                opacity: .25;
                cursor: pointer;
            }

            #legend .legend-row:hover {
                opacity: 1;
            } */

        </style>
    </head>
<body>
    <div id="map"></div>
    <div class='map-overlay'>
        <div>
            <strong>Place: </strong><span id='place'></span>
        </div>
        <div>
            <strong>Road Effciency: </strong><span id='eff'></span>
        </div>
        <div class="explainer">
            Road efficiency here is defined as the quotient of the straight-line distance
            between the start and end points of the road divided by the actual length of the road. A
            perfectly straight road would have an efficiency of 100%.
        </div>
        <div id="legend"></div>
    </div>
        <script>
            // Target the span elements used in the sidebar
            const placeDisplay = document.getElementById('place');
            const effDisplay = document.getElementById('eff');

            const bounds = [
                [-124.848974, 24.396308],
                [-66.885444, 49.384358] 
            ];
            mapboxgl.accessToken = 'pk.eyJ1IjoibXJwZWNuZXJzIiwiYSI6ImNsZjF0bHdvNTBidnkzeWxoYnB4bzU5cDAifQ.bfPhvoBQ-IFSM_l9px9eFg';
            const map = new mapboxgl.Map({
                container: 'map', // container ID
                // Choose from Mapbox's core styles, or make your own style with Mapbox Studio
                style: 'mapbox://styles/mrpecners/clf9saura001e01mkdujm3h0v', // style URL
                center: [-95.85597, 39.65967],
                maxBounds: bounds,
                zoom: 3 // starting zoom
            });
            let hoveredStateId = null;

            map.on('load', () => {
                // Add a data source containing GeoJSON data.
                map.addSource('counties', {
                type: 'geojson',
                data: './data.geojson'
                });

                map.addSource('centers', {
                    type: 'geojson',
                    data: './centers.geojson'
                });
            
                // Add a new layer to visualize the polygon.
                map.addLayer({
                    'id': 'county-fills', // name for this fill layer
                    'type': 'fill',
                    'source': 'counties', // reference the data source
                    'layout': {},
                    'paint': {
                        'fill-color': [
                            'interpolate',
                            ['linear'],
                            ['get', 'te'],
                            0,
                            '#341648',
                            0.5799417,
                            '#62205f',
                            0.9069606,
                            '#bb292c',
                            0.9402731,
                            '#ef8737',
                            0.9710547,
                            '#ffd353'
                            ]
                    }
                });

                map.addLayer({
                    'id': 'county-outline',
                    'type': 'line',
                    'source': 'counties',
                    'layout': {},
                    'paint': {
                        'line-color': [ // link fill-opacity to feature-state
                            'case',
                            ['boolean', ['feature-state', 'hover'], false],
                            "#000",
                            "#fff"
                        ],
                        'line-width': [
                            'case',
                            ['boolean', ['feature-state', 'hover'], false],
                            2,
                            0
                        ]
                    }
                });
                
                map.setPaintProperty('county-fills', 'fill-opacity', [
                    'interpolate',
                    // Set the exponential rate of change to 0.5
                    ['exponential', 0.5],
                    ['zoom'],
                    // When zoom is 5, buildings will be 90% opaque.
                    5,
                    0.9,
                    // When zoom is 20 or higher, buildings will be 10% opaque.
                    20,
                    .1
                ]);

                map.addLayer({
                    'id': 'county-center',
                    'type': 'circle',
                    'source': 'centers',
                    'layout': {},
                    'paint': {
                        'circle-radius': 0
                    }
                });

                map.on('mousemove', 'county-fills', (e) => {
                    map.getCanvas().style.cursor = 'pointer';


                    if (e.features.length > 0) {
                        placeDisplay.textContent = e.features[0].properties.NAME + ', ' + e.features[0].properties.state;
                        effDisplay.textContent =  Math.floor(Math.round(e.features[0].properties.te * 100000) / 100)/10 + "%";
                        if (hoveredStateId !== null) {
                            map.setFeatureState(
                                { source: 'counties', id: hoveredStateId },
                                { hover: false }
                                );
                            }
                        hoveredStateId = e.features[0].id;
                        map.setFeatureState(
                            { source: 'counties', id: hoveredStateId },
                            { hover: true }
                            );

                    }
                });
        
        // When the mouse leaves the state-fill layer, update the feature state of the
        // previously hovered feature.
                map.on('mouseleave', 'county-fills', () => {
                    map.getCanvas().style.cursor = '';

                    countyDisplay.textContent = '';
                    stateDisplay.textContent =  '';
                    effDisplay.textContent =  '';

                    if (hoveredStateId !== null) {
                        map.setFeatureState(
                            { source: 'counties', id: hoveredStateId },
                            { hover: false }
                        );
                    }
                    hoveredStateId = null;
                });

                map.on('click', 'county-fills', (e) => {
                    map.flyTo({
                        center: [e.features[0].properties.X, e.features[0].properties.Y], 
                        zoom: 10
                    })
                });

                // create legend
                // define layer names
                const layers = [
                "Curviest",
                "",
                "",
                "",
                "Straightest"
                ];
                const colors = [
                            '#341648',
                            '#62205f',
                            '#bb292c',
                            '#ef8737',
                            '#ffd353'
                ];
                const legend = document.getElementById('legend');

                layers.forEach((layer, i) => {
                    const color = colors[i];
                    const item = document.createElement('div');
                    const key = document.createElement('span');
                    key.className = 'legend-key';
                    key.style.backgroundColor = color;
                    item.className = 'legend-row';

                    item.appendChild(key);
                    legend.appendChild(item);

                });

                layers.forEach((layer) => {
                    const item = document.createElement('div');
                    const value = document.createElement('span');
                    item.className = 'key-label';
                    value.innerHTML = `${layer}`;

                    item.appendChild(value)
                    legend.appendChild(item);
                });

            });
            
        </script>

    </body>
</html>