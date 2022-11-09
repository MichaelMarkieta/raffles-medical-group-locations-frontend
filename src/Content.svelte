<script>
  import { getContext } from "svelte";
  import Popup from "./Popup.svelte";
  const { open } = getContext("simple-modal");
  export let locations;
  const showModal = () => open(Popup, { locations: locations });
</script>

<i
  class="mi mi-circle-help"
  style="cursor:pointer"
  on:click={showModal}
  on:keypress={showModal}
>
  <span class="u-sr-only">Circle help</span>
</i>
