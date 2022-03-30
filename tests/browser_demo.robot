*** Settings ***
Force Tags          idemo
Library             Browser
Library             String

*** Variables ***
#@{browsers}         chromium  firefox  webkit
${url}              http://www.insta.fi
${textFi}           Meihin on lupa luottaa.
${textEn}           We are worth your trust.
${timeout}          10s

*** Test Cases ***
TC1: Browse To URL
    [Documentation]     Browses to the selected URL
    [Tags]              url

    Open Page With Browser  ${BROWSER}  ${url}
    Close Page  CURRENT

TC2: Verify Texts
    [Documentation]     Verifies text with different languages
    [Tags]              text

    Open Page With Browser  ${BROWSER}  ${url}
    Verify Insta Text  ${textFi}
    Change Language  ${LANG}
    Verify Insta Text  ${textEn}
    Close Page  CURRENT

*** Keywords ***
Open Page With Browser
    [Documentation]  Opens a page with a selected browser.
    [Arguments]  ${browser}  ${url}

    New Browser     ${browser}  headless=False
    New Page        ${url}
    Wait Until Network Is Idle  timeout=${timeout}
    Click  id=hs-eu-confirmation-button

Verify Insta Text
    [Documentation]  Verifies Insta text.
    [Arguments]  ${text}

    ${wyt}=  Get Text  //*[@class="hero__content--content"]/p[1]
    ${wyt}=  Strip String  ${wyt}
    ${text}=  Strip String  ${text}
    Should Be Equal As Strings  ${wyt}  ${text}

Change Language
    [Documentation]  Changes language.
    [Arguments]  ${lang}

    Click  //*[@href="/en/en/"]
    Wait Until Network Is Idle  timeout=${timeout}
    ${text}=  Get Text  id=lang-switcher
    ${lang}=  Strip String  ${lang}
    ${text}=  Strip String  ${text}
    Should Be Equal As Strings  ${text}  ${lang}
