<script>
    import { translateText } from 'lang'
    export let onSelectMain;
    export let menuItem;


</script>
{#each menuItem as item, index}
    <div class="blockmenu" on:keypress={() => {}} on:click={() => onSelectMain (index)}>
        <p>{item.title}</p>
    </div>
{/each}