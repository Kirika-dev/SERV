<script>
    import { translateText } from 'lang';
    import Header from '../header.svelte';
    import HomeButton from '../homebutton.svelte';
    import { currentPage } from '../../stores';
    import { radioState, radioStation } from "@/views/player/hudevo/phonenew/stores";
    import { storeSettings } from 'store/settings';
    import { executeClient } from "api/rage";
    import { onDestroy } from 'svelte';
    import { fade } from 'svelte/transition';

    let isToggled = $radioState;
    let selectedStation = $radioStation;

    // Объединяем данные о радиостанциях
    let radioStations = [
        { name: "RedAge", url: "https://radio.redage.net:8000/radio.mp3" },
        { name: "RedAge Rap", url: "https://radio.redage.net:8010/radio.mp3" },
        { name: "RedAge Rock", url: "https://radio.redage.net:8040/radio.mp3" },
        { name: "RedAge Phonk", url: "https://radio.redage.net:8050/radio.mp3" },
        { name: "RedAge Pop", url: "https://radio.redage.net:8020/radio.mp3" },
        { name: "RedAge Chill", url: "https://radio.redage.net:8060/radio.mp3" },
        {name: "181.fm - Classic Rock", url:"http://listen.181fm.com/181-eagle_128k.mp3"},
        {name: "181.fm - Awesome 80s", url: "http://listen.181fm.com/181-awesome80s_128k.mp3"},
        {name: "181.fm - The Rock!", url: "http://listen.181fm.com/181-rock_128k.mp3"},
        {name: "181.fm - Dance", url: "http://listen.181fm.com/181-energy93_128k.mp3"},
        {name: "181.fm - Oldies", url:  "http://listen.181fm.com/181-goodtime_128k.mp3"},
        {name: "181.fm - R&B", url: "http://listen.181fm.com/181-truernb_128k.mp3"},
        {name:  "Европа Плюс", url:"https://ep128.hostingradio.ru:8052/europaplus128.mp3"},
        {name:  "Русское Радио", url: "https://rusradio.hostingradio.ru/rusradio96.aacp"},
        {name:  "Радио Рекорд", url: "https://radiorecord.hostingradio.ru/rr_main96.aacp"},
        {name: "Дорожное Радио", url: "https://dorognoe.hostingradio.ru:8000/dorognoe"},
        {name: "Ретро FM", url:  "https://retroserver.streamr.ru/retro256.mp3"},
        {name:  "Наше Радио", url: "https://nashe1.hostingradio.ru/nashe-128.mp3"},
        {name:   "Авторадио", url: "https://icecast.avtoradio.ru/avtoradio"},
        {name: "Радио Шансон", url: "https://chanson.hostingradio.ru:8041/chanson128.mp3"},
        {name: "Love Radio", url:  "https://love.hostingradio.ru/love96.aacp"},
        {name:  "Радио Монте-Карло", url: "https://montecarlo.hostingradio.ru/montecarlo96.aacp"},
    ];

    const enableStation = () => {
        if (selectedStation >= radioStations.length) return;
        executeClient("sounds.play2DRadio", radioStations[selectedStation].url, SettingsList.VolumePhoneRadio / 100);
    };

    const updateToggled = () => {
        isToggled = !isToggled;
        radioState.set(isToggled);

        if (!isToggled) {
            executeClient("sounds.stop2DRadio");
            return;
        }
        enableStation();
    };

    let SettingsList = {};
    let DefaultSettingsList = "";
    storeSettings.subscribe((value) => {
        if (SettingsList !== value) {
            SettingsList = value;
            DefaultSettingsList = JSON.stringify(SettingsList);
        }
    });

    const changeVolume = (value) => {
        let volume = Math.round(SettingsList.VolumePhoneRadio / 10) + value;

        if (volume < 0) volume = 0;
        else if (volume > 10) volume = 10;

        SettingsList.VolumePhoneRadio = volume * 10;
        if (!isToggled) return;

        executeClient("sounds.volume2DRadio", SettingsList.VolumePhoneRadio / 100);
    };

    const setRadioStation = (value) => {
        if (selectedStation === value || value >= radioStations.length) return;
        selectedStation = value;
        radioStation.set(value);
        enableStation();
    };

    onDestroy(() => {
        if (DefaultSettingsList !== JSON.stringify(SettingsList))
            executeClient("chatconfig", JSON.stringify(SettingsList));
    });
</script>

<div class="newphone__radio" in:fade>
    <Header />
    <div class="newphone__radio_content">
        {#if selectPage === "radio"}
            <div class="box-flex">
                <div class="newphone__maps_headerimage radio"></div>
                <div class="newphone__radio_headertitle">Radio <span class="purple">FM</span></div>
            </div>
            <div class="box-between m-t33">
                <div class="newphone__project_title">{radioStations[selectedStation].name}</div>
                <div class="box-flex">
                    <div class="newphone__radio_live"></div>
                    <div class="red">On Air</div>
                </div>
            </div>
            <div class="newphone__radio_headphones"></div>
            <div class="box-between">
                <div>{translateText('player2', 'Состояние радио')}:</div>
                <div class="sound__input-block switch-box">
                    <label class="switch" on:click={updateToggled}>
                        <input type="checkbox" checked={isToggled}>
                        <span class="slider round"></span>
                    </label>
                </div>
            </div>
            <div class="box-between">
                <div>{translateText('player2', 'Громкость')}:</div>
                <div class="box-flex">
                    <div class="newphone__radio_button" on:click={() => changeVolume(-1)}>-</div>
                    <div class="width-12">{Math.round(SettingsList.VolumePhoneRadio / 10)}</div>
                    <div class="newphone__radio_button m-l" on:click={() => changeVolume(1)}>+</div>
                </div>
            </div>
            <div class="newphone__project_button radio" on:click={() => selectPage = "radioList"}>Сменить станцию</div>
        {/if}

        {#if selectPage === "radioList"}
            <div class="newphone__project_title" in:fade>Выберите волну</div>
            <div class="newphone__radio_list">
                {#each radioStations as { name }, index}
                    <div class="newphone__project_categorie" on:click={() => setRadioStation(index)}>
                        <div>{name}</div>
                        <div class="box-flex">
                            <div class="newphone__radio_live"></div>
                            <div class="red">{selectedStation === index ? "On Air" : ""}</div>
                        </div>
                        <div class="phoneicons-Button newphone__chevron-back"></div>
                    </div>
                {/each}
            </div>
            <div class="newphone__radio_back purple" on:click={() => selectPage = "radio"}>{translateText('player2', 'Назад')}</div>
        {/if}
    </div>
    <HomeButton />
</div>
