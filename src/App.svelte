<script>
  import mapboxgl from "mapbox-gl";
  import { onMount } from "svelte";
  import Modal from "svelte-simple-modal";
  import Content from "./Content.svelte";

  mapboxgl.accessToken =
    "pk.eyJ1IjoibWFya2lldGEiLCJhIjoiY2w4dXV4M3U1MDc2cTN1b2NubjRmdzAwNyJ9.r9iIs8XUYOfSJZ4Ci52fGA";

  let fc = {};

  onMount(async () => {
    fc = await (await fetch("http://127.0.0.1:5000")).json();

    const map = new mapboxgl.Map({
      container: "map",
      style: "mapbox://styles/mapbox/outdoors-v11",
      center: [103.8198, 1.3521],
      zoom: 11,
    });

    map.on("style.load", () => {
      map.fitBounds([
        [103.58228682268629, 1.1958392147366226], // southwestern corner of the bounds
        [104.05012479035918, 1.4910862821596993], // northeastern corner of the bounds
      ]);
      map.addSource("raffles-medical-group", { type: "geojson", data: fc });
      map.addLayer({
        id: "raffles-medical-group",
        type: "circle",
        source: "raffles-medical-group",
        paint: {
          "circle-color": "#008066",
          "circle-radius": 6,
          "circle-stroke-width": 2,
          "circle-stroke-color": "#1B1B1B",
        },
      });
      map.on("click", "raffles-medical-group", (e) => {
        const coordinates = e.features[0].geometry.coordinates.slice();
        console.log(e.features[0].properties);
        const description = `<div class="card-top"><div class="title-block"><a href="${
          e.features[0].properties.clinicUrl
        }" target="_blank"><span class="clinic-name">${
          e.features[0].properties.clinicName
        }</span></a></div><div><span class="clinic-address">${
          e.features[0].properties.clinicAddress
        }</span></div></div><div class="card-bottom"><span class="clinic-services">${
          JSON.parse(e.features[0].properties.clinicServices).length == 0
            ? "Services unknown at this location"
            : JSON.parse(e.features[0].properties.clinicServices).join(", ")
        }</span></div>`;
        while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
          coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
        }
        new mapboxgl.Popup()
          .setLngLat(coordinates)
          .setHTML(description)
          .addTo(map);
      });

      map.on("mouseenter", "raffles-medical-group", () => {
        map.getCanvas().style.cursor = "pointer";
      });

      map.on("mouseleave", "raffles-medical-group", () => {
        map.getCanvas().style.cursor = "";
      });
    });
  });
</script>

<main>
  <div class="navbar">
    <span class="navbar-title">Raffles Medical Group Locations</span>
    <span class="navbar-expand" />
    <span class="navbar-info">
      <Modal>
        <Content locations={fc} />
      </Modal>
    </span>
  </div>

  <div id="map" />
</main>

<style>
  :global(.mi) {
    font-size: 1.4rem;
  }
  /* Use this to make sure screen readers read something sensible when encountering the mi. If you are using the icons decoratively, you can omit the <span> */
  :global(.u-sr-only) {
    position: absolute;
    left: -10000px;
    top: auto;
    width: 1px;
    height: 1px;
    overflow: hidden;
  }

  .navbar {
    position: absolute;
    width: 100vw;
    height: 50px;
    z-index: 999999;
    background-color: white;
    top: 0;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
  }

  .navbar-title {
    font-size: 24px;
    color: #000;
    padding: 0 20px;
  }

  .navbar-expand {
    flex-grow: 1;
  }

  .navbar-info {
    font-size: 14px;
    color: #000000;
    padding: 0 20px;
  }

  #map {
    width: 100vw;
    height: calc(100vh - 50px);
    margin-top: 50px;
    font-family: "Mukta", sans-serif;
  }

  :global(.card-top) {
    padding: 15px;
    color: #ffffff;
    border-top-left-radius: inherit;
    border-top-right-radius: inherit;
    border-bottom-left-radius: 0;
    border-bottom-right-radius: 0;
    background-color: #008066;
    z-index: -1;
  }

  :global(.card-bottom) {
    padding: 15px;
    background-color: #ffffff;
    color: #000000;
    border-top-left-radius: 0;
    border-top-right-radius: 0;
    border-bottom-left-radius: inherit;
    border-bottom-right-radius: inherit;
    z-index: 99;
  }

  :global(.title-block) {
    margin: 10px 0;
  }

  :global(.mapboxgl-popup-anchor-bottom .mapboxgl-popup-tip) {
    border-top-color: white;
  }

  :global(.mapboxgl-popup-close-button) {
    color: white;
  }

  :global(.mapboxgl-popup) {
    max-width: 500px;
  }

  :global(.mapboxgl-popup-content) {
    margin: 0;
    padding: 0;
    border-radius: 12px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
  }

  :global(a > .clinic-name) {
    font-size: 18px;
    color: #ffffff;
  }

  :global(.clinic-address) {
    font-size: 14px;
  }

  :global(.clinic-services) {
    font-size: 12px;
  }
</style>
