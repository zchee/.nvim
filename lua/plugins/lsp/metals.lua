local util = require("util")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("metals", "metals") },
  settings = {
    javaHome = "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home",
    sbtScript = util.homebrew_binary("sbt", "sbt"),
    gradleScript = util.homebrew_binary("gradle", "gradle"),
    mavenScript = util.homebrew_binary("maven", "mvn"),
    ammoniteJvmProperties = { "-Xmx2g", "-Xms2g", "-XX:+UseParallelGC" },
    -- -Xms10G -Xmx10G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200
    -- -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch
    -- -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M
    -- -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4
    -- -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90
    -- -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem
    -- -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs
    -- -Daikars.new.flags=true
  },
}
