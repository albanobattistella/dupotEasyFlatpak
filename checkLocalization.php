<?php

$localizationPath = __DIR__ . '/assets/localizations';

$refLocalizationPath = $localizationPath . '/en.json';
$refLocalization = json_decode(file_get_contents($refLocalizationPath));
$mandatoryKeyList = array_keys((array)$refLocalization);

$fileList = scandir($localizationPath);
foreach ($fileList as $fileLoop) {
    $fileBasenameLoop = basename($fileLoop);
    if (substr($fileBasenameLoop, 0, 1) == '.') {
        continue;
    }

    $refLocalizationLoop = json_decode(file_get_contents($localizationPath . '/' . $fileBasenameLoop));
    $missingKeyList = [];
    foreach ($mandatoryKeyList as $mandatoryKeyLoop) {
        if (!property_exists($refLocalizationLoop, $mandatoryKeyLoop)) {
            $missingKeyList[] = $mandatoryKeyLoop;
        }
    }
    if (!empty($missingKeyList)) {
        logText('Error on ' . $fileBasenameLoop);
        logText(' Missing keys:');
        foreach ($missingKeyList as $missingKeyLoop) {
            logText('  - ' . $missingKeyLoop);
        }
    } else {
        logText($fileBasenameLoop . ' OK');
    }
}

function logText(string $text)
{
    print($text . "\n");
}
