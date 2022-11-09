<script>
  export let locations;
</script>

<div style="padding: 25px; text-align: left">
  <h2>Info</h2>
  <p>
    This website is not affiliated with Raffles Medical Group. I created this
    website as a mini project to map the locations of Raffles Medical Group
    locations in Singapore because Raffles Medical Group only provides this data
    in a list format. You can see the source data for this map <a
      style="color: black"
      href="https://www.rafflesmedicalgroup.com/clinic/?_sft_clinic-location=singapore"
      target="_blank"
      rel="noreferrer"
    >
      here.
    </a>
    You can contact me through Github where this project's source code resides.
  </p>

  <h2>List of locations</h2>
  {#each locations.features as location}
    <div style="margin:14px 0">
      <span style="font-size: 16px; font-weight: bold">
        {location.properties.clinicName}
      </span>
      <br />
      <span style="font-size:12px">{location.properties.clinicAddress}</span>
      <br />
      <span style="font-size:12px; line-height:0.9em">
        {location.properties.clinicServices}
      </span>
    </div>
  {/each}
</div>
