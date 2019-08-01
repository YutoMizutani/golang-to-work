wifiWatcher = nil

scriptDir = "~/.hammerspoon/scripts/"
draftPath = ".draft_works"

targetSSID = "TARGET_SSID"
slackBotToken = "SLACK_BOT_TOKEN"
slackBotUserID = "SLACK_BOT_USER_ID"
slackPostChannel = "SLACK_POST_CHANNEL"
clockInText = "CLOCK_IN_TEXT"
clockOutText = "CLOCK_OUT_TEXT"
popDraftText = "POP_DRAFT_TEXT"

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    local scriptCmd = "sh "
    local echoCmd = "echo "
    local sleepCmd = "sleep 2 && "
    local argvPipe = " | xargs -I v "

    local getDate = scriptCmd .. scriptDir .. "get_date.sh"
    local getTime = scriptCmd .. scriptDir .. "get_time.sh"
    local urlEncode = scriptCmd .. scriptDir .. "url_encode.sh"
    local postToSlack = scriptCmd .. scriptDir .. "post_to_slack.sh" .. " " .. slackBotToken .. " " .. slackPostChannel
    local fileExist = scriptCmd .. scriptDir .. "file_exist.sh"
    local fileWrite = scriptCmd .. scriptDir .. "file_write.sh"
    local fileRead = scriptCmd .. scriptDir .. "file_read.sh"
    local fileRemove = scriptCmd .. scriptDir .. "file_remove.sh"

    local declarationCmd = "DATE=`getDate` && DATE=`getTime` && "
    local sedDateCmd = " | sed 's/DATE/$DATE/g; s/TIME/$TIME/g'"

    local clockInTime = declarationCmd .. echoCmd .. clockInText .. sedDateCmd
    local clockOutTime = declarationCmd .. echoCmd .. clockOutText .. sedDateCmd
    local popDraft = echoCmd .. popDraftText

    if newSSID == targetSSID and lastSSID ~= targetSSID then
        -- We just joined our target WiFi network
        hs.alert.show("Joined our target WiFi network!")
        local cmd = sleepCmd .. clockInTime .. argvPipe .. urlEncode .. " v" .. argvPipe .. postToSlack .. " v"
        os.execute(cmd)
    elseif newSSID == nil and lastSSID ~= nil then
        -- We just removed from target WiFi network
        hs.alert.show("Removed from target WiFi network!")
        local cmd = sleepCmd .. clockOutTime .. argvPipe .. fileWrite .. " v"
        os.execute(cmd)
    end

    if newSSID ~= nil then
        -- Post to slack if exists in draft
        local cmd = sleepCmd .. fileExist .. " && " .. popDraft .. argvPipe .. urlEncode .. " v" .. argvPipe .. postToSlack .. " v" .. " && " .. fileRead .. argvPipe .. urlEncode .. " v" .. argvPipe .. postToSlack .. " v" .. " && " .. fileRemove
        os.execute(cmd)
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
hs.alert.show("Hammerspoon started!")
