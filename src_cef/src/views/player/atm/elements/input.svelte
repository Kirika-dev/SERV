<script>
    import { translateText } from 'lang'
    import { executeClient } from 'api/rage'
    import { format } from 'api/formatter'
    import { charBankMoney } from 'store/chars';
    export let activeMain;
    export let subdata;
    export let type;
    export let placeholder;
    export let menuItem;

    let value = "";
    let icon = 'dollar';
    $: {
        if (placeholder === 'Transfer account') {
            icon = 'card';
        } else {
            icon = 'dollar';
        }
    }
    const onNext = () => {
        executeClient ('atmVal', value);
        value = ""
    }

    const onPrev = () => {
        executeClient ('atmCB', type, 0);
        value = ""
    }
	const onHandleInput = (value, num) => {
        value = Math.round(value.replace(/\D+/g, ""));
        if (value < 1) value = 1;
        else if (num === 6 && value > 9999999) value = 9999999;
        else if (num === 10 && value > 99999999) value = 99999999;
    }
</script>
{#if activeMain === 2 || activeMain === 3}
    <h1>{menuItem [activeMain].title}</h1>
    <div class="balanccard">
        <p>Баланс счета:</p>
        <span>₽ {format("money", $charBankMoney)}</span>
    </div>
    <div class="inputmoney">
        <p>{placeholder}</p>
        {#if icon == "card"}
            <input bind:value={value} type="text" on:input={(event) => onHandleInput (event.target.value, 10)} placeholder="000" maxLength={10}/>
            {:else}
            <input bind:value={value} type="text" on:input={(event) => onHandleInput (event.target.value, 6)} placeholder="000" maxLength={8}/>
        {/if}
    </div>
    {#if subdata.length}
        <div class="dopopp">
            <p>На счету: <b>₽{format("money", subdata.split('/')[0])}</b></p>
            <p>Максимальный Баланс: <b>₽{format("money", subdata.split('/')[1])}</b></p>
        </div>
    {/if}
    {:else}
    <h1>{menuItem [activeMain].title}</h1>
    <div class="balanccard">
        <p>Баланс счета:</p>
        <span>₽ {format("money", $charBankMoney)}</span>
    </div>
    <div class="inputmoney">
        <p>{placeholder}</p>
        {#if icon == "card"}
            <input bind:value={value} type="text" on:input={(event) => onHandleInput (event.target.value, 10)} placeholder="000" maxLength={10}/>
            {:else}
            <input bind:value={value} type="text" on:input={(event) => onHandleInput (event.target.value, 6)} placeholder="000" maxLength={8}/>
        {/if}
    </div>
{/if}
<div class="atmbtn">
    <div class="btnopp" on:keypress={() => {}} on:click={onNext}>
        <p>Выполнить</p>
    </div>
    <div class="btnopp" on:keypress={() => {}} on:click={onPrev}>
        <p>Вернуться назад</p>
    </div>
</div>