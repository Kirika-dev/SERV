<script>
    import { translateText } from 'lang'
    import Header from '../header.svelte'
    import HomeButton from '../homebutton.svelte'
    import currentPage from '../../stores'
    let selectPage = "radio"
    import { radioState, radioStation } from "@/views/player/hudevo/phonenew/stores";

    import { storeSettings } from 'store/settings'
    import {executeClient} from "api/rage";

    let isToggled = $radioState;
    let selectedStation = $radioStation;
	let radioStationsUrls = 
	[
		// 181.fm станции
    "http://listen.181fm.com/181-eagle_128k.mp3", // Classic Rock
    "http://listen.181fm.com/181-awesome80s_128k.mp3", // Awesome 80s
    "http://listen.181fm.com/181-rock_128k.mp3", // The Rock!
    "http://listen.181fm.com/181-energy93_128k.mp3", // Dance
    "http://listen.181fm.com/181-goodtime_128k.mp3", // Oldies
    "http://listen.181fm.com/181-truernb_128k.mp3", // R&B
    
    // Другие предложенные радиостанции
    "https://ep128.hostingradio.ru:8052/europaplus128.mp3", // Европа Плюс
    "https://rusradio.hostingradio.ru/rusradio96.aacp", // Русское Радио
    "https://radiorecord.hostingradio.ru/rr_main96.aacp", // Радио Рекорд
    "https://dorognoe.hostingradio.ru:8000/dorognoe", // Дорожное Радио
    "https://retroserver.streamr.ru/retro256.mp3", // Ретро FM
    "https://nashe1.hostingradio.ru/nashe-128.mp3", // Наше Радио
    "https://icecast.avtoradio.ru/avtoradio", // Авторадио
    "https://chanson.hostingradio.ru:8041/chanson128.mp3", // Радио Шансон
    "https://love.hostingradio.ru/love96.aacp", // Love Radio
    "https://montecarlo.hostingradio.ru/montecarlo96.aacp" // Радио Монте-Карло

	];
	let radioStationsNames = 
	[
		// 181.fm станции
    "181.fm - Classic Rock",
    "181.fm - Awesome 80s",
    "181.fm - The Rock!",
    "181.fm - Dance",
    "181.fm - Oldies",
    "181.fm - R&B",

    // Другие предложенные радиостанции
    "Европа Плюс",
    "Русское Радио",
    "Радио Рекорд",
    "Дорожное Радио",
    "Ретро FM",
    "Наше Радио",
    "Авторадио",
    "Радио Шансон",
    "Love Radio",
    "Радио Монте-Карло"
	];
	
	const enableStation = () => 
	{
		if (radioStationsUrls.length <= selectedStation) return;
        executeClient("sounds.play2DRadio", radioStationsUrls[selectedStation], SettingsList.VolumePhoneRadio / 100);
	}

    const updateToggled = () => {
        isToggled = !isToggled;
        radioState.set(isToggled);

        if (!isToggled) 
		{
			executeClient("sounds.stop2DRadio");
			return;
		}
		enableStation();
    }
    let SettingsList = {};
    let DefaultSettingsList = "";
    storeSettings.subscribe((value) => {
        if (SettingsList !== value) {
            SettingsList = value;
            DefaultSettingsList = JSON.stringify(SettingsList);
        }
    });

    const changeVolume = (value) => {
        let volume = Math.round(SettingsList.VolumePhoneRadio / 10);

        volume += value;

        if (volume < 0) volume = 0;
        else if (volume > 10) volume = 10;

        SettingsList.VolumePhoneRadio = volume * 10;
        if (!isToggled) return;
		
		executeClient("sounds.volume2DRadio", SettingsList.VolumePhoneRadio / 100)
    };
	
	const setRadioStation = (value) => 
	{
		if (selectedStation == value || radioStationsUrls.length <= value) return;
        selectedStation = value;
		radioStation.set(value);
		selectPage = "radio";
		enableStation();
    };


    import { onDestroy } from 'svelte';

    onDestroy(() => {
        if (DefaultSettingsList !== JSON.stringify (SettingsList))
            executeClient("chatconfig", JSON.stringify (SettingsList));
    });

    import { fade } from 'svelte/transition'
</script>
<div class="newphone__radio" in:fade>
    <Header />
    <div class="newphone__radio_content">
        {#if selectPage == "radio"}
            <div class="box-flex">
                <div class="newphone__maps_headerimage radio"></div>
                <div class="newphone__radio_headertitle">Radio <span class="yellow">FM</span></div>
            </div>
            <div class="box-between m-t33">
                <div class="newphone__project_title">{radioStationsNames[selectedStation]}</div>
                <div class="box-flex">
                    <div class="newphone__radio_live"></div>
                    <div class="red">On Air</div>
                </div>
            </div>
            <div class="newphone__radio_headphones"></div>
            <div class="box-between">
                <div>{translateText('player2', 'Состояние радио')}:</div>
                <div class="sound__input-block switch-box">
                    <button class="switch" on:click={updateToggled} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') updateToggled(); }}>
                        <input type="checkbox" checked={isToggled} tabindex="-1">
                        <span class="slider round"></span>
                    </button>
                </div>
            </div>
            <div class="box-between">
                <div>{translateText('player2', 'Громкость')}:</div>
                <div class="box-flex">
                    <div class="newphone__radio_button" on:click={() => changeVolume(-1)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') changeVolume(-1); }}>-</div>
                    <div class="width-12">{Math.round(SettingsList.VolumePhoneRadio / 10)}</div>
                    <div class="newphone__radio_button m-l" on:click={() => changeVolume(+1)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') changeVolume(1); }}>+</div>
                </div>
            </div>
            <div class="newphone__project_button radio" on:click={() => selectPage = "radioList"} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') selectPage = "radioList"; }}>Сменить станцию</div>
        {/if}
        {#if selectPage == "radioList"}
            <div class="newphone__project_title" in:fade>Выберите волну</div>
            <div class="newphone__radio_list">
                <div class="newphone__project_categorie" on:click={() => setRadioStation(0)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(0); }}>
                    <div>{radioStationsNames[0]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 0 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(1)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(1); }}>
                    <div>{radioStationsNames[1]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 1 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(2)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(2); }}>
                    <div>{radioStationsNames[2]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 2 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(3)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(3); }}>
                    <div>{radioStationsNames[3]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 3 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(4)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(4); }}>
                    <div>{radioStationsNames[4]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 4 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(5)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(5); }}>
                    <div>{radioStationsNames[5]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 5 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(6)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(6); }}>
                    <div>{radioStationsNames[6]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 6 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(7)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(7); }}>
                    <div>{radioStationsNames[7]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 7 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(8)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(8); }}>
                    <div>{radioStationsNames[8]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 8 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(9)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(9); }}>
                    <div>{radioStationsNames[9]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 9 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(10)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(10); }}>
                    <div>{radioStationsNames[10]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 10 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(11)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(11); }}>
                    <div>{radioStationsNames[11]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 11 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(12)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(12); }}>
                    <div>{radioStationsNames[12]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 12 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(13)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(13); }}>
                    <div>{radioStationsNames[13]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 13 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(14)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(14); }}>
                    <div>{radioStationsNames[14]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 14 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(15)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(15); }}>
                    <div>{radioStationsNames[15]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 15 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
                <div class="newphone__project_categorie" on:click={() => setRadioStation(16)} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') setRadioStation(16); }}>
                    <div>{radioStationsNames[16]}</div>
                    <div class="box-flex">
                        <div class="newphone__radio_live"></div>
                        <div class="red">{selectedStation == 16 ? "On Air" : ""}</div>
                    </div>
                    <div class="phoneicons-Button newphone__chevron-back"></div>
                </div>
            </div>
            <div class="newphone__radio_back purple" on:click={() => selectPage = "radio"} on:keydown={(e) => { if (e.key === 'Enter' || e.key === ' ') selectPage = "radio"; }}>{translateText('player2', 'Назад')}</div>
        {/if}
    </div>
    <HomeButton />
</div>