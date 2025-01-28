<script>
    import { translateText } from 'lang'
    import { executeClient } from 'api/rage'
    import { format } from 'api/formatter'    
    import { charBankMoney } from 'store/chars';

    import './css/main.css'
    import './fonts/Gilroy/stylesheet.css';
    import './fonts/SFPro/stylesheet.css';

    import Business from './elements/business.svelte'
    import Input from './elements/input.svelte'
    import Menu from './elements/menu.svelte'

    export let viewData;

    let SelectViews = "Menu";

    const Views = {
        Menu,
        Input,
        Business
    }

    const menuItem = [
        {
            "title":'Пополнить счет',
            "icon":"ic-user-shared-fill"
        },
        {
            "title":'Снять наличные',
            "icon":"ic-user-received-fill"
        },
        {
            "title":'Пополнить счет дома',
            "icon":"ic-home-fill"
        },
        {
            "title":'Пополнить счет бизнеса',
            "icon":"ic-store-fill"
        },
        {
            "title":'Перевести',
            "icon":"ic-article-fill"
        }
    ];

    let
        type = 1,
        subdata = '',   
        number = viewData.number,
        activeMain = 0,
        holder = viewData.holder,
        placeholder = "";


    window.atm = {
        open: (data) => {
            window.atm.reset();
            placeholder = data[2];
            subdata = data[1];
            type = data[0];            

            if(type === 1) SelectViews = "Menu";
            else if(type === 2) SelectViews = "Input";
            else if(type === 3) SelectViews = "Business";
        },
        reset: () => {
            subdata = [];
            type = 1;
            SelectViews = "Menu";
        }
    }

    const onSelectMain = (index) => {
        activeMain =  index;

        executeClient ("atmCB", type, index);
    }
</script>

<div class="atmhaxzer">
    <div class="atmmenu">
        {#if SelectViews == "Menu"}
            <div class="leftmenu">
                <svelte:component this={Views[SelectViews]} {menuItem} {type} {subdata} {activeMain} {placeholder} {onSelectMain} />
                <div class="blockmenu" on:keypress={() => {}} on:click={() => onSelectMain(-1)}>
                    <p>Выйти</p>
                </div>
            </div>
            <div class="rightmenu">
                <h1>Банкомат №43</h1>
                <div class="infomeun">
                    <p>Владелец счета:</p>
                    <span>{holder}</span>
                </div>
                <div class="infomeun">
                    <p>Баланс счета:</p>
                    <span>₽ {format("money", $charBankMoney)}</span>
                </div>
                <div class="infomeun">
                    <p>Ваша карта:</p>
                    <div class="cardatm">
                        <h1>VIP</h1>
                        <p>{number}</p>
                        <div class="dopinfo">
                            <p>12/30</p>
                            <svg width="29" height="29" viewBox="0 0 29 29" fill="none" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                <rect x="0.699219" y="0.617188" width="27.6164" height="27.6164" fill="url(#pattern0)"/>
                                <defs>
                                <pattern id="pattern0" patternContentUnits="objectBoundingBox" width="1" height="1">
                                <use xlink:href="#image0_790_310" transform="scale(0.00195312)"/>
                                </pattern>
                                <image id="image0_790_310" width="512" height="512" xlink:href="data:image/png;base64,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"/>
                                </defs>
                            </svg>                                
                        </div>
                    </div>
                </div>
            </div>
            {:else}
            <div class="atmopp">
                <svelte:component this={Views[SelectViews]} {menuItem} {type} {subdata} {activeMain} {placeholder} {onSelectMain} />
            </div>
        {/if}
    </div>
</div>