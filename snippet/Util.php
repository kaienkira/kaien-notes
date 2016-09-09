<?php

function urlbase64($bin)
{
    return str_replace(
        array('+', '/', '='),
        array('-', '_', ''),
        base64_encode($bin));
}

function runCommand($command, &$stdout, &$stderr)
{
    $proc = proc_open($command, array(
        1 => array('pipe', 'w'),
        2 => array('pipe', 'w')
    ), $pipes);
    if ($proc === false) {
        return false;
    }

    // get stdout
    $stdout = stream_get_contents($pipes[1]);
    if ($stdout === false) {
        return false;
    }
    fclose($pipes[1]);

    // get stderr
    $stderr = stream_get_contents($pipes[2]);
    if ($stderr === false) {
        return false;
    }
    fclose($pipes[2]);

    // get return value
    $return_value = proc_close($proc);

    return $return_value;
}
